<script setup lang="ts">
import type { Content, Kind } from "@/service/api/blog";
import BangumiFields from "../../bangumis/components/BangumiFields.vue";
import PhotoFields from "../../albums/components/PhotoFields.vue";
import CollectionFields from "../../collections/components/CollectionFields.vue";
defineProps<{ kind: Kind; form: Content }>();
</script>

<template>
  <section class="form-section">
    <div class="form-section__heading">
      <h2>
        {{
          kind === "bangumis"
            ? "追番信息"
            : kind === "collections"
              ? "收藏信息"
              : "展示设置"
        }}
      </h2>
    </div>
    <div class="form-section__fields">
      <BangumiFields v-if="kind === 'bangumis'" :form="form" />
      <PhotoFields v-if="kind === 'photos'" :form="form" />
      <CollectionFields v-if="kind === 'collections'" :form="form" />
      <NFormItem v-if="kind === 'tags'" label="展示颜色">
        <NColorPicker v-model:value="form.metadata.color" />
      </NFormItem>
      <NFormItem v-if="kind === 'albums'" label="展示布局">
        <NSelect
          v-model:value="form.metadata.layout"
          :options="[
            { label: '瀑布流', value: 'waterfall' },
            { label: '网格', value: 'grid' },
            { label: '画廊', value: 'gallery' },
          ]"
        />
      </NFormItem>
    </div>
  </section>
</template>
