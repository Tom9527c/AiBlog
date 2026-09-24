<script setup lang="ts">
import { computed, ref, watch } from 'vue';
import { NButton, useThemeVars } from 'naive-ui';
import { type Content, type Kind, api, list, options } from '@/service/api/blog';
import { useBlogAuth } from '@/hooks/business/blog-auth';
import PageHeaderSettings from '../../components/page-header-settings.vue';
import type { PageHeaderKey } from '@/service/api/blog';
import AboutFields from '../../about/components/AboutFields.vue';
import MusicFields from '../../music/components/MusicFields.vue';
import { names, descriptions, empty } from '../content-config';
import { createColumns } from '../table-columns';
import ContentFilters from './ContentFilters.vue';
import BodyFields from './BodyFields.vue';
import AlbumFields from './AlbumFields.vue';
import AdditionalFields from './AdditionalFields.vue';
import DisplayFields from './DisplayFields.vue';
import MediaFields from './MediaFields.vue';
import RelationFields from './RelationFields.vue';
import PublishingFields from './PublishingFields.vue';
import BasicFields from './BasicFields.vue';
const props = defineProps<{ kind: Kind; showPageSettings?: boolean }>();
const { hasAuth } = useBlogAuth();
const theme = useThemeVars();
const headerPages = computed<PageHeaderKey[]>(() => props.kind === 'documents' ? ['archives', 'articles'] : ['categories','tags','albums','bangumis','links','collections','music','comments','essays'].includes(props.kind) ? [props.kind as PageHeaderKey] : []);
const title = computed(() => names[props.kind]);
const description = computed(() => descriptions[props.kind]);
const themeVars = computed(() => ({
  '--manager-card': theme.value.cardColor,
  '--manager-soft': theme.value.actionColor,
  '--manager-border': theme.value.dividerColor,
  '--manager-muted': theme.value.textColor3,
  '--manager-text': theme.value.textColor1,
  '--manager-primary': theme.value.primaryColor,
  '--manager-error': theme.value.errorColor
}));
const can = (action: string) => hasAuth(`blog:${props.kind}:${action}`);
const rows = ref<Content[]>([]);
const total = ref(0);
const page = ref(1);
const pageSize = ref(12);
const keyword = ref('');
const status = ref<string | null>(null);
const filterParent = ref<number | null>(null);
const filterCategory = ref<number | null>(null);
const filterTag = ref<number | null>(null);
const filterState = ref<string | null>(null);
const busy = ref(false);
const saving = ref(false);
const mediaBusy = ref(false);
const show = ref(false);
const expandedSettings = ref<string[]>([]);
const error = ref('');
const categories = ref<{ label: string; value: number }[]>([]);
const tags = ref<{ label: string; value: number }[]>([]);
const parents = ref<{ label: string; value: number }[]>([]);
const form = ref<Content>(empty());
const previousAccess = ref('public');
const attachment = ref('');
const columns = computed(() => createColumns(props.kind, can, edit, remove));
function search() { page.value = 1; void load(); }
async function load() {
  busy.value = true;
  error.value = '';
  try {
    const result = await list(props.kind, {
      page: page.value,
      pageSize: pageSize.value,
      keyword: keyword.value,
      status: status.value || undefined,
      parentId: filterParent.value || undefined,
      categoryId: filterCategory.value || undefined,
      tagId: filterTag.value || undefined,
      state: filterState.value || undefined
    });
    rows.value = result.items;
    total.value = result.total;
  } catch {
    error.value = '列表加载失败，请重试';
  } finally {
    busy.value = false;
  }
}
async function relations() {
  const tasks = [];
  if (props.kind === 'documents') {
    tasks.push(
      options('categories').then(v => {
        categories.value = v;
      }),
      options('tags').then(v => {
        tags.value = v;
      })
    );
  }
  if (['photos', 'comments'].includes(props.kind))
    tasks.push(
      options(props.kind === 'photos' ? 'albums' : 'comments').then(v => {
        parents.value = v;
      })
    );
  await Promise.allSettled(tasks);
}
async function edit(id = 0) {
  error.value = '';
  attachment.value = '';
  expandedSettings.value = [];
  try {
    form.value = id ? await api<Content>(`content/${props.kind}/${id}`) : empty();
    previousAccess.value = form.value.accessMode;
    form.value.password = '';
    form.value.metadata = { ...form.value.metadata };
    if (props.kind === 'about') {
      form.value.metadata.profileTags ||= [];
      form.value.metadata.skills ||= [];
      form.value.metadata.socials ||= [];
      form.value.metadata.cards ||= [];
      form.value.metadata.experiences ||= [];
    }
    if (props.kind === 'bangumis') {
      form.value.metadata = {
        state: 'wish',
        progress: 0,
        total: 0,
        rating: 0,
        region: '',
        type: '',
        plays: 0,
        followers: 0,
        coins: 0,
        danmaku: 0,
        ...form.value.metadata
      };
    }
    if (props.kind === 'collections') {
      form.value.metadata = {
        category: '其他',
        icon: 'box',
        rating: 0,
        ...form.value.metadata
      };
    }
    show.value = true;
    await relations();
  } catch {
    error.value = '详情加载失败';
  }
}
function validateForm() {
  if (!form.value.title.trim() && props.kind !== 'comments') return '请填写标题 / 名称';
  if (props.kind === 'comments' && !form.value.body.trim()) return '请填写评论正文';
  if (props.kind === 'photos' && !form.value.parentId) return '请选择所属相册';
  if (
    form.value.accessMode === 'password' &&
    !form.value.password &&
    (!form.value.id || previousAccess.value !== 'password')
  )
    return '请设置访问密码';
  return '';
}
function saveData() {
  const { id, ...fields } = form.value;
  const data: Partial<Content> = fields;
  if (!data.slug?.trim()) delete data.slug;
  if (props.kind === 'albums' || props.kind === 'music') { delete data.body; delete data.format; }
  if (props.kind === 'bangumis') { data.body = ''; data.format = 'markdown'; }
  if (props.kind === 'comments' && !data.title?.trim()) data.title = '管理员评论';
  if (!data.password) delete data.password;
  if (props.kind === 'comments' && !data.metadata?.targetKind) {
    data.metadata = { ...data.metadata };
    delete data.metadata.targetKind;
    delete data.metadata.targetId;
  }
  return { id, data };
}
async function save() {
  error.value = '';
  const validationError = validateForm();
  if (validationError) {
    error.value = validationError;
    return;
  }
  saving.value = true;
  try {
    const { id, data } = saveData();
    const saved = await api<Content>(`content/${props.kind}${id ? `/${id}` : ''}`, id ? 'put' : 'post', data);
    if (props.kind === 'albums') {
      form.value = { ...saved, password: '' };
      previousAccess.value = saved.accessMode;
    } else show.value = false;
    window.$message?.success('保存成功');
    await load();
  } catch {
    error.value = '保存失败，请检查字段和接口提示';
  } finally {
    saving.value = false;
  }
}
async function remove(id: number) {
  try {
    await api(`content/${props.kind}/${id}`, 'delete');
    if (rows.value.length === 1 && page.value > 1) page.value -= 1;
    await load();
  } catch {
    error.value = '删除失败，请先检查关联数据';
  }
}
watch(
  () => props.kind,
  () => {
    page.value = 1;
    keyword.value = '';
    status.value = null;
    filterParent.value = null;
    filterCategory.value = null;
    filterTag.value = null;
    filterState.value = null;
    load();
    relations();
  },
  { immediate: true }
);
</script>

<template>
  <div class="content-manager" :style="themeVars">
    <header class="manager-header">
      <div class="heading-group">
        <div class="heading-icon"><SvgIcon icon="lucide:layout-list" /></div>
        <div>
          <div class="heading-eyebrow">
            内容管理
            <span class="header-count">{{ total }} 条记录</span>
          </div>
          <h1>{{ title }}管理</h1>
          <p>{{ description }}</p>
        </div>
      </div>
      <NSpace><PageHeaderSettings v-if="headerPages.length && showPageSettings !== false" :pages="headerPages" />
      <NButton type="primary" :disabled="!can('create')" @click="edit()">
        <template #icon><SvgIcon icon="lucide:plus" /></template>
        新增{{ title }}
      </NButton></NSpace>
    </header>

    <ContentFilters :kind="kind" :total="total" :can-list="can('list')" :categories="categories" :tags="tags" :parents="parents"
      v-model:keyword="keyword" v-model:status="status" v-model:filter-parent="filterParent" v-model:filter-category="filterCategory"
      v-model:filter-tag="filterTag" v-model:filter-state="filterState" @search="search" />

    <section class="table-card">
      <NAlert v-if="error && !show" type="error" class="feedback">{{ error }}</NAlert>
      <NDataTable
        class="content-table"
        :columns="columns"
        :data="rows"
        :loading="busy"
        :bordered="false"
        :scroll-x="850"
        :row-key="(row: Content) => row.id"
      />
      <div class="pagination-bar">
        <span class="pagination-summary">共 {{ total }} 条内容</span>
        <NPagination
          v-model:page="page"
          v-model:page-size="pageSize"
          :item-count="total"
          :page-sizes="[12, 24, 50, 100]"
          show-size-picker
          @update:page="load"
          @update:page-size="
            page = 1;
            load();
          "
        />
      </div>
    </section>

    <NDrawer v-model:show="show" width="min(960px, 100vw)" :mask-closable="false" :close-on-esc="!mediaBusy">
      <NDrawerContent class="content-drawer" :style="themeVars" :body-content-style="{ padding: '0' }" :closable="!mediaBusy">
        <template #header>
          <div class="drawer-heading">
            <div class="drawer-heading__icon"><SvgIcon icon="lucide:pen-line" /></div>
            <div>
              <strong>{{ form.id ? '编辑' : '新增' }}{{ title }}</strong>
              <span>{{ form.id ? '更新现有内容并保存修改' : '填写内容信息，完成后点击保存' }}</span>
            </div>
          </div>
        </template>

        <div class="drawer-body">
          <NAlert v-if="error" type="error" class="feedback">{{ error }}</NAlert>
          <NForm label-placement="top" :show-feedback="false" class="content-form">
            <BasicFields :form="form" :kind="kind" v-model:expanded-settings="expandedSettings" />

            <PublishingFields :form="form" :previous-access="previousAccess" />

            <RelationFields v-if="kind === 'documents' || kind === 'photos' || kind === 'comments'" :form="form" :kind="kind" :categories="categories" :tags="tags" :parents="parents" />

            <MediaFields :form="form" :kind="kind" />

            <DisplayFields v-if="['bangumis', 'photos', 'tags', 'albums', 'collections'].includes(kind)" :form="form" :kind="kind" />

            <MusicFields v-if="kind === 'music'" :form="form" />

            <AboutFields v-if="kind === 'about'" :form="form" />

            <AdditionalFields v-if="kind === 'moments' || kind === 'comments'" :form="form" :kind="kind" />

            <AlbumFields v-if="kind === 'albums'" :form="form" :saving="saving" v-model:media-busy="mediaBusy" />

            <BodyFields v-if="!['categories', 'tags', 'links', 'collections', 'albums', 'bangumis', 'music'].includes(kind)" :form="form" :kind="kind" v-model:attachment="attachment" />
          </NForm>
        </div>

        <template #footer>
          <div class="drawer-footer">
            <span class="drawer-footer__hint">{{ kind === 'albums' ? '相册信息需保存，媒体操作即时生效' : '修改完成后请点击保存' }}</span>
            <div class="drawer-footer__actions">
              <NButton :disabled="mediaBusy" @click="show = false">{{ kind === 'albums' ? '关闭' : '取消' }}</NButton>
              <NButton type="primary" :loading="saving" :disabled="mediaBusy || !can(form.id ? 'update' : 'create')" @click="save">
                <template #icon><SvgIcon icon="lucide:check" /></template>
                保存{{ title }}
              </NButton>
            </div>
          </div>
        </template>
      </NDrawerContent>
    </NDrawer>
  </div>
</template>

<style scoped src="../content-manager.css"></style>
