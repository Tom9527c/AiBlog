import { Music } from '../views/music';
import { Guestbook } from "../views/comments/Guestbook";
import { AboutPage } from "../views/about";
import { RandomPost } from "../views/articles/RandomPost";
import { EssayPage } from "../views/essays";
import { BangumiPage } from '../views/bangumi';
import { LinksPage } from '../views/links';
import { CollectionsPage } from '../views/collections';
import { Navigate, Route, Routes } from "react-router-dom";
import {
  Albums,
  Archives,
  Article,
  Home,
  NotFound,
  Taxonomy,
} from "../views";

export function AppRoutes() {
  return (
    <Routes>
      <Route path="/" element={<Home />} />
      <Route path="/essay/" element={<EssayPage />} />
      <Route path="/fcircle/" element={<Navigate to="/essay/" replace />} />
      <Route path="/about/" element={<AboutPage />} />
      <Route path="/random/" element={<RandomPost />} />
      <Route path="/posts/:slug" element={<Article />} />
      {["/archives/", "/archives/page/:pageNumber", "/archives/:year", "/archives/:year/page/:pageNumber", "/archives/:year/:month", "/archives/:year/:month/page/:pageNumber"].map((path) => <Route key={path} path={path} element={<Archives />} />)}
      <Route path="/page/:pageNumber" element={<Home />} />
      <Route path="/categories/:slug/page/:pageNumber" element={<Taxonomy kind="categories" />} />
      <Route path="/tags/:slug/page/:pageNumber" element={<Taxonomy kind="tags" />} />
      <Route path="/categories/" element={<Taxonomy kind="categories" />} />
      <Route path="/categories/:slug" element={<Taxonomy kind="categories" />} />
      <Route path="/tags/" element={<Taxonomy kind="tags" />} />
      <Route path="/tags/:slug" element={<Taxonomy kind="tags" />} />
      <Route path="/album/" element={<Albums />} />
      <Route path="/album/:slug" element={<Albums />} />
      {["dailyPhoto", "lovePic", "wordScenery"].map((p) => <Route key={p} path={`/${p}/`} element={<Albums />} />)}
      <Route path="/bangumis/" element={<BangumiPage />} />
      <Route path="/link/" element={<LinksPage />} />
      <Route path="/collect/" element={<CollectionsPage />} />
      <Route path="/music/" element={<Music />} />
      <Route path="/comments/" element={<Guestbook />} />
      <Route path="*" element={<NotFound />} />
    </Routes>
  );
}
