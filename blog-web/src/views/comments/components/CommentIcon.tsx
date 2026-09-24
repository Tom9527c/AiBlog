export function CommentIcon({
  name,
}: {
  name: "reply" | "up" | "down" | "refresh" | "smile" | "image" | "send";
}) {
  const paths = {
    reply: (
      <path d="M21 11.5a8.3 8.3 0 0 1-.9 3.8 8.4 8.4 0 0 1-7.6 4.7 8.3 8.3 0 0 1-3.8-.9L3 21l1.9-5.7a8.3 8.3 0 0 1-.9-3.8 8.4 8.4 0 0 1 4.7-7.6 8.3 8.3 0 0 1 3.8-.9h.5a8.4 8.4 0 0 1 8 8z" />
    ),
    up: (
      <>
        <path d="M7 10v11H3V10zM7 10l5-8c3 0 3 3 2 6h5a2 2 0 0 1 2 2l-2 9a2 2 0 0 1-2 2H7" />
      </>
    ),
    down: (
      <path d="M7 14V3H3v11zM7 14l5 8c3 0 3-3 2-6h5a2 2 0 0 0 2-2l-2-9a2 2 0 0 0-2-2H7" />
    ),
    refresh: (
      <>
        <path d="M20 7v5h-5M4 17v-5h5" />
        <path d="M6 7a7 7 0 0 1 12-1l2 3M4 15l2 3a7 7 0 0 0 12-1" />
      </>
    ),
    smile: (
      <>
        <circle cx="12" cy="12" r="9" />
        <path d="M8 14a4 4 0 0 0 8 0M8 8h.01M16 8h.01" />
      </>
    ),
    image: (
      <>
        <rect x="3" y="3" width="18" height="18" rx="3" />
        <circle cx="8" cy="8" r="1" />
        <path d="m21 15-5-5L5 21" />
      </>
    ),
    send: (
      <>
        <path d="m22 2-7 20-4-9-9-4zM22 2 11 13" />
      </>
    ),
  };
  return (
    <svg
      width="20"
      height="20"
      viewBox="0 0 24 24"
      fill="none"
      stroke="currentColor"
      strokeWidth="1.8"
      strokeLinecap="round"
      strokeLinejoin="round"
      aria-hidden="true"
    >
      {paths[name]}
    </svg>
  );
}
