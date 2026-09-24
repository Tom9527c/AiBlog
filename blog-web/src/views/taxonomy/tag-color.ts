import type { CSSProperties } from "react";
import type { TaxonomySummary } from "../../types";

/** Composite transparent picker colors onto white so badge contrast stays predictable. */
export function tagPalette(term: TaxonomySummary) {
  const input = term.locked ? undefined : term.metadata?.color;
  let channels = [107, 117, 255], alpha = 1;
  let color = "#6b75ff";
  if (typeof input === "string") {
    const hex = input.match(/^#([a-f\d]{3}|[a-f\d]{4}|[a-f\d]{6}|[a-f\d]{8})$/i);
    const rgb = input.match(/^rgba?\(\s*([\d.]+%?)\s*,\s*([\d.]+%?)\s*,\s*([\d.]+%?)(?:\s*,\s*([\d.]+%?))?\s*\)$/);
    if (hex) {
      const expanded = hex[1].length <= 4 ? [...hex[1]].map(v => v + v).join("") : hex[1];
      channels = [0, 2, 4].map(i => parseInt(expanded.slice(i, i + 2), 16));
      alpha = expanded.length === 8 ? parseInt(expanded.slice(6), 16) / 255 : 1;
      color = input;
    } else if (rgb) {
      channels = rgb.slice(1, 4).map(v => Math.min(255, parseFloat(v) * (v.endsWith("%") ? 2.55 : 1)));
      alpha = rgb[4] ? Math.min(1, parseFloat(rgb[4]) / (rgb[4].endsWith("%") ? 100 : 1)) : 1;
      color = input;
    }
  }
  channels = channels.map(v => Math.round(v * alpha + 255 * (1 - alpha)));
  if (alpha < 1) color = `rgb(${channels.join(", ")})`;
  const luminance = channels.map(v => v / 255).map(v => v <= .04045 ? v / 12.92 : ((v + .055) / 1.055) ** 2.4).reduce((sum, v, i) => sum + v * [.2126, .7152, .0722][i], 0);
  return { color, text: luminance > .179 ? "#000" : "#fff" };
}
export function tagStyle(term: TaxonomySummary): CSSProperties {
  const { color, text } = tagPalette(term);
  return { "--tag-color": color, "--tag-text": text } as CSSProperties;
}
