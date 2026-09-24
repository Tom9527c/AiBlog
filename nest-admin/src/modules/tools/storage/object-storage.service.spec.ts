import { mkdtemp, rm } from 'node:fs/promises';
import { tmpdir } from 'node:os';
import { join } from 'node:path';
import { ConfigService } from '@nestjs/config';
import { ObjectStorageService, LOCAL_PROFILE } from './object-storage.service';
import { ObjectStore } from './object-store';
import { Storage } from './storage.entity';

describe('file-specific storage configuration', () => {
  let root: string;
  beforeEach(async () => { root = await mkdtemp(join(tmpdir(), 'storage-config-')); });
  afterEach(async () => { await rm(root, { recursive: true, force: true }); jest.restoreAllMocks(); });
  it('stores new files under the upload date and legacy type folders', async () => {
    const put = jest.spyOn(ObjectStore.prototype, 'put').mockResolvedValue('/upload/ignored');
    const service = new ObjectStorageService(LOCAL_PROFILE, new ConfigService());

    const result = await service.put(Buffer.from('image'), 'cover.PNG', 'image/png', 'private');

    expect(put).toHaveBeenCalledWith(
      LOCAL_PROFILE,
      expect.stringMatching(/^storage\/blog-private\/\d{4}-\d{2}-\d{2}\/image\/[0-9a-f-]+\.png$/),
      Buffer.from('image'),
      'image/png',
      'private',
    );
    expect(result.storageKey).toMatch(/^storage\/blog-private\/\d{4}-\d{2}-\d{2}\/image\/[0-9a-f-]+\.png$/);
  });

  it('uses the same date and type folders for public files', async () => {
    const put = jest.spyOn(ObjectStore.prototype, 'put').mockResolvedValue('/upload/ignored');
    const service = new ObjectStorageService(LOCAL_PROFILE, new ConfigService());

    await service.put(Buffer.from('video'), 'clip.mp4', 'video/mp4', 'public');

    expect(put.mock.calls[0][1]).toMatch(/^upload\/\d{4}-\d{2}-\d{2}\/video\/[0-9a-f-]+\.mp4$/);
  });

  it('reads a local file with its saved location after active configuration changes to OSS', async () => {
    const driver = new ObjectStore(root);
    await driver.put(LOCAL_PROFILE, 'storage/blog-private/existing.png', Buffer.from('original'), 'image/png', 'private');
    const read = jest.spyOn(ObjectStore.prototype, 'read').mockImplementation((profile, key) => {
      // Use actual filesystem read, while keeping the test in an isolated directory.
      const path = join(root, key);
      expect(profile.type).toBe('local');
      return import('node:fs/promises').then(fs => fs.readFile(path));
    });
    const service = new ObjectStorageService({ ...LOCAL_PROFILE, type: 'aliyun', bucket: 'new' }, new ConfigService());
    expect((await service.read({ provider: 'local', storageKey: 'storage/blog-private/existing.png' } as Storage)).toString()).toBe('original');
    expect(read).toHaveBeenCalledTimes(1);
  });
  it('fails closed when a cloud file has no original profile, instead of using the active bucket', async () => {
    const service = new ObjectStorageService({ ...LOCAL_PROFILE, type: 'qcloud', bucket: 'new' }, new ConfigService());
    await expect(service.read({ provider: 'aliyun', storageKey: 'private/key' } as Storage)).rejects.toThrow('文件缺少存储配置记录');
  });
});
