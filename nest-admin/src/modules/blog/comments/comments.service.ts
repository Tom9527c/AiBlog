import { BadRequestException, ForbiddenException, Injectable, NotFoundException } from '@nestjs/common';
import { createHash, randomUUID } from 'node:crypto';
import { DataSource, EntityManager, In } from 'typeorm';
import { BlogAuthService, BlogRequest } from '../blog-auth.service';
import { BlogContent } from '../blog.entity';
import { BlogService } from '../blog.service';
import { commentTargetSummary } from './comment-targets';
import { commentEnvironment, requestClientIp } from './comment-environment';

export type ModerationStatus = 'pending' | 'approved' | 'rejected';

const PUBLIC_METADATA = ['targetKind', 'targetId', 'authorName', 'authorAvatar', 'authorWebsite', 'isOwner', 'browser', 'os', 'location', 'replyToName'];
export function publicCommentMetadata(metadata: Record<string, any> = {}) {
  return Object.fromEntries(PUBLIC_METADATA.flatMap(key => metadata[key] === undefined ? [] : [[key, metadata[key]]]));
}

function moderation(row: BlogContent): ModerationStatus {
  return row.metadata?.moderationStatus || (row.status === 'published' ? 'approved' : 'pending');
}

function target(input: any) {
  const targetKind = input?.targetKind || '';
  const targetId = typeof input?.targetId === 'string' && /^\d+$/.test(input.targetId) ? Number(input.targetId) : input?.targetId;
  if (!targetKind && targetId == null) return { targetKind: '', targetId: undefined };
  if (!['documents', 'albums', 'essays', 'about'].includes(targetKind) || !Number.isInteger(targetId) || targetId < 1) {
    throw new BadRequestException('评论目标错误');
  }
  return { targetKind, targetId };
}

@Injectable()
export class CommentsService {
  constructor(private readonly db: DataSource, private readonly blog: BlogService, private readonly auth: BlogAuthService) {}

  private async identity(req: BlogRequest) {
    const user = await this.auth.identify(req);
    if (!user) return null;
    const rows = await this.db.query('SELECT u.username, p.nick_name AS nickName, p.avatar FROM user u LEFT JOIN user_profile p ON p.id=u.profile_id WHERE u.id=? LIMIT 1', [user.uid]);
    return { uid: user.uid, name: rows[0]?.nickName || rows[0]?.username || '用户', avatar: rows[0]?.avatar || '', owner: await this.auth.hasPermission(user.uid, 'comments', 'update') };
  }

  async create(req: BlogRequest, dto: any) {
    if (dto.honeypot) throw new BadRequestException('提交失败');
    const body = typeof dto.body === 'string' ? dto.body.trim() : '';
    if (!body || body.length > 5000) throw new BadRequestException('评论内容长度不正确');
    const identity = await this.identity(req);
    if (!identity && /\/blog-media\/\d+/.test(body)) throw new ForbiddenException('访客评论不能引用受管理文件');
    const nickname = typeof dto.nickname === 'string' ? dto.nickname.trim() : '';
    if (!identity && (!nickname || nickname.length > 100)) throw new BadRequestException('请填写昵称');
    const email = typeof dto.email === 'string' ? dto.email.trim() : '';
    if (email && (email.length > 254 || !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email))) throw new BadRequestException('邮箱格式错误');
    const website = typeof dto.website === 'string' ? dto.website.trim() : '';
    if (website) {
      try { if (!['http:', 'https:'].includes(new URL(website).protocol)) throw new Error(); }
      catch { throw new BadRequestException('网站仅支持 HTTP(S) 地址'); }
    }

    let selectedTarget = target(dto.metadata);
    let parentId: number | null = null;
    let replyToName: string | undefined;
    if (dto.parentId) {
      const parent = await this.blog.raw('comments', dto.parentId);
      if (moderation(parent) !== 'approved' || !await this.blog.readable('comments', parent, req)) throw new ForbiddenException('无法回复尚未公开或不可访问的评论');
      const inherited = target(parent.metadata);
      if ((selectedTarget.targetKind || selectedTarget.targetId) && (selectedTarget.targetKind !== inherited.targetKind || selectedTarget.targetId !== inherited.targetId)) {
        throw new BadRequestException('回复目标不一致');
      }
      selectedTarget = inherited;
      parentId = parent.parentId || parent.id;
      replyToName = parent.metadata?.authorName;
    }
    if (selectedTarget.targetKind) {
      const targetRow = await this.blog.raw(selectedTarget.targetKind, selectedTarget.targetId!);
      if (!await this.blog.readable(selectedTarget.targetKind, targetRow, req)) throw new ForbiddenException('请先解锁内容');
    }
    const environment = await commentEnvironment(req, process.env.TRUST_PROXY_CIDRS || '');
    const metadata = {
      ...selectedTarget, authorName: identity?.name || nickname, authorAvatar: identity?.avatar || '',
      ...(email ? { authorEmail: email } : {}), ...(website ? { authorWebsite: website } : {}),
      isOwner: Boolean(identity?.owner), ...environment, rawIp: requestClientIp(req, process.env.TRUST_PROXY_CIDRS || ''),
      ...(replyToName ? { replyToName } : {}), moderationStatus: 'pending', votes: {},
    };
    const input = {
      title: '评论', slug: randomUUID(), summary: '', body, format: 'markdown', cover: '', url: '', groupName: '', sort: 0,
      status: 'draft', accessMode: 'public', passwordHash: '', accessVersion: 1, parentId, categoryId: null, tagIds: [], metadata,
      authorId: identity?.uid || null, publishedAt: null,
    };
    const saved = await this.db.transaction(async manager => {
      const repo = this.blog.repo('comments', manager);
      const row = await repo.save(repo.create(input));
      if (identity) await this.blog.mediaReferences(manager, 'comments', row.id, row, identity.uid);
      return row;
    });
    return { id: saved.id, status: 'pending', createdAt: saved.createdAt };
  }

  private async project(row: BlogContent, voterKey?: string) {
    const votes = row.metadata?.votes || {};
    const values = Object.values(votes) as number[];
    return {
      id: row.id, title: row.title, body: row.body, format: row.format, parentId: row.parentId, createdAt: row.createdAt, updatedAt: row.updatedAt,
      metadata: publicCommentMetadata(row.metadata), likes: values.filter(v => v === 1).length, dislikes: values.filter(v => v === -1).length,
      myVote: voterKey ? votes[voterKey] || 0 : 0,
    };
  }

  private voterKey(req: BlogRequest, required = false) {
    const raw = req.headers['x-comment-visitor'];
    if (typeof raw !== 'string' || !/^[A-Za-z0-9_-]{16,128}$/.test(raw)) {
      if (required) throw new BadRequestException('缺少有效的访客标识');
      return undefined;
    }
    return createHash('sha256').update('comment-voter:' + raw).digest('base64url');
  }

  private async canView(row: BlogContent, req: BlogRequest) {
    if (moderation(row) !== 'approved' || row.status !== 'published' || (row.publishedAt && row.publishedAt > new Date())) return false;
    return this.blog.readable('comments', row, req);
  }

  async list(req: BlogRequest, query: any) {
    const selectedTarget = target(query);
    if (selectedTarget.targetKind && !await this.blog.readable(selectedTarget.targetKind, await this.blog.raw(selectedTarget.targetKind, selectedTarget.targetId!), req)) throw new ForbiddenException('请先解锁内容');
    const page = Number(query.page) || 1, pageSize = Math.min(Number(query.pageSize) || 10, 100);
    if (!Number.isInteger(page) || page < 1 || !Number.isInteger(pageSize) || pageSize < 1) throw new BadRequestException('分页参数错误');
    const qb = this.blog.repo('comments').createQueryBuilder('comment')
      .where("comment.status='published'")
      .andWhere("(JSON_UNQUOTE(JSON_EXTRACT(comment.metadata, '$.moderationStatus'))='approved' OR JSON_EXTRACT(comment.metadata, '$.moderationStatus') IS NULL)")
      .andWhere('(comment.publishedAt IS NULL OR comment.publishedAt <= :now)', { now: new Date() })
      .andWhere('comment.parentId IS NULL');
    if (selectedTarget.targetKind) qb.andWhere("JSON_UNQUOTE(JSON_EXTRACT(comment.metadata, '$.targetKind'))=:targetKind AND JSON_EXTRACT(comment.metadata, '$.targetId')=:targetId", selectedTarget);
    else qb.andWhere("COALESCE(JSON_UNQUOTE(JSON_EXTRACT(comment.metadata, '$.targetKind')), '')='' ");
    const order = query.order === 'oldest' ? 'ASC' : 'DESC';
    if (query.order === 'popular') qb.orderBy("COALESCE(JSON_LENGTH(JSON_EXTRACT(comment.metadata, '$.votes')), 0)", 'DESC').addOrderBy('comment.id', 'DESC');
    else qb.orderBy('comment.createdAt', order).addOrderBy('comment.id', order);
    const roots = await qb.getMany();
    const readableRoots = (await Promise.all(roots.map(async row => await this.canView(row, req) ? row : null))).filter((row): row is BlogContent => !!row);
    const total = readableRoots.length;
    const visibleRoots = readableRoots.slice((page - 1) * pageSize, page * pageSize);
    const rootIds = visibleRoots.map(row => row.id);
    const replies = rootIds.length ? await this.blog.repo('comments').createQueryBuilder('comment')
      .where('comment.parentId IN (:...rootIds)', { rootIds }).andWhere("comment.status='published'")
      .andWhere("(JSON_UNQUOTE(JSON_EXTRACT(comment.metadata, '$.moderationStatus'))='approved' OR JSON_EXTRACT(comment.metadata, '$.moderationStatus') IS NULL)")
      .andWhere('(comment.publishedAt IS NULL OR comment.publishedAt <= :now)', { now: new Date() })
      .orderBy('comment.createdAt', 'ASC').addOrderBy('comment.id', 'ASC').getMany() : [];
    const user = await this.auth.identify(req);
    const voter = user ? createHash('sha256').update('comment-user:' + user.uid).digest('base64url') : this.voterKey(req);
    const replyMap = new Map<number, BlogContent[]>();
    for (const reply of replies) if (await this.canView(reply, req)) replyMap.set(reply.parentId!, [...(replyMap.get(reply.parentId!) || []), reply]);
    const items = await Promise.all(visibleRoots.map(async row => ({ ...(await this.project(row, voter)), replies: await Promise.all((replyMap.get(row.id) || []).map(reply => this.project(reply, voter))) })));
    const allRootIds = readableRoots.map(root => root.id);
    const allReplies = allRootIds.length ? await this.blog.repo('comments').createQueryBuilder('comment')
      .where("comment.status='published'").andWhere('comment.parentId IS NOT NULL')
      .andWhere('comment.parentId IN (:...allRootIds)', { allRootIds })
      .andWhere('(comment.publishedAt IS NULL OR comment.publishedAt <= :now)', { now: new Date() })
      .andWhere("(JSON_UNQUOTE(JSON_EXTRACT(comment.metadata, '$.moderationStatus'))='approved' OR JSON_EXTRACT(comment.metadata, '$.moderationStatus') IS NULL)")
      .andWhere(selectedTarget.targetKind
        ? "JSON_UNQUOTE(JSON_EXTRACT(comment.metadata, '$.targetKind'))=:targetKind AND JSON_EXTRACT(comment.metadata, '$.targetId')=:targetId"
        : "COALESCE(JSON_UNQUOTE(JSON_EXTRACT(comment.metadata, '$.targetKind')), '')=''", selectedTarget).getMany() : [];
    const replyCount = (await Promise.all(allReplies.map(reply => this.canView(reply, req)))).filter(Boolean).length;
    return { items, total, commentCount: total + replyCount, page, pageSize };
  }

  async react(req: BlogRequest, id: number, value: number) {
    if (![1, -1, 0].includes(value)) throw new BadRequestException('反应值错误');
    const user = await this.auth.identify(req);
    const key = user ? createHash('sha256').update('comment-user:' + user.uid).digest('base64url') : this.voterKey(req, true)!;
    return this.db.transaction(async manager => {
      const repo = this.blog.repo('comments', manager);
      const row = await repo.findOne({ where: { id }, lock: { mode: 'pessimistic_write' } });
      if (!row || moderation(row) !== 'approved' || !await this.blog.readable('comments', row, req)) throw new NotFoundException('评论不存在');
      const votes = { ...(row.metadata?.votes || {}) };
      if (value) votes[key] = value; else delete votes[key];
      row.metadata = { ...row.metadata, votes };
      await repo.save(row);
      const projected = await this.project(row, key);
      return { likes: projected.likes, dislikes: projected.dislikes, myVote: projected.myVote };
    });
  }

  async adminList(query: any) {
    const page = query.page === undefined ? 1 : Number(query.page);
    const pageSize = query.pageSize === undefined ? 20 : Number(query.pageSize);
    if (!Number.isInteger(page) || page < 1 || !Number.isInteger(pageSize) || pageSize < 1 || pageSize > 100) throw new BadRequestException('分页参数错误');
    if (query.moderation && !['pending', 'approved', 'rejected'].includes(query.moderation)) throw new BadRequestException('审核状态错误');
    if (query.targetKind && !['guestbook', 'documents', 'albums', 'essays', 'about'].includes(query.targetKind)) throw new BadRequestException('评论目标错误');
    if (query.keyword !== undefined && (typeof query.keyword !== 'string' || query.keyword.length > 200)) throw new BadRequestException('搜索关键字错误');
    const targetId = query.targetId === undefined ? undefined : Number(query.targetId);
    if (targetId !== undefined && (!Number.isSafeInteger(targetId) || targetId < 1 || !['documents', 'essays', 'albums', 'about'].includes(query.targetKind))) throw new BadRequestException('评论对象参数错误');
    const parentId = query.parentId === undefined ? undefined : Number(query.parentId);
    if (parentId !== undefined && (!Number.isSafeInteger(parentId) || parentId < 1)) throw new BadRequestException('父评论参数错误');
    const base = this.blog.repo('comments').createQueryBuilder('comment');
    if (targetId !== undefined) base.andWhere("JSON_EXTRACT(comment.metadata, '$.targetId') = :targetId", { targetId });
    if (parentId !== undefined) base.andWhere('comment.parentId = :parentId', { parentId });
    if (query.moderation) base.andWhere("COALESCE(JSON_UNQUOTE(JSON_EXTRACT(comment.metadata, '$.moderationStatus')), IF(comment.status='published','approved','pending'))=:moderation", { moderation: query.moderation });
    if (query.targetKind === 'guestbook') base.andWhere("COALESCE(JSON_UNQUOTE(JSON_EXTRACT(comment.metadata, '$.targetKind')), '')='' ");
    else if (query.targetKind) base.andWhere("JSON_UNQUOTE(JSON_EXTRACT(comment.metadata, '$.targetKind'))=:targetKind", { targetKind: query.targetKind });
    if (query.keyword) base.andWhere("(comment.body LIKE :keyword OR JSON_UNQUOTE(JSON_EXTRACT(comment.metadata, '$.authorName')) LIKE :keyword OR JSON_UNQUOTE(JSON_EXTRACT(comment.metadata, '$.authorEmail')) LIKE :keyword)", { keyword: `%${String(query.keyword).replace(/[\\%_]/g, '\\$&')}%` });
    const [items, total] = await base.orderBy('comment.createdAt', 'DESC').addOrderBy('comment.id', 'DESC').skip((page - 1) * pageSize).take(pageSize).getManyAndCount();
    const countRows = await this.blog.repo('comments').createQueryBuilder('comment').select("COALESCE(JSON_UNQUOTE(JSON_EXTRACT(comment.metadata, '$.moderationStatus')), IF(comment.status='published','approved','pending'))", 'state').addSelect('COUNT(*)', 'count').groupBy('state').getRawMany();
    const counts = { pending: 0, approved: 0, rejected: 0 };
    for (const row of countRows) if (row.state in counts) counts[row.state] = Number(row.count);
    const targets = new Map<string, ReturnType<typeof commentTargetSummary>>();
    await Promise.all(['documents', 'essays', 'albums', 'about'].map(async kind => {
      const ids = [...new Set(items.filter(row => row.metadata?.targetKind === kind).map(row => Number(row.metadata.targetId)).filter(id => Number.isSafeInteger(id) && id > 0))];
      if (!ids.length) return;
      const sources = await this.blog.repo(kind).find({ where: { id: In(ids) }, select: ['id', 'title', 'summary', 'slug', 'publishedAt', 'createdAt', 'metadata', ...(kind === 'essays' ? ['body' as const] : [])] });
      for (const source of sources) targets.set(`${kind}:${source.id}`, commentTargetSummary(kind, source));
    }));
    return { items: items.map(row => ({ ...row, moderationStatus: moderation(row), commentTarget: targets.get(`${row.metadata?.targetKind}:${row.metadata?.targetId}`) || null })), total, page, pageSize, counts };
  }

  async moderate(ids: number[], status: ModerationStatus, reason?: string) {
    if (!ids?.length || ids.length > 100 || !['approved', 'rejected', 'pending'].includes(status)) throw new BadRequestException('审核参数错误');
    return this.db.transaction(async manager => {
      const repo = this.blog.repo('comments', manager);
      const rows = await repo.createQueryBuilder('comment').setLock('pessimistic_write').where('comment.id IN (:...ids)', { ids: [...new Set(ids)] }).getMany();
      if (rows.length !== new Set(ids).size) throw new NotFoundException('部分评论不存在');
      if (status === 'approved') {
        for (const row of rows) if (row.parentId && !rows.some(parent => parent.id === row.parentId && status === 'approved')) {
          const parent = await repo.findOne({ where: { id: row.parentId }, lock: { mode: 'pessimistic_write' } });
          if (!parent || moderation(parent) !== 'approved' || parent.status !== 'published') throw new BadRequestException('请先通过上级评论');
        }
      }
      for (const row of rows) {
        row.status = status === 'approved' ? 'published' : 'draft';
        row.publishedAt = status === 'approved' ? row.publishedAt || new Date(Math.floor(Date.now() / 1000) * 1000) : null;
        row.metadata = { ...row.metadata, moderationStatus: status, ...(reason?.trim() ? { moderationReason: reason.trim() } : {}) };
        if (status !== 'rejected' && !reason?.trim()) delete row.metadata.moderationReason;
      }
      await repo.save(rows);
      return { updated: rows.length };
    });
  }

  async adminReply(req: BlogRequest, parentId: number, body: string, identity: { uid: number }) {
    body = String(body || '').trim();
    if (!body || body.length > 5000) throw new BadRequestException('回复内容长度不正确');
    const parent = await this.blog.raw('comments', parentId);
    if (moderation(parent) !== 'approved') throw new BadRequestException('只能回复已通过的评论');
    const rows = await this.db.query('SELECT u.username, p.nick_name AS nickName, p.avatar FROM user u LEFT JOIN user_profile p ON p.id=u.profile_id WHERE u.id=? LIMIT 1', [identity.uid]);
    const name = rows[0]?.nickName || rows[0]?.username || '博主';
    const environment = await commentEnvironment(req, process.env.TRUST_PROXY_CIDRS || '');
    return this.db.transaction(async manager => {
      const repo = this.blog.repo('comments', manager);
      const saved = await repo.save(repo.create({ title: '回复', slug: randomUUID(), summary: '', body, format: 'markdown', cover: '', url: '', groupName: '', sort: 0,
        status: 'published', accessMode: 'public', passwordHash: '', accessVersion: 1, parentId: parent.parentId || parent.id, categoryId: null, tagIds: [], authorId: identity.uid, publishedAt: new Date(),
        metadata: { ...target(parent.metadata), authorName: name, authorAvatar: rows[0]?.avatar || '', isOwner: true, replyToName: parent.metadata?.authorName,
          ...environment, rawIp: requestClientIp(req, process.env.TRUST_PROXY_CIDRS || ''), moderationStatus: 'approved', votes: {} },
      }));
      await this.blog.mediaReferences(manager, 'comments', saved.id, saved, identity.uid);
      return saved;
    });
  }
}
