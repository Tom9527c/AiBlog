import { useId, useLayoutEffect, useRef, useState } from "react";
import { Link, useLocation } from "react-router-dom";
import { safeUrl } from "../../services/api";
import type { Menu } from "../../types";

function MenuIcon({ icon }: { icon: string }) {
  if (!icon) return null;
  const themeIcon = icon.split(/\s+/).find((name) => /^anzhiyu-icon-[a-z0-9-]+$/.test(name));
  return themeIcon
    ? <i className={`anzhiyufont ${themeIcon}`} aria-hidden="true" />
    : <span className="menu-custom-icon" aria-hidden="true">{icon}</span>;
}

export function MenuTree({ menus, parent = null, onClick, mobile = false }: {
  menus: Menu[]; parent?: number | null; onClick?: () => void; mobile?: boolean;
}) {
  return <ul className={parent === null ? "menus_items" : "menus_item_child"}>
    {menus.filter(m => m.enabled && (m.parentId || null) === parent)
      .sort((a, b) => a.sort - b.sort || a.id - b.id)
      .map(m => <MenuItem key={m.id} item={m} menus={menus} mobile={mobile} onClick={onClick} />)}
  </ul>;
}

function MenuItem({ item, menus, mobile, onClick }: { item: Menu; menus: Menu[]; mobile: boolean; onClick?: () => void }) {
  const [open, setOpen] = useState(mobile);
  const [focusChild, setFocusChild] = useState(false);
  const ref = useRef<HTMLLIElement>(null);
  const id = useId();
  const location = useLocation();
  useLayoutEffect(() => {
    if (open && focusChild) {
      ref.current?.querySelector<HTMLElement>(".menu-children a,.menu-children button")?.focus();
      setFocusChild(false);
    }
  }, [open, focusChild]);
  const children = menus.some(m => m.enabled && m.parentId === item.id);
  const close = () => { setOpen(false); onClick?.(); };
  const content = <><MenuIcon icon={item.icon}/><span>{item.title}</span></>;
  return <li ref={ref} className={`menus_item${open ? " is-open" : ""}`}
    onMouseEnter={() => { if (!mobile) setOpen(true); }}
    onMouseLeave={() => { if (!mobile && !ref.current?.contains(document.activeElement)) setOpen(false); }}
    onBlur={e => { if (!e.currentTarget.contains(e.relatedTarget)) setOpen(false); }}
    onKeyDown={e => {
      if (e.key === "Escape" && children) {
        e.stopPropagation(); setOpen(false);
        ref.current?.querySelector<HTMLButtonElement>(":scope > button")?.focus();
      }
    }}>
    {item.path ? (item.external
      ? <a className="site-page" href={safeUrl(item.path)} target={item.newWindow ? "_blank" : undefined} rel="noopener noreferrer" onClick={close}>{content}</a>
      : <Link className="site-page" to={item.path} target={item.newWindow ? "_blank" : undefined} rel={item.newWindow ? "noopener noreferrer" : undefined} aria-current={location.pathname === item.path ? "page" : undefined} onClick={close}>{content}</Link>) : null}
    {children ? <button type="button" className={item.path ? "group-disclosure" : "site-page"}
      aria-label={item.path ? `展开${item.title}` : undefined} aria-expanded={open} aria-controls={id}
      onClick={() => setOpen(v => !v)}
      onKeyDown={e => { if (e.key === "ArrowDown") { e.preventDefault(); setFocusChild(true); setOpen(true); } }}>
        {item.path ? <i className="anzhiyufont anzhiyu-icon-angle-down" aria-hidden="true"/> : content}
      </button> : !item.path ? <span className="site-page">{content}</span> : null}
    {children && <div id={id} className="menu-children" hidden={!open}>
        <MenuTree menus={menus} parent={item.id} mobile={mobile} onClick={close}/>
      </div>}
  </li>;
}
