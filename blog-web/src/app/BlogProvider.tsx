import type { ReactNode } from "react";
import { BlogContext } from "../components/context";
import type { Content, Session, Site } from "../types";

export interface BlogProviderValue {
  site: Site;
  session: Session | null;
  login: () => void;
  notify: (message: string) => void;
  play: (track: Content) => void;
  revision: number;
}

export function BlogProvider({ value, children }: { value: BlogProviderValue; children: ReactNode }) {
  return <BlogContext.Provider value={value}>{children}</BlogContext.Provider>;
}
