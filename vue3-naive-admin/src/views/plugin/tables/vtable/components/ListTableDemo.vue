<script setup lang="tsx">
import { computed, ref } from "vue";
import { VTable } from "@visactor/vue-vtable";
import { useThemeStore } from "@/store/modules/theme";
import { ListTable, ListColumn } from "@visactor/vue-vtable";
import { listTableRecords } from "../data";
const themeStore = useThemeStore();
// list table
const listTableRef = ref(null);
const listOptions = computed(() => {
  const options = {
    theme: themeStore.darkMode ? VTable.themes.DARK : VTable.themes.DEFAULT,
  };
  return options;
});
const listRecords = ref<Record<string, string | number>[]>(listTableRecords);
</script>

<template>
  <NCard title="List Table" :bordered="false" class="h-full w-2/3 card-wrapper">
    <ListTable
      ref="listTableRef"
      :options="listOptions"
      :records="listRecords"
      height="400px"
    >
      <ListColumn field="Order ID" title="Order ID" width="auto" />
      <ListColumn field="Customer ID" title="Customer ID" width="auto" />
      <ListColumn field="Product Name" title="Product Name" width="auto" />
      <ListColumn field="Category" title="Category" width="auto" />
      <ListColumn field="Sub-Category" title="Sub-Category" width="auto" />
      <ListColumn field="Region" title="Region" width="auto" />
      <ListColumn field="City" title="City" width="auto" />
      <ListColumn field="Order Date" title="Order Date" width="auto" />
      <ListColumn field="Quantity" title="Quantity" width="auto" />
      <ListColumn field="Sales" title="Sales" width="auto" />
      <ListColumn field="Profit" title="Profit" width="auto" />
    </ListTable>
  </NCard>
</template>
