<script setup lang="ts">
import { computed, nextTick, onMounted, ref, watch } from 'vue';
import DOMPurify from 'dompurify';
import Vditor from 'vditor';
import { useThemeVars } from 'naive-ui';
import { api, listAdminComments, moderateComments, replyToComment, type CommentCounts, type CommentModeration, type Content } from '@/service/api/blog';
import { useBlogAuth } from '@/hooks/business/blog-auth';
import PageHeaderSettings from '../components/page-header-settings.vue';
import { publicSourceUrl, sourceLabel, commentSourceTitle, commentSourcePath } from './comment-utils';
import { createDetailSelection } from './detail-selection';
import CommentTable from './components/comment-table.vue';
import CommentReplies from './components/comment-replies.vue';

defineOptions({ name: 'blog_comments' });
const { hasAuth } = useBlogAuth();
const theme = useThemeVars();
const can = (action: string) => hasAuth(`blog:comments:${action}`);
const rows = ref<Content[]>([]);
const total = ref(0);
const counts = ref<CommentCounts>({ pending: 0, approved: 0, rejected: 0 });
const moderation = ref<CommentModeration>('pending');
const targetKind = ref<string | null>(null);
const targetId = ref<number>();
const targetTitle = ref('');
const keyword = ref('');
const page = ref(1);
const pageSize = ref(20);
const revision = ref(0);
const loading = ref(false);
const saving = ref(false);
const error = ref('');
const checked = ref<number[]>([]);
const detail = ref<Content | null>(null);
const showDetail = computed({ get: () => Boolean(detail.value), set: value => { if (!value) detail.value = null; } });
const showReason = ref(false);
const reason = ref('');
const reasonStatus = ref<CommentModeration>('rejected');
const reasonIds = ref<number[]>([]);
const showReply = ref(false);
const replyBody = ref('');
const selection = createDetailSelection(async body => {
  try { return DOMPurify.sanitize(await Vditor.md2html(body || '', { mode: 'light' })); }
  catch { return DOMPurify.sanitize((body || '').replaceAll('&','&amp;').replaceAll('<','&lt;').replaceAll('>','&gt;').replaceAll('\n','<br>')); }
}, async (id, kind) => {
  const target = await api<Content>(`content/${kind}/${id}`);
  return target.slug || String(target.id);
});
const previewHtml = selection.preview;
const sourceUrl = computed(() => publicSourceUrl(detail.value?.commentTarget ? commentSourcePath(detail.value) : selection.source.value, window.location, import.meta.env.VITE_PUBLIC_SITE_ORIGIN));
let loadSequence = 0;
const targetOptions = [
  { label: '留言板', value: 'guestbook' }, { label: '文章', value: 'documents' },
  { label: '即刻短文', value: 'essays' }, { label: '相册', value: 'albums' }, { label: '关于', value: 'about' }
];
const tabs: { label: string; value: CommentModeration; type: 'warning'|'success'|'error' }[] = [
  { label: '待审核', value: 'pending', type: 'warning' }, { label: '已通过', value: 'approved', type: 'success' }, { label: '已拒绝', value: 'rejected', type: 'error' }
];
const themeVars = computed(() => ({ '--comment-card': theme.value.cardColor, '--comment-soft': theme.value.actionColor, '--comment-border': theme.value.dividerColor, '--comment-muted': theme.value.textColor3, '--comment-text': theme.value.textColor1, '--comment-primary': theme.value.primaryColor }));
function messageOf(caught: unknown, fallback: string) { return caught instanceof Error && caught.message && !caught.message.includes('操作失败') ? caught.message : fallback; }
async function load() {
  if (!can('list')) { error.value = '你没有查看评论的权限。'; return; }
  const sequence = ++loadSequence;
  loading.value = true; error.value = '';
  try {
    const result = await listAdminComments({ moderation: moderation.value, targetKind: targetKind.value || undefined, targetId: targetId.value, keyword: keyword.value.trim() || undefined, page: page.value, pageSize: pageSize.value });
    if (sequence !== loadSequence) return;
    if (!result.items.length && page.value > 1) { page.value -= 1; await load(); return; }
    rows.value = result.items; total.value = result.total; counts.value = result.counts; checked.value = []; revision.value += 1;
    if (detail.value) {
      const selectedId = detail.value.id;
      try {
        const updated = await api<Content>(`content/comments/${selectedId}`);
        if (sequence === loadSequence && detail.value?.id === selectedId) detail.value = { ...updated, commentTarget: detail.value.commentTarget };
      } catch { if (sequence === loadSequence && detail.value?.id === selectedId) detail.value = null; }
    }
  } catch (caught) { if (sequence === loadSequence) error.value = messageOf(caught, '评论列表加载失败，请重试或检查权限。'); }
  finally { if (sequence === loadSequence) loading.value = false; }
}
function filterSource(row: Content) {
  targetKind.value = row.metadata?.targetKind || 'guestbook';
  targetId.value = row.metadata?.targetId ? Number(row.metadata.targetId) : undefined;
  targetTitle.value = commentSourceTitle(row);
  keyword.value = '';
  search();
}
function clearSource() { targetId.value = undefined; targetTitle.value = ''; search(); }
function search() { page.value = 1; detail.value = null; load(); }
function requestModeration(ids: number[], status: CommentModeration) {
  if (!ids.length || saving.value || loading.value) return;
  if (status === 'rejected' || status === 'pending') { reasonIds.value = [...ids]; reasonStatus.value = status; reason.value = ''; showReason.value = true; }
  else { reason.value = ''; applyModeration([...ids], status); }
}
async function applyModeration(ids = reasonIds.value, status = reasonStatus.value) {
  if (saving.value || !can('update')) return;
  saving.value = true; error.value = '';
  try { const result = await moderateComments(ids, status, reason.value.trim() || undefined); window.$message?.success(`已更新 ${result.updated} 条评论`); showReason.value = false; await load(); }
  catch (caught) { error.value = messageOf(caught, '审核操作失败，请重试或检查权限。'); }
  finally { saving.value = false; }
}
async function submitReply() {
  if (saving.value || !detail.value || !replyBody.value.trim() || !can('create')) return;
  saving.value = true; error.value = '';
  try { await replyToComment(detail.value.id, replyBody.value.trim()); window.$message?.success('回复已发布'); showReply.value = false; replyBody.value = ''; await load(); }
  catch (caught) { error.value = messageOf(caught, '回复失败，请重试或检查权限。'); }
  finally { saving.value = false; }
}
async function remove(row: Content) {
  if (saving.value || !can('delete')) return;
  saving.value = true; error.value = '';
  try { await api(`content/comments/${row.id}`, 'delete'); window.$message?.success('评论已删除'); detail.value = null; await load(); }
  catch (caught) { error.value = messageOf(caught, '删除失败；若该评论有回复，请先删除子回复。'); }
  finally { saving.value = false; }
}
function openDetail(row: Content) { detail.value = row; }
function formatDate(value?: string) { return value ? new Date(value).toLocaleString('zh-CN', { hour12: false }) : '时间未知'; }
watch(detail, value => { nextTick(() => selection.select(value)); });
watch(moderation, search);
onMounted(load);
</script>

<template>
  <div class="comments-page" :style="themeVars">
    <header class="page-heading">
      <div class="heading-copy"><div class="heading-icon"><SvgIcon icon="lucide:messages-square" /></div><div><span class="eyebrow">社区管理 · {{ total }} 条结果</span><h1>评论审核</h1><p>集中审核评论，展开主评论查看回复；IP 与邮箱仅后台可见。</p></div></div>
      <PageHeaderSettings :pages="['comments']" />
    </header>
    <NAlert v-if="error" type="error" closable class="feedback" @close="error = ''">{{ error }}</NAlert>
    <section class="panel filters">
      <div class="review-tabs">
        <button v-for="tab in tabs" :key="tab.value" type="button" :class="['review-tab', { active: moderation === tab.value }]" @click="moderation = tab.value"><span>{{ tab.label }}</span><NTag :type="tab.type" size="small" round :bordered="false">{{ counts[tab.value] }}</NTag></button>
      </div>
      <div class="filter-row">
        <NInput v-model:value="keyword" clearable placeholder="搜索评论正文、昵称或邮箱" @keyup.enter="search"><template #prefix><SvgIcon icon="lucide:search" /></template></NInput>
        <NSelect v-model:value="targetKind" :options="targetOptions" clearable placeholder="全部来源" @update:value="clearSource" />
        <NButton type="primary" :loading="loading" :disabled="!can('list')" @click="search">查询</NButton>
      </div>
      <div v-if="targetTitle" class="source-filter"><NTag closable type="info" @close="clearSource">当前评论对象：{{ targetTitle }}</NTag></div>
    </section>
    <section class="panel queue-main">
      <div class="bulk-bar">
        <span>共 {{ total }} 条 · 已选 {{ checked.length }} 条</span>
        <span class="queue-hint">点击主评论左侧箭头展开回复</span>
        <div class="bulk-actions">
          <NButton size="small" type="success" secondary :disabled="!checked.length || !can('update') || saving || loading" @click="requestModeration(checked, 'approved')">批量通过</NButton>
          <NButton size="small" type="error" secondary :disabled="!checked.length || !can('update') || saving || loading" @click="requestModeration(checked, 'rejected')">批量拒绝</NButton>
          <NButton size="small" secondary :disabled="!checked.length || !can('update') || saving || loading" @click="requestModeration(checked, 'pending')">移回待审</NButton>
        </div>
      </div>
      <CommentTable v-model:checked="checked" :rows="rows" :loading="loading" :saving="saving" :can-update="can('update')" expandable selectable @detail="openDetail" @moderate="requestModeration" @filter-source="filterSource">
        <template #replies="{ row }"><CommentReplies :key="`${row.id}-${revision}`" :parent-id="row.id" :can-update="can('update')" :saving="saving" @detail="openDetail" @moderate="requestModeration" @filter-source="filterSource" /></template>
      </CommentTable>
      <div class="pagination-bar"><NPagination v-model:page="page" v-model:page-size="pageSize" :item-count="total" show-size-picker :page-sizes="[10, 20, 50, 100]" :disabled="loading" @update:page="load" @update:page-size="search" /></div>
    </section>
    <NDrawer v-model:show="showDetail" width="min(600px, 100vw)">
      <NDrawerContent title="评论详情" closable :style="themeVars">
      <div class="detail-panel">

        <NEmpty v-if="!detail" description="选择一条评论查看详情" />
        <template v-else>
          <div class="detail-title"><div><span>评论 #{{ detail.id }}</span><h2>{{ detail.metadata?.authorName || '匿名访客' }}</h2></div><NButton quaternary circle @click="detail = null"><template #icon><SvgIcon icon="lucide:x" /></template></NButton></div>
          <dl class="contact-grid"><div><dt>邮箱（仅后台可见）</dt><dd>{{ detail.metadata?.authorEmail || '未提供' }}</dd></div><div><dt>个人网站</dt><dd><a v-if="detail.metadata?.authorWebsite" :href="detail.metadata.authorWebsite" target="_blank" rel="noopener noreferrer">{{ detail.metadata.authorWebsite }}</a><span v-else>未提供</span></dd></div><div><dt>来源</dt><dd><a v-if="sourceUrl" :href="sourceUrl" target="_blank" rel="noopener noreferrer">{{ commentSourceTitle(detail) }}</a><span v-else>{{ sourceLabel(detail.metadata) }}</span></dd></div><div><dt>提交时间</dt><dd>{{ formatDate(detail.createdAt) }}</dd></div></dl>
          <dl class="contact-grid environment-grid">
            <div><dt>IP 地址（仅后台可见）</dt><dd>{{ detail.metadata?.rawIp || '未记录' }}</dd></div>
            <div><dt>IP 属地</dt><dd>{{ detail.metadata?.location || '未知属地' }}</dd></div>
            <div><dt>操作系统</dt><dd>{{ detail.metadata?.os || '未记录' }}</dd></div>
            <div><dt>浏览器及版本</dt><dd>{{ detail.metadata?.browser || '未记录' }}</dd></div>
          </dl>
          <NAlert v-if="detail.metadata?.moderationReason" type="info">审核备注：{{ detail.metadata.moderationReason }}</NAlert>
          <section><h3>安全预览</h3><div class="markdown-body" v-html="previewHtml" /></section>
          <div class="detail-actions"><NButton type="primary" :disabled="!can('create') || saving || (detail.moderationStatus || detail.metadata?.moderationStatus || (detail.status === 'published' ? 'approved' : 'pending')) !== 'approved'" @click="replyBody = ''; showReply = true">回复</NButton><NPopconfirm :disabled="saving" @positive-click="remove(detail)"><template #trigger><NButton type="error" secondary :disabled="!can('delete') || saving">删除</NButton></template>确认永久删除？有子回复时后端会阻止删除。</NPopconfirm></div>
        </template>
      </div>
      </NDrawerContent>
    </NDrawer>
    <NModal v-model:show="showReason" preset="card" :title="reasonStatus === 'rejected' ? '拒绝评论' : '移回待审'" class="action-modal"><NFormItem :label="reasonStatus === 'rejected' ? '原因（可选，将保存在审核记录中）' : '备注（可选）'"><NInput v-model:value="reason" type="textarea" :maxlength="500" show-count :autosize="{ minRows: 3, maxRows: 7 }" /></NFormItem><template #footer><NSpace justify="end"><NButton :disabled="saving" @click="showReason = false">取消</NButton><NButton :type="reasonStatus === 'rejected' ? 'error' : 'primary'" :loading="saving" :disabled="!can('update')" @click="applyModeration()">确认更新 {{ reasonIds.length }} 条</NButton></NSpace></template></NModal>
    <NModal v-model:show="showReply" preset="card" title="回复访客" class="action-modal"><NAlert type="info" class="reply-tip">管理员回复会直接发布，并关联到当前评论。</NAlert><NInput v-model:value="replyBody" type="textarea" placeholder="支持 Markdown" :maxlength="5000" show-count :autosize="{ minRows: 6, maxRows: 14 }" /><template #footer><NSpace justify="end"><NButton :disabled="saving" @click="showReply = false">取消</NButton><NButton type="primary" :loading="saving" :disabled="!replyBody.trim() || !can('create')" @click="submitReply">发布回复</NButton></NSpace></template></NModal>
  </div>
</template>

<style scoped>
.comments-page{display:grid;gap:16px;color:var(--comment-text);min-width:0}
.page-heading,.heading-copy,.filter-row,.bulk-bar,.detail-title,.detail-actions{display:flex;align-items:center}
.page-heading{justify-content:space-between;gap:20px}.heading-copy{gap:14px}
.heading-icon{display:grid;width:46px;height:46px;place-items:center;border-radius:14px;background:color-mix(in srgb,var(--comment-primary) 14%,transparent);color:var(--comment-primary);font-size:22px}
.eyebrow{font-size:12px;color:var(--comment-primary);font-weight:700;letter-spacing:.08em}
.page-heading h1{margin:2px 0 0;font-size:26px}.page-heading p{margin:4px 0 0;color:var(--comment-muted)}
.panel{border:1px solid var(--comment-border);background:var(--comment-card);border-radius:12px;overflow:hidden;min-width:0}
.review-tabs{display:flex;border-bottom:1px solid var(--comment-border)}
.review-tab{display:flex;align-items:center;gap:8px;padding:12px 20px;border:0;border-bottom:2px solid transparent;background:transparent;color:var(--comment-muted);cursor:pointer}
.review-tab.active{border-color:var(--comment-primary);color:var(--comment-primary);font-weight:700}
.source-filter{padding:0 16px 14px;overflow-wrap:anywhere}
.filter-row{gap:12px;padding:14px 16px}.filter-row .n-input{max-width:440px}.filter-row .n-select{width:180px}
.bulk-bar{gap:16px;padding:12px 16px;flex-wrap:wrap;border-bottom:1px solid var(--comment-border)}
.queue-hint{color:var(--comment-muted);font-size:12px}.bulk-actions{display:flex;gap:8px;margin-left:auto}
.pagination-bar{display:flex;justify-content:flex-end;padding:14px 16px;overflow:auto}
.detail-panel{color:var(--comment-text)}.detail-title{justify-content:space-between}
.detail-title span,.contact-grid dt{color:var(--comment-muted);font-size:12px}.detail-title h2{margin:3px 0 0}
.contact-grid{display:grid;gap:11px;margin:18px 0}.environment-grid{grid-template-columns:repeat(2,minmax(0,1fr))}
.contact-grid div{padding:10px 12px;background:var(--comment-soft);border-radius:8px}.contact-grid dd{margin:3px 0 0;overflow-wrap:anywhere}.contact-grid a{color:var(--comment-primary)}
.detail-panel h3{font-size:14px}.markdown-body{min-height:100px;max-height:360px;padding:13px;overflow:auto;border:1px solid var(--comment-border);border-radius:10px;overflow-wrap:anywhere}.markdown-body :deep(img){max-width:100%}
.detail-actions{gap:10px;margin-top:16px}.action-modal{width:min(560px,calc(100vw - 32px))}.reply-tip{margin-bottom:14px}
@media(max-width:640px){.page-heading,.filter-row{align-items:stretch;flex-direction:column}.filter-row .n-input,.filter-row .n-select{width:100%;max-width:none}.review-tabs{overflow:auto}.review-tab{padding:13px;white-space:nowrap}.bulk-actions{margin:0;flex-wrap:wrap}.page-heading h1{font-size:24px}.queue-hint{width:100%}.pagination-bar{justify-content:flex-start}.environment-grid{grid-template-columns:1fr}}
</style>
