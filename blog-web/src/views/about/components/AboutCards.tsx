import { useEffect, useId, useRef, useState, type CSSProperties, type ReactNode } from 'react';
import { ContentBody, Media, Modal, useMedia } from '../../../components';
import { safeUrl } from '../../../services/api';
import type { Content } from '../../../types';
import './about.css';

type Entry = Record<string, unknown>;
const entries = (value: unknown): Entry[] => Array.isArray(value) ? value.filter((v): v is Entry => !!v && typeof v === 'object') : [];
const text = (value: unknown) => typeof value === 'string' ? value : '';
const strings = (value: unknown): string[] => Array.isArray(value) ? value.filter((v): v is string => typeof v === 'string' && !!v) : [];
function Card({ kind, image, darkImage, children }: { kind: string; image?: string; darkImage?: string; children: ReactNode }) {
  const url = useMedia(image || '');
  const darkUrl = useMedia(darkImage || '');
  const background = url || darkUrl ? { '--about-image': url ? `url(${JSON.stringify(url)})` : 'none', '--about-dark-image': `url(${JSON.stringify(darkUrl || url)})` } as CSSProperties : undefined;
  return <section className={`about-tile about-tile--${kind}${url || darkUrl ? ' has-image' : ''}`} style={background}>
    {(url || darkUrl) && <div className="about-tile-background" aria-hidden="true" />}
    <div className="about-tile-content">{children}</div>
  </section>;
}
function Row({ children }: { children: ReactNode }) { return <div className="about-row">{children}</div>; }
function Hello({ children }: { children: ReactNode }) {
  return <section className="about-hello" onPointerMove={event => { const rect = event.currentTarget.getBoundingClientRect(); event.currentTarget.style.setProperty('--pointer-x', `${event.clientX - rect.left}px`); event.currentTarget.style.setProperty('--pointer-y', `${event.clientY - rect.top}px`); }}>
    <div className="about-hello-shapes" aria-hidden="true"><i /><i /><i /></div><div className="about-hello-mask"><strong>{children}</strong></div>
  </section>;
}
function PursuitWords({ words }: { words: string[] }) {
  const [current, setCurrent] = useState(0);
  useEffect(() => {
    if (words.length < 2 || window.matchMedia?.('(prefers-reduced-motion: reduce)').matches) return;
    const timer = window.setInterval(() => setCurrent(value => (value + 1) % words.length), 2000);
    return () => window.clearInterval(timer);
  }, [words.length]);
  return <div className="about-pursuit-words"><span className="sr-only">{words.join('、')}</span>{words.map((word, i) => <span aria-hidden="true" key={i} className={i === current % words.length ? 'is-current' : ''}>{word}</span>)}</div>;
}
function SkillIcon({ skill, decorative = false }: { skill: Entry; decorative?: boolean }) {
  return <div className="about-skill-icon" style={{ background: /^#[a-f\d]{3,8}$/i.test(text(skill.color)) ? text(skill.color) : undefined }}>
    {text(skill.image) ? <Media src={text(skill.image)} alt={decorative ? '' : text(skill.name)} /> : <span>{text(skill.name).slice(0, 2)}</span>}
  </div>;
}
function Skills({ skills }: { skills: Entry[] }) {
  const [expanded, setExpanded] = useState(false);
  const detailsId = useId();
  const toggle = useRef<HTMLButtonElement>(null);
  // Repeat only configured skills; keep the two halves identical for a seamless loop.
  const count = Math.max(8, Math.ceil(skills.length / 2));
  const pairs = Array.from({ length: count }, (_, i) => [skills[(i * 2) % skills.length], skills[(i * 2 + 1) % skills.length]]);
  return <div className="about-skills-stage" data-expanded={expanded} onClick={() => setExpanded(value => !value)}
    onPointerEnter={event => { if (event.pointerType === 'mouse' && window.matchMedia?.('(hover: hover) and (pointer: fine)').matches) setExpanded(true); }}
    onPointerLeave={event => { if (event.pointerType === 'mouse') setExpanded(false); }}
    onKeyDown={event => { if (event.key === 'Escape') { setExpanded(false); toggle.current?.focus(); } }}>
    <button ref={toggle} type="button" className="about-skills-toggle sr-only" aria-label={expanded ? '返回技能图片墙' : '查看技能详情'} aria-expanded={expanded} aria-controls={detailsId} onClick={event => { event.stopPropagation(); setExpanded(value => !value); }} />
    <div className="about-skills-ribbon" aria-hidden="true"><div className="about-skills-track">{[...pairs, ...pairs].map((pair, i) => <div className="about-skills-pair" key={i}>{pair.map((skill, j) => <SkillIcon key={j} skill={skill} decorative />)}</div>)}</div></div>
    <div id={detailsId} className="about-skills-list" hidden={!expanded} tabIndex={0} role="region" aria-label="技能详情">{skills.map((skill, i) => <div className="about-skill" key={i}><SkillIcon skill={skill} /><span>{text(skill.name)}</span></div>)}</div>
  </div>;
}
export function AboutCards({ item }: { item: Content }) {
  const [reward, setReward] = useState(false);
  const m = item.metadata || {};
  const t = (key: string) => text(m[key]);
  const sections = (m.sections || {}) as Record<string, boolean>;
  const enabled = (key: string) => sections[key] !== false;
  const tags = strings(m.profileTags);
  const skills: Entry[] = Array.isArray(m.skillItems) ? entries(m.skillItems) : strings(m.skills).map(name => ({ name }));
  const experiences = entries(m.experiences);
  const comics = entries(m.comics);
  const cards = entries(m.cards);
  const socials = entries(m.socials);
  const label = (key: string) => t(key) ? <div className="about-eyebrow">{t(key)}</div> : null;
  const heading = (key: string) => t(key) ? <h2>{t(key)}</h2> : null;
  return <div id="about-page" className="about-managed">
    <header className="about-profile">
      <div className="about-avatar-row">
        <div className="about-tags">{tags.slice(0, Math.ceil(tags.length / 2)).map((tag, i) => <span key={i}>{tag}</span>)}</div>
        {t('avatar') && <div className="about-avatar"><Media src={t('avatar')} alt={t('name') || '个人头像'} /></div>}
        <div className="about-tags">{tags.slice(Math.ceil(tags.length / 2)).map((tag, i) => <span key={i}>{tag}</span>)}</div>
      </div>
      {t('heading') && <h2>{t('heading')}</h2>}
      {t('subtitle') && <p>{t('subtitle')}</p>}
    </header>
    <div className="about-grid">
      <Row>
      {enabled('intro') && (t('name') || t('role') || t('greeting')) && <Card kind="intro"><p>{t('greeting')}</p>{t('name') && <h2>{t('namePrefix')} <span>{t('name')}</span></h2>}{t('role') && <p>{t('rolePrefix')} {t('role')}</p>}</Card>}
      {enabled('pursuit') && (t('pursuitTitle') || strings(m.pursuitWords).length > 0) && <Card kind="pursuit">{label('pursuitLabel')}{heading('pursuitTitle')}<PursuitWords words={strings(m.pursuitWords)} /></Card>}
      </Row>
      {enabled('hello') && t('helloText') && <Hello>{t('helloText')}</Hello>}
      <Row>
      {enabled('skills') && skills.length > 0 && <Card kind="skills">{label('skillsLabel')}{heading('skillsTitle')}<Skills skills={skills} /></Card>}
      {enabled('careers') && (experiences.length > 0 || t('career') || t('careersImage')) && <Card kind="careers" image={t('careersImage')}>{label('careersLabel')}{heading('careersTitle')}<div className="about-careers">{experiences.length ? experiences.map((entry, i) => <div className="about-career" key={i}><span className="about-career-dot" /><div><span>{text(entry.title)}</span>{text(entry.date) && <time>{text(entry.date)}</time>}{text(entry.description) && <p>{text(entry.description)}</p>}</div></div>) : t('career') && <div className="about-career"><span className="about-career-dot" /><span>{t('career')}</span></div>}</div></Card>}
      </Row>
      {enabled('info') && <Row>
        {(t('location') || t('mapImage') || t('mapDarkImage')) && <Card kind="map" image={t('mapImage')} darkImage={t('mapDarkImage')}>{t('location') && <div className="about-map-title">{t('locationPrefix')}<b>{t('location')}</b></div>}</Card>}
        {(typeof m.birthYear === 'number' || t('birthYearText') || t('profession') || t('currentJob')) && <Card kind="info"><div className="about-facts">{(typeof m.birthYear === 'number' || t('birthYearText')) && <div className="about-fact-birth"><span>{t('birthLabel')}</span><strong>{typeof m.birthYear === 'number' ? m.birthYear : t('birthYearText')}</strong></div>}{t('profession') && <div className="about-fact-profession"><span>{t('professionLabel')}</span><strong>{t('profession')}</strong></div>}{t('currentJob') && <div className="about-fact-job"><span>{t('jobLabel')}</span><strong>{t('currentJob')}</strong></div>}</div></Card>}
      </Row>}
      <Row>
      {enabled('personality') && (t('personality') || t('personalityCode') || t('personalityImage')) && <Card kind="personality">{label('personalityLabel')}{heading('personality')}<strong className="about-personality-code">{t('personalityCode')}</strong>{t('personalityImage') && <Media src={t('personalityImage')} alt={t('personality')} />}{t('personalityUrl') && <a href={safeUrl(t('personalityUrl'))} target="_blank" rel="noreferrer">{t('personalityLinkText') || t('personality')}</a>}</Card>}
      {enabled('photo') && t('photo') && <Card kind="photo" image={t('photo')}><span className="sr-only">个人照片</span></Card>}
      </Row>
      <Row>
      {enabled('maxim') && t('motto') && <Card kind="maxim">{label('mottoLabel')}<h2 className="about-lines">{t('motto').split('\n').map((line, i) => <span key={i}>{line}</span>)}</h2></Card>}
      {enabled('buff') && t('buff') && <Card kind="buff">{label('buffLabel')}<h2 className="about-lines">{t('buff').split('\n').map((line, i) => <span key={i}>{line}</span>)}</h2><i className="about-buff-dice anzhiyufont anzhiyu-icon-dice" aria-hidden="true" /></Card>}
      </Row>
      <Row>
      {enabled('game') && (t('gameTitle') || t('gameImage') || t('gameUid')) && <Card kind="game" image={t('gameImage')}>{label('gameLabel')}{heading('gameTitle')}{t('gameUid') && <p className="about-bottom">{t('gameUid')}</p>}</Card>}
      {enabled('comics') && comics.length > 0 && <Card kind="comics">{label('comicsLabel')}{heading('comicsTitle')}<div className="about-comics">{comics.map((comic, i) => text(comic.url) ? <a key={i} href={safeUrl(text(comic.url))} target="_blank" rel="noreferrer" aria-label={text(comic.title)} title={text(comic.title)}><Media src={text(comic.image)} alt={text(comic.title)} /></a> : <div key={i}><Media src={text(comic.image)} alt={text(comic.title)} /></div>)}</div></Card>}
      </Row>
      <Row>
      {enabled('technology') && (t('technologyTitle') || t('technologyDescription') || t('technologyImage')) && <Card kind="technology" image={t('technologyImage')}>{label('technologyLabel')}{heading('technologyTitle')}<p className="about-bottom">{t('technologyDescription')}</p></Card>}
      {enabled('music') && (t('musicTitle') || t('musicImage') || t('musicDescription')) && <Card kind="music" image={t('musicImage')}>{label('musicLabel')}{heading('musicTitle')}<p className="about-bottom">{t('musicDescription')}</p>{t('musicUrl') && <a className="about-link-button" href={safeUrl(t('musicUrl'))}>{t('musicLinkText') || t('musicTitle')} →</a>}</Card>}
      </Row>
      <Row>
      {enabled('cards') && cards.map((card, i) => <Card key={i} kind="custom" image={text(card.image)}><h2>{text(card.url) ? <a href={safeUrl(text(card.url))}>{text(card.title)}</a> : text(card.title)}</h2><p>{text(card.description)}</p></Card>)}
      </Row>
    </div>
    {enabled('body') && item.body && <section className="about-body"><ContentBody item={item} /></section>}
    {enabled('socials') && socials.length > 0 && <div className="about-socials">{socials.map((social, i) => <a key={i} href={safeUrl(text(social.url))} target="_blank" rel="noreferrer">{text(social.label)}</a>)}</div>}
    {enabled('donation') && t('donationImage') && <div className="about-reward"><button onClick={() => setReward(true)}>{t('donationTitle') || '支持创作'}</button></div>}
    {reward && <Modal title={t('donationTitle') || '支持创作'} onClose={() => setReward(false)}><Media src={t('donationImage')} alt="打赏二维码" /><p>{t('donationText')}</p></Modal>}
  </div>;
}
