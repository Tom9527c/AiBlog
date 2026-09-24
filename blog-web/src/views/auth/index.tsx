import { useState } from "react";
import { api, setToken } from "../../services/api";
import { Modal, Status, useBlog, useLoad } from "../../components";
export default function Auth({ onClose }: { onClose: () => void }) {
  const [mode, setMode] = useState<"login" | "register" | "reset" | "code">(
    "login",
  );
  const [username, setUsername] = useState("");
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [code, setCode] = useState("");
  const [busy, setBusy] = useState(false);
  const [error, setError] = useState("");
  const [sent, setSent] = useState(false);
  const { notify } = useBlog();
  const captcha = useLoad(() =>
    api<{ img: string; id: string }>("/auth/captcha/img"),
  );
  return (
    <Modal
      title={
        {
          login: "欢迎回来",
          register: "创建账户",
          reset: "重置密码",
          code: "邮箱验证码登录",
        }[mode]
      }
      onClose={onClose}
    >
      <div className="auth-tabs">
        {(["login", "register", "reset", "code"] as const).map((m) => (
          <button
            className={mode === m ? "active" : ""}
            key={m}
            onClick={() => {
              setMode(m);
              setError("");
              setCode("");
            }}
          >
            {
              {
                login: "登录",
                register: "注册",
                reset: "忘记密码",
                code: "邮箱登录",
              }[m]
            }
          </button>
        ))}
      </div>
      <form
        className="auth-form"
        onSubmit={async (e) => {
          e.preventDefault();
          setBusy(true);
          setError("");
          try {
            if (mode === "login" || mode === "code") {
              const r = await api<{ access_token: string }>(
                `/auth/${mode === "login" ? "login" : "codeLogin"}`,
                {
                  method: "POST",
                  body: JSON.stringify(
                    mode === "login"
                      ? {
                          username,
                          password,
                          code,
                          captchaId: captcha.data?.id,
                        }
                      : { email, code },
                  ),
                },
              );
              setToken(r.access_token);
              notify("登录成功");
              onClose();
            } else {
              await api(
                mode === "register"
                  ? "/auth/register"
                  : "/auth/account/updatePasswordByCode",
                {
                  method: mode === "register" ? "POST" : "PUT",
                  body: JSON.stringify({
                    username: username || undefined,
                    email,
                    password,
                    code,
                  }),
                },
              );
              notify(
                mode === "register" ? "注册成功，请登录" : "密码已重置，请登录",
              );
              setMode("login");
              setCode("");
              captcha.reload();
            }
          } catch (e) {
            setError((e as Error).message);
            if (mode === "login") captcha.reload();
          } finally {
            setBusy(false);
          }
        }}
      >
        {(mode === "login" || mode === "register") && (
          <label>
            用户名
            <input
              required={mode === "login"}
              autoComplete="username"
              value={username}
              onChange={(e) => setUsername(e.target.value)}
            />
          </label>
        )}
        {mode !== "login" && (
          <label>
            邮箱
            <input
              type="email"
              required
              autoComplete="email"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
            />
          </label>
        )}
        {mode !== "code" && (
          <label>
            密码
            <input
              type="password"
              required
              minLength={mode === "login" ? 1 : 6}
              autoComplete={
                mode === "login" ? "current-password" : "new-password"
              }
              value={password}
              onChange={(e) => setPassword(e.target.value)}
            />
          </label>
        )}
        <label>
          验证码
          <div className="captcha-row">
            <input
              required
              value={code}
              onChange={(e) => setCode(e.target.value)}
              autoComplete="one-time-code"
            />
            {mode === "login" ? (
              <button
                type="button"
                aria-label="刷新验证码"
                onClick={captcha.reload}
              >
                {captcha.data && (
                  <img src={captcha.data.img} alt="图形验证码" />
                )}
              </button>
            ) : (
              <button
                type="button"
                disabled={sent || !email}
                onClick={async () => {
                  try {
                    await api("/auth/email/send", {
                      method: "POST",
                      body: JSON.stringify({ email }),
                    });
                    setSent(true);
                    notify("验证码已发送");
                    setTimeout(() => setSent(false), 60000);
                  } catch (e) {
                    setError((e as Error).message);
                  }
                }}
              >
                {sent ? "60 秒后重试" : "发送验证码"}
              </button>
            )}
          </div>
        </label>
        {mode === "login" && (
          <Status
            loading={captcha.loading}
            error={captcha.error}
            retry={captcha.reload}
          />
        )}{" "}
        {error && (
          <p role="alert" className="form-error">
            {error}
          </p>
        )}
        <button
          className="primary"
          disabled={busy || (mode === "login" && !captcha.data)}
        >
          {busy
            ? "处理中…"
            : {
                login: "登录",
                register: "注册",
                reset: "重置密码",
                code: "登录",
              }[mode]}
        </button>
      </form>
    </Modal>
  );
}
