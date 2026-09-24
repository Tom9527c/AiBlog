<script setup lang="tsx">
import { createMenuColumns } from './components/menu-table-columns';
import { NButton, NPopconfirm, NTag } from 'naive-ui';
import { Icon } from '@iconify/vue';
import { useTable, useTableOperate } from '@/hooks/common/table';
import { fetchDeleteMenu, fetchGetMenuList } from '@/service/api';
import { $t, getLocale } from '@/locales';
import { enableStatusRecord, menuIconTypeRecord, menuTypeRecord } from '@/constants/business';
import { useAuth } from '@/hooks/business/auth';
import SvgIcon from '@/components/custom/svg-icon.vue';
import { flatTreeData } from '@/utils/common';
import { useSearchForm } from '@/hooks/common/search-form';
import { useMenuDetailColumns } from './components/menu-detail-columns';
import { StatusEnum } from '@/constants/enum';
import MenuOperateDrawer from './components/menu-operate-drawer.vue';

const { hasAuth } = useAuth();

// 使用箭头函数可以保持 label的国际化响应式
const menuSearchForm = useSearchForm<Api.SystemManage.MenuSearchParams>(() => [
  {
    key: 'title',
    label: $t('page.manage.menu.menuName'),
    type: 'Input',
    props: {
      placeholder: $t('common.pleaseEnter') + $t('page.manage.menu.menuName')
    }
  },
  {
    key: 'path',
    label: $t('page.manage.menu.routePath'),
    type: 'Input',
    props: {
      placeholder: $t('common.pleaseEnter') + $t('page.manage.menu.routePath')
    }
  },
  {
    key: 'status',
    label: $t('common.status'),
    type: 'Select',
    props: {
      placeholder: $t('common.pleaseSelect') + $t('common.status'),
      options: [
        {
          label: $t('common.enable'),
          value: StatusEnum.ENABLE
        },
        {
          label: $t('common.disable'),
          value: StatusEnum.DISABLE
        }
      ]
    }
  }
]);

const {
  columns,
  columnChecks,
  data,
  loading,
  getDataByPage,
  getData,
  searchParams,
  resetSearchParams,
  toggleExpand,
  expandedRowKeys,
  isTreeTable
} = useTable({
  apiFn: fetchGetMenuList,
  showTotal: true,
  isTreeTable: true,
  apiParams: {
    currentPage: 1,
    pageSize: 999,
    title: '',
    name: '',
    path: '',
    status: null
  },
  columns: () => createMenuColumns({ detail, add, edit, deleteMenu: handleDelete, hasAuth })
});

const detailColumns = useMenuDetailColumns(isPermission, hideComponent);

const {
  drawerVisible,
  operateType,
  addingData,
  editingData,
  handleAdd,
  handleEdit,
  onDeleted,
  modelVisible,
  detailData,
  handleDetail
} = useTableOperate(data, getData);

function isPermission() {
  return detailData.value?.type === 2;
}

function hideComponent() {
  return detailData.value?.extOpenMode === 1;
}
async function detail({ id, parentId }: Api.SystemManage.Menu) {
  if (hasAuth('system:menu:read')) {
    const parentMenu = flatTreeData(data.value).find(item => item.id === parentId);
    handleDetail(id, {
      parentTitle: parentMenu?.title,
      parentI18Key: parentMenu?.i18nKey
    } as any);
  } else {
    window.$message?.error($t('common.noPermission'));
  }
}

function add(id: number, type: Api.SystemManage.MenuType) {
  handleAdd({
    parentId: id,
    type
  });
}

function edit(id: number) {
  handleEdit(id);
}

async function handleDelete(id: number) {
  const { error } = await fetchDeleteMenu(id);
  if (!error) {
    onDeleted();
  }
}
</script>

<template>
  <div class="min-h-500px flex-col-stretch gap-16px overflow-hidden lt-sm:overflow-auto">
    <NCard :bordered="false" size="small" class="flex-1 card-wrapper">
      <div class="h-full flex-col-stretch">
        <SearchForm
          v-model:model="searchParams"
          :fields="menuSearchForm"
          @search="getDataByPage"
          @reset="resetSearchParams"
        />
        <TableHeaderOperation
          v-model:columns="columnChecks"
          prefix="system:menu"
          :hide-delete="true"
          :loading="loading"
          :tree-table="isTreeTable"
          @add="handleAdd"
          @refresh="getData"
          @toggle-expand="toggleExpand"
        />
        <NDataTable
          v-model:expanded-row-keys="expandedRowKeys"
          :columns="columns"
          :data="data"
          size="small"
          :loading="loading"
          remote
          flex-height
          virtual-scroll
          :row-key="row => row.id"
          class="min-h-300px flex-1"
        />
      </div>
    </NCard>
    <MenuOperateDrawer
      v-model:visible="drawerVisible"
      :operate-type="operateType"
      :add-data="addingData"
      :edit-data="editingData"
      @submitted="getDataByPage"
    />
    <DetailsDescriptions
      v-model:visible="modelVisible"
      :title="$t('page.manage.menu.detail')"
      width="60%"
      :fields="detailColumns"
      :data="detailData"
      :label-style="{ width: '120px' }"
    />
  </div>
</template>

<style scoped></style>
