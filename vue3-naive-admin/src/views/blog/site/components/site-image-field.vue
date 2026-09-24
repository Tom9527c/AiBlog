<script setup lang="ts">
import { onBeforeUnmount, ref, watch } from 'vue';
import { mediaUrl, upload } from '@/service/api/blog';

const model = defineModel<string>({ default: '' });
const mediaType = defineModel<'image' | 'video'>('mediaType', { default: 'image' });
const props = withDefaults(
  defineProps<{ label: string; wide?: boolean; disabled?: boolean; maxlength?: number; allowVideo?: boolean }>(),
  {
    maxlength: 5000
  }
);
const emit = defineEmits<{ uploading: [active: boolean] }>();
const input = ref<HTMLInputElement>();
const preview = ref('');
const busy = ref(false);
const error = ref('');
const previewFailed = ref(false);
let generation = 0;
let disposed = false;
function release() {
  if (preview.value.startsWith('blob:')) URL.revokeObjectURL(preview.value);
  preview.value = '';
}
watch(
  [model, mediaType],
  async ([value]) => {
    generation += 1;
    const current = generation;
    release();
    previewFailed.value = false;
    error.value = '';
    if (!value) return;
    try {
      const url = await mediaUrl(value);
      if (current === generation) preview.value = url;
      else if (url.startsWith('blob:')) URL.revokeObjectURL(url);
    } catch {
      if (current === generation) previewFailed.value = true;
    }
  },
  { immediate: true }
);
async function pick(event: Event) {
  const target = event.target as HTMLInputElement;
  const file = target.files?.[0];
  target.value = '';
  if (!file || busy.value || props.disabled) return;
  error.value = '';
  const video = props.allowVideo && file.type === 'video/mp4';
  if (!video && !['image/jpeg', 'image/png', 'image/gif', 'image/webp', 'image/avif'].includes(file.type)) {
    error.value = props.allowVideo ? '请选择图片或 MP4 视频。' : '请选择 JPG、PNG、GIF、WebP 或 AVIF 图片。';
    return;
  }
  if (!file.size || file.size > 25 * 1024 * 1024) {
    error.value = '文件不能为空，且不能超过 25 MB。';
    return;
  }
  busy.value = true;
  emit('uploading', true);
  try {
    const result = await upload(file);
    if (!disposed) {
      mediaType.value = video ? 'video' : 'image';
      model.value = result.url;
    }
  } catch {
    if (!disposed) error.value = '上传失败，原文件已保留，请重试。';
  } finally {
    if (!disposed) {
      busy.value = false;
      emit('uploading', false);
    }
  }
}
onBeforeUnmount(() => {
  disposed = true;
  generation += 1;
  release();
  if (busy.value) emit('uploading', false);
});
</script>

<template>
  <div class="image-field" :class="{ 'image-field--wide': wide }">
    <div class="image-preview" :class="{ 'image-preview--empty': !preview || previewFailed }">
      <video
        v-if="preview && !previewFailed && allowVideo && mediaType === 'video'"
        :src="preview"
        controls
        muted
        playsinline
        preload="metadata"
        @error="previewFailed = true"
      />
      <img v-else-if="preview && !previewFailed" :src="preview" :alt="`${label}预览`" @error="previewFailed = true" />
      <div v-else class="image-placeholder">
        <SvgIcon icon="lucide:image" class="text-26px" />
        <span>{{ previewFailed ? '暂时无法预览' : allowVideo ? '添加素材' : '添加图片' }}</span>
      </div>
    </div>
    <div class="image-controls">
      <div class="image-actions">
        <NButton secondary :disabled="disabled" :loading="busy" @click="input?.click()">
          <template #icon><SvgIcon icon="lucide:upload" /></template>
          {{ allowVideo ? (model ? '替换素材' : '上传图片 / 视频') : model ? '替换图片' : '上传图片' }}
        </NButton>
        <NButton v-if="model" quaternary :disabled="disabled || busy" @click="model = ''">移除</NButton>
        <input
          ref="input"
          type="file"
          :accept="`image/jpeg,image/png,image/gif,image/webp,image/avif${allowVideo ? ',video/mp4' : ''}`"
          hidden
          :disabled="disabled || busy"
          :aria-label="`上传${label}`"
          @change="pick"
        />
      </div>
      <p class="image-hint">JPG、PNG、GIF、WebP、AVIF{{ allowVideo ? '、MP4（建议 H.264 编码）' : '' }} · 最大 25 MB</p>
      <NRadioGroup
        v-if="allowVideo"
        v-model:value="mediaType"
        :disabled="disabled || busy"
        size="small"
        :aria-label="`${label}类型`"
      >
        <NRadioButton value="image">图片 / 动图</NRadioButton>
        <NRadioButton value="video">MP4 视频</NRadioButton>
      </NRadioGroup>
      <p v-if="allowVideo" class="image-hint">上传自动识别类型；粘贴地址时请选对应类型。</p>
      <NInput
        v-model:value="model"
        size="small"
        :maxlength="maxlength"
        :disabled="disabled || busy"
        :input-props="{ 'aria-label': `${label}地址` }"
        :placeholder="allowVideo ? '或粘贴图片 / 视频地址 / 站内路径' : '或粘贴图片地址 / 站内路径'"
      />
      <p v-if="error" class="image-error" role="alert">{{ error }}</p>
      <p v-else-if="previewFailed" class="image-hint" role="status">请检查文件地址或访问权限，也可以重新上传。</p>
    </div>
  </div>
</template>

<style scoped>
.image-field {
  display: flex;
  align-items: center;
  gap: 18px;
  min-width: 0;
}
.image-preview {
  width: 100px;
  height: 100px;
  flex-shrink: 0;
  overflow: hidden;
  border: 1px solid var(--site-border);
  border-radius: 12px;
  background: var(--site-soft);
}
.image-preview img,
.image-preview video {
  width: 100%;
  height: 100%;
  object-fit: contain;
}
.image-preview--empty {
  border-style: dashed;
}
.image-placeholder {
  display: flex;
  height: 100%;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 8px;
  color: var(--site-muted);
  font-size: 12px;
}
.image-controls {
  flex: 1;
  min-width: 0;
}
.image-actions {
  display: flex;
  align-items: center;
  gap: 8px;
}
.image-hint {
  margin: 9px 0;
  color: var(--site-muted);
  font-size: 12px;
  line-height: 1.6;
}
.image-error {
  margin: 8px 0 0;
  color: var(--site-error);
  font-size: 12px;
}
.image-field--wide {
  align-items: stretch;
  flex-direction: column;
}
.image-field--wide .image-preview {
  width: 100%;
  height: 160px;
}
.image-field--wide .image-preview img,
.image-field--wide .image-preview video {
  object-fit: cover;
}
@media (max-width: 600px) {
  .image-field {
    align-items: stretch;
    flex-direction: column;
  }
  .image-field:not(.image-field--wide) .image-preview {
    width: 80px;
    height: 80px;
  }
}
</style>
