<script setup lang="tsx">
import { computed, onMounted, ref } from "vue";
import { VTable } from "@visactor/vue-vtable";
import { useThemeStore } from "@/store/modules/theme";
import {
  PivotTable,
  PivotColumnDimension,
  PivotRowDimension,
  PivotIndicator,
  PivotCorner,
  Menu,
} from "@visactor/vue-vtable";
const themeStore = useThemeStore();
// pivot table
const pivotTableRef = ref(null);
const pivotTableOptions = computed(() => {
  return {
    tooltip: {
      isShowOverflowTextTooltip: true,
    },
    dataConfig: {
      sortRules: [
        {
          sortField: "Category",
          sortBy: ["Office Supplies", "Technology", "Furniture"],
        },
      ],
    },
    widthMode: "standard",
    theme: themeStore.darkMode ? VTable.themes.DARK : VTable.themes.DEFAULT,
    emptyTip: {
      text: "no data records",
    },
  };
});
const pivotTableIndicators = ref([
  {
    indicatorKey: "Quantity",
    title: "Quantity",
    width: "auto",
    showSort: false,
    headerStyle: { fontWeight: "normal" },
    style: {
      padding: [16, 28, 16, 28],
      color(args: any) {
        return args.dataValue >= 0 ? "black" : "red";
      },
    },
  },
  {
    indicatorKey: "Sales",
    title: "Sales",
    width: "auto",
    showSort: false,
    headerStyle: { fontWeight: "normal" },
    format: (rec: string) => `$${Number(rec).toFixed(2)}`,
    style: {
      padding: [16, 28, 16, 28],
      color(args: any) {
        return args.dataValue >= 0 ? "black" : "red";
      },
    },
  },
  {
    indicatorKey: "Profit",
    title: "Profit",
    width: "auto",
    showSort: false,
    headerStyle: { fontWeight: "normal" },
    format: (rec: string) => `$${Number(rec).toFixed(2)}`,
    style: {
      padding: [16, 28, 16, 28],
      color(args: any) {
        return args.dataValue >= 0 ? "black" : "red";
      },
    },
  },
]);
const pivotTableRows = ref([
  {
    dimensionKey: "City",
    title: "City",
    headerStyle: { textStick: true },
    width: "auto",
  },
]);
const pivotTableRecords = ref([]);

onMounted(() => {
  fetch(
    "https://lf9-dp-fe-cms-tos.byteorg.com/obj/bit-cloud/VTable/North_American_Superstore_Pivot_data.json",
  )
    .then((res) => res.json())
    .then((data) => {
      pivotTableRecords.value = data;
    });
});
</script>

<template>
  <NCard
    title="Pivot Table"
    :bordered="false"
    class="h-full w-2/3 card-wrapper"
  >
    <PivotTable
      ref="pivotTableRef"
      :options="pivotTableOptions"
      :records="pivotTableRecords"
      height="400px"
    >
      <PivotColumnDimension
        title="Category"
        dimension-key="Category"
        :header-style="{ textStick: true }"
        width="auto"
      />
      <PivotRowDimension
        v-for="(row, index) in pivotTableRows"
        :key="index"
        :dimension-key="row.dimensionKey"
        :title="row.title"
        :header-style="row.headerStyle"
        :width="row.width"
      />
      <PivotIndicator
        v-for="(indicator, index) in pivotTableIndicators"
        :key="index"
        :indicator-key="indicator.indicatorKey"
        :title="indicator.title"
        :width="indicator.width"
        :show-sort="indicator.showSort"
        :header-style="indicator.headerStyle"
        :format="indicator.format"
        :style="indicator.style"
      />
      <PivotCorner title-on-dimension="row" />
      <Menu
        menu-type="html"
        :context-menu-items="['copy', 'paste', 'delete', '...']"
      />
    </PivotTable>
  </NCard>
</template>
