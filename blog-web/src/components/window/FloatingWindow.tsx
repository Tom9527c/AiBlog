import { useEffect, useRef, useState, type ReactNode } from "react";
import { createPortal } from "react-dom";
import { Modal } from "../index";
interface WindowHandle {
  body: HTMLElement;
  dom: HTMLElement;
  min: boolean;
  max: boolean;
  resize: (w: string, h: string) => WindowHandle;
  move: (x: string, y: string) => WindowHandle;
  close: () => void;
  focus: () => void;
  onclose?: () => boolean | void;
}
declare global {
  interface Window {
    WinBox?: new (options: Record<string, unknown>) => WindowHandle;
  }
}
let library: Promise<void> | undefined;
export function loadWindowLibrary() {
  if (window.WinBox) return Promise.resolve();
  return (library ??= new Promise<void>((resolve, reject) => {
    const script = document.createElement("script");
    script.src = "/theme/vendor/winbox.bundle.min.js";
    script.onload = () => resolve();
    script.onerror = () => {
      library = undefined;
      script.remove();
      reject(new Error("窗口组件加载失败"));
    };
    document.head.appendChild(script);
  }));
}
export function FloatingWindow({
  title,
  onClose,
  children,
}: {
  title: string;
  onClose: () => void;
  children: ReactNode;
}) {
  const [host, setHost] = useState<HTMLElement>();
  const [failed, setFailed] = useState(false);
  const closeRef = useRef(onClose);
  closeRef.current = onClose;
  useEffect(() => {
    let active = true;
    let win: WindowHandle | undefined;
    const previous = document.activeElement as HTMLElement;
    const resize = () => {
      if (!win || win.min || win.max) return;
      win
        .resize(
          `${innerWidth * (innerWidth <= 768 ? 0.95 : 0.6)}px`,
          `${innerHeight * (innerWidth <= 768 ? 0.9 : 0.7)}px`,
        )
        .move("center", "center");
    };
    const key = (e: KeyboardEvent) => {
      if (e.key === "Escape") win?.close();
    };
    loadWindowLibrary()
      .then(() => {
        if (!active) return;
        win = new window.WinBox!({
          title,
          id: "changeBgBox",
          index: 1100,
          x: "center",
          y: "center",
          minwidth: Math.min(300, innerWidth * 0.95),
          minheight: 150,
          background: "#49b1f5",
          onclose: () => {
            if (active) closeRef.current();
            // React must unmount the portal before cleanup destroys WinBox.
            // Veto its immediate close to avoid destroying the same window twice.
            return true;
          },
        });
        resize();
        win.body.tabIndex = -1;
        win.body.setAttribute("role", "dialog");
        win.body.setAttribute("aria-label", title);
        const root = win.body.closest(".winbox");
        [
          [".wb-min", "最小化窗口"],
          [".wb-max", "最大化或还原窗口"],
          [".wb-close", "关闭窗口"],
          [".wb-full", "全屏窗口"],
        ].forEach(([selector, label]) => {
          const control = root?.querySelector<HTMLElement>(selector);
          if (control) {
            control.setAttribute("role", "button");
            control.setAttribute("aria-label", label);
            control.tabIndex = 0;
            control.addEventListener("keydown", (e) => {
              if (e.key === "Enter" || e.key === " ") {
                e.preventDefault();
                control.click();
              }
            });
          }
        });
        setHost(win.body);
        win.body.focus();
        window.addEventListener("resize", resize);
        window.addEventListener("keydown", key);
      })
      .catch(() => {
        if (active) setFailed(true);
      });
    return () => {
      active = false;
      window.removeEventListener("resize", resize);
      window.removeEventListener("keydown", key);
      if (win) {
        win.onclose = undefined;
        win.close();
      }
      previous?.focus();
    };
  }, [title]);
  if (failed)
    return (
      <Modal title={title} onClose={onClose}>
        {children}
      </Modal>
    );
  return host
    ? createPortal(
        <div className="floating-window-content">{children}</div>,
        host,
      )
    : null;
}
