<script setup lang="tsx">
import { onMounted, onUnmounted, shallowRef, watch } from 'vue';
import * as VTableGantt from '@visactor/vtable-gantt';
import * as VTable_editors from '@visactor/vtable-editors';
import { useThemeStore } from '@/store/modules/theme';
import { basicGanttOption } from './basic-options';
import { linkGanttOption } from './linked-options';
import { customGanttOption } from './custom-options';

const theme = useThemeStore();

const input_editor = new VTable_editors.InputEditor();
const date_input_editor = new VTable_editors.DateInputEditor();
VTableGantt.VTable.register.editor('input', input_editor);
VTableGantt.VTable.register.editor('date-input', date_input_editor);

const basicGanttDomRef = shallowRef<HTMLElement>();
const linkGanttDomRef = shallowRef<HTMLElement>();
const customGanttDomRef = shallowRef<HTMLElement>();

const basicGanttInstance = shallowRef<VTableGantt.Gantt>();
const linkGanttInstance = shallowRef<VTableGantt.Gantt>();
const customGanttInstance = shallowRef<VTableGantt.Gantt>();

function initVTableGantt() {
  basicGanttInstance.value = new VTableGantt.Gantt(basicGanttDomRef.value as HTMLElement, getOption(basicGanttOption));
  linkGanttInstance.value = new VTableGantt.Gantt(linkGanttDomRef.value as HTMLElement, getOption(linkGanttOption));
  customGanttInstance.value = new VTableGantt.Gantt(
    customGanttDomRef.value as HTMLElement,
    getOption(customGanttOption)
  );
}

function getOption(option: VTableGantt.GanttConstructorOptions) {
  const isDark = theme.darkMode;
  if (isDark) {
    option.taskListTable!.theme = VTableGantt.VTable.themes.DARK;
    option.timelineHeader.backgroundColor = '#212121';
    option.underlayBackgroundColor = '#000';
  } else {
    option.taskListTable!.theme = VTableGantt.VTable.themes.DEFAULT;
    option.timelineHeader.backgroundColor = '#f0f0fb';
    option.underlayBackgroundColor = '#fff';
  }

  return option;
}

const stopHandle = watch(
  () => theme.darkMode,
  _newValue => {
    basicGanttInstance.value?.release();
    linkGanttInstance.value?.release();
    customGanttInstance.value?.release();

    initVTableGantt();
  }
);

onMounted(() => {
  initVTableGantt();
});

onUnmounted(() => {
  stopHandle();
});
</script>

<template>
  <NSpace vertical :size="16">
    <NCard :bordered="false" title="VTableGantt" class="h-full card-wrapper">
      <WebSiteLink label="More Demos: " link="https://www.visactor.com/vtable/example" />
    </NCard>
    <NCard :bordered="false" class="h-full card-wrapper">
      <div ref="basicGanttDomRef" class="relative h-400px"></div>
    </NCard>
    <NCard :bordered="false" class="h-full card-wrapper">
      <div ref="linkGanttDomRef" class="relative h-400px"></div>
    </NCard>
    <NCard :bordered="false" class="h-full card-wrapper">
      <div ref="customGanttDomRef" class="relative h-400px"></div>
    </NCard>
  </NSpace>
</template>
