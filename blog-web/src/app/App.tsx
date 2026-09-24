import { ContextMenu } from "../components/navigation/ContextMenu";
import { SearchDialog } from "../views/articles/components/SearchDialog";
import { Effects } from "./effects/Effects";
import { SiteFooter } from "./SiteFooter";
import { MobileMenu } from "./MobileMenu";
import { SettingsConsole } from "./SettingsConsole";
import { FloatingPlayer } from '../views/music/components/FloatingPlayer';
import {
  ShareDialog,
  BackgroundSettings,
  useTraditional,
} from "../components/extra/extras";
import { BlogNavigation } from "../components/navigation/BlogNavigation";
import { StartupScreen } from "../components/StartupScreen";
import { PageTools } from "../components/navigation/PageTools";
import { useCallback, useEffect, useRef, useState } from "react";
import {
  useLocation,
  useNavigate,
} from "react-router-dom";
import { api, list, safeUrl, setToken, token } from "../services/api";
import {
  pathFor,
  Status,
  useLoad,
  useMedia,
} from "../components";
import type { Content, Menu, Session, Site } from "../types";
import Auth from "../views/auth";
import { AppRoutes } from "./router";
import { BlogProvider } from "./BlogProvider"
import { HomeHero, heroSlides } from "../views/home/components/HomeHero";
const blank: Site = {
  title: "博客",
  subtitle: "",
  logo: "",
  avatar: "",
  description: "",
  announcement: "",
  heroTitle: "",
  heroSubtitle: "",
  heroImage: "",
  footerText: "",
  icp: "",
  startDate: "",
  defaultTheme: "light",
  effectsEnabled: true,
  showMusic: true,
  showAside: true,
  homeCards: [],
  socials: [],
};
export default function App() {
  const siteState = useLoad(() => api<Site>("/blog/public/site"));
  const menus = useLoad(() => api<Menu[]>("/blog/public/menus"));
  const [site, setSite] = useState(blank);
  const [session, setSession] = useState<Session | null>(null);
  const [revision, setRevision] = useState(0);
  const [auth, setAuth] = useState(false);
  const [search, setSearch] = useState(false);
  const [share, setShare] = useState(false);
  const [backgroundDialog, setBackgroundDialog] = useState(false);
  const [background, setBackground] = useState(() => {
    try {
      const saved = JSON.parse(
        localStorage.getItem("blog-background") || "null",
      );
      return saved && Date.now() - saved.time < 86400000 ? saved.value : "";
    } catch {
      return "";
    }
  });
  const heroBackground = useMedia(site.heroImage);
  useEffect(() => {
    localStorage.setItem(
      "blog-background",
      JSON.stringify({ time: Date.now(), value: background }),
    );
  }, [background]);
  const [traditional, setTraditional] = useState(
    localStorage.getItem("blog-traditional") === "true",
  );
  useTraditional(traditional);
  useEffect(() => {
    localStorage.setItem("blog-traditional", String(traditional));
  }, [traditional]);
  const [drawer, setDrawer] = useState(false);
  const [consoleOpen, setConsole] = useState(false);
  const [theme, setTheme] = useState(localStorage.getItem("blog-theme") || "");
  const [aside, setAside] = useState(
    localStorage.getItem("blog-aside") !== "false",
  );
  const [effects, setEffects] = useState(
    localStorage.getItem("blog-effects") !== "false",
  );
  const [keyboard, setKeyboard] = useState(true);
  const [rightMenu, setRightMenu] = useState(true);
  const [progress, setProgress] = useState(0);
  const [context, setContext] = useState<{
    x: number;
    y: number;
    image?: string;
    link?: string;
  } | null>(null);
  const [toast, setToast] = useState("");
  const [track, setTrack] = useState<Content | null>(null);
  const nav = useNavigate();
  const location = useLocation();
  const isMusicPage = /^\/music\/?$/.test(location.pathname);
  useEffect(() => { if (isMusicPage) setTrack(null); }, [isMusicPage]);
  const notify = useCallback((s: string) => setToast(s), []);
  useEffect(() => {
    if (siteState.data) setSite(siteState.data);
  }, [siteState.data]);
  useEffect(() => {
    const mode = theme || site.defaultTheme;
    document.documentElement.dataset.theme =
      mode === "system"
        ? matchMedia("(prefers-color-scheme:dark)").matches
          ? "dark"
          : "light"
        : mode;
    localStorage.setItem("blog-theme", theme);
  }, [theme, site.defaultTheme]);
  useEffect(() => {
    localStorage.setItem("blog-aside", String(aside));
    localStorage.setItem("blog-effects", String(effects));
  }, [aside, effects]);
  useEffect(() => {
    if (!toast) return;
    const t = setTimeout(() => setToast(""), 3500);
    return () => clearTimeout(t);
  }, [toast]);
  useEffect(() => {
    const refresh = () => {
      setRevision((v) => v + 1);
      if (!token()) {
        setSession(null);
        return;
      }
      api<Session>("/blog/public/session")
        .then(setSession)
        .catch(() => setSession(null));
    };
    refresh();
    window.addEventListener("blog-auth", refresh);
    window.addEventListener("blog-access", refresh);
    window.addEventListener("storage", refresh);
    return () => {
      window.removeEventListener("blog-auth", refresh);
      window.removeEventListener("blog-access", refresh);
      window.removeEventListener("storage", refresh);
    };
  }, []);
  useEffect(() => {
    setDrawer(false);
    setConsole(false);
    setContext(null);
    window.scrollTo(0, 0);
    if (location.pathname === "/") document.title = site.title;
    document
      .querySelector('meta[name="description"]')
      ?.setAttribute("content", site.description);
  }, [location.pathname, site.title, site.description]);
  useEffect(() => {
    const scroll = () => {
      const y = scrollY;
      setProgress(
        Math.min(
          100,
          Math.round(
            (y /
              Math.max(
                1,
                document.documentElement.scrollHeight - innerHeight,
              )) *
              100,
          ),
        ),
      );
    };
    window.addEventListener("scroll", scroll, { passive: true });
    return () => window.removeEventListener("scroll", scroll);
  }, []);
  const toggleTheme = () =>
    setTheme(
      document.documentElement.dataset.theme === "dark" ? "light" : "dark",
    );
  const random = async () => {
    try {
      const first = await list("documents", { pageSize: 1 });
      if (!first.total) {
        notify("还没有文章");
        return;
      }
      const result = await list("documents", {
        pageSize: 1,
        page: 1 + Math.floor(Math.random() * first.total),
      });
      if (result.items[0]) nav(pathFor("documents", result.items[0]));
    } catch (e) {
      notify((e as Error).message);
    }
  };
  useEffect(() => {
    const key = (e: KeyboardEvent) => {
      if ((e.target as HTMLElement).closest("input,textarea,[contenteditable]"))
        return;
      if (e.key === "Escape") {
        setConsole(false);
        setDrawer(false);
        setContext(null);
      }
      if (e.key === "/") {
        e.preventDefault();
        setSearch(true);
      }
      if (!e.shiftKey || !keyboard) return;
      const k = e.key.toLowerCase();
      if ("amkirdhflp".includes(k)) e.preventDefault();
      if (k === "a") setConsole((v) => !v);
      if (k === "d") toggleTheme();
      if (k === "h") nav("/");
      if (k === "f") nav("/fcircle/");
      if (k === "l") nav("/link/");
      if (k === "p") nav("/about/");
      if (k === "r") void random();
      if (k === "k") setKeyboard((v) => !v);
      if (k === "i") setRightMenu((v) => !v);
      if (k === "m")
        window.dispatchEvent(
          new CustomEvent("blog-player", { detail: "toggle" }),
        );
    };
    const ctx = (e: MouseEvent) => {
      if (!rightMenu || (e.target as HTMLElement).closest("input,textarea"))
        return;
      e.preventDefault();
      setContext({
        image:
          e.target instanceof HTMLImageElement
            ? e.target.currentSrc || e.target.src
            : undefined,
        link: (e.target as HTMLElement).closest<HTMLAnchorElement>("a[href]")
          ?.href,
        x: Math.max(8, Math.min(e.clientX, innerWidth - 210)),
        y: Math.max(8, Math.min(e.clientY, innerHeight - 500)),
      });
    };
    const close = () => setContext(null);
    window.addEventListener("keydown", key);
    window.addEventListener("contextmenu", ctx);
    window.addEventListener("click", close);
    return () => {
      window.removeEventListener("keydown", key);
      window.removeEventListener("contextmenu", ctx);
      window.removeEventListener("click", close);
    };
  }, [keyboard, rightMenu, theme]);
  const effectiveSite = { ...site, showAside: site.showAside && aside };
  // Do not mount content with placeholder settings and then replace its layout.
  if (site === blank) return <StartupScreen error={siteState.error} onRetry={siteState.reload} />;
  return (
    <BlogProvider
      value={{
        site: effectiveSite,
        session,
        login: () => setAuth(true),
        notify,
        play: setTrack,
        revision,
      }}
    >
      <div id="web_bg" style={background ? { background: background === "@site-hero" ? (heroBackground ? `url("${heroBackground}") center / cover no-repeat fixed` : undefined) : background } : undefined} />
      <Effects enabled={effects && site.effectsEnabled} />
      <div id="body-wrap" className={`page${isMusicPage ? " music-page" : ""}${location.pathname.startsWith("/posts/") ? " article-page" : ""}${location.pathname === '/' && site.homeHeroEnabled && heroSlides(site).length ? ' home-hero-page' : ''}`}>
        <BlogNavigation site={site} menus={menus.data || []} consoleOpen={consoleOpen}
          readingProgress={progress}
          onRandom={random} onSearch={() => setSearch(true)} onConsole={() => setConsole(v => !v)} onMenu={() => setDrawer(true)} />
        {location.pathname === '/' && <HomeHero site={site} />}
        <main id="blog-container">
          <Status
            loading={siteState.loading}
            error={siteState.error}
            retry={siteState.reload}
          />
          {menus.error && (
            <div className="menu-error" role="alert">
              导航加载失败 <button onClick={menus.reload}>重试</button>
            </div>
          )}
          <div className="route-transition" key={location.pathname}>
            <AppRoutes />
          </div>
        </main>
        {!isMusicPage && <SiteFooter site={site} />}
      </div>
      {drawer && <MobileMenu site={site} menus={menus.data || []} onClose={() => setDrawer(false)} />}
      {consoleOpen && <SettingsConsole session={session} traditional={traditional} aside={aside} effects={effects} keyboard={keyboard} rightMenu={rightMenu} toggleTheme={toggleTheme} notify={notify} onClose={() => setConsole(false)} onBackground={() => setBackgroundDialog(true)} onShare={() => setShare(true)} onTraditional={() => setTraditional(v => !v)} onAside={() => setAside(v => !v)} onEffects={() => setEffects(v => !v)} onKeyboard={() => setKeyboard(v => !v)} onRightMenu={() => setRightMenu(v => !v)} onLogin={() => setAuth(true)} />}
      {search && <SearchDialog onClose={() => setSearch(false)} />}
      {share && <ShareDialog onClose={() => setShare(false)} />}
      {backgroundDialog && (
        <BackgroundSettings
          onClose={() => setBackgroundDialog(false)}
          onChange={setBackground}
          hero={heroBackground}
        />
      )}{" "}
      {auth && <Auth onClose={() => setAuth(false)} />}
      {!isMusicPage && <PageTools onSettings={() => setConsole(true)} onBackground={() => setBackgroundDialog(true)} />}
      {site.showMusic && !isMusicPage && <FloatingPlayer track={track} />}{" "}
      {context && <ContextMenu context={context} traditional={traditional} notify={notify} random={random} toggleTheme={toggleTheme} onShare={() => setShare(true)} onTraditional={() => setTraditional(v => !v)} onSearch={() => setSearch(true)} />}
      {toast && (
        <div className="snackbar" role="status">
          {toast}
        </div>
      )}
    </BlogProvider>
  );
}
