<script setup lang="ts">
import { onMounted, onBeforeUnmount, ref } from 'vue';
import { listAdminComments, type Content, type CommentModeration } from '@/service/api/blog';
import CommentTable from './comment-table.vue';

const props = defineProps<{ parentId: number; canUpdate: boolean; saving: boolean }>();
const emit = defineEmits<{ detail: [row: Content]; moderate: [ids: number[], status: CommentModeration]; filterSource: [row: Content] }>();
const rows = ref<Content[]>([]);
const total = ref(0);
const page = ref(1);
const loading = ref(false);
const error = ref('');
let sequence = 0;
async function load() {
  const current = ++sequence;
  loading.value = true;
  error.value = '';
  try {
    const result = await listAdminComments({ parentId: props.parentId, page: page.value, pageSize: 10 });
    if (current !== sequence) return;
    rows.value = result.items;
    total.value = result.total;
  } catch {
    if (current === sequence) error.value = '回复加载失败，请重试。';
  } finally {
    if (current === sequence) loading.value = false;
  }
}
onMounted(load);
onBeforeUnmount(() => { sequence += 1; });
</script>

<template>
  <section class="replies-section" :aria-label="`评论 #${parentId} 的回复`">
    <div class="replies-heading"><strong>回复记录 · {{ total }} 条</strong><span>包含全部审核状态，按时间倒序</span></div>
    <NAlert v-if="error" type="error" class="reply-error">{{ error }} <NButton text type="primary" @click="load">重试</NButton></NAlert>
    <CommentTable :rows="rows" :loading="loading" :saving="saving" :can-update="canUpdate" @detail="emit('detail', $event)" @filter-source="emit('filterSource', $event)" @moderate="(ids, status) => emit('moderate', ids, status)" />
    <NPagination v-if="total > 10" v-model:page="page" :item-count="total" :page-size="10" :disabled="loading" class="reply-pagination" @update:page="load" />
  </section>
</template>

<style scoped>
.replies-section{padding:8px 4px 12px 16px;border-left:3px solid var(--comment-primary)}
.replies-heading{display:flex;align-items:center;gap:14px;margin:0 0 12px}
.replies-heading span{font-size:12px;color:var(--comment-muted)}
.reply-error{margin-bottom:12px}.reply-pagination{margin-top:12px;justify-content:flex-end}
</style>
