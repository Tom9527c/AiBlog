<script setup lang="ts">
import { computed, ref, watch } from 'vue';
import { type PageHeaderKey, type PageHeaderSettings, type Site, api } from '@/service/api/blog';
import { useBlogAuth } from '@/hooks/business/blog-auth';
import MediaField from './media-field.vue';
const props = defineProps<{ pages?: PageHeaderKey[] }>();
const { hasAuth } = useBlogAuth();
const canEdit = computed(() => hasAuth('blog:site:list') && hasAuth('blog:site:update'));
const labels: Record<PageHeaderKey,string> = {archives:'文章归档',articles:'文章详情',categories:'分类',tags:'标签',albums:'相册集',bangumis:'追番列表',essays:'即刻短文',links:'友人帐',collections:'藏宝阁',music:'音乐馆',comments:'留言板',notFound:'404 页面'};
const choices = computed(() => (props.pages || Object.keys(labels) as PageHeaderKey[]).map(value => ({label:labels[value],value})));
const selected = ref<PageHeaderKey>(props.pages?.[0] || 'archives');
const visible = ref(false);
const loading = ref(false);
const saving = ref(false);
const uploading = ref(false);
const error = ref('');
const drafts = ref<Partial<Record<PageHeaderKey,PageHeaderSettings>>>({});
const form = computed(() => drafts.value[selected.value]);
function defaults(site: Site, key: PageHeaderKey): PageHeaderSettings {
  return {enabled:true,title:key === 'essays' ? site.essayTitle ?? '咸鱼的日常生活。' : '',subtitle:key === 'essays' ? site.essaySubtitle ?? '随时随地，分享生活' : key === 'collections' ? '包含 影视/小说/游戏/音乐 等 持续更新中...' : '',cover:key === 'essays' ? site.essayCover || '' : '',...site.pageHeaders?.[key]};
}
async function open() {
  visible.value = true; loading.value = true; error.value = '';
  selected.value = choices.value[0].value;
  try { const site = await api<Site>('site'); drafts.value = Object.fromEntries(choices.value.map(({value}) => [value,defaults(site,value)])); }
  catch (e) { error.value = (e as Error).message; }
  finally { loading.value = false; }
}
async function save() {
  if (!form.value || uploading.value || saving.value) return;
  saving.value = true; error.value = '';
  try {
    await api('site','put',{pageHeaders:{[selected.value]:form.value}});
    window.$message?.success(`${labels[selected.value]}头部设置已保存`);
    visible.value = false;
  } catch(e) { error.value = (e as Error).message; }
  finally { saving.value = false; }
}
watch(() => props.pages, () => { if (!visible.value) selected.value = choices.value[0].value; });
</script>
<template>
  <NButton v-if="canEdit" @click="open">页面设置</NButton>
  <NModal :show="visible" preset="card" :title="`${labels[selected]} · 页面设置`" class="page-header-settings-modal" :mask-closable="!saving && !uploading" :closable="!saving && !uploading" @update:show="value => { if (!saving && !uploading) visible = value; }">
    <NSpin :show="loading">
      <NAlert v-if="error" type="error" style="margin-bottom: 16px">{{ error }}</NAlert>
      <NForm v-if="form" label-placement="top" :disabled="saving">
        <NFormItem v-if="choices.length > 1" label="配置页面"><NSelect v-model:value="selected" :options="choices" :disabled="uploading" /></NFormItem>
        <NFormItem label="启用封面头部"><NSwitch v-model:value="form.enabled" /><NText depth="3" style="margin-left: 12px">{{ selected === 'music' ? '开启后显示与追番列表一致的封面头部；关闭后保留全屏音乐馆。播放器背景始终跟随歌曲封面' : '关闭后只显示普通页面标题' }}</NText></NFormItem>
        <NFormItem label="封面标题"><NInput v-model:value="form.title" maxlength="2000" placeholder="留空使用页面标题；详情页保留内容标题" /></NFormItem>
        <NFormItem label="封面描述"><NInput v-model:value="form.subtitle" maxlength="2000" placeholder="选填" /></NFormItem>
        <NFormItem :label="selected === 'music' ? '页头背景图（留空使用站点封面）' : '页头背景图（留空使用内容封面或站点封面）'"><MediaField :key="selected" v-model="form.cover" @busy="uploading = $event" /></NFormItem>
        <NButton type="primary" :loading="saving" :disabled="uploading" @click="save">保存页面设置</NButton>
      </NForm>
      <NButton v-else-if="!loading" @click="open">重新加载</NButton>
    </NSpin>
  </NModal>
</template>
<style>
.page-header-settings-modal { width: min(680px,calc(100vw - 32px)); margin: 32px auto; }
</style>
