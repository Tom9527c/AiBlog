import { api } from "./api";
import type { Content, Kind, Page } from "../types";

export const listContent = (
  kind: Kind,
  query: Record<string, string | number> = {},
) =>
  api<Page>(
    `/blog/public/content/${kind}?${new URLSearchParams(
      Object.entries(query).map(([key, value]) => [key, String(value)]),
    )}`,
  );

export const getContent = (kind: Kind, id: string | number) =>
  api<Content>(`/blog/public/content/${kind}/${encodeURIComponent(id)}`);

export const list = listContent;
export const detail = getContent;

/** Follow the public article order, including neighbors on adjacent result pages. */
export async function articleNeighbors(id: number): Promise<{ previous?: Content; next?: Content }> {
  let previous: Content | undefined;
  let found = false;
  let loaded = 0;
  for (let page = 1; ; page += 1) {
    const result = await listContent("documents", { page, pageSize: 100 });
    for (const item of result.items) {
      if (found) return { previous, next: item };
      if (item.id === id) found = true;
      else previous = item;
    }
    loaded += result.items.length;
    if (!result.items.length || loaded >= result.total) return found ? { previous, next: undefined } : {};
  }
}
