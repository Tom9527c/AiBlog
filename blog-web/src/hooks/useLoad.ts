import { useEffect, useState } from "react";

export function useLoad<T>(load: () => Promise<T>, deps: unknown[] = []) {
  const [data, setData] = useState<T>();
  const [error, setError] = useState("");
  const [loading, setLoading] = useState(true);
  const [tick, setTick] = useState(0);
  useEffect(() => {
    let alive = true;
    setLoading(true);
    setError("");
    setData(undefined);
    load()
      .then((value) => {
        if (alive) setData(value);
      })
      .catch((reason) => {
        if (alive) setError(reason instanceof Error ? reason.message : String(reason));
      })
      .finally(() => {
        if (alive) setLoading(false);
      });
    return () => {
      alive = false;
    };
  }, [...deps, tick]);
  return { data, error, loading, reload: () => setTick((value) => value + 1) };
}
