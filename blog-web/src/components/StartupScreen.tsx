export function StartupScreen({ error, onRetry }: { error?: string; onRetry: () => void }) {
  return <main className="startup-screen" aria-busy={!error}>
    <div className="startup-screen__content">
      {!error && <div className="startup-screen__mark" aria-hidden="true"><span /><span /><span /></div>}
      <p role={error ? "alert" : "status"}>{error ? "暂时无法加载站点" : "正在准备页面"}</p>
      <small>{error ? "请检查网络后重试" : "内容即将呈现，请稍候"}</small>
      {error && <button onClick={onRetry}>重新加载</button>}
    </div>
  </main>;
}
