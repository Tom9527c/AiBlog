export function Status({
  loading,
  error,
  empty,
  retry,
}: {
  loading?: boolean;
  error?: string;
  empty?: boolean;
  retry?: () => void;
}) {
  if (loading)
    return (
      <div className="empty-state" role="status">
        <span className="spinner" />
        正在加载…
      </div>
    );
  if (error)
    return (
      <div className="empty-state" role="alert">
        <p>{error}</p>
        <button onClick={retry}>重新加载</button>
      </div>
    );
  if (empty)
    return (
      <div className="empty-state">
        <span className="empty-icon">✧</span>
        <p>这里还没有发布内容</p>
        <small>美好的故事，值得等待。</small>
      </div>
    );
  return null;
}
