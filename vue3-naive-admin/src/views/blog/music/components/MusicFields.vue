<script setup lang="ts">
import type { Content } from "@/service/api/blog";
defineProps<{ form: Content }>();
</script>

<template>
  <section class="form-section">
    <div class="form-section__heading"><h2>音乐信息</h2></div>
    <div class="form-section__fields">
      <NFormItem label="歌手">
        <NInput
          v-model:value="form.metadata.artist"
          placeholder="填写歌手或演奏者"
        />
      </NFormItem>
      <NFormItem label="歌词（支持 LRC）">
        <NInput
          v-model:value="form.metadata.lyrics"
          type="textarea"
          :autosize="{ minRows: 4, maxRows: 8 }"
          placeholder="可选，支持 LRC 时间轴格式"
        />
      </NFormItem>
    </div>
  </section>
</template>
