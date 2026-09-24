<script setup lang="ts">
import type { Field } from '../modules/about-fields';
import SiteImageField from '../../site/components/site-image-field.vue';
const model = defineModel<any>();
defineProps<{ field: Field; disabled: boolean }>();
defineEmits<{ uploading: [active: boolean] }>();
</script>
<template>
  <NFormItem :label="field.label" :class="{ 'field-wide': ['image', 'lines', 'tags'].includes(field.type || '') }">
    <SiteImageField v-if="field.type === 'image'" v-model="model" :label="field.label" :disabled="disabled" @uploading="$emit('uploading', $event)" />
    <NDynamicTags v-else-if="field.type === 'tags'" v-model:value="model" :disabled="disabled" :max="16" />
    <NInputNumber v-else-if="field.type === 'number'" v-model:value="model" :min="1900" :max="new Date().getFullYear()" :precision="0" clearable :disabled="disabled" />
    <NInput v-else :value="model || ''" :type="field.type === 'lines' ? 'textarea' : 'text'" :autosize="field.type === 'lines' ? { minRows: 2, maxRows: 6 } : false" :maxlength="5000" :disabled="disabled" :input-props="{ 'aria-label': field.label }" @update:value="model = $event" />
  </NFormItem>
</template>
