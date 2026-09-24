import { createCipheriv, createDecipheriv, createHash, randomBytes } from 'node:crypto';
import { mkdir, readFile, rm, writeFile } from 'node:fs/promises';
import { dirname, join } from 'node:path';
import * as AliOSS from 'ali-oss';
import * as COS from 'cos-nodejs-sdk-v5';

export type StorageProfile = {
  type: string;
  secretId: string;
  secretKey: string;
  bucket: string;
  region: string;
  domain: string;
};

function localPath(root: string, key: string) {
  if (!/^(upload|storage\/blog-private|legacy-blog-private)\//.test(key) || key.includes('\\') || key.split('/').some(part => !part || part === '.' || part === '..')) {
    throw new Error('不安全的存储路径');
  }
  if (key.startsWith('legacy-blog-private/')) return join(root, '.blog-private', key.slice('legacy-blog-private/'.length));
  return join(root, key.startsWith('upload/') ? 'public' : '', key);
}

export class ObjectStore {
  constructor(private readonly root = process.cwd()) {}

  private ali(profile: StorageProfile) {
    return new AliOSS({ accessKeyId: profile.secretId, accessKeySecret: profile.secretKey,
      bucket: profile.bucket, region: profile.region, ...(profile.domain ? { endpoint: profile.domain } : {}) });
  }

  private cos(profile: StorageProfile) {
    return new COS({ SecretId: profile.secretId, SecretKey: profile.secretKey,
      ...(profile.domain ? { Domain: profile.domain } : {}) });
  }

  async put(profile: StorageProfile, key: string, body: Buffer, mime = 'application/octet-stream', visibility: 'public' | 'private' = 'public'): Promise<string> {
    if (profile.type === 'local') {
      if (visibility === 'private' && key.startsWith('upload/')) throw new Error('私有文件不能保存到公开目录');
      const path = localPath(this.root, key);
      await mkdir(dirname(path), { recursive: true });
      await writeFile(path, body, { mode: visibility === 'private' ? 0o600 : 0o644, flag: 'wx' });
      return `/${key}`;
    }
    if (profile.type === 'aliyun') {
      const result = await this.ali(profile).put(key, body, { mime, headers: { 'x-oss-object-acl': visibility === 'private' ? 'private' : 'public-read' } });
      return result.url;
    }
    if (profile.type === 'qcloud') {
      const client = this.cos(profile);
      await client.putObject({ Bucket: profile.bucket, Region: profile.region, Key: key, Body: body,
        ContentType: mime, ACL: visibility === 'private' ? 'private' : 'public-read' });
      return new Promise<string>((resolve, reject) => client.getObjectUrl(
        { Bucket: profile.bucket, Region: profile.region, Key: key, Sign: false },
        (error, data) => error ? reject(error) : resolve(data.Url),
      ));
    }
    throw new Error('未配置有效的存储类型');
  }

  async read(profile: StorageProfile, key: string): Promise<Buffer> {
    if (profile.type === 'local') return readFile(localPath(this.root, key));
    if (profile.type === 'aliyun') {
      const result = await this.ali(profile).get(key);
      return Buffer.from(result.content);
    }
    if (profile.type === 'qcloud') {
      const result = await this.cos(profile).getObject({ Bucket: profile.bucket, Region: profile.region, Key: key });
      return Buffer.from(result.Body as Buffer);
    }
    throw new Error('未配置有效的存储类型');
  }

  async remove(profile: StorageProfile, key: string) {
    if (profile.type === 'local') return rm(localPath(this.root, key), { force: true });
    if (profile.type === 'aliyun') { await this.ali(profile).delete(key); return; }
    if (profile.type === 'qcloud') { await this.cos(profile).deleteObject({ Bucket: profile.bucket, Region: profile.region, Key: key }); return; }
    throw new Error('未配置有效的存储类型');
  }
}

export function sealProfile(profile: StorageProfile, secret: string) {
  const key = createHash('sha256').update(secret).digest();
  const iv = randomBytes(12);
  const cipher = createCipheriv('aes-256-gcm', key, iv);
  const body = Buffer.concat([cipher.update(JSON.stringify(profile), 'utf8'), cipher.final()]);
  return `${iv.toString('base64url')}.${cipher.getAuthTag().toString('base64url')}.${body.toString('base64url')}`;
}

export function openProfile(value: string, secret: string): StorageProfile {
  const [ivText, tagText, bodyText] = value.split('.');
  if (!ivText || !tagText || !bodyText) throw new Error('存储配置损坏');
  const decipher = createDecipheriv('aes-256-gcm', createHash('sha256').update(secret).digest(), Buffer.from(ivText, 'base64url'));
  decipher.setAuthTag(Buffer.from(tagText, 'base64url'));
  return JSON.parse(Buffer.concat([decipher.update(Buffer.from(bodyText, 'base64url')), decipher.final()]).toString('utf8')) as StorageProfile;
}
