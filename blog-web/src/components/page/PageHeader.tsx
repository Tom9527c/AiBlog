import { useBlog } from '../context';
import { Media } from '../media/Media';
import type { PageHeaderKey } from '../../types';
import { pageHeaderSettings, pageLabels } from './page-header';
import './page-header.css';
export function PageHeader({ page, title, cover = '', subtitle = '', detail = false }: { page: PageHeaderKey; title: string; cover?: string; subtitle?: string; detail?: boolean }) {
  const { site } = useBlog();
  const settings = pageHeaderSettings(site, page);
  if (!settings.enabled) return <h1 className="page-title">{title}</h1>;
  const image = settings.cover || cover || site.heroImage;
  return <header className="page-cover-header" data-page={page}>
    {image && <Media src={image} alt={`${title}封面`} className="page-cover-header__image" />}
    <div className="page-cover-header__content">
      <div className="page-cover-header__label">{detail && settings.title ? settings.title : pageLabels[page]}</div>
      <h1>{detail ? title : settings.title || title}</h1>
      {(settings.subtitle || subtitle) && <p>{settings.subtitle || subtitle}</p>}
    </div>
  </header>;
}
