import { useLayoutEffect, useRef, useState } from "react";

/** Measure the actual logo, full menu and actions; collapsed menus remain measurable. */
export function useResponsiveNav(dependency: unknown) {
  const ref = useRef<HTMLElement>(null);
  const [collapsed, setCollapsed] = useState(false);
  useLayoutEffect(() => {
    const nav = ref.current;
    if (!nav) return;
    const logo = nav.querySelector<HTMLElement>("#nav-group")!;
    const menus = nav.querySelector<HTMLElement>("#menus")!;
    const actions = nav.querySelector<HTMLElement>("#nav-right")!;
    const toggle = actions.querySelector<HTMLElement>("#toggle-menu")!;
    let active = true;
    const measure = () => {
      if (!active) return;
      const style = getComputedStyle(nav);
      const available = nav.clientWidth - parseFloat(style.paddingLeft || "0") - parseFloat(style.paddingRight || "0");
      const actionWidth = actions.scrollWidth + (toggle.offsetWidth ? 0 : 38);
      setCollapsed(nav.clientWidth <= 768 || 2 * Math.max(logo.scrollWidth, actionWidth) + menus.scrollWidth + 48 > available);
    };
    const observer = new ResizeObserver(measure);
    [nav, logo, menus, actions].forEach((element) => observer.observe(element));
    measure();
    document.fonts?.ready.then(measure);
    return () => { active = false; observer.disconnect(); };
  }, [dependency]);
  return { ref, collapsed };
}
