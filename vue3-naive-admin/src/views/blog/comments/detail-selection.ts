import { ref } from 'vue';
import { sourceHref } from './comment-utils';

type Detail = { id: number; body: string; metadata: Record<string, any> };

export function createDetailSelection(
  render: (body: string) => Promise<string>,
  lookupSlug: (id: number, kind: 'documents' | 'albums') => Promise<string | undefined>
) {
  const preview = ref('');
  const source = ref<string>();
  let generation = 0;
  async function select(detail: Detail | null) {
    const current = ++generation;
    preview.value = '';
    source.value = detail ? sourceHref(detail.metadata) : undefined;
    if (!detail) return;
    const previewTask = render(detail.body).then(html => {
      if (current === generation) preview.value = html;
    }).catch(() => {
      if (current === generation) preview.value = '';
    });
    const kind = detail.metadata?.targetKind;
    const id = Number(detail.metadata?.targetId);
    const sourceTask = (kind === 'documents' || kind === 'albums') && Number.isSafeInteger(id) && id > 0
      ? lookupSlug(id, kind).then(slug => {
        if (current === generation && slug) source.value = sourceHref({ ...detail.metadata, targetSlug: slug });
      }).catch(() => undefined)
      : Promise.resolve();
    await Promise.all([previewTask, sourceTask]);
  }
  return { preview, source, select };
}
