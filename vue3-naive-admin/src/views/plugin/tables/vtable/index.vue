<script setup lang="ts">
import ListTableDemo from "./components/ListTableDemo.vue";
import GroupTableDemo from "./components/GroupTableDemo.vue";
import PivotTableDemo from "./components/PivotTableDemo.vue";
import PivotChartDemo from "./components/PivotChartDemo.vue";
import CustomLayoutDemo from "./components/CustomLayoutDemo.vue";
</script>

<template>
  <div class="h-full">
    <NSpace vertical :size="16">
      <ListTableDemo />

      <GroupTableDemo />

      <PivotTableDemo />

      <PivotChartDemo />

      <CustomLayoutDemo />

      <NCard :bordered="false" class="h-full w-2/3 card-wrapper">
        <WebSiteLink
          label="More VTable Demos: "
          link="https://www.visactor.com/vtable/example"
        />
      </NCard>
    </NSpace>
  </div>
</template>
