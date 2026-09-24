import { useState } from "react";
import { unlock } from "../../services/api";
import type { Content, Kind } from "../../types";
import { useBlog } from "../context";

export function Gate({
  kind,
  item,
  onUnlocked,
}: {
  kind: Kind;
  item: Content;
  onUnlocked: () => void;
}) {
  const { login } = useBlog();
  const [password, setPassword] = useState("");
  const [error, setError] = useState("");
  const [busy, setBusy] = useState(false);
  return (
    <div className="access-gate">
      <span>♙</span>
      <h2>
        {item.accessMode === "login" ? "登录后继续阅读" : "这份内容已加密"}
      </h2>
      <p>
        {item.accessMode === "login"
          ? "使用 AiBlog 账户登录，继续发现精彩。"
          : "请输入作者设置的访问密码。"}
      </p>
      {item.accessMode === "login" ? (
        <button onClick={login}>登录账户</button>
      ) : (
        <form
          onSubmit={async (e) => {
            e.preventDefault();
            setBusy(true);
            setError("");
            try {
              await unlock(kind, item.id, password);
              onUnlocked();
            } catch (e) {
              setError((e as Error).message);
            } finally {
              setBusy(false);
            }
          }}
        >
          <input
            type="password"
            aria-label="访问密码"
            required
            value={password}
            onChange={(e) => setPassword(e.target.value)}
          />
          <button disabled={busy}>{busy ? "验证中…" : "解锁阅读"}</button>
        </form>
      )}
      {error && <p role="alert">{error}</p>}
    </div>
  );
}
