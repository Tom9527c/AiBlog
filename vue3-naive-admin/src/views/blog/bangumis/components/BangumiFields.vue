<script setup lang="ts">
import type { Content } from "@/service/api/blog";
defineProps<{ form: Content }>();
const states = [
  { label: "想看", value: "wish" },
  { label: "在看", value: "watching" },
  { label: "看过", value: "finished" },
];
</script>

<template>
  <NGrid cols="1 480:2 760:3" :x-gap="16" :y-gap="12">
    <NFormItemGi label="观看状态">
      <NSelect v-model:value="form.metadata.state" :options="states" />
    </NFormItemGi>
    <NFormItemGi label="已看集数">
      <NInputNumber
        v-model:value="form.metadata.progress"
        class="w-full"
        :min="0"
        :precision="0"
      />
    </NFormItemGi>
    <NFormItemGi label="总集数">
      <NInputNumber
        v-model:value="form.metadata.total"
        class="w-full"
        :min="0"
        :precision="0"
      />
    </NFormItemGi>
    <NFormItemGi label="评分">
      <NInputNumber
        v-model:value="form.metadata.rating"
        class="w-full"
        :min="0"
        :max="10"
      />
    </NFormItemGi>
    <NFormItemGi label="地区">
      <NInput
        v-model:value="form.metadata.region"
        placeholder="例如：日本、中国大陆"
      />
    </NFormItemGi>
    <NFormItemGi label="番剧类型">
      <NInput
        v-model:value="form.metadata.type"
        placeholder="例如：TV、电影、国创"
      />
    </NFormItemGi>
    <NFormItemGi label="总播放">
      <NInputNumber
        v-model:value="form.metadata.plays"
        class="w-full"
        :min="0"
        :max="1000000000000"
        :precision="0"
      />
    </NFormItemGi>
    <NFormItemGi label="追番人数">
      <NInputNumber
        v-model:value="form.metadata.followers"
        class="w-full"
        :min="0"
        :max="1000000000000"
        :precision="0"
      />
    </NFormItemGi>
    <NFormItemGi label="硬币数">
      <NInputNumber
        v-model:value="form.metadata.coins"
        class="w-full"
        :min="0"
        :max="1000000000000"
        :precision="0"
      />
    </NFormItemGi>
    <NFormItemGi label="弹幕总数">
      <NInputNumber
        v-model:value="form.metadata.danmaku"
        class="w-full"
        :min="0"
        :max="1000000000000"
        :precision="0"
      />
    </NFormItemGi>
  </NGrid>
</template>
