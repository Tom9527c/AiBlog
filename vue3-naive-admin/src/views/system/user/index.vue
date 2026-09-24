<script setup lang="tsx">
import { createUserColumns } from './components/user-table-columns';
import { NAvatar, NButton, NPopconfirm, NTag } from 'naive-ui';
import { onMounted, ref } from 'vue';
import { useAppStore } from '@/store/modules/app';
import { useTable, useTableOperate } from '@/hooks/common/table';
import { fetchDeleteUser, fetchGetAllRole, fetchGetUserList, fetchUpdatedUserStatus } from '@/service/api';
import { enableStatusRecord, userGenderRecord } from '@/constants/business';
import { $t, getLocale } from '@/locales';
import { useAuth } from '@/hooks/business/auth';
import { generatePrefix } from '@/utils/common';
import { useUserSearchForm } from './modules/user-search-form';
import { useUserDetailColumns } from './components/user-detail-columns';
import { StatusEnum } from '@/constants/enum';
import UserOperateDrawer from './components/user-operate-drawer.vue';
import DeptTree from './components/dept-tree.vue';
import ResetPassword from './components/reset-password.vue';
const appStore = useAppStore();
const { hasAuth } = useAuth();

const userSearchForm = useUserSearchForm();
const detailColumns = useUserDetailColumns();

const showModal = ref<boolean>(false);
const resetId = ref<number | null>(null);

const {
  columns,
  columnChecks,
  data,
  loading,
  pagination,
  getDataByPage,
  getData,
  searchParams,
  resetSearchParams,
  scrollX
} = useTable({
  apiFn: fetchGetUserList,
  showTotal: true,
  apiParams: {
    currentPage: 1,
    pageSize: 10,
    // if you want to use the searchParams in Form, you need to define the following properties, and the value is null
    // the value can not be undefined, otherwise the property in Form will not be reactive
    status: null,
    username: null,
    gender: null,
    nickName: null,
    phone: null,
    email: null,
    deptIds: null,
    roleId: null
  },
  columns: () => createUserColumns({ detail, edit, changeStatus: handleChangeStatus, resetPassword: resetPasswordEvent, deleteUser, hasAuth })
});

const {
  drawerVisible,
  checkedRowKeys,
  operateType,
  editingData,
  handleAdd,
  handleEdit,
  modelVisible,
  detailData,
  handleDetail
} = useTableOperate(data, getData);

async function detail(id: number) {
  if (hasAuth('system:user:read')) {
    handleDetail(id);
  } else {
    window.$message?.error($t('common.noPermission'));
  }
}
function edit(id: number) {
  handleEdit(id);
}

async function deleteUser(id: number) {
  const { error } = await fetchDeleteUser(id);
  if (!error) {
    getDataByPage();
    window.$message?.success($t('common.deleteSuccess'));
  }
}

async function handleChangeStatus(id: number, status: number | null) {
  const { error } = await fetchUpdatedUserStatus({
    ids: [id],
    status: status ? 0 : 1
  });
  if (!error) {
    window.$message?.success($t('common.operateSuccess'));
  }
  // request
  getDataByPage();
}

async function resetPasswordEvent(id: number) {
  showModal.value = true;
  resetId.value = id;
}

async function handleBatchDChangeStatus() {
  const { error } = await fetchUpdatedUserStatus({
    ids: checkedRowKeys.value as number[],
    status: 0
  });
  if (!error) {
    window.$message?.success($t('common.operateSuccess'));
  }
  // request
  getDataByPage();
}

function change() {
  getDataByPage();
}

async function getAllRoles() {
  const { data: roleList, error } = await fetchGetAllRole();
  if (!error) {
    userSearchForm.value[4]!.props!.options = roleList.map(item => ({
      label: item.name,
      value: item.id
    }));
  }
}

function resetChange() {
  resetId.value = null;
}

onMounted(async () => {
  getAllRoles();
});
</script>

<template>
  <div class="min-h-500px flex-col-stretch gap-16px overflow-hidden lt-sm:overflow-auto">
    <NCard :bordered="false" size="small" class="flex-1 card-wrapper">
      <NSplit v-if="!appStore.isMobile" class="h-full" direction="horizontal" :default-size="0.2" :max="0.9" :min="0.1">
        <template #1>
          <DeptTree v-model:value="searchParams.deptIds" @change="change" />
        </template>
        <template #2>
          <div class="h-full flex-col-stretch">
            <SearchForm
              v-model:model="searchParams"
              :fields="userSearchForm"
              @search="getDataByPage"
              @reset="resetSearchParams"
            />
            <TableHeaderOperation
              v-model:columns="columnChecks"
              prefix="system:user"
              :hide-delete="true"
              :disabled-delete="checkedRowKeys.length === 0"
              :loading="loading"
              @add="handleAdd"
              @refresh="getData"
            >
              <NPopconfirm
                v-if="hasAuth(generatePrefix('system:user', 'update'))"
                @positive-click="handleBatchDChangeStatus"
              >
                <template #trigger>
                  <NButton type="error" ghost size="small" :disabled="checkedRowKeys.length === 0">
                    {{ $t('common.batchDisable') }}
                  </NButton>
                </template>
                {{ `${$t('common.batchDisable')}?` }}
              </NPopconfirm>
            </TableHeaderOperation>
            <NDataTable
              v-model:checked-row-keys="checkedRowKeys"
              :columns="columns"
              :data="data"
              size="small"
              flex-height
              :loading="loading"
              :pagination="pagination"
              :scroll-x="scrollX"
              remote
              :row-key="row => row.id"
              class="flex-1"
            />
          </div>
        </template>
      </NSplit>
      <div v-else class="h-full flex-col-stretch">
        <SearchForm
          v-model:model="searchParams"
          :fields="userSearchForm"
          @search="getDataByPage"
          @reset="resetSearchParams"
        />
        <TableHeaderOperation
          v-model:columns="columnChecks"
          prefix="system:user"
          :hide-delete="true"
          :disabled-delete="checkedRowKeys.length === 0"
          :loading="loading"
          @add="handleAdd"
          @refresh="getData"
        >
          <NPopconfirm
            v-if="hasAuth(generatePrefix('system:user', 'update'))"
            @positive-click="handleBatchDChangeStatus"
          >
            <template #trigger>
              <NButton type="error" ghost size="small" :disabled="checkedRowKeys.length === 0">
                {{ $t('common.batchDisable') }}
              </NButton>
            </template>
            {{ `${$t('common.batchDisable')}?` }}
          </NPopconfirm>
        </TableHeaderOperation>
        <NDataTable
          v-model:checked-row-keys="checkedRowKeys"
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
    <UserOperateDrawer
      v-model:visible="drawerVisible"
      :operate-type="operateType"
      :row-data="editingData"
      @submitted="getDataByPage"
    />
    <DetailsDescriptions
      v-model:visible="modelVisible"
      :title="$t('page.manage.user.detail')"
      width="60%"
      :fields="detailColumns"
      :label-style="{ width: '120px' }"
      :data="detailData"
    />

    <ResetPassword
      v-model:show="showModal"
      :reset-id="resetId"
      :title="$t('page.manage.user.resetPassword')"
      @change="resetChange"
    />
  </div>
</template>

<style scoped></style>
