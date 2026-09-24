<script setup lang="ts">
import { onMounted, ref, watch } from 'vue';
import { type Content, api, list } from '@/service/api/blog';
import { useBlogAuth } from '@/hooks/business/blog-auth';
import EssayEditor from './components/essay-editor.vue';
import PageHeaderSettings from '../components/page-header-settings.vue';
defineOptions({ name: 'blog_essays' });
const { hasAuth } = useBlogAuth();
const can = (action: string) => hasAuth(`blog:essays:${action}`);
const rows = ref<Content[]>([]);
const total = ref(0);
const page = ref(1);
const keyword = ref('');
const status = ref<string | null>(null);
const busy = ref(false);
const error = ref('');
const current = ref<Content | null>(null);
let generation = 0;
async function load() {
  const run = ++generation;
  busy.value = true; error.value = '';
  try {
    const data = await list('essays', {page:page.value,pageSize:12,keyword:keyword.value,...(status.value ? {status:status.value}: {})});
    if (run === generation) { rows.value = data.items; total.value = data.total; }
  } catch(e) { if (run === generation) error.value = (e as Error).message; }
  finally { if (run === generation) busy.value = false; }
}
function create() {
  current.value = {id:0,title:'',slug:'',summary:'',body:'',format:'markdown',cover:'',url:'',groupName:'',sort:0,status:'draft',accessMode:'public',parentId:null,categoryId:null,tagIds:[],publishedAt:null,metadata:{media:[],tags:[]}};
}
async function edit(row: Content) {
  try { current.value = await api<Content>(`content/essays/${row.id}`); }
  catch(e) { error.value = (e as Error).message; }
}
async function remove(row: Content) {
  try { await api(`content/essays/${row.id}`, 'delete'); if (rows.value.length === 1 && page.value > 1) page.value -= 1; else await load(); }
  catch(e) { error.value = (e as Error).message; }
}
function saved() { current.value = null; load(); }
function search() { if (page.value === 1) load(); else page.value = 1; }
function label(row: Content) { return row.status === 'draft' ? '草稿' : row.publishedAt && Date.parse(row.publishedAt) > Date.now() ? '待定时发布' : '已发布'; }
watch(page, load);
onMounted(load);
</script>
<template>
  <div class="essay-manager">
    <header class="essay-heading">
      <div><h1>即刻短文</h1><NText depth="3">随时记录想法，用图片、动图、视频和音乐分享生活。</NText></div>
      <NSpace>
        <PageHeaderSettings :pages="['essays']" />
        <NButton v-if="can('create')" type="primary" @click="create">写短文</NButton>
      </NSpace>
    </header>
    <NCard :bordered="false">
      <div class="essay-filter">
        <NInput v-model:value="keyword" clearable placeholder="搜索短文内容" @keydown.enter="search" />
        <NSelect v-model:value="status" clearable placeholder="全部状态" :options="[{label:'草稿',value:'draft'},{label:'已发布 / 定时发布',value:'published'}]" @update:value="search" />
        <NButton @click="search">搜索</NButton>
        <NButton :loading="busy" @click="load">刷新</NButton>
      </div>
    </NCard>
    <NAlert v-if="error" type="error">{{ error }}</NAlert>
    <NSpin :show="busy">
      <div v-if="rows.length" class="essay-list">
        <NCard v-for="row in rows" :key="row.id" class="essay-card" :bordered="false">
          <NSpace size="small"><NTag size="small" :type="row.status === 'draft' ? 'warning' : 'success'">{{ label(row) }}</NTag><NTag v-if="row.sort > 0" size="small" type="info">置顶</NTag><NTag v-if="row.accessMode !== 'public'" size="small">{{ row.accessMode === 'login' ? '登录可见' : '密码可见' }}</NTag></NSpace>
          <p class="essay-excerpt">{{ row.summary || row.title }}</p>
          <NText depth="3">{{ row.metadata.media?.length || (row.cover ? 1 : 0) }} 项媒体</NText>
          <div class="essay-meta"><span>{{ new Date(row.metadata.occurredAt || row.publishedAt || Date.now()).toLocaleString('zh-CN') }}</span><span v-if="row.metadata.mood">{{ row.metadata.mood }}</span><span v-if="row.metadata.weather">{{ row.metadata.weather }}</span><span v-if="row.metadata.location">⌖ {{ row.metadata.location }}</span></div>
          <NSpace><NTag v-for="tag in row.metadata.tags || []" :key="tag" size="small" :bordered="false"># {{ tag }}</NTag></NSpace>
          <template #footer><NSpace justify="end"><NButton v-if="can('update')" secondary @click="edit(row)">编辑</NButton><NPopconfirm v-if="can('delete')" @positive-click="remove(row)"><template #trigger><NButton quaternary type="error">删除</NButton></template>确定删除这条短文？</NPopconfirm></NSpace></template>
        </NCard>
      </div>
      <NEmpty v-else-if="!busy" description="还没有短文，记录你的第一个瞬间吧" />
    </NSpin>
    <NPagination v-if="total > 12" v-model:page="page" :item-count="total" :page-size="12" />
    <NModal :show="!!current" preset="card" :title="current?.id ? '编辑短文' : '写一条即刻短文'" class="essay-modal" :mask-closable="false" @update:show="value => { if (!value) current = null; }">
      <EssayEditor v-if="current" :key="current.id" :item="current" @saved="saved" @cancel="current = null" />
    </NModal>

  </div>
</template>
<style scoped>
.essay-manager { display: grid; gap: 20px; padding: 20px; }
.essay-heading { display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 16px; }
.essay-heading h1 { font-size: 26px; font-weight: 700; margin: 0 0 8px; }
.essay-filter { display: flex; gap: 12px; flex-wrap: wrap; }
.essay-filter > .n-input { flex: 1; min-width: 180px; }
.essay-filter > .n-select { width: 220px; }
.essay-list { display: grid; grid-template-columns: repeat(auto-fill,minmax(min(100%,300px),1fr)); gap: 18px; }
.essay-card { border-radius: 16px; }
.essay-excerpt { margin: 18px 0; white-space: pre-wrap; overflow-wrap: anywhere; display: -webkit-box; -webkit-line-clamp: 5; -webkit-box-orient: vertical; overflow: hidden; min-height: 88px; line-height: 1.75; }
.essay-meta { display: flex; flex-wrap: wrap; gap: 8px; font-size: 12px; opacity: .65; margin: 12px 0; }
</style>
<style>
.essay-modal { width: min(920px,calc(100vw - 32px)); margin: 30px auto; }
.essay-settings-modal { width: min(680px,calc(100vw - 32px)); }
</style>
