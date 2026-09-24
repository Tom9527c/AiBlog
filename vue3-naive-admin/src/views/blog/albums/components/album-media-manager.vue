<script setup lang="ts">
import { computed, ref, watch } from 'vue';
import { api, list, upload, type Content } from '@/service/api/blog';
import { useBlogAuth } from '@/hooks/business/blog-auth';
import AlbumMediaPreview from './album-media-preview.vue';
const props = defineProps<{ albumId: number; disabled?: boolean }>();
const emit = defineEmits<{ busy: [value: boolean] }>();
const { hasAuth } = useBlogAuth();
const allowed = (action: string) => !props.disabled && (hasAuth('blog:albums:update') || hasAuth(`blog:photos:${action}`));
const canList = computed(() => hasAuth('blog:albums:list') || hasAuth('blog:photos:list'));
const items = ref<Content[]>([]);
const total = ref(0);
const page = ref(1);
const loading = ref(false);
const busy = ref(false);
const error = ref('');
const input = ref<HTMLInputElement>();
const progress = ref('');
const pending = ref<{ name: string; url: string; mime: string }[]>([]);
const editing = ref<Content | null>(null);
let generation = 0;
function setBusy(value: boolean) { busy.value = value; emit('busy', value); }
async function load() {
  const current = ++generation;
  if (!props.albumId || !canList.value) return;
  loading.value = true;
  try {
    const result = await list('photos', { parentId: props.albumId, page: page.value, pageSize: 12 });
    if (current === generation) { items.value = result.items; total.value = result.total; }
  } catch { if (current === generation) error.value = '相册内容加载失败，请重试'; }
  finally { if (current === generation) loading.value = false; }
}
watch(() => props.albumId, () => { page.value = 1; items.value = []; pending.value = []; error.value = ''; load(); }, { immediate: true });
async function register(media: { name: string; url: string; mime: string }) {
  await api('content/photos', 'post', { parentId: props.albumId, title: media.name.slice(0, 200), url: media.url,
    status: 'published', accessMode: 'public', metadata: { mediaType: media.mime.startsWith('video/') ? 'video' : 'image' } });
}
async function pick(event: Event) {
  const field = event.target as HTMLInputElement;
  const files = Array.from(field.files || []); field.value = '';
  if (!files.length || !props.albumId || !allowed('create') || busy.value) return;
  error.value = ''; setBusy(true);
  let successes = 0;
  const failed: string[] = [];
  try {
    for (const [index, file] of files.entries()) {
      progress.value = `正在处理 ${index + 1} / ${files.length}`;
      if (file.size > 25 * 1024 * 1024 || !/\.(jpe?g|png|gif|webp|avif|mp4)$/i.test(file.name)) { failed.push(`${file.name}：格式不支持或超过 25MB`); continue; }
      let media;
      try {
        media = await upload(file);
        await register(media);
        successes += 1;
      } catch {
        if (media) pending.value.push(media);
        failed.push(`${file.name}：${media ? '已上传，添加到相册失败，请点击重试' : '上传失败，请重新选择'}`);
      }
    }
    if (successes) window.$message?.success(`已添加 ${successes} 个文件`);
    error.value = failed.join('；');
    page.value = 1;
    await load();
  } finally { setBusy(false); progress.value = ''; }
}
async function retry() {
  if (!allowed('create') || busy.value) return;
  setBusy(true); error.value = '';
  try {
    for (const media of [...pending.value]) {
      try { await register(media); pending.value = pending.value.filter(item => item !== media); }
      catch { error.value = '部分文件仍未添加成功，请重试'; }
    }
    page.value = 1; await load();
  } finally { setBusy(false); }
}
async function saveItem() {
  if (!editing.value || !allowed('update') || busy.value) return;
  const row = editing.value;
  if (!row.title.trim()) { window.$message?.warning('请填写名称'); return; }
  setBusy(true); error.value = '';
  try {
    await api(`content/photos/${row.id}`, 'put', { title: row.title, summary: row.summary, sort: row.sort, status: row.status });
    editing.value = null; await load();
  } catch { error.value = '保存失败，请重试'; }
  finally { setBusy(false); }
}
async function remove(row: Content) {
  if (!allowed('delete') || busy.value) return;
  setBusy(true); error.value = '';
  try {
    await api(`content/photos/${row.id}`, 'delete');
    if (items.value.length === 1 && page.value > 1) page.value -= 1;
    await load();
  } catch { error.value = '移除失败，请重试'; }
  finally { setBusy(false); }
}
function video(row: Content) { return row.metadata?.mediaType === 'video' || /\.(mp4|webm|mov)(?:[?#]|$)/i.test(row.url); }
</script>

<template>
  <div class="album-manager">
    <NAlert v-if="!albumId" type="info" :show-icon="false">先保存相册信息，即可在这里添加图片、动图和视频。</NAlert>
    <template v-else>
      <div class="album-manager__toolbar">
        <NButton type="primary" :loading="busy" :disabled="!allowed('create') || busy" @click="input?.click()">上传图片 / 视频</NButton>
        <NButton :disabled="busy || loading" @click="load">刷新</NButton>
        <span>{{ progress || `共 ${total} 个文件` }}</span>
        <input ref="input" type="file" multiple accept="image/jpeg,image/png,image/gif,image/webp,image/avif,video/mp4" hidden @change="pick" />
      </div>
      <NText depth="3">支持 JPG、PNG、GIF、WebP、AVIF、MP4，每个文件不超过 25MB。添加、修改和移除即时保存；新上传文件随相册访问权限展示。</NText>
      <NAlert v-if="error" type="error" class="album-manager__error">{{ error }}</NAlert>
      <NButton v-if="pending.length" :disabled="busy || !allowed('create')" @click="retry">重试添加 {{ pending.length }} 个已上传文件</NButton>
      <NAlert v-if="!canList" type="warning">没有查看相册内容的权限。</NAlert>
      <NSpin v-else :show="loading">
        <div v-if="items.length" class="album-manager__grid">
          <article v-for="row in items" :key="row.id" class="album-manager__item">
            <AlbumMediaPreview :src="row.url || row.cover" :video="video(row)" :title="row.title" />
            <strong>{{ row.title }}</strong>
            <div class="album-manager__meta">
              <NTag size="small">{{ video(row) ? '视频' : '图片 / 动图' }}</NTag>
              <span>{{ row.status === 'published' ? '已发布' : '草稿' }} · 排序 {{ row.sort }}</span>
              <span v-if="row.accessMode !== 'public'">{{ row.accessMode === 'password' ? '单独密码保护' : '需登录' }}</span>
            </div>
            <p v-if="row.summary">{{ row.summary }}</p>
            <NSpace>
              <NButton size="small" :disabled="busy || !allowed('update')" @click="editing = { ...row }">编辑</NButton>
              <NPopconfirm @positive-click="remove(row)">
                <template #trigger><NButton size="small" type="error" :disabled="busy || !allowed('delete')">移除</NButton></template>
                从相册移除此项？原始文件仍保留在文件管理中。
              </NPopconfirm>
            </NSpace>
          </article>
        </div>
        <NEmpty v-else-if="!loading" description="还没有内容，上传图片或视频开始记录吧" class="album-manager__empty" />
      </NSpin>
      <NPagination v-if="total > 12" v-model:page="page" :page-size="12" :item-count="total" :disabled="busy" @update:page="load" />
    </template>
    <NModal :show="Boolean(editing)" preset="card" title="编辑相册内容" style="width: min(500px, 90vw)" :mask-closable="false" :closable="!busy" @update:show="editing = null">
      <NForm v-if="editing" label-placement="top">
        <NFormItem label="名称"><NInput v-model:value="editing.title" :maxlength="200" /></NFormItem>
        <NFormItem label="说明"><NInput v-model:value="editing.summary" type="textarea" :maxlength="2000" /></NFormItem>
        <NFormItem label="排序（数字越大越靠前）"><NInputNumber v-model:value="editing.sort" :min="-100000" :max="100000" :precision="0" /></NFormItem>
        <NFormItem label="状态"><NSelect v-model:value="editing.status" :options="[{ label: '发布', value: 'published' }, { label: '草稿', value: 'draft' }]" /></NFormItem>
        <NButton type="primary" :loading="busy" @click="saveItem">保存</NButton>
      </NForm>
    </NModal>
  </div>
</template>
<style scoped>
.album-manager { display: grid; gap: 14px; width: 100%; }
.album-manager__toolbar { display: flex; gap: 10px; align-items: center; flex-wrap: wrap; }
.album-manager__toolbar span, .album-manager__meta { font-size: 12px; color: var(--manager-muted); }
.album-manager__grid { display: grid; grid-template-columns: repeat(2, minmax(0, 1fr)); gap: 16px; }
.album-manager__item { display: grid; align-content: start; gap: 10px; border: 1px solid var(--manager-border); padding: 12px; border-radius: 12px; min-width: 0; }
.album-manager__item strong, .album-manager__item p { overflow-wrap: anywhere; margin: 0; }
.album-manager__meta { display: flex; gap: 8px; flex-wrap: wrap; align-items: center; }
.album-manager__empty { padding: 30px 0; }
@media (max-width: 600px) { .album-manager__grid { grid-template-columns: 1fr; } }
</style>
