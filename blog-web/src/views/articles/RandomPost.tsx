import { useEffect } from "react";
import { useNavigate } from "react-router-dom";
import { list } from "../../services/content";
import { pathFor } from "../../utils/path";
import { useLoad } from "../../hooks/useLoad";
import { Status } from "../../components/feedback/Status";

export function RandomPost() {
  const navigate = useNavigate();
  const state = useLoad(async () => {
    const count = await list("documents", {pageSize: 1});
    if (!count.total) return null;
    const result = await list("documents", {pageSize: 1, page: 1 + Math.floor(Math.random() * count.total)});
    return result.items[0] || null;
  }, []);
  useEffect(() => {
    if (state.data) navigate(pathFor("documents",state.data), {replace:true});
  },[state.data,navigate]);
  return <Status loading={state.loading} error={state.error} retry={state.reload} empty={!state.loading && !state.data}/>;
}
