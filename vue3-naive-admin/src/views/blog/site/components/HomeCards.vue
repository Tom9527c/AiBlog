<script setup lang="ts">
import type { Site } from "@/service/api/blog";
import SiteImageField from "./site-image-field.vue";
const props = defineProps<{ form: Site; locked: boolean; uploads: number }>();
const emit = defineEmits<{ uploading: [value: boolean] }>();
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
function trackUpload(value: boolean) {
  emit("uploading", value);
}
</script>

<template>
  <section class="settings-card">
    <div class="section-heading section-heading--action">
      <div>
        <h2>
          首页卡片
          <span class="heading-count">{{ form.homeCards.length }} / 30</span>
        </h2>
        <p>用于首页推荐内容，按下方顺序展示</p>
      </div>
      <NButton
        secondary
        type="primary"
        :disabled="locked || form.homeCards.length >= 30"
        @click="
          form.homeCards.push({
            title: '',
            description: '',
            image: '',
            url: '',
          })
        "
      >
        <template #icon><SvgIcon icon="lucide:plus" /></template>
        添加卡片
      </NButton>
    </div>
    <NEmpty
      v-if="!form.homeCards.length"
      description="还没有首页卡片，添加一张来推荐你的内容吧"
      class="list-empty"
    />
    <div class="cards-grid">
      <article
        v-for="(card, index) in form.homeCards"
        :key="rowKey(card)"
        class="entry-card"
      >
        <div class="entry-heading">
          <span class="entry-number">{{
            String(index + 1).padStart(2, "0")
          }}</span>
          <strong>{{ card.title || "新卡片" }}</strong>
          <div class="entry-actions">
            <NButton
              quaternary
              circle
              size="small"
              :aria-label="`上移卡片 ${index + 1}`"
              :disabled="locked || !!uploads || index === 0"
              @click="move(form.homeCards, index, -1)"
            >
              <template #icon><SvgIcon icon="lucide:arrow-up" /></template>
            </NButton>
            <NButton
              quaternary
              circle
              size="small"
              :aria-label="`下移卡片 ${index + 1}`"
              :disabled="
                locked || !!uploads || index === form.homeCards.length - 1
              "
              @click="move(form.homeCards, index, 1)"
            >
              <template #icon><SvgIcon icon="lucide:arrow-down" /></template>
            </NButton>
            <NPopconfirm @positive-click="remove(form.homeCards, card)">
              <template #trigger>
                <NButton
                  quaternary
                  circle
                  size="small"
                  type="error"
                  :aria-label="`删除卡片 ${index + 1}`"
                  :disabled="locked || !!uploads"
                >
                  <template #icon><SvgIcon icon="lucide:trash-2" /></template>
                </NButton>
              </template>
              移除这张卡片？保存后生效。
            </NPopconfirm>
          </div>
        </div>
        <SiteImageField
          v-model="card.image"
          :label="`卡片 ${index + 1} 封面`"
          wide
          :maxlength="2000"
          :disabled="locked"
          @uploading="trackUpload"
        />
        <div class="entry-fields">
          <NFormItem label="卡片标题">
            <NInput
              v-model:value="card.title"
              :maxlength="2000"
              placeholder="输入标题"
            />
          </NFormItem>
          <NFormItem label="卡片说明">
            <NInput
              v-model:value="card.description"
              :maxlength="2000"
              type="textarea"
              :autosize="{ minRows: 2, maxRows: 4 }"
              placeholder="简单介绍推荐内容"
            />
          </NFormItem>
          <NFormItem label="跳转地址">
            <NInput
              v-model:value="card.url"
              :maxlength="2000"
              placeholder="https:// 或 /站内路径"
            />
          </NFormItem>
        </div>
      </article>
    </div>
  </section>
</template>
