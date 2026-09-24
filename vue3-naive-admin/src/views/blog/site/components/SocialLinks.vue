<script setup lang="ts">
import type { Site } from "@/service/api/blog";
const props = defineProps<{ form: Site; locked: boolean; uploads: number }>();
const rowIds = new WeakMap<object, number>();
let nextId = 0;
function rowKey(row: object) {
  if (!rowIds.has(row)) rowIds.set(row, ++nextId);
  return rowIds.get(row)!;
}
function move<T>(rows: T[], index: number, step: number) {
  if (props.locked || props.uploads) return;
  const target = index + step;
  if (target < 0 || target >= rows.length) return;
  const [row] = rows.splice(index, 1);
  rows.splice(target, 0, row);
}
function remove<T>(rows: T[], row: T) {
  if (props.locked || props.uploads) return;
  const index = rows.indexOf(row);
  if (index !== -1) rows.splice(index, 1);
}
</script>

<template>
  <section class="settings-card">
    <div class="section-heading section-heading--action">
      <div>
        <h2>
          社交链接
          <span class="heading-count">{{ form.socials.length }} / 30</span>
        </h2>
        <p>让访客在其他地方找到你，按下方顺序展示</p>
      </div>
      <NButton
        secondary
        type="primary"
        :disabled="locked || form.socials.length >= 30"
        @click="form.socials.push({ label: '', url: '' })"
      >
        <template #icon><SvgIcon icon="lucide:plus" /></template>
        添加链接
      </NButton>
    </div>
    <NEmpty
      v-if="!form.socials.length"
      description="还没有社交链接，添加你的社交主页吧"
      class="list-empty"
    />
    <div class="social-list">
      <div
        v-for="(social, index) in form.socials"
        :key="rowKey(social)"
        class="social-row"
      >
        <span class="entry-number">{{
          String(index + 1).padStart(2, "0")
        }}</span>
        <NFormItem label="名称">
          <NInput
            v-model:value="social.label"
            :maxlength="2000"
            placeholder="如：GitHub"
          />
        </NFormItem>
        <NFormItem label="链接地址">
          <NInput
            v-model:value="social.url"
            :maxlength="2000"
            placeholder="https:// 或 /站内路径"
          />
        </NFormItem>
        <div class="entry-actions">
          <NButton
            quaternary
            circle
            :aria-label="`上移链接 ${index + 1}`"
            :disabled="locked || !!uploads || index === 0"
            @click="move(form.socials, index, -1)"
          >
            <template #icon><SvgIcon icon="lucide:arrow-up" /></template>
          </NButton>
          <NButton
            quaternary
            circle
            :aria-label="`下移链接 ${index + 1}`"
            :disabled="locked || !!uploads || index === form.socials.length - 1"
            @click="move(form.socials, index, 1)"
          >
            <template #icon><SvgIcon icon="lucide:arrow-down" /></template>
          </NButton>
          <NPopconfirm @positive-click="remove(form.socials, social)">
            <template #trigger>
              <NButton
                quaternary
                circle
                type="error"
                :aria-label="`删除链接 ${index + 1}`"
                :disabled="locked"
              >
                <template #icon><SvgIcon icon="lucide:trash-2" /></template>
              </NButton>
            </template>
            移除这个链接？保存后生效。
          </NPopconfirm>
        </div>
      </div>
    </div>
  </section>
</template>
