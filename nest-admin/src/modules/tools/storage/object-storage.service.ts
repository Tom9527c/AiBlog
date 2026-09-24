import { Inject, Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { randomUUID } from 'node:crypto';
import { extname } from 'node:path';
import * as dayjs from 'dayjs';
import { IOssConfig, OssConfig } from '~/config/oss.config';
import { getFileType } from '~/utils/file.util';
import { ObjectStore, openProfile, sealProfile, StorageProfile } from './object-store';
import { Storage } from './storage.entity';

export const LOCAL_PROFILE: StorageProfile = { type: 'local', secretId: '', secretKey: '', bucket: '', region: '', domain: '' };

@Injectable()
export class ObjectStorageService {
  private readonly driver = new ObjectStore();
  constructor(@Inject(OssConfig.KEY) private readonly config: IOssConfig, private readonly settings: ConfigService) {}

  private secret() { return this.settings.getOrThrow<string>('security.jwtSecret'); }
  profile(): StorageProfile { return this.config.type === 'local' ? LOCAL_PROFILE : this.config; }
  storedProfile(row: Storage): StorageProfile {
    if (row.storageProfile) return openProfile(row.storageProfile, this.secret());
    if (!row.provider || row.provider === 'local') return LOCAL_PROFILE;
    throw new Error('文件缺少存储配置记录');
  }
  storedKey(row: Storage) {
    return row.storageKey || row.path.replace(/^\//, '');
  }

  async put(body: Buffer, name: string, mime: string, visibility: 'public' | 'private') {
    const profile = this.profile();
    const extension = extname(name).toLowerCase();
    const suffix = /^\.[a-z0-9]{1,12}$/.test(extension) ? extension : '';
    // Keep the upload layout used by the original local uploader: date first,
    // then the file category. The UUID still prevents collisions and avoids
    // exposing the original file name in public or private object keys.
    const type = getFileType(extension.slice(1));
    const date = dayjs().format('YYYY-MM-DD');
    const root = visibility === 'private' ? 'storage/blog-private' : 'upload';
    const key = `${root}/${date}/${type}/${randomUUID()}${suffix}`;
    const url = await this.driver.put(profile, key, body, mime, visibility);
    return { storageKey: key, provider: profile.type, storageProfile: profile.type === 'local' ? null : sealProfile(profile, this.secret()), path: url, mime, visibility };
  }
  async read(row: Storage) { return this.driver.read(this.storedProfile(row), this.storedKey(row)); }
  async remove(row: Storage) { await this.driver.remove(this.storedProfile(row), this.storedKey(row)); }
}
