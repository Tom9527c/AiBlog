import { PageShell } from '../../components/page/PageShell';
import { Link } from 'react-router-dom';
export function NotFound() {
  return (
    <PageShell title="404">
      <div className="not-found">
        <strong>404</strong>
        <h2>页面走丢了</h2>
        <p>换个方向，继续探索吧。</p>
        <Link to="/">返回首页</Link>
        <Link to="/archives/">看看文章</Link>
      </div>
    </PageShell>
  );
}
