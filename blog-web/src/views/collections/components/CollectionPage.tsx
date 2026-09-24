import {
LoadedContent,
useMedia
} from "../../../components";
import { safeUrl } from "../../../services/api";
import type { Content } from "../../../types";

const collectionEmoji: Record<string, string> = {
  电影: "🎬",
  小说: "📖",
  游戏: "🎮",
  音乐: "🎵",
  其他: "📦",
};
const collectionIconEmoji: Record<string, string> = {
  film: "🎬",
  book: "📖",
  game: "🎮",
  music: "🎵",
  box: "📦",
};

function CollectionCard({ item, category }: { item: Content; category: string }) {
  const image = useMedia(item.locked ? "" : item.cover || "");
  const icon = String(item.metadata?.icon || "");
  const rating = Math.max(0, Math.min(5, Number(item.metadata?.rating) || 0));
  const card = (
    <div
      className="collection-card"
      style={image ? { backgroundImage: `url(${JSON.stringify(image)})` } : undefined}
    >
      <div className="collection-card__top">
        <span aria-hidden="true">{collectionIconEmoji[icon] || collectionEmoji[category] || "📦"}</span>
        <span>{category}</span>
      </div>
      <div className="collection-card__content">
        <strong className="collection-card__title">{item.title}</strong>
        <div className="collection-card__stars" aria-label={`${rating} 星评分`}>
          {[1, 2, 3, 4, 5].map((star) => <span key={star} aria-hidden="true">{star <= rating ? "★" : "☆"}</span>)}
        </div>
      </div>
      {item.locked && <LoadedContent kind="collections" item={item} />}
    </div>
  );
  return item.url && !item.locked ? (
    <a className="collection-card-link" href={safeUrl(item.url)} target="_blank" rel="noopener noreferrer" aria-label={item.title}>
      {card}
    </a>
  ) : card;
}

export function CollectionPage({ items }: { items: Content[] }) {
  const groups = items.reduce<Record<string, Content[]>>((result, item) => {
    const category = String(item.metadata?.category || item.groupName || "其他");
    (result[category] ||= []).push(item);
    return result;
  }, {});
  const orderedGroups = Object.entries(groups);
  return (
    <div className="collection-page">
      {orderedGroups.map(([category, group]) => (
        <section className="collection-group" key={category}>
          <h2><span aria-hidden="true">{collectionEmoji[category] || "📦"}</span> {category} ({group.length})</h2>
          <div className="collection-list">
            {group.map((item) => <CollectionCard item={item} category={category} key={item.id} />)}
          </div>
        </section>
      ))}
    </div>
  );
}

