<script setup lang="ts">
import type { Kind } from "@/service/api/blog";
import { states, statuses } from "../content-config";
defineProps<{
  kind: Kind;
  total: number;
  canList: boolean;
  categories: { label: string; value: number }[];
  tags: { label: string; value: number }[];
  parents: { label: string; value: number }[];
}>();
const emit = defineEmits<{ search: [] }>();
const keyword = defineModel<string>("keyword", { required: true });
const status = defineModel<string | null>("status", { required: true });
const filterParent = defineModel<number | null>("filterParent", {
  required: true,
});
const filterCategory = defineModel<number | null>("filterCategory", {
  required: true,
});
const filterTag = defineModel<number | null>("filterTag", { required: true });
const filterState = defineModel<string | null>("filterState", {
  required: true,
});
</script>

<template>
  <section class="manager-card manager-card--filters">
    <div class="toolbar-header">
      <div>
        <h2>筛选内容</h2>
        <p>按标题、状态和关联信息快速定位内容</p>
      </div>
      <span class="toolbar-result">{{ total }} 条结果</span>
    </div>
    <div class="manager-toolbar">
      <div class="toolbar-fields">
        <NInput
          v-model:value="keyword"
          class="filter-keyword"
          placeholder="搜索标题、摘要"
          clearable
          @keyup.enter="emit('search')"
        >
          <template #prefix><SvgIcon icon="lucide:search" /></template>
        </NInput>
        <NSelect
          v-model:value="status"
          :options="statuses"
          clearable
          placeholder="发布状态"
          class="filter-status"
        />
        <NSelect
          v-if="kind === 'documents'"
          v-model:value="filterCategory"
          :options="categories"
          clearable
          placeholder="分类"
          class="filter-relation"
        />
        <NSelect
          v-if="kind === 'documents'"
          v-model:value="filterTag"
          :options="tags"
          clearable
          placeholder="标签"
          class="filter-relation"
        />
        <NSelect
          v-if="kind === 'photos'"
          v-model:value="filterParent"
          :options="parents"
          clearable
          placeholder="所属相册"
          class="filter-album"
        />
        <NSelect
          v-if="kind === 'bangumis'"
          v-model:value="filterState"
          :options="states"
          clearable
          placeholder="观看状态"
          class="filter-state"
        />
      </div>
      <NButton
        secondary
        type="primary"
        :disabled="!canList"
        @click="emit('search')"
      >
        <template #icon><SvgIcon icon="lucide:search" /></template>
        查询
      </NButton>
    </div>
  </section>
</template>
