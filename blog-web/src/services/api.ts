// Compatibility entry point for the request layer during the module migration.
export {
  api,
  base,
  detail,
  grants,
  headers,
  list,
  mediaUrl,
  safeUrl,
  setToken,
  token,
  unlock,
} from "./legacy/api";
