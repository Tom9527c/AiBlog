import http from 'node:http';
import net from 'node:net';
import { pathToFileURL } from 'node:url';

export function createGateway({ blog = 5174, admin = 8080, api = 3000 } = {}) {
  function route(url = '/') {
    if (/^\/api(?:\/|\?|$)/.test(url)) return { port: api, path: url.replace(/^\/api(?=\/|\?|$)/, '') || '/' };
    return { port: url.startsWith('/admin/') ? admin : blog, path: url };
  }
  const server = http.createServer((req, res) => {
    if (req.url === '/admin' || req.url?.startsWith('/admin?')) {
      res.writeHead(308, { Location: req.url.replace('/admin', '/admin/') });
      res.end();
      return;
    }
    const target = route(req.url);
    if (target.path.startsWith('?')) target.path = `/${target.path}`;
    const upstream = http.request({
      hostname: '127.0.0.1', port: target.port, path: target.path,
      method: req.method, headers: req.headers
    }, response => {
      res.writeHead(response.statusCode, response.headers);
      response.pipe(res);
    });
    upstream.on('error', () => {
      if (!res.headersSent) res.writeHead(502, { 'Content-Type': 'text/plain; charset=utf-8' });
      res.end(`Upstream localhost:${target.port} is unavailable. Start the corresponding dev service.\n`);
    });
    req.on('aborted', () => upstream.destroy());
    req.pipe(upstream);
  });
  // Vite HMR uses WebSockets, with /admin/ distinguishing the two dev servers.
  server.on('upgrade', (req, socket, head) => {
    const target = route(req.url);
    const upstream = net.connect(target.port, '127.0.0.1', () => {
      upstream.write(`${req.method} ${target.path} HTTP/${req.httpVersion}\r\n`);
      for (let i = 0; i < req.rawHeaders.length; i += 2) upstream.write(`${req.rawHeaders[i]}: ${req.rawHeaders[i + 1]}\r\n`);
      upstream.write('\r\n');
      if (head.length) upstream.write(head);
      socket.pipe(upstream).pipe(socket);
    });
    upstream.on('error', () => socket.destroy());
    socket.on('error', () => upstream.destroy());
    socket.on('close', () => upstream.destroy());
  });
  return server;
}

if (process.argv[1] && import.meta.url === pathToFileURL(process.argv[1]).href) {
  const server = createGateway();
  server.on('error', error => { console.error(error.message); process.exitCode = 1; });
  server.listen(5173, '127.0.0.1', () => console.log('AiBlog: http://localhost:5173/  Admin: http://localhost:5173/admin/'));
}
