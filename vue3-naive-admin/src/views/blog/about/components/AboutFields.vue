<script setup lang="ts">
import type { Content } from "@/service/api/blog";
import MediaField from "../../components/media-field.vue";
defineProps<{ form: Content }>();
</script>

<template>
  <section class="form-section">
    <div class="form-section__heading"><h2>个人资料</h2></div>
    <div class="form-section__fields">
      <NGrid cols="1 640:2" :x-gap="16" :y-gap="12">
        <NFormItem label="姓名"
          ><NInput v-model:value="form.metadata.name" placeholder="例如：Tom"
        /></NFormItem>
        <NFormItem label="职业称呼"
          ><NInput
            v-model:value="form.metadata.role"
            placeholder="例如：前端工程师"
        /></NFormItem>
        <NFormItem label="居住地"
          ><NInput
            v-model:value="form.metadata.location"
            placeholder="例如：中国，广州"
        /></NFormItem>
        <NFormItem label="职业经历概述"
          ><NInput
            v-model:value="form.metadata.career"
            placeholder="例如：EDU，软件工程专业"
        /></NFormItem>
        <NFormItem label="专业"
          ><NInput
            v-model:value="form.metadata.profession"
            placeholder="例如：软件工程"
        /></NFormItem>
        <NFormItem label="现在职业"
          ><NInput
            v-model:value="form.metadata.currentJob"
            placeholder="例如：社畜"
        /></NFormItem>
        <NFormItem label="性格类型"
          ><NInput
            v-model:value="form.metadata.personality"
            placeholder="例如：执政官"
        /></NFormItem>
        <NFormItem label="人格代码"
          ><NInput
            v-model:value="form.metadata.personalityCode"
            placeholder="例如：ESFJ-A"
        /></NFormItem>
      </NGrid>
      <NFormItem label="头像旁标签"
        ><NDynamicTags v-model:value="form.metadata.profileTags"
      /></NFormItem>
      <NFormItem label="出生年份（选填）">
        <NInputNumber
          v-model:value="form.metadata.birthYear"
          class="w-full"
          :min="1900"
          :max="new Date().getFullYear()"
          :precision="0"
          clearable
        />
      </NFormItem>
      <NFormItem label="技能"
        ><NDynamicTags v-model:value="form.metadata.skills"
      /></NFormItem>
      <NFormItem label="社交链接">
        <NDynamicInput
          v-model:value="form.metadata.socials"
          :on-create="() => ({ label: '', url: '' })"
        >
          <template #default="{ value }">
            <NSpace>
              <NInput v-model:value="value.label" placeholder="名称" />
              <NInput v-model:value="value.url" placeholder="网址" />
            </NSpace>
          </template>
        </NDynamicInput>
      </NFormItem>
      <NFormItem label="个人经历">
        <NDynamicInput
          v-model:value="form.metadata.experiences"
          :on-create="() => ({ title: '', description: '', date: '' })"
        >
          <template #default="{ value }">
            <NSpace vertical>
              <NInput v-model:value="value.title" placeholder="经历标题" />
              <NInput v-model:value="value.date" placeholder="时间" />
              <NInput v-model:value="value.description" placeholder="描述" />
            </NSpace>
          </template>
        </NDynamicInput>
      </NFormItem>
      <NFormItem label="展示卡片">
        <NDynamicInput
          v-model:value="form.metadata.cards"
          :on-create="
            () => ({ title: '', description: '', url: '', image: '' })
          "
        >
          <template #default="{ value }">
            <NSpace vertical>
              <NInput v-model:value="value.title" placeholder="标题" />
              <NInput v-model:value="value.description" placeholder="描述" />
              <NInput v-model:value="value.url" placeholder="跳转地址" />
              <MediaField v-model="value.image" />
            </NSpace>
          </template>
        </NDynamicInput>
      </NFormItem>
      <NFormItem label="打赏说明"
        ><NInput v-model:value="form.metadata.donationText"
      /></NFormItem>
      <NFormItem label="打赏二维码"
        ><MediaField v-model="form.metadata.donationImage"
      /></NFormItem>
      <NGrid cols="1 640:2" :x-gap="16" :y-gap="12">
        <NFormItem label="自拍图片"
          ><MediaField v-model="form.metadata.photo"
        /></NFormItem>
        <NFormItem label="地图背景"
          ><MediaField v-model="form.metadata.mapImage"
        /></NFormItem>
        <NFormItem label="原神卡片背景"
          ><MediaField v-model="form.metadata.gameImage"
        /></NFormItem>
        <NFormItem label="数码科技背景"
          ><MediaField v-model="form.metadata.technologyImage"
        /></NFormItem>
        <NFormItem label="音乐偏好背景"
          ><MediaField v-model="form.metadata.musicImage"
        /></NFormItem>
      </NGrid>
    </div>
  </section>
</template>
