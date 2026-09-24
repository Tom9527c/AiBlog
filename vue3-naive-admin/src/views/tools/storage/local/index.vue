<script setup lang="tsx">
import { ref } from 'vue';
import { NButton, NPopconfirm, NTag, NTime } from 'naive-ui';
import { useTable, useTableOperate } from '@/hooks/common/table';
import { fetchDeleteStorageLocal, fetchGetStorageLocalList } from '@/service/api';
import { $t } from '@/locales';
import { useAuth } from '@/hooks/business/auth';
import { useSearchForm } from '@/hooks/common/search-form';
import { migrateBlogStorage } from '@/service/api/tool/storage-local';
import StoragePreview from '../modules/storage-preview.vue';
const { hasAuth } = useAuth();
const previewFile = ref<Api.ToolsManage.StorageLocal | null>(null);
const migrating = ref<number | null>(null);
const referenceNames: Record<string, string> = { site: '站点配置', documents: '文章', categories: '分类', tags: '标签', albums: '相册', photos: '照片', essays: '说说', about: '关于', links: '友链', music: '音乐', bangumis: '追番', moments: '朋友圈', collections: '收藏' };
const providerNames = { local: '本地', aliyun: '阿里云 OSS', qcloud: '腾讯云 COS' };


const storageLocalSearchForm = useSearchForm<Api.ToolsManage.StorageLocalSearchParams>(() => [
  {
    key: 'name',
    label: $t('page.tools.storage.fileName'),
    type: 'Input',
    props: {
      placeholder: $t('common.pleaseEnter') + $t('page.tools.storage.fileName')
    }
  },
  { key: 'source', label: '来源', type: 'Select', props: { clearable: true, options: [{ label: '普通上传', value: 'general' }, { label: '博客', value: 'blog' }] } },
  { key: 'provider', label: '存储位置', type: 'Select', props: { clearable: true, options: Object.entries(providerNames).map(([value, label]) => ({ value, label })) } },
  { key: 'visibility', label: '文件访问', type: 'Select', props: { clearable: true, options: [{ label: '公开', value: 'public' }, { label: '受控访问', value: 'private' }] } },
  {
    key: 'username',
    label: $t('page.tools.storage.uploadBy'),
    type: 'Input',
    props: {
      placeholder: $t('common.pleaseEnter') + $t('page.tools.storage.uploadBy')
    }
  },
  {
    key: 'time',
    label: $t('page.tools.storage.uploadTime'),
    type: 'DatePicker',
    props: {
      type: 'daterange'
    }
  }
]);

const { columns, columnChecks, data, loading, pagination, getDataByPage, getData, searchParams, resetSearchParams } =
  useTable({
    apiFn: fetchGetStorageLocalList,
    showTotal: true,
    apiParams: {
      currentPage: 1,
      pageSize: 10,
      // if you want to use the searchParams in Form, you need to define the following properties, and the value is null
      // the value can not be undefined, otherwise the property in Form will not be reactive
      source: null,
      provider: null,
      visibility: null,
      username: null,
      time: null,
      name: null
    },
    columns: () => [
      {
        fixed: 'left',
        type: 'selection',
        align: 'center',
        width: 48,
        disabled: row => Boolean(row.references?.length)
      },
      {
        key: 'name',
        title: $t('page.tools.storage.fileName'),
        align: 'left',
        width: 200,
        ellipsis: {
          tooltip: true
        }
      },
      {
        key: 'extName',
        title: $t('page.tools.storage.fileExt'),
        align: 'center',
        width: 100
      },
      {
        key: 'type',
        title: $t('page.tools.storage.fileType'),
        align: 'center',
        width: 120,
        render: row => {
          if (row.type === null) return null;
          return <NTag>{row.type}</NTag>;
        }
      },
      { key: 'source', title: '来源', width: 100, render: row => row.source === 'blog' ? '博客' : '普通上传' },
      { key: 'provider', title: '存储位置', width: 120, render: row => providerNames[row.provider] || row.provider },
      { key: 'visibility', title: '文件访问', width: 110, render: row => <NTag>{row.visibility === 'private' ? '受控访问' : '公开'}</NTag> },
      { key: 'references', title: '引用位置', width: 180, render: row => row.references?.map(ref => `${referenceNames[ref.kind] || ref.kind}${ref.kind === 'site' ? '' : ` #${ref.contentId}`}`).join('、') || '未引用' },
      { key: 'path', title: '预览', width: 90,
        render: row => <NButton size="small" onClick={() => { previewFile.value = row; }}>预览</NButton> },
      {
        key: 'size',
        title: $t('page.tools.storage.size'),
        align: 'center',
        width: 100
      },
      {
        key: 'createdAt',
        title: $t('page.tools.storage.uploadTime'),
        align: 'center',
        width: 200,
        render: row => {
          if (!row.createdAt) return null;
          return <NTime time={new Date(row.createdAt)} />;
        }
      },
      {
        key: 'username',
        title: $t('page.tools.storage.uploadBy'),
        align: 'center',
        width: 200
      },
      {
        key: 'operate',
        title: $t('common.operate'),
        align: 'center',
        width: 230,
        render: row => (
          <div class="flex-center gap-8px">
            <NPopconfirm onPositiveClick={() => handleDelete(row.id)}>
              {{
                default: () => `${$t('common.delete')} - ${row.name} ？`,
                trigger: () => (
                  <NButton disabled={!hasAuth('tool:storage:delete') || Boolean(row.references?.length)} type={'error'} ghost size="small">
                    {$t('common.delete')}
                  </NButton>
                )
              }}
            </NPopconfirm>
            {row.source === 'blog' && <NPopconfirm onPositiveClick={() => handleMigrate(row.id)}>
              {{ default: () => '复制到当前配置的存储位置，校验后切换，原文件保留。', trigger: () =>
                <NButton size="small" loading={migrating.value === row.id} disabled={!hasAuth('tool:storage:migrate') || migrating.value !== null}>迁移</NButton> }}
            </NPopconfirm>}
          </div>
        )
      }
    ]
  });

const { checkedRowKeys, onBatchDeleted, onDeleted } = useTableOperate(data, getData);

async function handleDelete(id: number) {
  const { error } = await fetchDeleteStorageLocal([id]);
  if (!error) {
    onDeleted();
  }
}

async function batchDelete() {
  const { error } = await fetchDeleteStorageLocal(checkedRowKeys.value as number[]);
  if (!error) {
    onBatchDeleted();
  }
}
async function handleMigrate(id: number) {
  migrating.value = id;
  try {
    const { data: result, error } = await migrateBlogStorage(id);
    if (!error) {
      window.$message?.success(result?.migrated ? '迁移完成，原文件已保留' : '文件已在当前存储位置');
      await getData();
    }
  } finally { migrating.value = null; }
}
</script>

<template>
  <div class="min-h-500px flex-col-stretch gap-16px overflow-hidden lt-sm:overflow-auto">
    <StoragePreview :file="previewFile" @close="previewFile = null" />
    <NCard title="文件管理" :bordered="false" size="small" class="flex-1 card-wrapper">
      <div class="h-full flex-col-stretch">
        <SearchForm
          v-model:model="searchParams"
          :fields="storageLocalSearchForm"
          @search="getDataByPage"
          @reset="resetSearchParams"
        />
        <TableHeaderOperation
          v-model:columns="columnChecks"
          prefix="tool:storage"
          :hide-add="true"
          :loading="loading"
          :disabled-delete="checkedRowKeys.length === 0"
          @delete="batchDelete"
          @refresh="getData"
        />
        <NDataTable
          v-model:checked-row-keys="checkedRowKeys"
          :scroll-x="1900"
          :columns="columns"
          :data="data"
          size="small"
          flex-height
          :loading="loading"
          :pagination="pagination"
          remote
          :row-key="row => row.id"
          class="min-h-300px flex-1"
        />
      </div>
    </NCard>
  </div>
</template>

<style scoped></style>
