<script setup lang="ts">
import { computed, onMounted, onUnmounted, ref, watch } from 'vue';
import { useThemeVars } from 'naive-ui';
import { useBlogAuth } from '@/hooks/business/blog-auth';
import { applyMusicLibrary, getMusicLibrary, importMusicLibrary, previewMusicLibrary, type MusicSnapshot, type MusicState, type MusicTrack } from '@/service/api/music';
import ContentManager from '../content';
import PageHeaderSettings from '../components/page-header-settings.vue';
import { DEFAULT_MUSIC_SOURCE, MAX_IMPORT_BYTES, emptySnapshot, parseSnapshot, previewIsExpired, removeTrack, safeMusicUrl, serializeSnapshot, updateTrack } from './music-library';

defineOptions({ name: 'blog_music' });
const { hasAuth } = useBlogAuth();
const theme = useThemeVars();
const canRead = computed(() => hasAuth('blog:music:list'));
const canUpdate = computed(() => hasAuth('blog:music:update'));
const state = ref<MusicState | null>(null);
const source = ref(DEFAULT_MUSIC_SOURCE);
const busy = ref('');
const error = ref('');
const search = ref('');
const page = ref(1);
const pageSize = 20;
const acknowledgedShrink = ref(false);
const fileInput = ref<HTMLInputElement | null>(null);
const editor = ref<MusicTrack | null>(null);
const editorTitle = ref('');
const editorError = ref('');
const editorRevision = ref(0);
const editorBase = ref<MusicSnapshot | null>(null);
const now = ref(Date.now());
let timer: ReturnType<typeof setInterval> | undefined;
const pending = computed(() => state.value?.pending);
const working = computed(() => pending.value?.snapshot || state.value?.snapshot || emptySnapshot());
const expired = computed(() => Boolean(pending.value && previewIsExpired(pending.value.createdAt, now.value)));
const stale = computed(() => Boolean(pending.value && pending.value.baseRevision !== state.value?.revision));
const filtered = computed(() => {
  const query = search.value.trim().toLocaleLowerCase();
  return working.value.tracks.filter(track => !query || `${track.title} ${track.artist} ${track.album}`.toLocaleLowerCase().includes(query));
});
const tracks = computed(() => filtered.value.slice((page.value - 1) * pageSize, page.value * pageSize));
const showEditor = computed({ get: () => Boolean(editor.value), set: value => { if (!value) editor.value = null; } });
const themeVars = computed(() => ({ '--music-card': theme.value.cardColor, '--music-soft': theme.value.actionColor, '--music-border': theme.value.dividerColor, '--music-muted': theme.value.textColor3, '--music-text': theme.value.textColor1, '--music-primary': theme.value.primaryColor }));
const diffs = computed(() => pending.value ? [
  { key: 'added', title: '新增', type: 'success' as const, items: pending.value.diff.added },
  { key: 'removed', title: '移除', type: 'error' as const, items: pending.value.diff.removed },
  { key: 'changed', title: '修改', type: 'warning' as const, items: pending.value.diff.changed }
] : []);
watch(search, () => { page.value = 1; });
watch(() => pending.value?.token, () => { acknowledgedShrink.value = false; page.value = 1; });
watch(() => filtered.value.length, count => { page.value = Math.max(1, Math.min(page.value, Math.ceil(count / pageSize))); });
function messageOf(caught: unknown) { return caught instanceof Error ? caught.message : '操作失败，请稍后重试'; }
function accept(next: MusicState) { state.value = next; now.value = Date.now(); }
async function refresh() {
  if (!canRead.value || busy.value) return;
  busy.value = 'refresh'; error.value = '';
  try {
    accept(await getMusicLibrary());
    if (state.value?.snapshot?.source.provider === 'tencent') source.value = state.value.snapshot.source.url || state.value.snapshot.source.id;
  } catch (caught) { error.value = messageOf(caught); }
  finally { busy.value = ''; }
}
async function mutate(action: string, request: () => Promise<MusicState>, success: string) {
  if (!canUpdate.value || !state.value || busy.value) return false;
  busy.value = action; error.value = '';
  try {
    const next = await request();
    accept(next);
    if (action === 'sync' && !next.pending) {
      error.value = next.lastError || '同步未生成预览，请重试';
      return false;
    }
    window.$message?.success(success);
    return true;
  }
  catch (caught) {
    error.value = `${messageOf(caught)}。如预览过期或数据已更新，请重新生成预览。`;
    // A failed sync still persists failure details, and another editor may have advanced the revision.
    try { accept(await getMusicLibrary()); } catch { /* Retain the last readable state. */ }
    return false;
  } finally { busy.value = ''; }
}
async function sync() {
  if (!state.value || !source.value.trim()) return;
  const revision = state.value.revision;
  await mutate('sync', () => previewMusicLibrary(source.value.trim(), revision), '已生成同步预览，请检查后确认更新');
}
async function previewSnapshot(snapshot: MusicSnapshot, revision: number) {
  const validated = parseSnapshot(JSON.stringify(snapshot));
  return mutate('import', () => importMusicLibrary(validated, revision), '预览已保存，确认更新后才会发布');
}
async function importFile(event: Event) {
  const input = event.target as HTMLInputElement;
  const file = input.files?.[0]; input.value = '';
  if (!file || !state.value || busy.value || !canUpdate.value) return;
  const revision = state.value.revision;
  try {
    if (file.size > MAX_IMPORT_BYTES) throw new Error('JSON 文件不能超过 1 MB');
    const snapshot = parseSnapshot(await file.text());
    await previewSnapshot(snapshot, revision);
  } catch (caught) { error.value = messageOf(caught); }
}
function exportSnapshot(snapshot: MusicSnapshot | null | undefined, suffix = '') {
  if (!snapshot || !canRead.value) return;
  const blob = new Blob([serializeSnapshot(snapshot)], { type: 'application/json;charset=utf-8' });
  const url = URL.createObjectURL(blob);
  const link = document.createElement('a'); link.href = url;
  link.download = `music-library${suffix}-${new Date().toISOString().slice(0, 10)}.json`;
  link.click(); setTimeout(() => URL.revokeObjectURL(url), 1000);
}
async function apply() {
  const preview = pending.value;
  if (!preview || !state.value || expired.value || stale.value || (preview.diff.suspicious && !acknowledgedShrink.value)) return;
  await mutate('apply', () => applyMusicLibrary(preview.token, preview.baseRevision), '音乐库已更新，前台将使用新歌单');
}
function edit(track?: MusicTrack) {
  if (!state.value || !canUpdate.value || busy.value || stale.value || expired.value) return;
  editorBase.value = JSON.parse(JSON.stringify(working.value));
  editorRevision.value = state.value.revision; editorTitle.value = working.value.title; editorError.value = '';
  editor.value = track ? { ...track } : { id: `manual:${crypto.randomUUID()}`, provider: 'manual', title: '', artist: '', album: '', cover: '', duration: 0, url: '', lyric: '', externalUrl: '' };
}
async function saveEditor() {
  if (!editor.value || !editorBase.value) return;
  try {
    const snapshot = updateTrack({ ...editorBase.value, title: editorTitle.value }, editor.value);
    if (await previewSnapshot(snapshot, editorRevision.value)) editor.value = null;
    else editorError.value = error.value || '预览未保存，请重试';
  } catch (caught) { editorError.value = messageOf(caught); }
}
async function remove(track: MusicTrack) {
  if (!state.value) return;
  try { await previewSnapshot(removeTrack(working.value, track.id), state.value.revision); }
  catch (caught) { error.value = messageOf(caught); }
}
function date(value?: string | null) { return value ? new Date(value).toLocaleString('zh-CN', { hour12: false }) : '尚未同步'; }
function duration(seconds: number) { return seconds ? `${Math.floor(seconds / 60)}:${String(Math.floor(seconds % 60)).padStart(2, '0')}` : '—'; }
function changedFields(track: MusicTrack) {
  const old = state.value?.snapshot?.tracks.find(item => item.id === track.id);
  if (!old) return '';
  const fields: [keyof MusicTrack, string][] = [['title', '名称'], ['artist', '歌手'], ['album', '专辑'], ['cover', '封面'], ['url', '音源'], ['lyric', '歌词'], ['duration', '时长'], ['externalUrl', '官方链接'], ['provider', '来源'], ['mid', '平台标识']];
  return fields.filter(([key]) => old[key] !== track[key]).map(([key, label]) => ['title', 'artist', 'album'].includes(key) ? `${label}：${old[key] || '空'} → ${track[key] || '空'}` : label).join(' · ');
}
onMounted(() => { refresh(); timer = setInterval(() => { now.value = Date.now(); }, 30000); });
onUnmounted(() => { if (timer) clearInterval(timer); });
</script>

<template>
  <div class="music-page" :style="themeVars">
    <header class="page-heading"><div class="heading-icon"><SvgIcon icon="lucide:disc-3" /></div><div><span class="eyebrow">MUSIC LIBRARY</span><h1>音乐馆</h1><p>从喜欢的歌单出发，让每一首收藏都有回响。</p></div><div style="margin-left: auto"><PageHeaderSettings :pages="['music']" /></div></header>
    <NTabs type="line" animated>
      <NTabPane name="library" tab="歌单音乐库">
        <div v-if="canRead" class="library-layout">
          <NAlert v-if="error" type="error" closable @close="error = ''">{{ error }}</NAlert>
          <section class="library-hero panel">
            <div class="hero-copy"><NTag size="small" round :bordered="false" type="primary">QQ 音乐 · 手动同步</NTag><h2>{{ state?.snapshot?.title || '把喜欢的歌，带进博客' }}</h2><p>先生成预览，核对变化，再发布到音乐馆。</p></div>
            <div class="hero-disc" aria-hidden="true"><SvgIcon icon="lucide:music-2" /></div>
            <div class="source-controls"><NInput v-model:value="source" aria-label="QQ 音乐歌单链接或 ID" placeholder="QQ 音乐歌单链接或 ID" :disabled="Boolean(busy) || !canUpdate" @keyup.enter="sync"><template #prefix><SvgIcon icon="lucide:link" /></template></NInput><NButton type="primary" :loading="busy === 'sync'" :disabled="!state || !canUpdate || Boolean(busy) || !source.trim()" @click="sync">生成同步预览</NButton></div>
            <p class="hero-note">支持 QQ 音乐公开歌单；每次同步都需要确认。新预览会替换当前待确认预览。</p>
          </section>
          <div class="status-grid">
            <div class="panel metric"><span>已发布曲目</span><strong>{{ state?.snapshot?.tracks.length ?? '—' }}<small> 首</small></strong></div>
            <div class="panel metric"><span>最近成功拉取</span><strong class="date-value">{{ date(state?.lastSuccessAt) }}</strong></div>
            <div class="panel metric"><span>连续同步失败</span><strong :class="{ 'error-value': state?.consecutiveFailures }">{{ state?.consecutiveFailures ?? '—' }}<small> 次</small></strong></div>
          </div>
          <NAlert v-if="state?.lastError" type="warning" title="上次同步未完成">{{ state.lastError }}<div class="attempt-note">尝试时间：{{ date(state.lastAttemptAt) }} · 已发布歌单继续保留。</div></NAlert>
          <section v-if="pending" class="panel preview-panel">
            <div class="section-heading"><div><span class="eyebrow">REVIEW & PUBLISH</span><h2>待确认的更新</h2><p>{{ pending.snapshot.title }} · {{ pending.snapshot.tracks.length }} 首 · {{ date(pending.createdAt) }} 生成，24 小时内有效</p></div><NTag :type="expired || stale ? 'error' : 'warning'" round>{{ expired ? '预览已过期' : stale ? '版本已变化' : '尚未发布' }}</NTag></div>
            <NAlert v-if="expired || stale" type="error" class="preview-notice">请重新同步或导入，生成新的预览后确认。</NAlert>
            <NAlert v-if="pending.diff.suspicious" type="warning" class="preview-notice" title="曲目数量大幅减少">请确认歌单是否完整。应用后将移除下列曲目，原歌单可通过「导出上一版」恢复。<div class="shrink-check"><NCheckbox v-model:checked="acknowledgedShrink" :disabled="Boolean(busy)">我已核对，确认此次大量移除</NCheckbox></div></NAlert>
            <NCollapse class="diff-collapse">
              <NCollapseItem v-for="group in diffs" :key="group.key" :name="group.key" :title="`${group.title} ${group.items.length} 首`">
                <div v-if="group.items.length" class="diff-list"><div v-for="track in group.items" :key="track.id" class="diff-row"><NTag :type="group.type" size="small" :bordered="false">{{ group.title }}</NTag><div><strong>{{ track.title }}</strong><span> · {{ track.artist || '未知歌手' }}</span><p v-if="group.key === 'changed'">{{ changedFields(track) }}</p></div></div></div><p v-else class="muted">没有{{ group.title }}的曲目</p>
              </NCollapseItem>
            </NCollapse>
            <div class="preview-footer"><span>确认后，博客音乐馆使用此版本。刷新页面不会丢失预览。</span><NButton type="primary" :loading="busy === 'apply'" :disabled="!canUpdate || Boolean(busy) || expired || stale || (pending.diff.suspicious && !acknowledgedShrink)" @click="apply">确认更新 {{ pending.snapshot.tracks.length }} 首</NButton></div>
          </section>
          <section class="panel tracks-panel">
            <div class="section-heading"><div><h2>{{ pending ? '预览曲目' : '已发布曲目' }} <span class="count-badge">{{ working.tracks.length }}</span></h2><p>{{ pending ? '编辑会在当前预览上继续修改，再次预览后统一发布。' : '补充音源、修正封面或添加自己的音乐。' }}</p></div><NButton secondary type="primary" :disabled="!state || !canUpdate || Boolean(busy) || expired || stale" @click="edit()"><template #icon><SvgIcon icon="lucide:plus" /></template>添加曲目</NButton></div>
            <div class="toolbar"><NInput v-model:value="search" clearable placeholder="搜索歌曲、歌手、专辑" aria-label="搜索曲目"><template #prefix><SvgIcon icon="lucide:search" /></template></NInput><div class="toolbar-actions"><NButton :disabled="!state || !canUpdate || Boolean(busy)" @click="fileInput?.click()">导入 JSON</NButton><NButton :disabled="!state?.snapshot || Boolean(busy)" @click="exportSnapshot(state?.snapshot)">导出当前</NButton><NButton v-if="state?.previousSnapshot" :disabled="Boolean(busy)" @click="exportSnapshot(state?.previousSnapshot, '-previous')">导出上一版</NButton><NButton :loading="busy === 'refresh'" :disabled="Boolean(busy)" aria-label="刷新音乐库" @click="refresh"><template #icon><SvgIcon icon="lucide:refresh-cw" /></template></NButton></div><input ref="fileInput" type="file" accept="application/json,.json" class="file-input" @change="importFile" /></div>
            <NSpin :show="busy === 'refresh'">
              <div v-if="tracks.length" class="track-list"><article v-for="(track, index) in tracks" :key="track.id" class="track-row"><span class="track-number">{{ (page - 1) * pageSize + index + 1 }}</span><NAvatar :src="safeMusicUrl(track.cover) ? track.cover : undefined" :size="44" :bordered="false" class="track-cover"><SvgIcon icon="lucide:music-2" /></NAvatar><div class="track-info"><strong>{{ track.title }}</strong><span>{{ track.artist || '未知歌手' }}<template v-if="track.album"> · {{ track.album }}</template></span></div><NTag :bordered="false" size="small" :type="track.provider === 'manual' ? 'info' : 'default'" class="provider-tag">{{ track.provider === 'manual' ? '手动' : 'QQ 音乐' }}</NTag><span class="track-duration">{{ duration(track.duration) }}</span><NButton text type="primary" :disabled="!canUpdate || Boolean(busy) || expired || stale" @click="edit(track)">编辑</NButton><NPopconfirm :disabled="!canUpdate || Boolean(busy) || expired || stale" @positive-click="remove(track)"><template #trigger><NButton quaternary circle size="small" :disabled="!canUpdate || Boolean(busy) || expired || stale" :aria-label="`移除 ${track.title}`"><template #icon><SvgIcon icon="lucide:trash-2" /></template></NButton></template>将「{{ track.title }}」移出预览；确认更新后生效。</NPopconfirm></article></div>
              <NEmpty v-else :description="search ? '没有找到匹配的曲目' : '音乐库还没有曲目，先同步歌单或添加一首吧'" class="empty-state" />
            </NSpin>
            <div class="table-footer"><span>JSON 导入上限 1 MB · 导入和编辑均需预览确认</span><NPagination v-if="filtered.length > pageSize" v-model:page="page" :page-size="pageSize" :item-count="filtered.length" :page-slot="5" /></div>
          </section>
        </div>
        <NResult v-else status="403" title="暂无音乐库查看权限" description="需要 blog:music:list 权限" />
      </NTabPane>
      <NTabPane name="manual" tab="手动音乐" display-directive="if"><NAlert type="info" style="margin-bottom: 16px">已发布且当前访客可访问的音乐会与歌单一起显示；草稿及未到发布时间的音乐不会显示。</NAlert><ContentManager kind="music" :show-page-settings="false" /></NTabPane>
    </NTabs>
    <NModal v-model:show="showEditor" preset="card" title="编辑曲目" class="music-editor" :mask-closable="!busy" :closable="!busy" :close-on-esc="!busy">
      <template v-if="editor"><NAlert type="info" class="editor-notice">保存后生成预览，确认更新后发布。下次 QQ 同步会按远端歌单重新生成，请导出备份保留手动修改。</NAlert><NAlert v-if="editorError" type="error" class="editor-notice">{{ editorError }}</NAlert><NForm label-placement="top" :disabled="Boolean(busy)"><NFormItem label="音乐馆标题"><NInput v-model:value="editorTitle" :maxlength="200" /></NFormItem><div class="editor-grid"><NFormItem label="歌曲名称" required><NInput v-model:value="editor.title" :maxlength="300" /></NFormItem><NFormItem label="歌手"><NInput v-model:value="editor.artist" :maxlength="500" /></NFormItem><NFormItem label="专辑"><NInput v-model:value="editor.album" :maxlength="300" /></NFormItem><NFormItem label="时长（秒）"><NInputNumber v-model:value="editor.duration" :min="0" :precision="0" :show-button="false" @update:value="value => { if (editor && value === null) editor.duration = 0; }" /></NFormItem></div><NFormItem label="封面链接"><NInput v-model:value="editor.cover" placeholder="https://…" /></NFormItem><NFormItem label="音源链接"><NInput v-model:value="editor.url" placeholder="https://…（留空时，QQ 曲目由平台解析）" /></NFormItem><NFormItem label="官方歌曲链接"><NInput v-model:value="editor.externalUrl" placeholder="https://…" /></NFormItem><NFormItem label="歌词（支持 LRC 时间标签）"><NInput v-model:value="editor.lyric" type="textarea" :autosize="{ minRows: 5, maxRows: 10 }" placeholder="[00:01.00]第一句歌词" /></NFormItem></NForm><div class="editor-id">{{ editor.provider === 'manual' ? '手动曲目' : 'QQ 音乐' }} · {{ editor.id }}</div></template>
      <template #footer><NSpace justify="end"><NButton :disabled="Boolean(busy)" @click="editor = null">取消</NButton><NButton type="primary" :loading="busy === 'import'" :disabled="!canUpdate || Boolean(busy) || !editor?.title.trim() || !editorTitle.trim()" @click="saveEditor">保存并生成预览</NButton></NSpace></template>
    </NModal>
  </div>
</template>

<style scoped>
.music-page{min-width:0;color:var(--music-text)}.page-heading{display:flex;align-items:center;gap:14px;margin:0 0 18px}.heading-icon{display:grid;place-items:center;width:48px;height:48px;border-radius:15px;background:color-mix(in srgb,var(--music-primary) 12%,transparent);color:var(--music-primary);font-size:25px}.eyebrow{font-size:11px;letter-spacing:.14em;font-weight:700;color:var(--music-primary)}h1,h2,p{margin:0}.page-heading h1{font-size:27px;font-weight:650;line-height:1.4}.page-heading p,.section-heading p{color:var(--music-muted);font-size:13px;margin-top:5px}.library-layout{display:grid;gap:18px;padding-top:6px}.panel{background:var(--music-card);border:1px solid var(--music-border);border-radius:14px;min-width:0;overflow:hidden}.library-hero{position:relative;padding:26px 28px;background:linear-gradient(115deg,color-mix(in srgb,var(--music-primary) 9%,var(--music-card)),var(--music-card) 80%)}.hero-copy{position:relative;z-index:1}.hero-copy h2{font-size:25px;font-weight:650;margin:10px 0 6px}.hero-copy p,.hero-note{color:var(--music-muted);font-size:13px}.hero-disc{position:absolute;right:55px;top:-45px;width:210px;height:210px;border-radius:50%;border:35px solid color-mix(in srgb,var(--music-primary) 5%,transparent);box-shadow:0 0 0 1px color-mix(in srgb,var(--music-primary) 9%,transparent);display:grid;place-items:center;color:color-mix(in srgb,var(--music-primary) 30%,transparent);font-size:42px;pointer-events:none}.source-controls{position:relative;z-index:1;display:flex;gap:10px;max-width:820px;margin-top:22px}.hero-note{margin-top:10px;font-size:12px}.status-grid{display:grid;grid-template-columns:1fr 1.6fr 1fr;gap:16px}.metric{padding:18px 22px;display:flex;flex-direction:column;gap:10px}.metric>span{font-size:12px;color:var(--music-muted)}.metric strong{font-size:29px;font-weight:650;font-variant-numeric:tabular-nums;line-height:1.4}.metric small{font-size:12px;font-weight:400;color:var(--music-muted)}.metric .date-value{font-size:16px;padding-top:10px}.error-value{color:#d66f43}.attempt-note{margin-top:5px;font-size:12px}.section-heading{display:flex;justify-content:space-between;align-items:center;gap:15px;padding:20px 22px}.section-heading h2{font-size:18px;font-weight:650}.preview-panel{border-color:color-mix(in srgb,var(--music-primary) 30%,var(--music-border))}.preview-notice{margin:0 22px 16px}.shrink-check{margin-top:10px}.diff-collapse{padding:0 22px 20px}.diff-list{max-height:300px;overflow:auto}.diff-row{display:flex;align-items:flex-start;gap:10px;padding:9px 0;border-bottom:1px solid var(--music-border);overflow-wrap:anywhere}.diff-row strong{font-weight:500}.diff-row span,.diff-row p{font-size:12px;color:var(--music-muted)}.diff-row p{margin-top:4px}.preview-footer{display:flex;align-items:center;justify-content:space-between;gap:16px;background:var(--music-soft);padding:16px 22px}.preview-footer>span,.muted{font-size:12px;color:var(--music-muted)}.count-badge{font-size:12px;vertical-align:middle;background:var(--music-soft);border-radius:10px;padding:3px 8px;margin-left:5px;color:var(--music-muted)}.toolbar{display:flex;justify-content:space-between;gap:12px;padding:0 22px 18px}.toolbar>.n-input{max-width:320px}.toolbar-actions{display:flex;gap:8px;flex-wrap:wrap}.file-input{display:none}.track-row{display:flex;align-items:center;gap:14px;padding:12px 22px;border-top:1px solid var(--music-border);transition:background .2s}.track-row:hover{background:var(--music-soft)}.track-number{width:24px;flex:none;font-size:12px;color:var(--music-muted);font-variant-numeric:tabular-nums}.track-cover{flex:none;border-radius:8px}.track-info{display:flex;flex:1;min-width:0;flex-direction:column;gap:4px}.track-info strong{font-size:14px;font-weight:550;overflow:hidden;text-overflow:ellipsis;white-space:nowrap}.track-info>span{font-size:12px;color:var(--music-muted);overflow:hidden;text-overflow:ellipsis;white-space:nowrap}.track-duration{width:45px;color:var(--music-muted);font-size:12px;text-align:right;font-variant-numeric:tabular-nums}.empty-state{padding:60px 20px}.table-footer{display:flex;justify-content:space-between;align-items:center;gap:12px;padding:15px 22px;border-top:1px solid var(--music-border)}.table-footer>span{font-size:12px;color:var(--music-muted)}.music-editor{width:min(660px,calc(100vw - 28px))}.editor-grid{display:grid;grid-template-columns:1fr 1fr;gap:0 15px}.editor-grid .n-input-number{width:100%}.editor-notice{margin-bottom:18px}.editor-id{color:var(--music-muted);font-size:12px;overflow-wrap:anywhere}
@media(max-width:800px){.toolbar{flex-direction:column}.toolbar>.n-input{max-width:none}.hero-disc{right:-70px}.status-grid{gap:10px}.metric{padding:16px}.section-heading{padding:18px}.track-row{padding:12px 16px;gap:10px}.provider-tag{display:none}}
@media(max-width:560px){.library-hero{padding:22px 18px}.source-controls{flex-direction:column}.hero-copy h2{font-size:22px}.status-grid{grid-template-columns:1fr 1fr}.metric:nth-child(2){grid-column:1/-1;grid-row:2}.metric .date-value{padding-top:0}.preview-footer,.table-footer{align-items:stretch;flex-direction:column}.preview-notice{margin-left:16px;margin-right:16px}.section-heading{align-items:flex-start}.track-number,.track-duration{display:none}.track-row{gap:9px}.editor-grid{grid-template-columns:1fr}.page-heading h1{font-size:24px}.toolbar{padding:0 16px 16px}.diff-collapse{padding-left:16px;padding-right:16px}.section-heading p{max-width:230px}}
</style>
