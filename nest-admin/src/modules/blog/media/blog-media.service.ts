import { BadRequestException, ForbiddenException, Injectable, NotFoundException } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { BlogMedia, BlogMediaReference } from '../blog.entity';
import { StorageService } from '../../tools/storage/storage.service';
import { BlogService } from '../blog.service';
import { BlogAuthService, BlogRequest } from '../blog-auth.service';

@Injectable()
export class BlogMediaService {
  constructor(private readonly db: DataSource, private readonly blog: BlogService, private readonly auth: BlogAuthService, private readonly storage: StorageService) {}

  async upload(file: Express.Multer.File, req: BlogRequest) {
    const user = await this.auth.identify(req, true);
    const allowed = await this.db.query(`SELECT m.permission FROM sys_menu m JOIN sys_role_menus rm ON rm.menu_id=m.id JOIN sys_user_roles ur ON ur.role_id=rm.role_id JOIN sys_role r ON r.id=rm.role_id WHERE ur.user_id=? AND r.status=1 AND m.status=1 AND (m.permission LIKE 'blog:%:create' OR m.permission LIKE 'blog:%:update')`, [user.uid]);
    if (!user.roles.includes('superadmin') && !allowed.length) throw new ForbiddenException('没有博客上传权限');
    if (!file?.buffer || file.size > 25 * 1024 * 1024) throw new BadRequestException('文件不能为空且不能超过 25MB');
    const b = file.buffer;
    let mime = '';
    if (b.subarray(0, 3).equals(Buffer.from([0xff, 0xd8, 0xff]))) mime = 'image/jpeg';
    else if (b.subarray(0, 8).equals(Buffer.from([137, 80, 78, 71, 13, 10, 26, 10]))) mime = 'image/png';
    else if (/^GIF8[79]a$/.test(b.subarray(0, 6).toString())) mime = 'image/gif';
    else if (b.subarray(0, 4).toString() === 'RIFF' && b.subarray(8, 12).toString() === 'WEBP') mime = 'image/webp';
    else if (b.subarray(0, 3).toString() === 'ID3' || (b[0] === 255 && (b[1] & 0xe0) === 0xe0)) mime = 'audio/mpeg';
    else if (b.subarray(4, 8).toString() === 'ftyp') mime = b.subarray(8, 16).toString().includes('avif') ? 'image/avif' : 'video/mp4';
    if (!mime) throw new BadRequestException('支持 JPG、PNG、GIF、WebP、AVIF、MP3、MP4 文件');
    return this.storage.upload(file, user.uid, 'blog', mime);
  }

  async read(id: number, req: BlogRequest) {
    const row = await this.db.getRepository(BlogMedia).findOneBy({ id });
    if (!row) throw new NotFoundException('文件不存在');
    const user = await this.auth.identify(req);
    const refs = await this.db.getRepository(BlogMediaReference).findBy({ mediaId: id });
    let allowed = !refs.length && !!user && row.uploaderId === user.uid;
    for (const ref of refs) {
      if (ref.kind === 'site') { allowed = true; break; }
      try {
        if (await this.blog.readable(ref.kind, await this.blog.raw(ref.kind, ref.contentId), req)) { allowed = true; break; }
        if (user) { await this.auth.permit(req, ref.kind, 'list'); allowed = true; break; }
      } catch { /* Missing or inaccessible references do not grant access. */ }
    }
    if (!allowed) throw new ForbiddenException('请先登录或解锁对应内容');
    return this.storage.readBlog(id);
  }
}
