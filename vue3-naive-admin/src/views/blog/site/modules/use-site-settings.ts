import { computed, ref } from 'vue';
import type { Site } from '@/service/api/blog';
import { homeHeroDefaults } from './home-hero-defaults';

type SiteRequest = (method: 'get' | 'put', data?: Site) => Promise<Site>;

/** Keep the saved snapshot separate so failed requests never discard edits. */
export function useSiteSettings(request: SiteRequest, canEdit: () => boolean) {
  const form = ref<Site>();
  const snapshot = ref('');
  const loading = ref(false);
  const saving = ref(false);
  const uploads = ref(0);
  const error = ref('');
  const savedAt = ref('');
  const dirty = computed(() => Boolean(form.value && JSON.stringify(form.value) !== snapshot.value));
  const locked = computed(() => loading.value || saving.value || !canEdit());
  const canSave = computed(() => dirty.value && !locked.value && uploads.value === 0);

  function accept(value: Site) {
    snapshot.value = JSON.stringify({ restrictedMediaValidationEnabled: false, articlePageSize: 8, ...homeHeroDefaults, ...value });
    form.value = JSON.parse(snapshot.value) as Site;
  }

  async function load() {
    if (loading.value || saving.value || dirty.value) return;
    loading.value = true;
    error.value = '';
    try {
      accept(await request('get'));
    } catch {
      error.value = '站点配置加载失败，请重试。';
    } finally {
      loading.value = false;
    }
  }

  async function save() {
    if (!canSave.value || !form.value) return false;
    saving.value = true;
    error.value = '';
    try {
      const payload = JSON.parse(JSON.stringify(form.value)) as Site;
      // Page headers are saved independently in their modal; this form may hold an older snapshot.
      delete payload.pageHeaders;
      accept(await request('put', payload));
      savedAt.value = new Date().toLocaleTimeString('zh-CN', { hour12: false });
      return true;
    } catch {
      error.value = '保存失败，修改内容已保留。请检查网络或接口提示后重试。';
      return false;
    } finally {
      saving.value = false;
    }
  }

  function restore() {
    if (!snapshot.value || saving.value || uploads.value) return;
    form.value = JSON.parse(snapshot.value) as Site;
    error.value = '';
  }

  function trackUpload(active: boolean) {
    uploads.value = Math.max(0, uploads.value + (active ? 1 : -1));
  }

  return { form, loading, saving, uploads, error, savedAt, dirty, locked, canSave, load, save, restore, trackUpload };
}
