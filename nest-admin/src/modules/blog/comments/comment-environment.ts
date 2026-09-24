import { isIP } from 'node:net';
import { Request } from 'express';
import { UAParser } from 'ua-parser-js';
import * as Ip2Region from 'ip2region-ts';
import * as proxyAddr from 'proxy-addr';

const searcher = Ip2Region.newWithBuffer(Ip2Region.loadContentFromFile(Ip2Region.defaultDbFile));

function header(req: Request, name: string) {
  const value = req.headers[name];
  return Array.isArray(value) ? value[0] : value || '';
}

function normalizedIp(value: string) {
  const ip = value.trim().replace(/^::ffff:/, '');
  return isIP(ip) ? ip : '';
}

function privateIp(ip: string) {
  if (!ip || ip === '::1' || ip === '127.0.0.1') return true;
  if (isIP(ip) === 6) return /^(?:fc|fd|fe8|fe9|fea|feb)/i.test(ip);
  const parts = ip.split('.').map(Number);
  return parts[0] === 10 || parts[0] === 127 || parts[0] === 0 || (parts[0] === 169 && parts[1] === 254) ||
    (parts[0] === 172 && parts[1] >= 16 && parts[1] <= 31) || (parts[0] === 192 && parts[1] === 168);
}

export function requestClientIp(req: Request, trustedProxyCidrs: string | boolean = '') {
  const remote = normalizedIp(req.socket?.remoteAddress || '');
  const configured = trustedProxyCidrs === true ? 'loopback' : trustedProxyCidrs;
  let trust: ReturnType<typeof proxyAddr.compile> | null = null;
  if (configured && remote) {
    try { trust = proxyAddr.compile(String(configured).split(',').map(value => value.trim()).filter(Boolean)); }
    catch { trust = null; }
  }
  if (trust && trust(remote, 0)) {
    const forwarded = normalizedIp(proxyAddr(req, trust));
    if (forwarded && forwarded !== remote) return forwarded;
  }
  return remote;
}

function windowsVersion(platform: string, platformVersion: string, fallback?: string) {
  if (platform.replaceAll('"', '').toLowerCase() !== 'windows') return fallback || '';
  const major = Number(platformVersion.replaceAll('"', '').split('.')[0]);
  return major >= 13 ? '11' : fallback || '10';
}

async function location(ip: string) {
  if (privateIp(ip)) return '本地/内网';
  if (isIP(ip) !== 4) return '未知属地';
  try {
    const result = await searcher.search(ip);
    const [country, , province] = String(result.region || '').split('|');
    if (country !== '中国' || !province || province === '0') return country && country !== '0' ? country : '未知属地';
    return province.replace(/(?:省|市|壮族自治区|回族自治区|维吾尔自治区|自治区|特别行政区)$/u, '') || '未知属地';
  } catch { return '未知属地'; }
}

export async function commentEnvironment(req: Request, trustedProxyCidrs: string | boolean = '') {
  const ua = new UAParser(String(header(req, 'user-agent'))).getResult();
  const browserName = ua.browser.name === 'Edge' ? 'Microsoft Edge' : ua.browser.name || '';
  const fullVersions = String(header(req, 'sec-ch-ua-full-version-list'));
  const hintedBrowser = browserName && [...fullVersions.matchAll(/"([^"]+)";v="([^"]+)"/g)]
    .find(match => match[1] === browserName || (browserName === 'Chrome' && match[1] === 'Google Chrome'));
  const browserVersion = hintedBrowser?.[2] || ua.browser.version || '';
  const osName = ua.os.name || '';
  const hintedWindows = windowsVersion(String(header(req, 'sec-ch-ua-platform')), String(header(req, 'sec-ch-ua-platform-version')), ua.os.version);
  const osVersion = osName === 'Windows' ? hintedWindows : ua.os.version || '';
  return {
    browser: [browserName, browserVersion].filter(Boolean).join(' '),
    os: [osName, osVersion].filter(Boolean).join(' '),
    location: await location(requestClientIp(req, trustedProxyCidrs)),
  };
}
