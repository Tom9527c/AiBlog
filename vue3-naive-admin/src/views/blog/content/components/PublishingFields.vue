<script setup lang="ts">
import type { Content, Kind } from "@/service/api/blog";
import { statuses } from "../content-config";
defineProps<{ form: Content; previousAccess: string }>();
</script>

<template>
  <section class="form-section">
    <div class="form-section__heading"><h2>发布与访问</h2></div>
    <div class="form-section__fields">
      <NGrid cols="1 480:2 680:3" :x-gap="16" :y-gap="12">
        <NFormItemGi label="发布状态">
          <NSelect v-model:value="form.status" :options="statuses" />
        </NFormItemGi>
        <NFormItemGi label="访问规则">
          <NSelect
            v-model:value="form.accessMode"
            :options="[
              { label: '公开', value: 'public' },
              { label: '登录可见', value: 'login' },
              { label: '密码可见', value: 'password' },
            ]"
          />
        </NFormItemGi>

        <NFormItemGi label="发布时间">
          <NDatePicker
            :value="form.publishedAt ? Date.parse(form.publishedAt) : null"
            class="w-full"
            type="datetime"
            clearable
            @update:value="
              (v) => (form.publishedAt = v ? new Date(v).toISOString() : null)
            "
          />
        </NFormItemGi>
        <NFormItemGi
          v-if="form.accessMode === 'password'"
          label="访问密码"
          :required="!form.id || previousAccess !== 'password'"
        >
          <NInput
            v-model:value="form.password"
            type="password"
            show-password-on="click"
            placeholder="编辑时留空则保留原密码"
          />
        </NFormItemGi>
      </NGrid>
    </div>
  </section>
</template>
