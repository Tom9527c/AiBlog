<script setup lang="ts">
import type { Content, Kind } from "@/service/api/blog";
import MediaField from "../../components/media-field.vue";
defineProps<{ kind: Kind; form: Content }>();
</script>

<template>
  <section class="form-section">
    <div class="form-section__heading"><h2>媒体素材</h2></div>
    <div class="form-section__fields">
      <NFormItem label="封面 / 图标">
        <MediaField v-model="form.cover" />
      </NFormItem>
      <NFormItem
        v-if="
          [
            'photos',
            'music',
            'links',
            'collections',
            'bangumis',
            'moments',
          ].includes(kind)
        "
        :label="kind === 'music' ? '音频文件' : '图片 / 跳转地址'"
      >
        <MediaField
          v-if="kind === 'photos' || kind === 'music'"
          v-model="form.url"
          :audio="kind === 'music'"
        />
        <NInput
          v-else
          v-model:value="form.url"
          placeholder="https:// 或 /站内路径"
        />
      </NFormItem>
    </div>
  </section>
</template>
