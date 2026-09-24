<script setup lang="ts">
import type { Content } from "@/service/api/blog";
defineProps<{ form: Content }>();
</script>

<template>
  <NGrid cols="1 480:2 760:3" :x-gap="16" :y-gap="12">
    <NFormItemGi label="收藏分类">
      <NSelect
        v-model:value="form.metadata.category"
        :options="[
          { label: '电影', value: '电影' },
          { label: '小说', value: '小说' },
          { label: '游戏', value: '游戏' },
          { label: '音乐', value: '音乐' },
          { label: '其他', value: '其他' },
        ]"
      />
    </NFormItemGi>
    <NFormItemGi label="分类图标">
      <NSelect
        v-model:value="form.metadata.icon"
        :options="[
          { label: '电影（film）', value: 'film' },
          { label: '小说（book）', value: 'book' },
          { label: '游戏（game）', value: 'game' },
          { label: '音乐（music）', value: 'music' },
          { label: '其他（box）', value: 'box' },
        ]"
      />
    </NFormItemGi>
    <NFormItemGi label="星级评分">
      <NInputNumber
        v-model:value="form.metadata.rating"
        class="w-full"
        :min="0"
        :max="5"
        :precision="0"
      />
    </NFormItemGi>
  </NGrid>
</template>
