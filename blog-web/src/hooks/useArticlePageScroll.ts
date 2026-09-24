import { useEffect, useRef } from "react";

/** Wait for the new list to finish loading before positioning it below the navigation. */
export function useArticlePageScroll(page: number, data: { page: number } | null | undefined) {
  const listRef = useRef<HTMLDivElement>(null);
  const lastPage = useRef(page);
  useEffect(() => {
    if (!data || data.page !== page || lastPage.current === page) return;
    lastPage.current = page;
    const list = listRef.current;
    if (list) window.scrollTo({ top: Math.max(0, list.getBoundingClientRect().top + window.scrollY - 90), behavior: "smooth" });
  }, [data, page]);
  return listRef;
}
