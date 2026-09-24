import type { Kind, Content, Page } from "../../types";
export const base = (import.meta.env.VITE_API_BASE_URL || "/api").replace(
  /\/$/,
  "",
);
export function token(): string {
  try {
    return JSON.parse(localStorage.getItem("SOY_token") || "null") || "";
  } catch {
    return "";
  }
}
export function setToken(value: string) {
  if (value) localStorage.setItem("SOY_token", JSON.stringify(value));
  else localStorage.removeItem("SOY_token");
  window.dispatchEvent(new Event("blog-auth"));
}
export function grants(): Record<string, string> {
  try {
    return JSON.parse(sessionStorage.getItem("blog-unlocks") || "{}");
  } catch {
    return {};
  }
}
export function headers() {
  return {
    "Content-Type": "application/json",
    ...(token() ? { Authorization: `Bearer ${token()}` } : {}),
    "X-Blog-Unlock": JSON.stringify(grants()),
  };
}
export async function api<T>(
  path: string,
  options: RequestInit = {},
): Promise<T> {
  const r = await fetch(base + path, {
    ...options,
    headers: { ...headers(), ...options.headers },
  });
  const json = await r.json().catch(() => ({ message: "服务响应异常" }));
  if (!r.ok || (json.code !== undefined && Number(json.code) !== 200)) {
    if (r.status === 401 || Number(json.code) === 401) setToken("");
    throw new Error(
      Array.isArray(json.message)
        ? json.message.join("，")
        : json.msg || json.message || `请求失败 (${r.status})`,
    );
  }
  return (json.data === undefined ? json : json.data) as T;
}
export const list = (kind: Kind, query: Record<string, string | number> = {}) =>
  api<Page>(
    `/blog/public/content/${kind}?${new URLSearchParams(Object.entries(query).map(([k, v]) => [k, String(v)]))}`,
  );
export const detail = (kind: Kind, id: string | number) =>
  api<Content>(`/blog/public/content/${kind}/${encodeURIComponent(id)}`);
export async function unlock(kind: Kind, id: number, password: string) {
  const r = await api<{ token: string }>(
    `/blog/public/content/${kind}/${id}/unlock`,
    { method: "POST", body: JSON.stringify({ password }) },
  );
  sessionStorage.setItem(
    "blog-unlocks",
    JSON.stringify({ ...grants(), [`${kind}:${id}`]: r.token }),
  );
  window.dispatchEvent(new Event("blog-access"));
}
export function safeUrl(url?: string) {
  return url && /^(https?:\/\/|\/[^/]|blob:)/i.test(url) ? url : "";
}
// Share only in-flight downloads, scoped to the exact access credentials. Each
// consumer owns its blob URL; completed protected media is never cached here.
const mediaDownloads = new Map<string, Promise<Blob>>();
export async function mediaUrl(url: string, signal?: AbortSignal) {
  signal?.throwIfAborted();
  const m = url.match(/^\/blog-media\/(\d+)$/);
  if (!m) return safeUrl(url);
  const access = headers();
  const key = JSON.stringify([url, access]);
  let download = mediaDownloads.get(key);
  if (!download) {
    // A consumer unmounting must not cancel other consumers or StrictMode's
    // immediate remount. Bound abandoned transfers with a network timeout.
    download = fetch(`${base}/blog/public/media/${m[1]}`, {
      headers: access,
      signal: AbortSignal.timeout(120000),
    }).then(async r => {
      if (!r.ok) throw new Error(`媒体加载失败 (${r.status})`);
      return r.blob();
    }).finally(() => mediaDownloads.delete(key));
    mediaDownloads.set(key, download);
  }
  const blob = await download;
  signal?.throwIfAborted();
  return URL.createObjectURL(blob);
}
