import { computed, ref } from 'vue';
import type { Content } from '@/service/api/blog';
type Request = (method: 'get' | 'put', data?: Partial<Content>) => Promise<Content>;
export function useAboutSettings(request: Request, canEdit: () => boolean) {
  const form = ref<Content>();
  const snapshot = ref('');
  const saving = ref(false);
  const loading = ref(false);
  const uploads = ref(0);
  const error = ref('');
  const savedAt = ref('');
  const dirty = computed(() => !!form.value && JSON.stringify(form.value) !== snapshot.value);
  const locked = computed(() => saving.value || loading.value || !canEdit());
  const canSave = computed(() => !!form.value && (dirty.value || !form.value.id) && !locked.value && !uploads.value);
  function accept(value: Content) {
    const metadata = { ...value.metadata };
    for (const key of ['profileTags', 'skillItems', 'experiences', 'comics', 'cards', 'socials', 'pursuitWords']) metadata[key] ??= [];
    metadata.sections ??= {};
    snapshot.value = JSON.stringify({ ...value, metadata, password: '' });
    form.value = JSON.parse(snapshot.value);
  }
  async function load() {
    if (loading.value || saving.value || dirty.value) return;
    loading.value = true;
    error.value = '';
    try { accept(await request('get')); } catch { error.value = '个人资料加载失败，请重试。'; } finally { loading.value = false; }
  }
  async function save() {
    if (!form.value || !canSave.value || !canEdit()) return false;
    if (!form.value.title.trim()) { error.value = '请填写页面标题'; return false; }
    const previous = snapshot.value ? JSON.parse(snapshot.value) : null;
    if (form.value.accessMode === 'password' && !form.value.password && (!form.value.id || previous?.accessMode !== 'password')) { error.value = '请设置访问密码'; return false; }
    saving.value = true;
    error.value = '';
    try {
      const { title, summary, body, format, status, accessMode, publishedAt, metadata, password } = form.value;
      const data = JSON.parse(JSON.stringify({ title, summary, body, format, status, accessMode, publishedAt, metadata, ...(password ? { password } : {}) }));
      accept(await request('put', data));
      savedAt.value = new Date().toLocaleTimeString('zh-CN');
      return true;
    } catch { error.value = '保存失败，修改内容已保留。请检查接口提示后重试。'; return false; } finally { saving.value = false; }
  }
  function restore() { if (snapshot.value && !saving.value && !uploads.value) { form.value = JSON.parse(snapshot.value); error.value = ''; } }
  function trackUpload(active: boolean) { uploads.value = Math.max(0, uploads.value + (active ? 1 : -1)); }
  return { form, snapshot, loading, saving, uploads, error, savedAt, dirty, locked, canSave, load, save, restore, trackUpload };
}
