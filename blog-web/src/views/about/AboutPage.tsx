import Comments from "../comments/Comments";
import { AboutCards } from "./components/AboutCards";
import { LoadedContent, Status, useBlog, useLoad } from "../../components";
import { api } from "../../services/api";
import { PageShell } from "../../components/page/PageShell";
import type { Content } from "../../types";

export function AboutPage() {
  const { revision } = useBlog();
  const state = useLoad(
    () => api<Content | null>("/blog/public/about"),
    [revision],
  );
  return (
    <PageShell title={state.data?.title || "关于本人"} aside={false}>
      <Status {...state} retry={state.reload} empty={!state.data} />
      {state.data &&
        (state.data.locked ? (
          <LoadedContent kind="about" item={state.data}>
            {(item) => (
              <>
                <AboutCards item={item} />
                <Comments targetKind="about" targetId={item.id} />
              </>
            )}
          </LoadedContent>
        ) : (
          <>
            <AboutCards item={state.data} />
            <Comments targetKind="about" targetId={state.data.id} />
          </>
        ))}
    </PageShell>
  );
}
