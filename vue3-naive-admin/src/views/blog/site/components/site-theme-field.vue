<script setup lang="ts">
import type { Site } from '@/service/api/blog';

defineProps<{ disabled?: boolean }>();
const model = defineModel<Site['defaultTheme']>({ required: true });
const options = [
  { value: 'system', label: '跟随系统', icon: 'lucide:monitor' },
  { value: 'light', label: '浅色模式', icon: 'lucide:sun' },
  { value: 'dark', label: '深色模式', icon: 'lucide:moon' }
] as const;
</script>

<template>
  <fieldset class="theme-options" :disabled="disabled">
    <legend class="sr-only">博客默认主题</legend>
    <label v-for="option in options" :key="option.value" class="theme-option">
      <input v-model="model" type="radio" name="site-default-theme" :value="option.value" />
      <span class="theme-option-content">
        <span class="theme-preview" :class="`theme-preview--${option.value}`" aria-hidden="true">
          <span class="preview-toolbar"><i /><i /><i /></span>
          <span class="preview-layout">
            <span class="preview-sidebar"><i /><i /><i /></span>
            <span class="preview-content"><i /><i /><i /></span>
          </span>
        </span>
        <span class="theme-label">
          <SvgIcon :icon="option.icon" />
          <span>{{ option.label }}</span>
          <span class="theme-check" aria-hidden="true" />
        </span>
      </span>
    </label>
  </fieldset>
</template>

<style scoped>
.theme-options {
  display: grid;
  width: 100%;
  min-width: 0;
  grid-template-columns: repeat(3, minmax(0, 1fr));
  margin: 0;
  padding: 0;
  gap: 10px;
  border: 0;
}
.theme-option {
  position: relative;
  min-width: 0;
  cursor: pointer;
}
.theme-option input {
  position: absolute;
  width: 1px;
  height: 1px;
  opacity: 0;
}
.theme-option-content {
  display: block;
  padding: 7px;
  border: 1px solid var(--site-border);
  border-radius: 10px;
  transition: border-color 0.15s, background 0.15s;
}
.theme-option:hover .theme-option-content,
.theme-option input:checked + .theme-option-content {
  border-color: var(--site-primary);
  background: var(--site-primary-soft);
}
.theme-option input:focus-visible + .theme-option-content {
  outline: 2px solid var(--site-primary);
  outline-offset: 3px;
}
.theme-options:disabled {
  opacity: 0.6;
}
.theme-options:disabled .theme-option {
  cursor: not-allowed;
}
.theme-preview {
  --preview-background: #f4f6fa;
  --preview-surface: #fff;
  --preview-line: #dbe1eb;
  display: block;
  overflow: hidden;
  height: 74px;
  border: 1px solid #8794ab26;
  border-radius: 5px;
  background: var(--preview-background);
}
.theme-preview--dark {
  --preview-background: #22252d;
  --preview-surface: #30343e;
  --preview-line: #535d70;
}
.theme-preview--system {
  background: linear-gradient(115deg, #f4f6fa 50%, #22252d 50%);
}
.theme-preview--system .preview-toolbar {
  background: linear-gradient(115deg, #fff 61%, #30343e 61%);
}
.theme-preview--system .preview-content {
  background: #535d7055;
}
.preview-toolbar {
  display: flex;
  height: 15px;
  align-items: center;
  padding: 0 5px;
  gap: 3px;
  background: var(--preview-surface);
}
.preview-toolbar i {
  width: 3px;
  height: 3px;
  border-radius: 50%;
  background: #94a3b8;
}
.preview-layout {
  display: flex;
  height: 59px;
  padding: 7px;
  gap: 7px;
}
.preview-sidebar {
  display: grid;
  width: 18%;
  align-content: start;
  padding-top: 4px;
  gap: 5px;
}
.preview-sidebar i,
.preview-content i {
  height: 3px;
  border-radius: 2px;
  background: var(--preview-line);
}
.preview-sidebar i:first-child {
  background: var(--site-primary);
}
.preview-content {
  display: grid;
  flex: 1;
  align-content: start;
  padding: 7px;
  gap: 5px;
  border-radius: 3px;
  background: var(--preview-surface);
}
.preview-content i:first-child {
  width: 65%;
  height: 7px;
  margin-bottom: 3px;
  background: var(--site-primary);
  opacity: 0.7;
}
.theme-label {
  display: flex;
  min-height: 32px;
  align-items: center;
  padding: 6px 2px 0;
  gap: 5px;
  color: var(--site-muted);
  font-size: 12px;
  white-space: nowrap;
}
.theme-label > svg {
  flex-shrink: 0;
  font-size: 14px;
}
.theme-check {
  width: 12px;
  height: 12px;
  flex-shrink: 0;
  margin-left: auto;
  border: 1px solid var(--site-border);
  border-radius: 50%;
}
input:checked + .theme-option-content .theme-label {
  color: var(--site-primary);
}
input:checked + .theme-option-content .theme-check {
  border: 4px solid var(--site-primary);
  background: var(--site-card);
}
@container site-settings (max-width: 420px) {
  .theme-options {
    gap: 6px;
  }
  .theme-label > svg {
    display: none;
  }
}
</style>
