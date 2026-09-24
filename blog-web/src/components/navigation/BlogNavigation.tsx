import { useEffect, useRef, useState } from "react";
import { Link, useLocation } from "react-router-dom";
import { Media } from "../media/Media";
import { useResponsiveNav } from "../../hooks/useResponsiveNav";
import { MenuTree } from "./MenuTree";
import type { Menu, Site } from "../../types";

export function BlogNavigation({ site, menus, consoleOpen, onRandom, onSearch, onConsole, onMenu, readingProgress = 0 }: {
  site: Site; menus: Menu[]; consoleOpen: boolean; onRandom: () => void; onSearch: () => void; onConsole: () => void; onMenu: () => void; readingProgress?: number;
}) {
  const responsive = useResponsiveNav(menus);
  const [scroll, setScroll] = useState({ fixed: false, visible: false, hasScrolled: false });
  const [pageTitle, setPageTitle] = useState(site.title);
  const location = useLocation();
  const lastTop = useRef(0);
  useEffect(() => {
    const title = () => setPageTitle(document.title.split(" | ")[0] || site.title);
    title();
    const observer = new MutationObserver(title);
    const element = document.querySelector("title");
    if (element) observer.observe(element, { childList: true, subtree: true, characterData: true });
    return () => observer.disconnect();
  }, [site.title, location.pathname]);
  useEffect(() => {
    const update = () => {
      const top = window.scrollY;
      const previousTop = lastTop.current;
      if (top > 60 && Math.abs(previousTop - top) < 20) return;
      setScroll(old => ({ fixed: top > 26 || (top > 5 && old.fixed), visible: top > 26 && top < previousTop, hasScrolled: top > 0 }));
      lastTop.current = top;
    };
    update(); window.addEventListener("scroll", update, { passive: true });
    return () => window.removeEventListener("scroll", update);
  }, []);
  return <header id="page-header" className={`not-top-img blog-navigation${scroll.fixed ? " nav-fixed" : ""}${scroll.visible ? " nav-visible" : ""}`}>
    <nav id="nav" aria-label="主导航" ref={responsive.ref} className={responsive.collapsed ? "react-nav-collapsed" : "react-nav-expanded"}>
      <div id="nav-group">
        <span id="blog_name"><Link id="site-name" to="/" aria-label={site.title} title="返回首页">
          <span className="title">{site.logo && <Media src={site.logo} alt=""/>}{site.title}</span>
          <i className="anzhiyufont anzhiyu-icon-house-chimney" aria-hidden="true"/>
        </Link></span>
      </div>
      <button className="nav-page-title" onClick={() => window.scrollTo({ top: 0, behavior: "smooth" })}
        tabIndex={scroll.fixed && !scroll.visible && !responsive.collapsed ? 0 : -1}
        aria-hidden={!scroll.fixed || scroll.visible || responsive.collapsed} title="返回顶部">{pageTitle}</button>
      <div id="menus" aria-hidden={responsive.collapsed || (scroll.fixed && !scroll.visible) || undefined}
        inert={responsive.collapsed || (scroll.fixed && !scroll.visible)}><MenuTree menus={menus}/></div>
      <div id="nav-right">
        <button className="nav-action nav-random" title="随机文章 (Shift+R)" aria-label="随机文章" onClick={onRandom}><i className="anzhiyufont anzhiyu-icon-dice" aria-hidden="true"/></button>
        <button className="nav-action" title="搜索 (/)" aria-label="搜索" onClick={onSearch}><i className="anzhiyufont anzhiyu-icon-magnifying-glass" aria-hidden="true"/></button>
        <button className="nav-action console-toggle" title="中控台 (Shift+A)" aria-label="控制台" aria-expanded={consoleOpen} onClick={onConsole}>
          <span className="console-symbol" aria-hidden="true"><i className="left"/><i className="center"/><i className="right"/></span>
        </button>
        {scroll.hasScrolled && <button className="nav-action page-reading-progress" aria-label={`阅读进度 ${readingProgress}%，返回顶部`} onClick={() => window.scrollTo({ top: 0, behavior: "smooth" })}>{readingProgress || <i className="anzhiyufont anzhiyu-icon-arrow-up" aria-hidden="true" />}</button>}
        <button id="toggle-menu" className="nav-action" aria-label="打开菜单" onClick={onMenu}><i className="anzhiyufont anzhiyu-icon-bars" aria-hidden="true"/></button>
      </div>
    </nav>
  </header>;
}
