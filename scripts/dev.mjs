import { spawn } from 'node:child_process';
import net from 'node:net';

// Fail before spawning anything; never reuse or terminate an unknown existing service.
for (const port of [5173, 5174, 8080, 3000]) {
  await new Promise((resolve, reject) => {
    const probe = net.createServer();
    probe.once('error', () => reject(new Error(`Port ${port} is occupied. Use individual dev:* commands for services not already running.`)));
    probe.listen(port, '127.0.0.1', () => probe.close(resolve));
  });
}
const children = [];
let stopping = false;
function stop(code = 0) {
  if (stopping) return;
  stopping = true;
  process.exitCode = code;
  for (const child of children) {
    try { process.kill(-child.pid, 'SIGTERM'); } catch { /* Already exited. */ }
  }
}
for (const name of ['api', 'blog', 'admin', 'gateway']) {
  const child = spawn('npm', ['run', `dev:${name}`], { cwd: new URL('..', import.meta.url), stdio: 'inherit', detached: true });
  children.push(child);
  child.on('error', error => { console.error(error); stop(1); });
  child.on('exit', code => { if (!stopping) stop(code || 1); });
}
process.on('SIGINT', () => stop());
process.on('SIGTERM', () => stop());
