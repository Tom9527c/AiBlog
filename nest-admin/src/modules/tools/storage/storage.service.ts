import { BadRequestException, ConflictException, Injectable, NotFoundException, OnApplicationBootstrap } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Brackets, DataSource, EntityManager, In, IsNull, Repository } from 'typeorm';
import { createHash } from 'node:crypto';
import { getExtname, getFileType, getSize } from '~/utils';
import { Storage } from './storage.entity';
import { ObjectStorageService } from './object-storage.service';
import { StoragePageDto } from './storage.dto';
import { BlogMedia, BlogMediaReference } from '../../blog/blog.entity';
import { UserEntity } from '../../user/user.entity';

@Injectable()
export class StorageService implements OnApplicationBootstrap {
  constructor(@InjectRepository(Storage) private readonly files: Repository<Storage>,
    private readonly db: DataSource, private readonly objects: ObjectStorageService) {}

  async onApplicationBootstrap() {
    // Idempotent metadata import; original files and /blog-media/:id links are unchanged.
    const media = await this.db.getRepository(BlogMedia).createQueryBuilder('m')
      .leftJoin(Storage, 's', 's.blogMediaId = m.id').where('s.id IS NULL').getMany();
    for (const row of media) {
      await this.files.createQueryBuilder().insert().values({
        ...this.metadata(row.name, row.mime, row.size, row.uploaderId),
        source: 'blog', visibility: 'private', blogMediaId: row.id, provider: 'local',
        storageKey: `legacy-blog-private/${row.filename}`, path: `/blog-media/${row.id}`, createdAt: row.createdAt,
      }).orIgnore().execute();
    }
  }

  private metadata(name: string, mime: string, bytes: number, uid: string | number) {
    return { name: name.slice(0, 200), fileName: name.slice(0, 200), extName: getExtname(name),
      type: mime.startsWith('image/') ? 'image' : mime.startsWith('video/') ? 'video' : mime.startsWith('audio/') ? 'music' : getFileType(getExtname(name)),
      mime, size: getSize(bytes), userId: String(uid) };
  }

  async upload(file: Express.Multer.File, uid: string | number, source: 'general' | 'blog', mime = file?.mimetype || 'application/octet-stream') {
    if (!file?.buffer?.length) throw new BadRequestException('文件不能为空');
    const object = await this.objects.put(file.buffer, file.originalname, mime, source === 'blog' ? 'private' : 'public');
    try {
      return await this.db.transaction(async manager => {
        const media = source === 'blog' ? await manager.getRepository(BlogMedia).save({
          name: file.originalname.slice(0, 255), filename: object.storageKey.split('/').pop(), mime,
          size: file.buffer.length, uploaderId: Number(uid),
        }) : null;
        const storage = await manager.getRepository(Storage).save({
          ...object, ...this.metadata(file.originalname, mime, file.buffer.length, uid), source,
          ...(media ? { blogMediaId: media.id, path: `/blog-media/${media.id}` } : {}),
        });
        return { id: media?.id ?? storage.id, name: file.originalname, url: storage.path, mime };
      });
    } catch (error) {
      await this.objects.remove(object as Storage).catch(() => undefined);
      throw error;
    }
  }

  private async record(id: number, manager: EntityManager = this.db.manager) {
    const row = await manager.getRepository(Storage).createQueryBuilder('s').addSelect(['s.storageProfile', 's.previousLocations']).where('s.id = :id', { id }).getOne();
    if (!row) throw new NotFoundException('文件不存在');
    return row;
  }
  async read(id: number) {
    const row = await this.record(id);
    try { return { buffer: await this.objects.read(row), mime: row.mime || 'application/octet-stream', name: row.fileName || row.name }; }
    catch (error) { if (error.code === 'ENOENT' || error.code === 'NoSuchKey') throw new NotFoundException('文件不存在'); throw error; }
  }
  async readBlog(mediaId: number) {
    const row = await this.files.findOneBy({ blogMediaId: mediaId });
    if (!row) throw new NotFoundException('文件不存在');
    return this.read(row.id);
  }

  async delete(ids: number[]) {
    await this.db.transaction(async manager => {
      // Lock media first, matching content-save reference locks, so a concurrent save cannot create a dangling reference.
      const candidates = await manager.getRepository(Storage).findBy({ id: In(ids) });
      const mediaIds = candidates.map(row => row.blogMediaId).filter(Boolean).sort((a,b) => a-b);
      if (mediaIds.length) {
        await manager.getRepository(BlogMedia).createQueryBuilder('m').whereInIds(mediaIds).orderBy('m.id').setLock('pessimistic_write').getMany();
        const references = await manager.getRepository(BlogMediaReference).createQueryBuilder('r')
          .where('r.mediaId IN (:...mediaIds)', { mediaIds }).setLock('pessimistic_read').getMany();
        if (references.length) throw new ConflictException(`文件仍被博客内容引用：${references.map(ref => `${ref.kind} #${ref.contentId}`).join('、')}`);
      }
      for (const id of [...ids].sort((a,b) => a-b)) {
        await manager.getRepository(Storage).createQueryBuilder('s').where('s.id = :id', { id }).setLock('pessimistic_write').getOne();
      }
      // Validate the whole batch before touching any objects.
      for (const row of candidates) {
        const full = await this.record(row.id, manager);
        await this.objects.remove(full);
        if (row.blogMediaId) await manager.getRepository(BlogMedia).delete(row.blogMediaId);
        await manager.getRepository(Storage).delete(row.id);
      }
    });
  }

  async deleteFilesByFileName(names: string[], uid: string | number) {
    // The upload widget may delete only its own ordinary uploads, never blog media.
    const rows = await this.files.findBy({ source: 'general', userId: String(uid), blogMediaId: IsNull() });
    const selected = rows.filter(row => names.includes((row.storageKey || row.path).split('/').pop()));
    if (selected.length) await this.delete(selected.map(row => row.id));
  }

  async migrate(id: number) {
    return this.db.transaction(async manager => {
      await manager.getRepository(Storage).createQueryBuilder('s').where('s.id = :id', { id }).setLock('pessimistic_write').getOne();
      const row = await this.record(id, manager);
      if (row.source !== 'blog') throw new BadRequestException('当前迁移支持博客媒体，普通文件仍保留原有公开地址');
      if (JSON.stringify(this.objects.storedProfile(row)) === JSON.stringify(this.objects.profile()) && !row.storageKey.startsWith('legacy-blog-private/')) return { migrated: false };
      const bytes = await this.objects.read(row);
      const target = await this.objects.put(bytes, row.fileName || row.name, row.mime, 'private');
      try {
        const copied = await this.objects.read(target as Storage);
        if (createHash('sha256').update(bytes).digest('hex') !== createHash('sha256').update(copied).digest('hex')) throw new Error('迁移校验失败，原文件保留');
        await manager.getRepository(Storage).update(id, { storageKey: target.storageKey, storageProfile: target.storageProfile, provider: target.provider,
          previousLocations: JSON.stringify([...(row.previousLocations ? JSON.parse(row.previousLocations) : []), { storageKey: this.objects.storedKey(row), provider: row.provider || 'local', storageProfile: row.storageProfile || null, migratedAt: new Date().toISOString() }]),
        });
      } catch (error) { await this.objects.remove(target as Storage).catch(() => undefined); throw error; }
      // Retain the source as a recovery copy; links keep the same blog media ID.
      return { migrated: true };
    });
  }

  async list(query: StoragePageDto) {
    const { currentPage = 1, pageSize = 10, name, username, source, provider, visibility, type, extName, time } = query;
    const qb = this.files.createQueryBuilder('s').leftJoin(UserEntity, 'u', 'u.id = s.userId').addSelect('u.username', 'username');
    if (name) qb.andWhere(new Brackets(q => q.where('s.name LIKE :name', { name: `%${name}%` }).orWhere('s.fileName LIKE :name', { name: `%${name}%` })));
    if (username) qb.andWhere('u.username = :username', { username });
    if (source) qb.andWhere('s.source = :source', { source });
    if (provider) qb.andWhere(provider === 'local' ? '(s.provider = :provider OR s.provider IS NULL)' : 's.provider = :provider', { provider });
    if (visibility) qb.andWhere('s.visibility = :visibility', { visibility });
    if (type) qb.andWhere('s.type = :type', { type });
    if (extName) qb.andWhere('s.extName = :extName', { extName });
    if (time?.length === 2) qb.andWhere('s.createdAt BETWEEN :start AND :end', { start: new Date(Number(time[0])), end: new Date(Number(time[1])) });
    const total = await qb.getCount();
    const { entities, raw } = await qb.orderBy('s.createdAt', 'DESC').addOrderBy('s.id', 'DESC').offset((currentPage - 1) * pageSize).limit(pageSize).getRawAndEntities();
    const mediaIds = entities.map(row => row.blogMediaId).filter(Boolean);
    const refs = mediaIds.length ? await this.db.getRepository(BlogMediaReference).findBy({ mediaId: In(mediaIds) }) : [];
    const list = entities.map((row, index) => ({ id: row.id, name: row.fileName || row.name, extName: row.extName, path: row.visibility === 'private' ? '' : row.path,
      type: row.type, size: /^\d+ B$/.test(row.size) ? getSize(parseInt(row.size)) : row.size, createdAt: row.createdAt, username: raw[index]?.username,
      source: row.source, provider: row.provider || 'local', visibility: row.visibility, mime: row.mime,
      references: refs.filter(ref => ref.mediaId === row.blogMediaId).map(ref => ({ kind: ref.kind, contentId: ref.contentId })),
    }));
    return { list, total, currentPage, pageSize };
  }
}
