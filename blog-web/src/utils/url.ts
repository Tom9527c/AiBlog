export function safeUrl(url?: string) {
  return url && /^(https?:\/\/|\/[^/]|blob:)/i.test(url) ? url : "";
}

export { mediaUrl } from "../services/media";
