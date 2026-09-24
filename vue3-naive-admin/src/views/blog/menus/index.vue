<script setup lang="ts">
import { computed, h, onMounted, ref } from "vue";
import { NButton, NPopconfirm, NSpace } from "naive-ui";
import { type Menu, api } from "@/service/api/blog";
import { useBlogAuth } from "@/hooks/business/blog-auth";
defineOptions({ name: "blog_menus" });
const { hasAuth } = useBlogAuth();
const rows = ref<Menu[]>([]);
const busy = ref(false);
const show = ref(false);
const error = ref("");
const empty = (): Menu => ({
  id: 0,
  parentId: null,
  title: "",
  path: "",
  icon: "",
  sort: 0,
  enabled: true,
  external: false,
  newWindow: false,
});
const form = ref(empty());
type Node = Menu & { children?: Node[] };
const tree = computed(() => {
  const build = (parentId: number | null): Node[] =>
    rows.value
      .filter((row) => row.parentId === parentId)
      .map((row) => {
        const children = build(row.id);
        return { ...row, ...(children.length ? { children } : {}) };
      });
  return build(null);
});
const parentOptions = computed(() => {
  const excluded = new Set([form.value.id]);
  let size = -1;
  while (size !== excluded.size) {
    size = excluded.size;
    rows.value.forEach((row) => {
      if (row.parentId && excluded.has(row.parentId)) excluded.add(row.id);
    });
  }
  return rows.value
    .filter((row) => !excluded.has(row.id))
    .map((row) => ({ label: row.title, value: row.id }));
});
const columns = [
  { title: "菜单标题", key: "title" },
  { title: "路径", key: "path" },
  { title: "排序", key: "sort" },
  {
    title: "启用",
    key: "enabled",
    render: (row: Menu) => (row.enabled ? "是" : "否"),
  },
  {
    title: "操作",
    key: "action",
    render: (row: Menu) =>
      h(NSpace, {}, () => [
        h(
          NButton,
          {
            size: "small",
            disabled: !hasAuth("blog:menus:update"),
            onClick: () => edit(row),
          },
          () => "编辑",
        ),
        h(
          NPopconfirm,
          { onPositiveClick: () => remove(row.id) },
          {
            trigger: () =>
              h(
                NButton,
                {
                  size: "small",
                  type: "error",
                  disabled: !hasAuth("blog:menus:delete"),
                },
                () => "删除",
              ),
            default: () => "确认删除菜单？请先移除子菜单。",
          },
        ),
      ]),
  },
];
async function load() {
  busy.value = true;
  try {
    rows.value = await api<Menu[]>("menus");
    error.value = "";
  } catch {
    error.value = "加载失败，请重试";
  } finally {
    busy.value = false;
  }
}
function edit(row?: Menu) {
  form.value = row ? { ...row } : empty();
  error.value = "";
  show.value = true;
}
async function save() {
  if (!form.value.title.trim() || (form.value.external && !form.value.path.trim())) {
    error.value = "请填写菜单标题；外链必须填写地址";
    return;
  }
  busy.value = true;
  try {
    const { id, ...data } = form.value;
    await api(`menus${id ? `/${id}` : ""}`, id ? "put" : "post", data);
    show.value = false;
    await load();
  } catch {
    error.value = "保存失败，请检查路径和父级关联";
  } finally {
    busy.value = false;
  }
}
async function remove(id: number) {
  try {
    await api(`menus/${id}`, "delete");
    await load();
  } catch {
    error.value = "删除失败，请先删除子菜单";
  }
}
onMounted(load);
</script>

<template>
  <div>
    <NCard title="前台菜单管理">
      <NSpace class="mb-4">
        <NButton
          type="primary"
          :disabled="!hasAuth('blog:menus:create')"
          @click="edit()"
          >新增菜单</NButton
        >
        <NButton @click="load">刷新</NButton>
      </NSpace>
      <NAlert v-if="error && !show" type="error">{{ error }}</NAlert>
      <NDataTable
        :columns="columns"
        :data="tree"
        :row-key="(row: Menu) => row.id"
        :loading="busy"
        default-expand-all
        :scroll-x="650"
      />
    </NCard>
    <NModal
      v-model:show="show"
      preset="card"
      title="编辑前台菜单"
      style="width: min(600px, 95vw)"
    >
      <NAlert v-if="error" type="error">{{ error }}</NAlert>
      <NForm label-placement="top">
        <NFormItem label="标题" required
          ><NInput v-model:value="form.title"
        /></NFormItem>
        <NFormItem label="父菜单">
          <NSelect
            v-model:value="form.parentId"
            :options="parentOptions"
            clearable
            filterable
          />
        </NFormItem>
        <NFormItem label="路径 / 外链（留空为分组）" :required="form.external">
          <NInput
            v-model:value="form.path"
            placeholder="留空只展开子菜单；或填写 /archives/、https://example.com"
          />
        </NFormItem>
        <NFormItem label="图标"><NInput v-model:value="form.icon" /></NFormItem>
        <NFormItem label="排序">
          <NInputNumber
            v-model:value="form.sort"
            :precision="0"
            :min="-100000"
            :max="100000"
          />
        </NFormItem>
        <NSpace>
          <NCheckbox v-model:checked="form.enabled">启用</NCheckbox>
          <NCheckbox v-model:checked="form.external">外部链接</NCheckbox>
          <NCheckbox v-model:checked="form.newWindow">新窗口打开</NCheckbox>
        </NSpace>
      </NForm>
      <template #footer>
        <NButton
          type="primary"
          :loading="busy"
          :disabled="
            !hasAuth(form.id ? 'blog:menus:update' : 'blog:menus:create')
          "
          @click="save"
        >
          保存
        </NButton>
      </template>
    </NModal>
  </div>
</template>
