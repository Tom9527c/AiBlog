import test from 'node:test';
import assert from 'node:assert/strict';
import http from 'node:http';
import { createGateway } from './gateway.mjs';

test('routes SPA, admin and API requests and preserves request data', async t => {
  const servers = [];
  async function listen(server) {
    servers.push(server);
    await new Promise(resolve => server.listen(0, '127.0.0.1', resolve));
    return server.address().port;
  }
  t.after(() => Promise.all(servers.map(server => new Promise(resolve => { server.closeAllConnections(); server.close(resolve); }))));
  const ports = {};
  for (const name of ['blog', 'admin', 'api']) {
    ports[name] = await listen(http.createServer(async (req, res) => {
      let body = '';
      for await (const chunk of req) body += chunk;
      res.setHeader('Content-Type', 'application/json');
      res.end(JSON.stringify({ name, url: req.url, method: req.method, auth: req.headers.authorization, body }));
    }));
  }
  const port = await listen(createGateway(ports));
  const base = `http://127.0.0.1:${port}`;
  for (const [path, name, expected] of [
    ['/articles/abc', 'blog', '/articles/abc'], ['/admin/blog/article?id=2', 'admin', '/admin/blog/article?id=2'],
    ['/api/blog/articles?page=2', 'api', '/blog/articles?page=2'], ['/api?x=1', 'api', '/?x=1'], ['/apiculture', 'blog', '/apiculture']
  ]) {
    const result = await (await fetch(base + path)).json();
    assert.equal(result.name, name); assert.equal(result.url, expected);
  }
  const redirect = await fetch(base + '/admin?x=1', { redirect: 'manual' });
  assert.equal(redirect.status, 308); assert.equal(redirect.headers.get('location'), '/admin/?x=1');
  const write = await (await fetch(base + '/api/blog/comments', { method: 'POST', headers: { Authorization: 'Bearer test' }, body: 'comment' })).json();
  assert.equal(write.auth, 'Bearer test'); assert.equal(write.method, 'POST'); assert.equal(write.body, 'comment');
});
