<script setup lang="ts">
import { computed, h } from 'vue';
import { NButton, NDataTable, NSpace, NTag, type DataTableColumns } from 'naive-ui';
import type { CommentModeration, Content } from '@/service/api/blog';
import { sourceLabel, commentSourceTitle, commentSourcePath, publicSourceUrl } from '../comment-utils';

const props = withDefaults(defineProps<{
  rows: Content[];
  loading?: boolean;
  saving?: boolean;
  canUpdate: boolean;
  expandable?: boolean;
  selectable?: boolean;
  checked?: number[];
}>(), { checked: () => [], selectable: false, expandable: false });
const emit = defineEmits<{
  detail: [row: Content];
  moderate: [ids: number[], status: CommentModeration];
  filterSource: [row: Content];
  'update:checked': [ids: number[]];
}>();
const slots = defineSlots<{ replies(props: { row: Content }): any }>();
const labels = { pending: '待审核', approved: '已通过', rejected: '已拒绝' } as const;
const types = { pending: 'warning', approved: 'success', rejected: 'error' } as const;
function state(row: Content): CommentModeration {
  return row.moderationStatus || row.metadata?.moderationStatus || (row.status === 'published' ? 'approved' : 'pending');
}
function stacked(primary: string, secondary: string) {
  return h('div', { class: 'cell-stack' }, [h('span', primary), h('small', secondary)]);
}
const columns = computed<DataTableColumns<Content>>(() => [
  ...(props.selectable ? [{ type: 'selection' as const, width: 40, disabled: () => Boolean(props.loading || props.saving) }] : []),
  ...(props.expandable ? [{ type: 'expand' as const, width: 30, expandable: (row: Content) => !row.parentId, renderExpand: (row: Content) => slots.replies?.({ row }) }] : []),
  {
    title: '评论 / 回复', key: 'body', width: 220,
    render: row => h('div', { class: 'content-cell' }, [
      h('div', { class: 'comment-context' }, [
        h('span', `#${row.id}`),
        row.parentId ? h('span', `↳ 回复 #${row.parentId}${row.metadata?.replyToName ? ` · ${row.metadata.replyToName}` : ''}`) : h('span', '主评论'),
      ]),
      h('button', { type: 'button', class: 'body-preview', title: '查看完整评论', onClick: () => emit('detail', row) }, row.body || '（空内容）'),
      row.metadata?.moderationReason ? h('small', { class: 'moderation-reason', title: row.metadata.moderationReason }, `审核备注：${row.metadata.moderationReason}`) : null,
    ])
  },
  { title: '作者 / 邮箱', key: 'author', width: 120, render: row => stacked(row.metadata?.authorName || '匿名访客', row.metadata?.authorEmail || '未留邮箱') },
  {
    title: '评论对象', key: 'source', width: 210,
    render: row => {
      const href = publicSourceUrl(commentSourcePath(row), window.location, import.meta.env.VITE_PUBLIC_SITE_ORIGIN);
      const date = row.commentTarget?.date;
      return h('div', { class: 'cell-stack source-cell' }, [
        h('small', `${sourceLabel(row.metadata)}${date && row.metadata?.targetKind === 'essays' ? ` · ${new Date(date).toLocaleDateString('zh-CN')}` : ''}`),
        h(href ? 'a' : 'span', { ...(href ? { href, target: '_blank', rel: 'noopener noreferrer' } : {}), class: 'source-title', title: commentSourceTitle(row) }, commentSourceTitle(row)),
        h(NButton, { text: true, size: 'tiny', type: 'primary', onClick: () => emit('filterSource', row) }, { default: () => '只看此内容' }),
      ]);
    }
  },
  { title: 'IP / 属地', key: 'ip', width: 125, render: row => stacked(row.metadata?.rawIp || '未记录', row.metadata?.location || '未知属地') },
  { title: '系统 / 浏览器版本', key: 'environment', width: 150, render: row => stacked(row.metadata?.os || '未记录系统', row.metadata?.browser || '未记录浏览器') },
  { title: '状态', key: 'moderationStatus', width: 75, render: row => h(NTag, { size: 'small', bordered: false, type: types[state(row)] }, { default: () => labels[state(row)] }) },
  { title: '提交时间', key: 'createdAt', width: 110, render: row => row.createdAt ? stacked(new Date(row.createdAt).toLocaleDateString('zh-CN'), new Date(row.createdAt).toLocaleTimeString('zh-CN', { hour12: false })) : '时间未知' },
  {
    title: '操作', key: 'actions', width: 115, fixed: 'right',
    render: row => h(NSpace, { size: 8 }, { default: () => [
      h(NButton, { text: true, type: 'primary', onClick: () => emit('detail', row) }, { default: () => '详情' }),
      ...(['approved', 'rejected', 'pending'] as const).filter(status => status !== state(row)).map(status => h(NButton, {
        text: true, type: types[status], disabled: !props.canUpdate || props.saving || props.loading,
        onClick: () => emit('moderate', [row.id], status)
      }, { default: () => ({ approved: '通过', rejected: '拒绝', pending: '待审' })[status] })),
    ] })
  }
]);
</script>

<template>
  <NDataTable
    :columns="columns" :data="rows" :row-key="(row: Content) => row.id" :loading="loading"
    :checked-row-keys="checked" :scroll-x="selectable ? 1295 : 1225" size="small" :bordered="false"
    @update:checked-row-keys="emit('update:checked', $event as number[])"
  />
</template>

<style scoped>
:deep(.n-data-table-td){vertical-align:top}
:deep(.cell-stack){display:grid;gap:4px;overflow-wrap:anywhere;line-height:1.5}
:deep(.cell-stack small),:deep(.comment-context){color:var(--comment-muted);font-size:12px}
:deep(.comment-context){display:flex;gap:8px;margin-bottom:4px;flex-wrap:wrap}
:deep(.body-preview){display:-webkit-box;-webkit-line-clamp:2;-webkit-box-orient:vertical;overflow:hidden;white-space:pre-wrap;overflow-wrap:anywhere;text-align:left;color:inherit;cursor:pointer;line-height:1.6;background:none;border:0;padding:0;font:inherit}
:deep(.body-preview:hover){color:var(--comment-primary)}
:deep(.body-preview:focus-visible){outline:2px solid var(--comment-primary);outline-offset:2px}
:deep(.moderation-reason){display:block;color:var(--comment-muted);font-size:12px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;max-width:290px;margin-top:4px}
:deep(.source-title){display:-webkit-box;-webkit-line-clamp:2;-webkit-box-orient:vertical;overflow:hidden;line-height:1.5}
:deep(a.source-title){color:var(--comment-primary);text-decoration:none}
:deep(a.source-title:hover){text-decoration:underline}
:deep(.source-cell .n-button){justify-self:start}
</style>
