<script setup lang="ts">
import type { Content, Kind } from "@/service/api/blog";
type Option = { label: string; value: number };
defineProps<{
  kind: Kind;
  form: Content;
  categories: Option[];
  tags: Option[];
  parents: Option[];
}>();
</script>

<template>
  <section class="form-section">
    <div class="form-section__heading"><h2>内容关联</h2></div>
    <div class="form-section__fields">
      <NGrid cols="1 480:2" :x-gap="16" :y-gap="12">
        <NFormItemGi v-if="kind === 'documents'" label="分类">
          <NSelect
            v-model:value="form.categoryId"
            :options="categories"
            filterable
            clearable
            placeholder="选择分类"
          />
        </NFormItemGi>
        <NFormItemGi v-if="kind === 'documents'" label="标签">
          <NSelect
            v-model:value="form.tagIds"
            :options="tags"
            multiple
            filterable
            placeholder="选择标签"
          />
        </NFormItemGi>
        <NFormItemGi
          v-if="kind === 'photos' || kind === 'comments'"
          :label="kind === 'photos' ? '所属相册' : '回复的评论'"
          :required="kind === 'photos'"
        >
          <NSelect
            v-model:value="form.parentId"
            :options="parents.filter((p) => p.value !== form.id)"
            clearable
            filterable
            :placeholder="
              kind === 'photos' ? '请选择所属相册' : '可选，选择要回复的评论'
            "
          />
        </NFormItemGi>
      </NGrid>
    </div>
  </section>
</template>
