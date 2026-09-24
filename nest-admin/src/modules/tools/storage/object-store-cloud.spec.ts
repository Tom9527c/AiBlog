import { ObjectStore } from './object-store';
const aliPut = jest.fn(), aliGet = jest.fn(), cosPut = jest.fn(), cosGet = jest.fn();
jest.mock('ali-oss', () => jest.fn().mockImplementation(() => ({ put: (...args) => aliPut(...args), get: (...args) => aliGet(...args) })));
jest.mock('cos-nodejs-sdk-v5', () => jest.fn().mockImplementation(() => ({
  putObject: (...args) => cosPut(...args), getObject: (...args) => cosGet(...args),
  getObjectUrl: (_params, cb) => cb(null, { Url: 'https://bucket.example/object' }),
})));
const profile = { type: 'aliyun', secretId: 'id', secretKey: 'key', bucket: 'bucket', region: 'region', domain: '' };
afterEach(() => jest.clearAllMocks());
it('uploads to Aliyun with a private ACL in the original PUT, never exposing an intermediate public object', async () => {
  aliPut.mockResolvedValue({ url: 'https://bucket.example/object' });
  const driver = new ObjectStore();
  await driver.put(profile, 'storage/blog-private/test', Buffer.from('secret'), 'image/png', 'private');
  expect(aliPut).toHaveBeenCalledWith('storage/blog-private/test', Buffer.from('secret'), expect.objectContaining({ headers: { 'x-oss-object-acl': 'private' } }));
});
it('sets private COS ACL and reads with the original bucket from the file profile', async () => {
  cosPut.mockResolvedValue({}); cosGet.mockResolvedValue({ Body: Buffer.from('secret') });
  const driver = new ObjectStore();
  await driver.put({ ...profile, type: 'qcloud' }, 'storage/blog-private/test', Buffer.from('secret'), 'video/mp4', 'private');
  expect(cosPut).toHaveBeenCalledWith(expect.objectContaining({ Bucket: 'bucket', ACL: 'private', ContentType: 'video/mp4' }));
  expect(await driver.read({ ...profile, type: 'qcloud', bucket: 'old-bucket' }, 'original')).toEqual(Buffer.from('secret'));
  expect(cosGet).toHaveBeenCalledWith(expect.objectContaining({ Bucket: 'old-bucket', Key: 'original' }));
});
it('propagates cloud upload failures without returning a success URL', async () => {
  aliPut.mockRejectedValue(new Error('storage unavailable'));
  await expect(new ObjectStore().put(profile, 'key', Buffer.from('data'))).rejects.toThrow('storage unavailable');
});
