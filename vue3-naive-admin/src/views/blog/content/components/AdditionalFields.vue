<script setup lang="ts">
import type { Content, Kind } from "@/service/api/blog";
import { names } from "../content-config";
defineProps<{ kind: Kind; form: Content }>();
</script>

<template>
  <section class="form-section">
    <div class="form-section__heading"><h2>补充信息</h2></div>
    <div class="form-section__fields">
      <NFormItem v-if="kind === 'moments'" label="动态来源名称">
        <NInput
          v-model:value="form.metadata.source"
          placeholder="例如：微博、朋友圈或个人记录"
        />
      </NFormItem>
      <NFormItem
        v-if="kind === 'comments'"
        label="评论所属内容类型（留空为留言板）"
      >
        <NSelect
          v-model:value="form.metadata.targetKind"
          :options="
            (['documents', 'albums', 'essays', 'about'] as Kind[]).map((k) => ({
              label: names[k],
              value: k,
            }))
          "
          clearable
          placeholder="选择内容类型"
        />
      </NFormItem>
      <NFormItem
        v-if="kind === 'comments' && form.metadata.targetKind"
        label="所属内容 ID"
      >
        <NInputNumber
          v-model:value="form.metadata.targetId"
          class="w-full"
          :min="1"
          :precision="0"
        />
      </NFormItem>
    </div>
  </section>
</template>
