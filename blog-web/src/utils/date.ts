export const date = (value: string | null) =>
  value ? new Date(value).toLocaleDateString("zh-CN") : "";
