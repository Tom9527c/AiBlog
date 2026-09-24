import type { ReactNode } from "react";
import { detail } from "../../services/api";
import { useLoad } from "../../hooks/useLoad";
import type { Content, Kind } from "../../types";
import { useBlog } from "../context";
import { Status } from "../feedback/Status";
import { Gate } from "./Gate";
import { ContentBody } from "./ContentBody";

export function LoadedContent({
  kind,
  item,
  children,
}: {
  kind: Kind;
  item: Content;
  children?: (c: Content) => ReactNode;
}) {
  const { revision } = useBlog();
  const state = useLoad(() => detail(kind, item.id), [kind, item.id, revision]);
  return (
    <>
      <Status {...state} />
      {state.data &&
        (state.data.locked ? (
          <Gate kind={kind} item={state.data} onUnlocked={state.reload} />
        ) : children ? (
          children(state.data)
        ) : (
          <ContentBody item={state.data} />
        ))}
    </>
  );
}
