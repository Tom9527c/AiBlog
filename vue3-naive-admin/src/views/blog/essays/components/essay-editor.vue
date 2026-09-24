<script setup lang="ts">
import { computed, ref } from 'vue';
import { type Content, api } from '@/service/api/blog';
import EssayMedia from './essay-media.vue';
import MediaField from '../../components/media-field.vue';
import BodyEditor from '../../components/body-editor.vue';
const props = defineProps<{ item: Content }>();
const emit = defineEmits<{ saved: []; cancel: [] }>();
const form = ref<Content>(JSON.parse(JSON.stringify(props.item)));
form.value.metadata = { ...form.value.metadata, media: form.value.metadata.media || [], tags: form.value.metadata.tags || [] };
const busy = ref(false);
const uploading = ref(false);
const legacyUploading = ref(false);
const error = ref('');
const occurredAt = computed({ get: () => form.value.metadata.occurredAt ? Date.parse(form.value.metadata.occurredAt) : null, set: (v: number | null) => { form.value.metadata.occurredAt = v === null ? '' : new Date(v).toISOString(); } });
const publishedAt = computed({ get: () => form.value.publishedAt ? Date.parse(form.value.publishedAt) : null, set: (v: number | null) => { form.value.publishedAt = v === null ? null : new Date(v).toISOString(); } });
const pinned = computed({ get: () => form.value.sort > 0, set: (v: boolean) => { form.value.sort = v ? Math.max(1, form.value.sort) : 0; } });
async function save(status: 'draft' | 'published') {
  if (!form.value.body.trim() && !form.value.title.trim() && !form.value.metadata.media.length && !form.value.cover && !form.value.url) { error.value = '写点什么，或添加媒体后再保存'; return; }
  busy.value = true; error.value = '';
  try {
    const { id, ...payload } = form.value;
    payload.status = status;
    payload.title = (payload.title || payload.body.replace(/<[^>]*>/g, '').trim() || payload.metadata.media[0]?.title || '一则短文').slice(0, 200);
    if (!id) payload.summary = payload.body.replace(/<[^>]*>/g, '').slice(0, 2000) || payload.summary;
    if (!payload.slug) delete (payload as Partial<Content>).slug;
    await api(`content/essays${id ? `/${id}` : ''}`, id ? 'put' : 'post', payload);
    window.$message?.success(status === 'draft' ? '已保存草稿' : publishedAt.value && publishedAt.value > Date.now() ? '已安排定时发布' : '已发布');
    emit('saved');
  } catch (e) { error.value = (e as Error).message; }
  finally { busy.value = false; }
}
</script>
<template>
  <div class="essay-editor">
    <NAlert v-if="error" type="error">{{ error }}</NAlert>
    <NInput v-if="form.format !== 'html'" v-model:value="form.body" type="textarea" placeholder="记录此刻的想法…（支持 Markdown，无需标题）" :autosize="{ minRows: 6, maxRows: 18 }" />
    <BodyEditor v-else v-model="form.body" format="html" />
    <EssayMedia v-model="form.metadata.media" @busy="uploading = $event" />
    <NDivider />
    <NForm label-placement="top">
      <div class="essay-fields">
        <NFormItem label="记录时间"><NDatePicker v-model:value="occurredAt" type="datetime" clearable placeholder="默认使用发布时间" /></NFormItem>
        <NFormItem label="地点"><NInput v-model:value="form.metadata.location" placeholder="例如：深圳 · 杨梅坑（选填）" maxlength="200" /></NFormItem>
        <NFormItem label="心情（选填）"><NSelect v-model:value="form.metadata.mood" clearable filterable tag :options="['开心 😊','平静 😌','期待 ✨','感动 🥹','疲惫 😴','低落 🌧️'].map(value => ({ label: value, value }))" placeholder="选择或输入心情" /></NFormItem>
        <NFormItem label="天气（选填）"><NSelect v-model:value="form.metadata.weather" clearable filterable tag :options="['晴 ☀️','多云 ⛅','阴 ☁️','小雨 🌦️','雨 🌧️','雪 ❄️','有风 🍃'].map(value => ({ label: value, value }))" placeholder="选择或输入天气" /></NFormItem>
        <NFormItem label="标签"><NDynamicTags v-model:value="form.metadata.tags" :max="10" /></NFormItem>
        <NFormItem label="来源（选填）"><NInput v-model:value="form.metadata.source" placeholder="例如：旅行随记" /></NFormItem>
        <NFormItem label="发布时间"><NDatePicker v-model:value="publishedAt" type="datetime" clearable placeholder="留空立即发布，选未来时间定时发布" /></NFormItem>
        <NFormItem label="可见范围"><NSelect v-model:value="form.accessMode" :options="[{label:'公开',value:'public'},{label:'登录可见',value:'login'},{label:'密码可见',value:'password'}]" /></NFormItem>
        <NFormItem v-if="form.accessMode === 'password'" label="访问密码"><NInput v-model:value="form.password" type="password" show-password-on="click" placeholder="已有密码留空则保留" /></NFormItem>
        <NFormItem label="置顶"><NSwitch v-model:value="pinned" /></NFormItem>
      </div>
      <NCollapse v-if="form.id"><NCollapseItem title="原有内容与高级设置" name="legacy">
        <NFormItem label="原有标题"><NInput v-model:value="form.title" /></NFormItem>
        <NFormItem label="原有摘要"><NInput v-model:value="form.summary" type="textarea" /></NFormItem>
        <NFormItem label="原有封面"><MediaField v-model="form.cover" @busy="legacyUploading = $event" /></NFormItem>
        <NFormItem label="原有链接"><NInput v-model:value="form.url" /></NFormItem>
      </NCollapseItem></NCollapse>
    </NForm>
    <div class="essay-actions">
      <NButton :disabled="busy || uploading || legacyUploading" @click="emit('cancel')">取消</NButton>
      <NButton :loading="busy" :disabled="uploading || legacyUploading" @click="save('draft')">保存草稿</NButton>
      <NButton type="primary" :loading="busy" :disabled="uploading || legacyUploading" @click="save('published')">{{ publishedAt && publishedAt > Date.now() ? '定时发布' : '发布短文' }}</NButton>
    </div>
  </div>
</template>
<style scoped>
.essay-editor { display: grid; gap: 20px; }
.essay-editor :deep(.n-divider) { margin: 0; }
.essay-fields { display: grid; grid-template-columns: repeat(2,minmax(0,1fr)); gap: 0 20px; }
.essay-fields :deep(.n-date-picker) { width: 100%; }
.essay-actions { display: flex; gap: 12px; justify-content: flex-end; position: sticky; bottom: -24px; padding: 16px 0; background: var(--n-color); z-index: 2; }
@media(max-width:600px) { .essay-fields { grid-template-columns: 1fr; } }
</style>
