import { ForbiddenException, Inject, Injectable, UnauthorizedException } from '@nestjs/common';
import { Request } from 'express';
import Redis from 'ioredis';
import { DataSource } from 'typeorm';
import { InjectRedis } from '~/common/decorators/inject-redis.decorator';
import { AppConfig, IAppConfig } from '~/config';
import { genTokenBlacklistKey } from '~/helper/gen-redis-key';
import { AuthService } from '../auth/auth.service';
import { TokenService } from '../auth/services/token.service';
import { UserEntity } from '../user/user.entity';
import { UnlockGrants } from './blog-access.policy';

export interface BlogRequest extends Request { blogUser?: IAuthUser; blogGrants?: UnlockGrants; }

@Injectable()
export class BlogAuthService {
  constructor(private readonly tokens: TokenService, private readonly auth: AuthService,
    private readonly db: DataSource, @InjectRedis() private readonly redis: Redis,
    @Inject(AppConfig.KEY) private readonly config: IAppConfig) {}

  async identify(req: BlogRequest, required = false): Promise<IAuthUser | null> {
    if (req.blogUser) return req.blogUser;
    const raw = req.headers.authorization;
    if (!raw) { if (required) throw new UnauthorizedException('请先登录'); return null; }
    const token = raw.replace(/^Bearer\s+/i, '');
    if (await this.redis.get(genTokenBlacklistKey(token)) || !(await this.tokens.checkAccessToken(token))) {
      throw new UnauthorizedException('登录已失效，请重新登录');
    }
    const user = await this.tokens.verifyAccessToken(token);
    const account = await this.db.getRepository(UserEntity).findOneBy({ id: user.uid });
    await this.auth.checkUserCanLogin(account);
    if (!this.config.multiDeviceLogin && token !== await this.auth.getTokenByUid(user.uid)) {
      throw new UnauthorizedException('登录已失效');
    }
    // Read current roles, rather than granting old privileges from a still-valid JWT.
    const roles = await this.db.query('SELECT r.value FROM sys_role r JOIN sys_user_roles ur ON ur.role_id=r.id WHERE ur.user_id=? AND r.status=1', [user.uid]);
    req.blogUser = { ...user, roles: roles.map(r => r.value) };
    return req.blogUser;
  }

  grants(req: BlogRequest): UnlockGrants {
    if (req.blogGrants) return req.blogGrants;
    try {
      const raw = req.headers['x-blog-unlock'];
      if (!raw || typeof raw !== 'string' || raw.length > 16000) return {};
      const parsed = JSON.parse(raw);
      if (!parsed || Array.isArray(parsed) || typeof parsed !== 'object') return {};
      return req.blogGrants = Object.fromEntries(Object.entries(parsed).filter(([key, value]) => /^[a-z]+:\d+$/.test(key) && typeof value === 'string')) as UnlockGrants;
    } catch { return {}; }
  }

  async permit(req: BlogRequest, resource: string, action: string) {
    const user = await this.identify(req, true);
    if (!await this.hasPermission(user.uid, resource, action)) throw new ForbiddenException('没有博客管理权限');
    return user;
  }

  async hasPermission(uid: number, resource: string, action: string): Promise<boolean> {
    const admins = await this.db.query("SELECT r.id FROM sys_role r JOIN sys_user_roles ur ON ur.role_id=r.id WHERE ur.user_id=? AND r.value='superadmin' AND r.status=1", [uid]);
    if (admins.length) return true;
    const rows = await this.db.query(`SELECT m.id FROM sys_menu m JOIN sys_role_menus rm ON rm.menu_id=m.id
      JOIN sys_user_roles ur ON ur.role_id=rm.role_id JOIN sys_role r ON r.id=rm.role_id
      LEFT JOIN sys_menu p ON p.id=m.parent_id LEFT JOIN sys_menu g ON g.id=p.parent_id
      WHERE ur.user_id=? AND r.status=1 AND m.status=1 AND (p.id IS NULL OR p.status=1)
      AND (g.id IS NULL OR g.status=1) AND m.permission IN (?, ?)`, [uid, `blog:${resource}:${action}`, resource === 'photos' ? `blog:albums:${action === 'list' ? 'list' : 'update'}` : `blog:${resource}:${action}`]);
    return rows.length > 0;
  }
}
