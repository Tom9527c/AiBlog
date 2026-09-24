<script setup lang="tsx">
import { computed, ref } from "vue";
import { VTable } from "@visactor/vue-vtable";
import { useThemeStore } from "@/store/modules/theme";
import { ListTable, ListColumn } from "@visactor/vue-vtable";
import { listTableRecords } from "../data";
const themeStore = useThemeStore();
const titleColorPool = ["#3370ff", "#34c724", "#ff9f1a", "#ff4050", "#1f2329"];
// group table
const groupTableRef = ref(null);
const groupOptions = computed(() => {
  const options = {
    groupBy: ["Category", "Sub-Category"],
    theme: (themeStore.darkMode
      ? VTable.themes.DARK
      : VTable.themes.DEFAULT
    ).extends({
      groupTitleStyle: {
        fontWeight: "bold",
        bgColor: (args: any) => {
          const { col, row, table } = args;
          const index = table.getGroupTitleLevel(col, row);
          if (index !== undefined) {
            return titleColorPool[index % titleColorPool.length] as string;
          }
          return "white";
        },
      },
    }),
  };
  return options;
});
const groupRecords = ref<Record<string, string | number>[]>(listTableRecords);
</script>

<template>
  <NCard
    title="Group Table"
    :bordered="false"
    class="h-full w-2/3 card-wrapper"
  >
    <ListTable
      ref="groupTableRef"
      :options="groupOptions"
      :records="groupRecords"
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
