import { useEffect, useSyncExternalStore } from 'react';
import type { Content } from '../types';

const eventName = 'blog-post-read';
const key = (id: number) => `blog-read:${id}`;
function subscribe(notify: () => void) {
  window.addEventListener(eventName, notify);
  window.addEventListener('storage', notify);
  return () => {
    window.removeEventListener(eventName, notify);
    window.removeEventListener('storage', notify);
  };
}
function hasRead(id: number) {
  try { return localStorage.getItem(key(id)) === '1'; } catch { return false; }
}
export function useReadPost(id: number) {
  return useSyncExternalStore(subscribe, () => hasRead(id), () => false);
}
export function useMarkPostRead(post?: Content) {
  useEffect(() => {
    if (!post || post.locked || hasRead(post.id)) return;
    try {
      localStorage.setItem(key(post.id), '1');
      window.dispatchEvent(new Event(eventName));
    } catch { /* Reading remains available when browser storage is disabled. */ }
  }, [post?.id, post?.locked]);
}
