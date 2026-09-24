import { createContext, useContext } from "react";
import type { Content, Session, Site } from "../types";

export const BlogContext = createContext<{
  site: Site;
  session: Session | null;
  login: () => void;
  notify: (s: string) => void;
  play: (c: Content) => void;
  revision: number;
}>({} as never);

export const useBlog = () => useContext(BlogContext);
