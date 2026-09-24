import type { Menu, Site } from "../types";
import { Media } from "../components";
import { MenuTree } from "../components/navigation/MenuTree";

export function MobileMenu({ site, menus, onClose }: { site: Site; menus: Menu[]; onClose: () => void }) {
  return (
<div id="sidebar" className="open">
          <div id="menu-mask" onClick={() => onClose()} />
          <div id="sidebar-menus">
            <button onClick={() => onClose()} aria-label="关闭菜单">
              ×
            </button>
            <Media src={site.avatar} alt={site.title} className="avatar-img" />
            <h2>{site.title}</h2>
            <MenuTree
              mobile
              menus={menus}
              onClick={() => onClose()}
            />
          </div>
        </div>
  );
}
