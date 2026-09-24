import { Modal } from "../components";
import { api, setToken } from "../services/api";
import type { Session } from "../types";

type Props = { session: Session | null; traditional: boolean; aside: boolean; effects: boolean; keyboard: boolean; rightMenu: boolean; toggleTheme: () => void; notify: (message: string) => void; onClose: () => void; onBackground: () => void; onShare: () => void; onTraditional: () => void; onAside: () => void; onEffects: () => void; onKeyboard: () => void; onRightMenu: () => void; onLogin: () => void };
export function SettingsConsole({ session, traditional, aside, effects, keyboard, rightMenu, toggleTheme, notify, onClose, onBackground, onShare, onTraditional, onAside, onEffects, onKeyboard, onRightMenu, onLogin }: Props) {
  return (
<Modal title="控制台" onClose={() => onClose()}>
          <div className="console-grid">
            <button
              onClick={() => {
                onClose();
                onBackground();
              }}
            >
              切换背景
            </button>
            <button onClick={() => onTraditional()}>
              {traditional ? "切换简体" : "切換繁體"}
            </button>
            <button
              onClick={() => {
                onClose();
                onShare();
              }}
            >
              二维码分享
            </button>
            <button onClick={toggleTheme}>
              {document.documentElement.dataset.theme === "dark"
                ? "☀ 浅色模式"
                : "☾ 深色模式"}
            </button>
            <button onClick={() => onAside()}>
              {aside ? "隐藏侧栏" : "显示侧栏"}
            </button>
            <button onClick={() => onEffects()}>
              {effects ? "关闭特效" : "开启特效"}
            </button>
            <button onClick={() => onKeyboard()}>
              {keyboard ? "关闭快捷键" : "开启快捷键"}
            </button>
            <button
              onClick={() => {
                window.dispatchEvent(
                  new CustomEvent("blog-player", { detail: "open" }),
                );
                onClose();
              }}
            >
              音乐播放器
            </button>
            <button onClick={() => onRightMenu()}>
              {rightMenu ? "关闭右键菜单" : "开启右键菜单"}
            </button>
          </div>
          <p className="keyboard-help">
            Shift + A 控制台 · D 主题 · M 音乐 · R 随机文章 · H 首页 · F 朋友圈
            · L 友链 · P 关于
          </p>
          {session ? (
            <p>
              {session.nickName || session.username}{" "}
              <button
                onClick={async () => {
                  try {
                    await api("/blog/public/logout", { method: "POST" });
                    setToken("");
                    onClose();
                    notify("已退出登录");
                  } catch (e) {
                    notify((e as Error).message);
                  }
                }}
              >
                退出登录
              </button>
            </p>
          ) : (
            <button
              onClick={() => {
                onClose();
                onLogin();
              }}
            >
              登录账户
            </button>
          )}
        </Modal>
  );
}
