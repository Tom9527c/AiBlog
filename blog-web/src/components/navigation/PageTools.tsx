export function PageTools({ onSettings, onBackground }: {
  onSettings: () => void;
  onBackground: () => void;
}) {
  return <div id="rightside" className="unified-page-tools">
    <button aria-label="阅读设置" title="阅读设置" onClick={onSettings}>
      <i className="anzhiyufont anzhiyu-icon-gear" aria-hidden="true" />
    </button>
    <button aria-label="切换背景" title="切换背景" onClick={onBackground}>
      <svg width="19" height="19" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" aria-hidden="true">
        <rect x="3" y="3" width="18" height="13" rx="1" /><path d="M8 21h8M12 16v5" />
      </svg>
    </button>
    <button aria-label="返回顶部" title="返回顶部" onClick={() => window.scrollTo({ top: 0, behavior: "smooth" })}>
      <i className="anzhiyufont anzhiyu-icon-arrow-up" aria-hidden="true" />
    </button>
  </div>;
}
