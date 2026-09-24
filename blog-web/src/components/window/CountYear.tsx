import { useEffect, useRef, useState } from "react";
/** CountUp 1.9.2's original easeOutExpo, duration 2s, no thousands grouping. */
export const countUpValue = (year: number, elapsed: number) =>
  Math.round(
    (year * (-Math.pow(2, (-10 * Math.min(elapsed, 2000)) / 2000) + 1) * 1024) /
      1023,
  );
export function CountYear({ year }: { year: number }) {
  const ref = useRef<HTMLSpanElement>(null);
  const [value, setValue] = useState(0);
  useEffect(() => {
    let frame = 0;
    let start: number | undefined;
    let started = false;
    const animate = (now: number) => {
      start ??= now;
      const elapsed = now - start;
      setValue(elapsed >= 2000 ? year : countUpValue(year, elapsed));
      if (elapsed < 2000) frame = requestAnimationFrame(animate);
    };
    const begin = () => {
      if (started) return;
      started = true;
      if (matchMedia("(prefers-reduced-motion: reduce)").matches)
        setValue(year);
      else frame = requestAnimationFrame(animate);
    };
    const observer =
      typeof IntersectionObserver === "undefined"
        ? null
        : new IntersectionObserver((entries) => {
            if (entries.some((e) => e.isIntersecting)) {
              begin();
              observer?.disconnect();
            }
          });
    setValue(0);
    if (observer && ref.current) observer.observe(ref.current);
    else begin();
    return () => {
      cancelAnimationFrame(frame);
      observer?.disconnect();
    };
  }, [year]);
  return (
    <span
      ref={ref}
      id="selfInfo-content-year"
      className="selfInfo-content"
      aria-label={String(year)}
    >
      {value}
    </span>
  );
}
