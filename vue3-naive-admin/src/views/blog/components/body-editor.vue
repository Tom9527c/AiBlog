<script setup lang="ts">
import { onBeforeUnmount, onMounted, ref, watch } from 'vue';
import Vditor from 'vditor';
import 'vditor/dist/index.css';
import Tinymce from '@/components/common/tinymce/index.vue';
import { mediaUrl } from '@/service/api/blog';
const model = defineModel<string>({ default: '' });
const props = defineProps<{ format: string }>();
const host = ref<HTMLElement>();
const html = ref('');
const ready = ref(false);
let editor: Vditor | undefined;
let disposed = false;
let revision = 0;
const blobs = new Map<string, string>();
async function hydrate(value: string) {
  revision += 1;
  const current = revision;
  for (const match of value.matchAll(/\/blog-media\/\d+/g)) {
    if (!blobs.has(match[0])) {
      try {
        // eslint-disable-next-line no-await-in-loop
        const url = await mediaUrl(match[0]);
        if (disposed) {
          URL.revokeObjectURL(url);
          return;
        }
        blobs.set(match[0], url);
      } catch {
        blobs.set(match[0], `data:,#${match[0].split('/').pop()}`);
      }
    }
  }
  if (current !== revision || disposed) return;
  html.value = value.replace(/\/blog-media\/\d+/g, path => blobs.get(path) || 'data:,');
  ready.value = true;
}
function changeHtml(value: string) {
  let restored = value;
  for (const [path, url] of blobs) restored = restored.split(url).join(path);
  model.value = restored;
}
onMounted(() => {
  if (props.format === 'markdown' && host.value)
    editor = new Vditor(host.value, {
      cdn: `${import.meta.env.BASE_URL}vendor/vditor`,
      height: 420,
      mode: 'sv',
      preview: { mode: 'editor' },
      cache: { enable: false },
      value: model.value,
      input: value => {
        model.value = value;
      },
      toolbar: [
        'headings',
        'bold',
        'italic',
        'strike',
        'link',
        'list',
        'ordered-list',
        'check',
        'quote',
        'code',
        'inline-code',
        'table',
        'undo',
        'redo'
      ],
      after: () => editor?.setValue(model.value)
    });
});
watch(
  model,
  value => {
    if (props.format === 'html') hydrate(value);
    else if (editor && editor.getValue() !== value) editor.setValue(value);
  },
  { immediate: true }
);
onBeforeUnmount(() => {
  disposed = true;
  editor?.destroy();
  for (const url of blobs.values()) if (url.startsWith('blob:')) URL.revokeObjectURL(url);
});
</script>

<template>
  <!-- Keep editor-managed DOM inside a stable Vue-owned root during format switches. -->
  <div class="body-editor">
    <Tinymce
      v-if="format === 'html' && ready"
      :value="html"
      :height="420"
      :init="{ convert_urls: false }"
      @update:value="changeHtml"
    />
    <div v-else-if="format === 'markdown'" ref="host" />
    <NSpin v-else />
  </div>
</template>

<style scoped>
.body-editor {
  width: 100%;
  min-width: 0;
}
</style>
