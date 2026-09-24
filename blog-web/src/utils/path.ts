import type { Content, Kind } from "../types";

export const pathFor = (kind: Kind, content: Content) =>
  kind === "documents"
    ? `/posts/${encodeURIComponent(content.slug || content.id)}.html`
    : kind === "albums"
      ? `/album/${encodeURIComponent(content.slug || content.id)}`
      : `/${kind}/${encodeURIComponent(content.slug || content.id)}`;
