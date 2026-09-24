import { useEffect } from "react";

export function useTraditional(enabled: boolean) {
  useEffect(() => {
    if (!enabled) return;
    let active = true;
    let converter: (value: string) => string = (value) => value;
    const originals = new Map<Text, { original: string; converted: string }>();
    const attributes = new Map<
      Element,
      Map<string, { original: string; converted: string }>
    >();
    const convert = () => {
      observer.disconnect();
      originals.forEach((_, node) => {
        if (!node.isConnected) originals.delete(node);
      });
      const walk = document.createTreeWalker(
        document.body,
        NodeFilter.SHOW_TEXT,
      );
      let current: Node | null;
      while ((current = walk.nextNode())) {
        const node = current as Text;
        if (
          node.parentElement?.closest(
            "script,style,code,pre,input,textarea,[contenteditable],svg",
          )
        )
          continue;
        const value = node.nodeValue || "";
        const saved = originals.get(node);
        if (saved?.converted === value) continue;
        const converted = converter(value);
        if (converted !== value) {
          originals.set(node, { original: value, converted });
          node.nodeValue = converted;
        }
      }
      attributes.forEach((_, el) => {
        if (!el.isConnected) attributes.delete(el);
      });
      document.body
        .querySelectorAll("[title],[alt],[placeholder]")
        .forEach((el) => {
          if (el.closest("code,pre,script,style,[contenteditable],svg")) return;
          for (const name of ["title", "alt", "placeholder"]) {
            const value = el.getAttribute(name);
            if (value === null) continue;
            const saved = attributes.get(el)?.get(name);
            if (saved?.converted === value) continue;
            const converted = converter(value);
            if (converted !== value) {
              if (!attributes.has(el)) attributes.set(el, new Map());
              attributes.get(el)!.set(name, { original: value, converted });
              el.setAttribute(name, converted);
            }
          }
        });
      observer.observe(document.body, {
        attributes: true,
        attributeFilter: ["title", "alt", "placeholder"],
        childList: true,
        subtree: true,
        characterData: true,
      });
    };
    const observer = new MutationObserver(convert);
    import("opencc-js/cn2t").then((module) => {
      if (active) {
        converter = module.Converter({ from: "cn", to: "tw" });
        convert();
        document.documentElement.lang = "zh-TW";
      }
    });
    return () => {
      active = false;
      document.documentElement.lang = "zh-CN";
      observer.disconnect();
      originals.forEach(({ original, converted }, node) => {
        if (node.isConnected && node.nodeValue === converted)
          node.nodeValue = original;
      });
      originals.clear();
      attributes.forEach((values, el) => {
        if (el.isConnected)
          values.forEach(({ original, converted }, name) => {
            if (el.getAttribute(name) === converted)
              el.setAttribute(name, original);
          });
      });
      attributes.clear();
    };
  }, [enabled]);
}
