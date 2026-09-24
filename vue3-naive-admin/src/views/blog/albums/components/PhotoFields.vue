<script setup lang="ts">
import type { Content } from "@/service/api/blog";
defineProps<{ form: Content }>();
</script>

<template>
  <NGrid cols="1 480:2" :x-gap="16" :y-gap="12">
    <NFormItemGi label="宽度 px">
      <NInputNumber
        v-model:value="form.metadata.width"
        class="w-full"
        :min="0"
        :precision="0"
      />
    </NFormItemGi>
    <NFormItemGi label="高度 px">
      <NInputNumber
        v-model:value="form.metadata.height"
        class="w-full"
        :min="0"
        :precision="0"
      />
    </NFormItemGi>
  </NGrid>
</template>
