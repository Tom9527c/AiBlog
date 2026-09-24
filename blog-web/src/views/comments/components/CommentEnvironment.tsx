function EnvironmentIcon({
  value,
  kind,
}: {
  value: string;
  kind: "location" | "os" | "browser";
}) {
  const name = value.toLowerCase();
  let shape;
  if (kind === "location") shape = <path d="M22 2 2 10l8 3 3 9z" />;
  else if (name.includes("windows"))
    shape = (
      <path d="M2 4 11 2.8V11H2zm10-1.4L22 1v10H12zM2 12h9v8.2L2 19zm10 0h10v10l-10-1.6z" />
    );
  else if (name.includes("android"))
    shape = (
      <>
        <path d="M3 12a9 9 0 0 1 18 0v5H3z" />
        <path
          d="m6 6-2-3m14 3 2-3"
          fill="none"
          stroke="currentColor"
          strokeWidth="1.5"
        />
        <circle cx="8" cy="11" r="1" fill="var(--blog-card)" />
        <circle cx="16" cy="11" r="1" fill="var(--blog-card)" />
      </>
    );
  else if (/mac|ios|ipad|iphone/.test(name))
    shape = (
      <path d="M15 5c1-1 2-3 1-5-2 0-4 2-4 4 0 1 1 2 3 1zm4 8c0-3 2-4 2-4-1-2-3-3-5-3s-3 1-4 1-2-1-4-1C4 6 2 9 3 14c1 4 3 8 5 8 1 0 2-1 4-1s3 1 4 1c2 0 4-4 5-6-1 0-2-1-2-3z" />
    );
  else if (name.includes("edge"))
    shape = (
      <>
        <path d="M22 15c-2 4-8 6-12 3-3-2-4-6-1-9-4 0-7 3-7 6 0 5 5 8 10 8 5 0 9-3 10-8z" />
        <path
          d="M2 12C1 5 7 0 13 1c6 0 10 5 10 10 0 4-3 6-7 6-4 0-6-2-6-4 3 1 7 0 7-3 0-5-10-6-15 2z"
          opacity=".8"
        />
      </>
    );
  else if (name.includes("chrome"))
    shape = (
      <>
        <path d="M12 1a11 11 0 0 1 9.5 5.5H12A5.5 5.5 0 0 0 7 9zM2.3 6.8a11 11 0 0 0 8.2 16.1L15 15a5.5 5.5 0 0 1-8-4zM22.3 8H13a5.5 5.5 0 0 1 3.6 8.4l-3.8 6.5A11 11 0 0 0 22.3 8z" />
        <circle cx="12" cy="12" r="3.5" />
      </>
    );
  else
    shape = (
      <>
        <circle
          cx="12"
          cy="12"
          r="9"
          fill="none"
          stroke="currentColor"
          strokeWidth="2"
        />
        <path d="m17 7-3 7-7 3 3-7z" />
      </>
    );
  return (
    <svg viewBox="0 0 24 24" fill="currentColor" aria-hidden="true">
      {shape}
    </svg>
  );
}
export function CommentEnvironment({
  metadata,
}: {
  metadata: Record<string, unknown>;
}) {
  return (
    <div className="comment-badges">
      {(["location", "os", "browser"] as const).map((kind) =>
        metadata[kind] ? (
          <span
            key={kind}
            title={`${kind === "location" ? "IP 属地" : kind === "os" ? "操作系统" : "浏览器"}：${metadata[kind]}`}
          >
            <EnvironmentIcon kind={kind} value={String(metadata[kind])} />
            {String(metadata[kind])}
          </span>
        ) : null,
      )}
    </div>
  );
}
