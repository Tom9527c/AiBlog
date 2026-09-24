<script setup lang="ts">
import { onBeforeUnmount, watch, ref } from 'vue';
import { getServiceBaseURL } from '@/utils/service';
import { getAuthorization } from '@/service/request/shared';
const props = defineProps<{ file: Api.ToolsManage.StorageLocal | null }>();
const emit = defineEmits<{ close: [] }>();
const url = ref('');
const busy = ref(false);
const error = ref('');
let controller: AbortController | undefined;
function clear() {
  controller?.abort();
  if (url.value) URL.revokeObjectURL(url.value);
  url.value = '';
}
watch(() => props.file, async file => {
  clear();
  error.value = '';
  if (!file) return;
  const current = new AbortController();
  controller = current;
  busy.value = true;
  try {
    const { baseURL } = getServiceBaseURL(import.meta.env, import.meta.env.DEV && import.meta.env.VITE_HTTP_PROXY === 'Y');
    const response = await fetch(`${baseURL}/tools/storage/${file.id}/preview`, {
      signal: current.signal, headers: { Authorization: getAuthorization() || '' }
    });
    if (!response.ok) throw new Error('预览失败，请检查文件或访问权限');
    const blob = await response.blob();
    if (!current.signal.aborted) url.value = URL.createObjectURL(blob);
  } catch (cause) {
    if (!current.signal.aborted) error.value = cause instanceof Error ? cause.message : '预览失败';
  } finally {
    if (!current.signal.aborted) busy.value = false;
  }
}, { immediate: true });
onBeforeUnmount(clear);
</script>

<template>
  <NModal :show="Boolean(file)" preset="card" :title="file?.name" style="width: min(900px, 90vw)" @update:show="emit('close')">
    <NSpin :show="busy">
      <NAlert v-if="error" type="error">{{ error }}</NAlert>
      <template v-else-if="url">
        <NImage v-if="file?.type === 'image'" :src="url" :img-props="{ style: 'max-height: 70vh; max-width: 100%' }" />
        <video v-else-if="file?.type === 'video'" :src="url" controls style="max-width: 100%; max-height: 70vh" />
        <audio v-else-if="file?.type === 'music'" :src="url" controls />
        <a v-else :href="url" :download="file?.name">下载文件</a>
      </template>
      <div v-else class="min-h-100px" />
    </NSpin>
  </NModal>
</template>
