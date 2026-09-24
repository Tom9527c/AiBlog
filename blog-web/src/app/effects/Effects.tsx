import { useEffect, useRef } from "react";
import { startOriginalStars } from "./originalStars";

export function Effects({ enabled }: { enabled: boolean }) {
  const ref = useRef<HTMLCanvasElement>(null);
  useEffect(() => {
    if (!enabled || matchMedia("(prefers-reduced-motion: reduce)").matches)
      return;
    return startOriginalStars(ref.current!);
  }, [enabled]);
  return enabled ? <canvas id="universe" ref={ref} aria-hidden="true" /> : null;
}
