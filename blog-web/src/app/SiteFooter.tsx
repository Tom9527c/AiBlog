import type { Site } from "../types";
import { safeUrl } from "../services/api";

export function SiteFooter({ site }: { site: Site }) {
  return (
        <footer id="footer">
          <div id="footer-wrap">
            <p>{site.footerText || site.title}</p>
            <div className="socials">
              {site.socials?.map((s) => (
                <a
                  key={s.label}
                  href={safeUrl(s.url)}
                  target="_blank"
                  rel="noreferrer"
                >
                  {s.label}
                </a>
              ))}
            </div>
            {site.startDate && (
              <p>
                本站已运行{" "}
                {Math.max(
                  0,
                  Math.floor(
                    (Date.now() - new Date(site.startDate).getTime()) /
                      86400000,
                  ),
                )}{" "}
                天
              </p>
            )}
            {site.icp && (
              <a
                href="https://beian.miit.gov.cn/"
                target="_blank"
                rel="noreferrer"
              >
                {site.icp}
              </a>
            )}
          </div>
        </footer>
  );
}
