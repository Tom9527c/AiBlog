import { listMenus, saveMenu, deleteMenu } from './site/blog-menus';
import { visibleEssayCommentCounts } from './comments/comment-targets';
import { aboutMetadata } from './site/blog-about';
import { photoMetadata } from './media/blog-photo-media';
import { BadRequestException, ConflictException, ForbiddenException, Injectable, NotFoundException } from '@nestjs/common';
import { DataSource, EntityManager, In, IsNull, LessThanOrEqual, Repository } from 'typeorm';
import { randomUUID } from 'node:crypto';
import * as argon2 from 'argon2';
import { BlogAccessPolicy } from './blog-access.policy';
import { BlogAuthService, BlogRequest } from './blog-auth.service';
import { BlogContentDto, BlogMenuDto, BlogQuery } from './blog.dto';
import { BlogContent, BlogKind, BlogSite, CONTENT_ENTITIES, BlogMediaReference, BlogMedia } from './blog.entity';
import { DEFAULT_SITE, safeUrl, validateSettings } from './site/blog-settings';
import { validateMetadata } from './content/blog-metadata';
import { assertManagedMedia } from './media/blog-private-media';

const publicCommentMetadata = (metadata: Record<string, any> = {}) => Object.fromEntries(
  ['targetKind', 'targetId', 'authorName', 'authorAvatar', 'authorWebsite', 'isOwner', 'browser', 'os', 'location', 'replyToName']
    .flatMap(key => metadata[key] === undefined ? [] : [[key, metadata[key]]]),
);

@Injectable()
export class BlogService {
  constructor(private readonly db: DataSource, private readonly auth: BlogAuthService, private readonly access: BlogAccessPolicy) {}

  kind(value: string): BlogKind {
    if (!Object.prototype.hasOwnProperty.call(CONTENT_ENTITIES, value)) throw new NotFoundException('内容类型不存在');
    return value as BlogKind;
  }
  repo(kind: string, manager: EntityManager = this.db.manager): Repository<BlogContent> {
    return manager.getRepository(CONTENT_ENTITIES[this.kind(kind)]);
  }
  async site() { return { ...DEFAULT_SITE, ...(await this.db.getRepository(BlogSite).findOneBy({ id: 1 }))?.settings }; }
  async saveSite(input: any, userId: number) {
    const previous = await this.site();
    const changes = validateSettings(input);
    const settings = { ...previous, ...changes };
    if (changes.pageHeaders) settings.pageHeaders = Object.fromEntries(Object.entries({ ...previous.pageHeaders, ...changes.pageHeaders }).map(([key, value]) => [key, { ...previous.pageHeaders?.[key], ...(value as object) }]));
    await this.db.transaction(async manager => {
      await manager.getRepository(BlogSite).save({ id: 1, settings });
      await this.mediaReferences(manager, 'site', 1, settings, userId);
    });
    return settings;
  }
  // Stable identity: editing sort/publication dates never changes the selected page.
  private aboutRow(manager: EntityManager = this.db.manager) {
    return this.repo('about', manager).findOne({ where: {}, order: { id: 'ASC' } });
  }
  async about(req: BlogRequest, admin = false) {
    const row = await this.aboutRow();
    if (!row) return admin ? { id: 0, title: '关于本人', status: 'draft', accessMode: 'public', body: '', format: 'markdown', metadata: aboutMetadata() } : null;
    if (!admin && (row.status !== 'published' || (row.publishedAt && row.publishedAt > new Date()))) return null;
    const result = admin ? this.adminProjection(row, true) : await this.projection('about', row, req, true);
    if (admin) result.metadata = aboutMetadata(row.metadata, await this.site(), !('heading' in row.metadata), row.accessMode === 'public');
    return result;
  }
  async saveAbout(dto: BlogContentDto, userId: number) {
    return this.db.transaction(async manager => {
      // A shared singleton row serializes even the first creation, across server processes.
      await manager.query("INSERT IGNORE INTO blog_site (id, settings) VALUES (1, '{}')");
      await manager.query('SELECT id FROM blog_site WHERE id = 1 FOR UPDATE');
      const previous = await this.aboutRow(manager);
      const metadata = aboutMetadata(dto.metadata ?? previous?.metadata ?? {}, await this.site(), Boolean(previous && !('heading' in (dto.metadata ?? previous.metadata))), previous?.accessMode === 'public');
      return this.save('about', { ...dto, title: dto.title ?? previous?.title ?? '关于本人', metadata }, userId, previous?.id, manager);
    });
  }
  menus(publicOnly = false) { return listMenus(this.db, publicOnly); }
  saveMenu(dto: BlogMenuDto, id?: number) { return saveMenu(this.db, dto, id); }
  deleteMenu(id: number) { return deleteMenu(this.db, id); }

  async raw(kind: string, slugOrId: string | number) {
    const qb = this.repo(kind).createQueryBuilder('content').addSelect('content.passwordHash');
    if (typeof slugOrId === 'number' || /^\d+$/.test(slugOrId)) qb.where('content.id = :id', { id: Number(slugOrId) });
    else qb.where('content.slug = :slug', { slug: slugOrId });
    const row = await qb.getOne();
    if (!row) throw new NotFoundException('内容不存在');
    return row;
  }

  async readable(kind: string, row: BlogContent, req: BlogRequest, seen = new Set<string>()): Promise<boolean> {
    const key = `${kind}:${row.id}`;
    if (seen.has(key)) return false;
    seen.add(key);
    const user = await this.auth.identify(req);
    if (!this.access.canRead(kind, row, user, this.auth.grants(req))) return false;
    if (kind === 'photos') {
      if (!row.parentId) return false;
      try { return this.readable('albums', await this.raw('albums', row.parentId), req, seen); } catch { return false; }
    }
    if (kind === 'comments' && row.metadata?.moderationStatus && row.metadata.moderationStatus !== 'approved') return false;
    if (kind === 'comments' && row.metadata?.targetKind && row.metadata?.targetId) {
      try {
        if (row.parentId && !await this.readable('comments', await this.raw('comments', row.parentId), req, new Set(seen))) return false;
        return this.readable(row.metadata.targetKind, await this.raw(row.metadata.targetKind, row.metadata.targetId), req, seen);
      } catch { return false; }
    }
    if (kind === 'comments' && row.parentId) {
      try { return this.readable('comments', await this.raw('comments', row.parentId), req, seen); } catch { return false; }
    }
    return true;
  }

  private adminProjection(row: BlogContent, detail: boolean) {
    const { passwordHash, accessVersion, ...safe } = row;
    if (!detail) delete safe.body;
    return safe;
  }
  async projection(kind: string, row: BlogContent, req: BlogRequest, detail = false) {
    const canRead = await this.readable(kind, row, req);
    const safe: any = this.adminProjection(row, (detail || kind === 'essays') && canRead);
    safe.locked = !canRead;
    if (kind === 'photos' && canRead) {
      const id = /^\/blog-media\/(\d+)$/.exec(row.url || row.cover)?.[1];
      const media = id ? await this.db.getRepository(BlogMedia).findOneBy({ id: Number(id) }) : null;
      safe.metadata = photoMetadata(row.metadata, row.url || row.cover, media?.mime);
    }
    if (kind === 'about' && canRead) safe.metadata = aboutMetadata(row.metadata, await this.site(), !('heading' in row.metadata), row.accessMode === 'public');
    if (kind === 'comments') safe.metadata = canRead ? publicCommentMetadata(row.metadata) : {};
    delete safe.authorId;
    if (!canRead) { safe.cover = ''; safe.url = ''; safe.metadata = {}; if (kind === 'essays') { safe.title = '受限短文'; safe.summary = ''; } }
    // Comments contain plain text in body; expose it only after the target's access check.
    if (kind === 'comments' && canRead) safe.body = row.body;
    return safe;
  }

  async list(kind: string, query: BlogQuery, req: BlogRequest, admin = false) {
    this.kind(kind);
    if (kind === 'moments' && !admin) throw new NotFoundException('朋友圈已合并到即刻短文');
    if (query.month && !query.year) throw new BadRequestException('按月归档需要指定年份');
    if (!admin) await this.auth.identify(req);
    if (!admin && kind === 'photos' && !query.parentId) throw new BadRequestException('请选择相册');
    if (!admin && kind === 'photos' && !await this.readable('albums', await this.raw('albums', query.parentId), req)) throw new ForbiddenException('请先解锁相册');
    if (!admin && kind === 'comments' && (query.targetKind || query.targetId)) {
      if (!['documents', 'albums', 'essays', 'about'].includes(query.targetKind) || !query.targetId) throw new BadRequestException('评论目标错误');
      if (!await this.readable(query.targetKind, await this.raw(query.targetKind, query.targetId), req)) throw new ForbiddenException('请先解锁内容');
    }
    const qb = this.repo(kind).createQueryBuilder('content');
    if (!admin) qb.where("content.status = 'published'").andWhere('(content.publishedAt IS NULL OR content.publishedAt <= :now)', { now: new Date() });
    else if (query.status) qb.where('content.status = :status', { status: query.status });
    if (query.accessMode) qb.andWhere('content.accessMode = :accessMode', { accessMode: query.accessMode });
    if (query.keyword) qb.andWhere('(content.title LIKE :keyword OR content.summary LIKE :keyword)', { keyword: `%${query.keyword.replace(/[\\%_]/g, '\\$&')}%` });
    if (query.year) qb.andWhere('YEAR(COALESCE(content.publishedAt, content.createdAt)) = :archiveYear', { archiveYear: query.year });
    if (query.month) qb.andWhere('MONTH(COALESCE(content.publishedAt, content.createdAt)) = :archiveMonth', { archiveMonth: query.month });
    for (const field of ['categoryId', 'parentId', 'groupName']) if (query[field] !== undefined) qb.andWhere(`content.${field} = :${field}`, { [field]: query[field] });
    if (query.tagId) qb.andWhere('JSON_CONTAINS(content.tagIds, :tag)', { tag: JSON.stringify(query.tagId) });
    if (query.state) qb.andWhere("JSON_UNQUOTE(JSON_EXTRACT(content.metadata, '$.state')) = :state", { state: query.state });
    if (kind === 'comments') {
      if (query.targetKind && query.targetId) qb.andWhere("JSON_UNQUOTE(JSON_EXTRACT(content.metadata, '$.targetKind')) = :targetKind AND JSON_EXTRACT(content.metadata, '$.targetId') = :targetId", query);
      else if (!admin) qb.andWhere("JSON_EXTRACT(content.metadata, '$.targetId') IS NULL");
      if (!admin) qb.andWhere("COALESCE(JSON_UNQUOTE(JSON_EXTRACT(content.metadata, '$.moderationStatus')), 'approved') = 'approved'");
    }
    const page = query.page || 1, pageSize = query.pageSize || 12;
    const [rows, total] = await qb.orderBy('content.sort', 'DESC').addOrderBy('content.publishedAt', 'DESC').addOrderBy('content.id', 'DESC').skip((page - 1) * pageSize).take(pageSize).getManyAndCount();
    const items = await Promise.all(rows.map(async row => {
      if (!admin) return this.projection(kind, row, req);
      const item = this.adminProjection(row, false);
      if (kind === 'photos') {
        const mediaId = /^\/blog-media\/(\d+)$/.exec(row.url || row.cover)?.[1];
        const media = mediaId ? await this.db.getRepository(BlogMedia).findOneBy({ id: Number(mediaId) }) : null;
        item.metadata = photoMetadata(row.metadata, row.url || row.cover, media?.mime);
      }
      return item;
    }));
    if (!admin && kind === 'comments') {
      const visible = await Promise.all(rows.map(row => this.readable('comments', row, req)));
      for (let index = items.length - 1; index >= 0; index--) if (!visible[index]) items.splice(index, 1);
    }
    if (!admin && kind === 'documents' && items.length) {
      const now = new Date();
      const taxonomy = async (kind: 'categories' | 'tags', ids: number[]) => {
        if (!ids.length) return new Map<number, { id: number; title: string; slug: string; cover?: string; metadata?: Record<string, any> }>();
        const filter = { id: In([...new Set(ids)]), status: 'published' };
        const terms = await this.repo(kind).find({
          select: kind === 'tags'
            ? ['id', 'title', 'slug', 'cover', 'metadata', 'status', 'publishedAt', 'accessMode', 'accessVersion']
            : ['id', 'title', 'slug'],
          where: [{ ...filter, publishedAt: IsNull() }, { ...filter, publishedAt: LessThanOrEqual(now) }],
        });
        return new Map(await Promise.all(terms.map(async term => {
          const { id, title, slug, cover, metadata } = term;
          const readable = kind === 'tags' && await this.readable(kind, term, req);
          return [id, {
            id, title, slug,
            ...(readable && cover ? { cover } : {}),
            ...(readable && typeof metadata?.color === 'string' ? { metadata: { color: metadata.color } } : {}),
          }] as const;
        })));
      };
      const [categories, tags, latest] = await Promise.all([
        taxonomy('categories', rows.map(row => row.categoryId).filter((id): id is number => id != null)),
        taxonomy('tags', rows.flatMap(row => row.tagIds || [])),
        this.repo('documents').createQueryBuilder('latest').select('latest.id')
          .where("latest.status = 'published'")
          .andWhere('(latest.publishedAt IS NULL OR latest.publishedAt <= :now)', { now })
          .orderBy('COALESCE(latest.publishedAt, latest.createdAt)', 'DESC').addOrderBy('latest.id', 'DESC').getOne(),
      ]);
      for (const item of items) {
        item.category = categories.get(item.categoryId) || null;
        item.tags = (item.tagIds || []).flatMap(id => tags.has(id) ? [tags.get(id)] : []);
        item.isLatest = item.id === latest?.id;
      }
    }
    if (!admin && kind === 'essays') await this.attachEssayCommentCounts(items, req);
    return { items, total, page, pageSize };
  }

  async detail(kind: string, slug: string, req: BlogRequest, admin = false) {
    if (kind === 'moments' && !admin) throw new NotFoundException('朋友圈已合并到即刻短文');
    const row = await this.raw(kind, slug);
    if (admin) return this.adminProjection(row, true);
    if (row.status !== 'published' || (row.publishedAt && row.publishedAt > new Date()) ||
      (kind === 'comments' && (row.metadata?.moderationStatus === 'rejected' || !await this.readable(kind, row, req)))) throw new NotFoundException('内容不存在');
    const item = await this.projection(kind, row, req, true);
    if (kind === 'essays') await this.attachEssayCommentCounts([item], req);
    return item;
  }
  private async attachEssayCommentCounts(items: any[], req: BlogRequest) {
    const ids = items.filter(item => !item.locked).map(item => item.id);
    if (!ids.length) return;
    const rows = await this.repo('comments').createQueryBuilder('comment')
      .select(['comment.id', 'comment.parentId', 'comment.metadata', 'comment.status', 'comment.accessMode', 'comment.accessVersion', 'comment.publishedAt'])
      .where("comment.status='published'")
      .andWhere("(JSON_UNQUOTE(JSON_EXTRACT(comment.metadata, '$.moderationStatus'))='approved' OR JSON_EXTRACT(comment.metadata, '$.moderationStatus') IS NULL)")
      .andWhere('(comment.publishedAt IS NULL OR comment.publishedAt <= :now)', { now: new Date() })
      .andWhere("JSON_UNQUOTE(JSON_EXTRACT(comment.metadata, '$.targetKind'))='essays'")
      .andWhere("JSON_EXTRACT(comment.metadata, '$.targetId') IN (:...ids)", { ids }).getMany();
    const user = await this.auth.identify(req);
    const grants = this.auth.grants(req);
    const counts = visibleEssayCommentCounts(rows.filter(row => this.access.canRead('comments', row, user, grants)));
    for (const item of items) if (!item.locked) item.commentCount = counts.get(item.id) || 0;
  }

  async unlock(kind: string, id: number, password: string) { return this.access.unlock(this.kind(kind), await this.raw(kind, id), password); }

  async save(kind: string, dto: BlogContentDto, userId: number, id?: number, transaction?: EntityManager) {
    if (kind === 'moments') throw new ConflictException('朋友圈已合并到即刻短文，请在即刻短文管理中编辑');
    // Legacy create endpoints must not create additional personal pages.
    if (kind === 'about' && !id && !transaction) {
      if (await this.aboutRow()) throw new ConflictException('关于本人已存在，请在个人资料页面编辑');
      return this.saveAbout(dto, userId);
    }
    const previous = id ? await this.raw(kind, id) : null;
    const { password, publishedAt, ...provided } = dto;
    const fields = Object.fromEntries(Object.entries(provided).filter(([, value]) => value !== undefined));
    const row = this.repo(kind).create({ title: '', slug: randomUUID(), summary: '', body: '', format: 'markdown', cover: '', url: '', groupName: '', sort: 0,
      status: 'draft', accessMode: 'public', passwordHash: '', accessVersion: 1, parentId: null, categoryId: null, tagIds: [], metadata: {}, authorId: userId, publishedAt: null,
      ...previous, ...fields, ...(publishedAt !== undefined ? { publishedAt: publishedAt ? new Date(publishedAt) : null } : {}) });
    if (kind === 'bangumis') {
      row.body = '';
      row.format = 'markdown';
    }
    if (kind === 'essays' && !row.title?.trim()) row.title = (row.body.trim() || row.summary.trim() || '一则短文').slice(0, 200);
    if (!row.title?.trim() || !row.slug?.trim()) throw new BadRequestException('标题和固定标识不能为空');
    if (!/^[\p{L}\p{N}_.-]+$/u.test(row.slug)) throw new BadRequestException('固定标识只支持文字、数字、下划线、点和横线');
    if (!safeUrl(row.cover) || !safeUrl(row.url)) throw new BadRequestException('链接仅支持 HTTP(S) 或站内路径');
    if (JSON.stringify(row.metadata).length > 50000) throw new BadRequestException('扩展信息过长');
    row.metadata = validateMetadata(kind, row.metadata);
    if (row.accessMode === 'password') {
      if (password) row.passwordHash = await argon2.hash(password);
      if (!row.passwordHash) throw new BadRequestException('请设置访问密码');
    } else row.passwordHash = '';
    if (password || previous?.accessMode !== row.accessMode) row.accessVersion = (previous?.accessVersion || 0) + 1;
    if (row.status === 'published' && !row.publishedAt) row.publishedAt = new Date(Math.floor(Date.now() / 1000) * 1000);
    if (row.categoryId && !(await this.repo('categories').existsBy({ id: row.categoryId }))) throw new BadRequestException('分类不存在');
    row.tagIds = [...new Set(row.tagIds || [])];
    for (const tagId of row.tagIds) if (!(await this.repo('tags').existsBy({ id: tagId }))) throw new BadRequestException('标签不存在');
    if (kind === 'photos' && (!row.parentId || !(await this.repo('albums').existsBy({ id: row.parentId })))) throw new BadRequestException('请选择有效相册');
    if (kind === 'photos') {
      const mediaId = /^\/blog-media\/(\d+)$/.exec(row.url || row.cover)?.[1];
      const media = mediaId ? await this.db.getRepository(BlogMedia).findOneBy({ id: Number(mediaId) }) : null;
      if (media && !/^(image|video)\//.test(media.mime)) throw new BadRequestException('相册仅支持图片、动图和视频');
      row.metadata = photoMetadata(row.metadata, row.url || row.cover, media?.mime);
    }
    if (kind === 'comments') await this.validateComment(row);
    if (kind === 'comments' && previous && fields.status !== undefined && fields.status !== previous.status) {
      row.metadata = { ...row.metadata, moderationStatus: row.status === 'published' ? 'approved' : 'pending' };
    }
    // One site setting governs restricted-media validation across every blog kind.
    if ((await this.site()).restrictedMediaValidationEnabled === true) {
      if (kind === 'albums' && row.accessMode !== 'public') {
        const photos = await this.repo('photos').findBy({ parentId: row.id || -1 });
        for (const photo of photos) assertManagedMedia(photo, true);
      }
      if (row.accessMode !== 'public' || (kind === 'photos' && (await this.raw('albums', row.parentId)).accessMode !== 'public')) {
        assertManagedMedia(row, ['photos', 'music'].includes(kind));
      }
    }
    try {
      const persist = async (manager: EntityManager) => {
        const result = await this.repo(kind, manager).save(row);
        await this.mediaReferences(manager, kind, result.id, result, userId);
        return result;
      };
      const saved = transaction ? await persist(transaction) : await this.db.transaction(persist);
      return this.adminProjection(saved, true);
    } catch (error) {
      if (error.code === 'ER_DUP_ENTRY') throw new ConflictException('固定标识已存在');
      throw error;
    }
  }

  private async validateComment(row: BlogContent) {
    const { targetKind, targetId } = row.metadata;
    if (targetKind || targetId) {
      if (!targetId || !Number.isInteger(targetId) || !['documents', 'essays', 'about', 'albums'].includes(targetKind)) throw new BadRequestException('评论目标错误');
      await this.raw(targetKind, targetId);
    }
    if (row.parentId) {
      const parent = await this.raw('comments', row.parentId);
      if (row.id === row.parentId || parent.parentId) throw new BadRequestException('仅支持回复一级评论');
      if (parent.metadata.targetKind !== targetKind || parent.metadata.targetId !== targetId) throw new BadRequestException('回复目标不一致');
    }
  }

  async remove(kind: string, id: number) {
    if (kind === 'moments') throw new ConflictException('朋友圈已合并到即刻短文，请在即刻短文管理中编辑');
    await this.raw(kind, id);
    const children = kind === 'albums' ? 'photos' : kind === 'comments' ? 'comments' : null;
    if (children && await this.repo(children).countBy({ parentId: id })) throw new ConflictException('请先删除子内容');
    if (['categories', 'tags'].includes(kind)) {
      for (const resource of Object.keys(CONTENT_ENTITIES)) {
        const qb = this.repo(resource).createQueryBuilder('content');
        const count = kind === 'categories' ? await qb.where('content.categoryId = :id', { id }).getCount() : await qb.where('JSON_CONTAINS(content.tagIds, :id)', { id: JSON.stringify(id) }).getCount();
        if (count) throw new ConflictException('该分类或标签仍被内容引用');
      }
    }
    await this.db.transaction(async manager => {
      await this.repo(kind, manager).delete(id);
      await manager.getRepository(BlogMediaReference).delete({ kind, contentId: id });
    });
  }

  async mediaReferences(manager: EntityManager, kind: string, contentId: number, value: any, userId: number) {
    const ids = [...new Set([...JSON.stringify(value).matchAll(/\/blog-media\/(\d+)/g)].map(match => Number(match[1])))];
    const repo = manager.getRepository(BlogMediaReference);
    for (const mediaId of ids.sort((a, b) => a - b)) {
      const media = await manager.getRepository(BlogMedia).findOne({ where: { id: mediaId }, lock: { mode: 'pessimistic_write' } });
      if (!media) throw new BadRequestException('引用的博客文件不存在');
      const references = await repo.findBy({ mediaId });
      if (!references.length && media.uploaderId !== userId) throw new ForbiddenException('不能使用其他用户未发布的文件');
      for (const ref of references) {
        if (!await this.auth.hasPermission(userId, ref.kind, 'update')) throw new ForbiddenException('没有该文件所属内容的编辑权限');
      }
    }
    await repo.delete({ kind, contentId });
    if (ids.length) await repo.save(ids.map(mediaId => ({ mediaId, kind, contentId })));
  }

  async stats() {
    const pairs = await Promise.all(['documents', 'categories', 'tags', 'comments'].map(async kind => [kind, await this.repo(kind).createQueryBuilder('c').where("c.status='published' AND (c.publishedAt IS NULL OR c.publishedAt <= :now)", { now: new Date() }).getCount()]));
    return Object.fromEntries(pairs);
  }
}
