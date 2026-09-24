import { useEffect, type ReactNode } from 'react';
import { useLocation } from 'react-router-dom';
import { useBlog } from '../context';
import { PageHeader } from './PageHeader';
import { pageHeaderKey } from './page-header';
import { Aside } from '../../views/home/components/Aside';
export function PageShell({
  title,
  heading,
  children,
  aside = false,
  headerCover = '',
  headerSubtitle = '',
  headerDetail = false,
}: {
  title: string;
  heading?: ReactNode;
  children: ReactNode;
  aside?: boolean;
  headerCover?: string;
  headerSubtitle?: string;
  headerDetail?: boolean;
}) {
  const { site } = useBlog();
  const { pathname } = useLocation();
  const headerPage = pageHeaderKey(pathname);
  useEffect(() => {
    document.title = `${title} | ${site.title || "博客"}`;
  }, [title, site.title]);
  return (
    <div
      id="content-inner"
      className={`layout ${!aside || !site.showAside ? "hide-aside" : ""}`}
    >
      <div id="page">
        {headerPage ? <PageHeader page={headerPage} title={title} cover={headerCover} subtitle={headerSubtitle} detail={headerDetail} /> : heading || <h1 className="page-title">{title}</h1>}
        {children}
      </div>
      {aside && site.showAside && <Aside />}
    </div>
  );
}
