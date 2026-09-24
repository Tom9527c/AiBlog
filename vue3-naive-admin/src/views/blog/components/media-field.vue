<script setup lang="ts">
import { onBeforeUnmount, ref, watch } from 'vue';
import { mediaUrl, upload } from '@/service/api/blog';
const model = defineModel<string>({ default: '' });
const props = defineProps<{ label?: string; audio?: boolean }>();
const emit = defineEmits<{ busy: [value: boolean] }>();
const preview = ref('');
const fileInput = ref<HTMLInputElement>();
const busy = ref(false);
const error = ref('');
let generation = 0;
function release() {
  if (preview.value.startsWith('blob:')) URL.revokeObjectURL(preview.value);
  preview.value = '';
}
watch(
  model,
  async value => {
    generation += 1;
    const current = generation;
    release();
    error.value = '';
    if (!value) return;
    try {
      const url = await mediaUrl(value);
      if (current === generation) preview.value = url;
      else if (url.startsWith('blob:')) URL.revokeObjectURL(url);
    } catch {
      error.value = '预览不可用（请检查媒体权限）';
    }
  },
  { immediate: true }
);
onBeforeUnmount(() => {
  generation += 1;
  release();
});
async function pick(event: Event) {
  const input = event.target as HTMLInputElement;
  const file = input.files?.[0];
  if (!file) return;
  busy.value = true; emit('busy', true);
  try {
    model.value = (await upload(file)).url;
  } catch {
    error.value = '上传失败';
  } finally {
    busy.value = false; emit('busy', false);
    input.value = '';
  }
}
</script>

<template>
  <div class="media-field">
    <div class="media-field__controls">
      <NInput v-model:value="model" :placeholder="props.label || '输入媒体地址，或上传文件'" />
      <NButton :loading="busy" secondary @click="fileInput?.click()">
        {{ audio ? '上传音频' : '上传图片' }}
      </NButton>
      <input ref="fileInput" class="media-field__file" type="file" :disabled="busy" @change="pick" />
    </div>
    <NText depth="3" class="media-field__hint">开启“受限内容媒体校验”后，受限内容须使用上传文件；可在站点设置中开关，默认关闭。</NText>
    <NText v-if="error" type="error" class="media-field__hint" role="alert">{{ error }}</NText>
    <audio v-if="preview && audio" :src="preview" controls />
    <img v-else-if="preview" :src="preview" alt="媒体预览" class="media-field__preview" />
  </div>
</template>

<style scoped>
.media-field {
  display: grid;
  width: 100%;
  min-width: 0;
  gap: 6px;
}
.media-field__controls {
  display: flex;
  min-width: 0;
  align-items: center;
  gap: 10px;
}
.media-field__controls > .n-input {
  min-width: 0;
  flex: 1;
}
.media-field__file {
  display: none;
}
.media-field__hint {
  font-size: 12px;
  line-height: 18px;
}
.media-field__preview {
  max-height: 120px;
  max-width: 100%;
  object-fit: contain;
}
.media-field audio {
  max-width: 100%;
}
</style>
