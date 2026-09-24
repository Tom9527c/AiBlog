import { mkdtemp, readFile, rm, mkdir, writeFile } from 'node:fs/promises';
import { tmpdir } from 'node:os';
import { join } from 'node:path';
import { ObjectStore, sealProfile, openProfile } from './object-store';

const config = { type: 'local', secretId: '', secretKey: '', bucket: '', region: '', domain: '' };
describe('shared object storage', () => {
  let root: string;
  beforeEach(async () => { root = await mkdtemp(join(tmpdir(), 'blog-storage-')); });
  afterEach(async () => { await rm(root, { recursive: true, force: true }); });
  it('keeps private files outside public and reads them after the active configuration changes', async () => {
    const driver = new ObjectStore(root);
    await driver.put(config, 'storage/blog-private/test.png', Buffer.from('private'), 'image/png', 'private');
    expect(await driver.read(config, 'storage/blog-private/test.png')).toEqual(Buffer.from('private'));
    await expect(readFile(join(root, 'public/storage/blog-private/test.png'))).rejects.toThrow();
    expect(await readFile(join(root, 'storage/blog-private/test.png'), 'utf8')).toBe('private');
    await driver.remove(config, 'storage/blog-private/test.png');
    await expect(driver.read(config, 'storage/blog-private/test.png')).rejects.toThrow();
  });
  it.each(['../secret', '/etc/passwd', 'public/../secret', 'public\\secret', 'other/secret'])('rejects unsafe local key %s', async key => {
    await expect(new ObjectStore(root).put(config, key, Buffer.from('data'))).rejects.toThrow('不安全的存储路径');
  });
  it('reads legacy private files and rejects writing private bytes under public', async () => {
    await mkdir(join(root, '.blog-private'));
    await writeFile(join(root, '.blog-private', 'old'), 'legacy');
    const driver = new ObjectStore(root);
    expect((await driver.read(config, 'legacy-blog-private/old')).toString()).toBe('legacy');
    await expect(driver.put(config, 'upload/private.png', Buffer.from('secret'), 'image/png', 'private')).rejects.toThrow();
  });
  it('encrypts profile credentials and detects tampering or a wrong key', () => {
    const profile = { ...config, type: 'aliyun', secretKey: 'cloud-secret' };
    const encrypted = sealProfile(profile, 'server-secret');
    expect(encrypted).not.toContain('cloud-secret');
    expect(openProfile(encrypted, 'server-secret')).toEqual(profile);
    expect(() => openProfile(encrypted, 'wrong-secret')).toThrow();
  });
});
