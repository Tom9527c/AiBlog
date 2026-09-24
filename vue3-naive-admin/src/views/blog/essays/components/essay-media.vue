<script setup lang="ts">
import { ref } from 'vue';
import { upload } from '@/service/api/blog';
import AlbumMediaPreview from '../../albums/components/album-media-preview.vue';
import MediaField from '../../components/media-field.vue';
export interface EssayMedia { type: 'image' | 'video' | 'audio' | 'link'; url: string; title?: string; artist?: string; poster?: string }
const model = defineModel<EssayMedia[]>({ default: () => [] });
const emit = defineEmits<{ busy: [value: boolean] }>();
const fileInput = ref<HTMLInputElement>();
const busy = ref(false);
const nestedBusy = ref(0);
const nested = (value: boolean) => { nestedBusy.value += value ? 1 : -1; emit('busy', busy.value || nestedBusy.value > 0); };
const error = ref('');
const url = ref('');
const type = ref<EssayMedia['type']>('image');
const types = [{label:'图片 / 动图',value:'image'},{label:'视频',value:'video'},{label:'音乐',value:'audio'},{label:'网页链接',value:'link'}];
function add() {
  if (!url.value.trim()) return;
  if (model.value.length >= 30) { error.value = '每条短文最多 30 项媒体'; return; }
  model.value = [...model.value, { type: type.value, url: url.value.trim(), title: '' }];
  url.value = '';
}
function move(index: number, delta: number) {
  const next = [...model.value];
  [next[index], next[index + delta]] = [next[index + delta], next[index]];
  model.value = next;
}
async function pick(event: Event) {
  const input = event.target as HTMLInputElement;
  const files = Array.from(input.files || []);
  busy.value = true; emit('busy', true); error.value = '';
  try {
    for (const file of files) {
      if (model.value.length >= 30) throw new Error('每条短文最多 30 项媒体');
      if (file.size > 25 * 1024 * 1024) throw new Error(`${file.name} 超过 25 MB`);
      const result = await upload(file);
      const kind = result.mime.startsWith('video/') ? 'video' : result.mime.startsWith('audio/') ? 'audio' : 'image';
      model.value = [...model.value, { type: kind, url: result.url, title: kind === 'audio' ? file.name : '' }];
    }
  } catch (e) { error.value = (e as Error).message; }
  finally { busy.value = false; emit('busy', nestedBusy.value > 0); input.value = ''; }
}
</script>
<template>
  <div class="essay-media">
    <div class="media-tools">
      <NButton secondary type="primary" :loading="busy" @click="fileInput?.click()">上传图片 / 动图 / 视频 / 音乐</NButton>
      <NText depth="3">{{ model.length }} / 30 · 每个文件最大 25 MB</NText>
      <input ref="fileInput" type="file" multiple accept=".jpg,.jpeg,.png,.gif,.webp,.avif,.mp4,.mp3" hidden :disabled="busy || nestedBusy > 0" @change="pick" />
    </div>
    <div class="link-tools">
      <NSelect v-model:value="type" :options="types" style="width: 140px" />
      <NInput v-model:value="url" placeholder="粘贴媒体直链或网页链接" @keydown.enter.prevent="add" />
      <NButton :disabled="busy || nestedBusy > 0" @click="add">添加链接</NButton>
    </div>
    <NText depth="3">音乐、视频请选择可播放的文件直链；网易云等平台分享页请选择“网页链接”。</NText>
    <NAlert v-if="error" type="error" :show-icon="false">{{ error }}</NAlert>
    <div class="media-grid">
      <div v-for="(item, index) in model" :key="`${index}-${item.url}`" class="media-item">
        <AlbumMediaPreview v-if="item.type === 'image' || item.type === 'video'" :src="item.url" :title="item.title || '媒体预览'" :video="item.type === 'video'" />
        <MediaField v-else-if="item.type === 'audio'" v-model="item.url" audio label="音乐直链" @busy="nested" />
        <NTag v-else type="info">网页链接</NTag>
        <NInput v-model:value="item.url" placeholder="媒体地址" />
        <NInput v-model:value="item.title" :placeholder="item.type === 'audio' ? '歌曲名称' : '描述 / 链接标题（选填）'" />
        <NInput v-if="item.type === 'audio'" v-model:value="item.artist" placeholder="歌手（选填）" />
        <MediaField v-if="item.type === 'video'" v-model="item.poster" label="视频封面（选填）" @busy="nested" />
        <NSpace justify="end" size="small">
          <NButton size="tiny" :disabled="index === 0 || busy || nestedBusy > 0" @click="move(index, -1)">前移</NButton>
          <NButton size="tiny" :disabled="index === model.length - 1 || busy || nestedBusy > 0" @click="move(index, 1)">后移</NButton>
          <NButton size="tiny" type="error" quaternary :disabled="busy || nestedBusy > 0" @click="model = model.filter((_, i) => i !== index)">移除</NButton>
        </NSpace>
      </div>
    </div>
  </div>
</template>
<style scoped>
.essay-media { display: grid; gap: 12px; }
.media-tools,.link-tools { display: flex; align-items: center; gap: 10px; flex-wrap: wrap; }
.link-tools > .n-input { flex: 1; min-width: 180px; }
.media-grid { display: grid; grid-template-columns: repeat(2,minmax(0,1fr)); gap: 12px; }
.media-item { min-width: 0; display: grid; gap: 8px; padding: 12px; border: 1px solid #8883; border-radius: 12px; align-content: start; }
@media(max-width:600px) { .media-grid { grid-template-columns: 1fr; } }
</style>
