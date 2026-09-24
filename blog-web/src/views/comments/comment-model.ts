import type { Content } from "../../types";

export interface Comment extends Content {
  replies?: Comment[];
  likes?: number;
  dislikes?: number;
  myVote?: number;
}
export interface CommentPage {
  items: Comment[];
  total: number;
  commentCount: number;
  page: number;
  pageSize: number;
}
export type Target = "documents" | "essays" | "albums" | "about";
export function visitor() {
  try {
    let value = localStorage.getItem("blog-comment-visitor");
    if (!value) {
      value = crypto.randomUUID();
      localStorage.setItem("blog-comment-visitor", value);
    }
    return value;
  } catch {
    return "";
  }
}
export const nameOf = (c: Comment) => String(c.metadata.authorName || "读者");
