<script setup lang="ts">
import { onBeforeUnmount, ref, watch } from 'vue';
import { mediaUrl } from '@/service/api/blog';
const props = defineProps<{ src: string; video?: boolean; title: string }>();
const preview = ref('');
const error = ref(false);
let generation = 0;
function release() {
  if (preview.value.startsWith('blob:')) URL.revokeObjectURL(preview.value);
  preview.value = '';
}
watch(() => props.src, async src => {
  const current = ++generation;
  release(); error.value = false;
  if (!src) return;
  try {
    const url = await mediaUrl(src);
    if (current === generation) preview.value = url;
    else if (url.startsWith('blob:')) URL.revokeObjectURL(url);
  } catch { if (current === generation) error.value = true; }
}, { immediate: true });
onBeforeUnmount(() => { generation += 1; release(); });
</script>
<template>
  <div class="album-media-preview">
    <video v-if="preview && video" :src="preview" controls preload="metadata" :aria-label="title" />
    <NImage v-else-if="preview" :src="preview" :alt="title" object-fit="contain" />
    <span v-else>{{ error ? '预览加载失败' : '加载预览…' }}</span>
  </div>
</template>
<style scoped>
.album-media-preview { height: 180px; display: flex; align-items: center; justify-content: center; background: var(--manager-soft); border-radius: 8px; overflow: hidden; }
.album-media-preview video, .album-media-preview :deep(img) { width: 100%; height: 180px; object-fit: contain; }
.album-media-preview :deep(.n-image) { width: 100%; }
</style>
