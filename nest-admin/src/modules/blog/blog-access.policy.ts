import { ForbiddenException } from '@nestjs/common';
import { createHmac, timingSafeEqual } from 'node:crypto';
import * as argon2 from 'argon2';

export interface AccessContent {
  id: number; status: string; accessMode: string; passwordHash: string; accessVersion: number;
  publishedAt?: Date | null;
}
export type UnlockGrants = Record<string, string>;

/** Grants are deliberately not account JWTs and cannot authenticate a user. */
export class BlogAccessPolicy {
  constructor(private readonly secret: string, private readonly now = () => Date.now()) {}

  private signature(value: string) {
    return createHmac('sha256', this.secret).update('blog-content-unlock:' + value).digest('base64url');
  }

  canRead(kind: string, item: AccessContent, user: { uid: number } | null, grants: UnlockGrants): boolean {
    if (item.status !== 'published' || (item.publishedAt && item.publishedAt.getTime() > this.now())) return false;
    if (item.accessMode === 'public') return true;
    if (item.accessMode === 'login') return !!user?.uid;
    if (item.accessMode !== 'password') return false;
    try {
      const [body, signature, extra] = (grants[`${kind}:${item.id}`] || '').split('.');
      if (!body || !signature || extra) return false;
      const expected = Buffer.from(this.signature(body));
      const actual = Buffer.from(signature);
      if (expected.length !== actual.length || !timingSafeEqual(expected, actual)) return false;
      const payload = JSON.parse(Buffer.from(body, 'base64url').toString());
      return payload.kind === kind && payload.id === item.id && payload.version === item.accessVersion && payload.exp > this.now();
    } catch { return false; }
  }

  async unlock(kind: string, item: AccessContent, password: string) {
    if (item.status !== 'published' || (item.publishedAt && item.publishedAt.getTime() > this.now()) || item.accessMode !== 'password' || !item.passwordHash ||
        !(await argon2.verify(item.passwordHash, password))) {
      throw new ForbiddenException('访问密码错误或内容不可访问');
    }
    const expiresIn = 3600;
    const body = Buffer.from(JSON.stringify({ kind, id: item.id, version: item.accessVersion, exp: this.now() + expiresIn * 1000 })).toString('base64url');
    return { token: `${body}.${this.signature(body)}`, expiresIn };
  }
}
