<script setup lang="tsx">
import { computed, onMounted, ref } from "vue";
import { VTable } from "@visactor/vue-vtable";
import { useThemeStore } from "@/store/modules/theme";
import { PivotChart } from "@visactor/vue-vtable";
import {
  pivotChartColumns,
  pivotChartIndicators,
  pivotChartRows,
} from "../data";
import VChart from "@visactor/vchart";
import { registerChartModule } from "@visactor/vue-vtable";
registerChartModule("vchart", VChart);
const themeStore = useThemeStore();
// pivot chart
const pivotChartRef = ref(null);
const pivotChartOptions = computed(() => {
  return {
    rows: pivotChartRows,
    columns: pivotChartColumns,
    indicators: pivotChartIndicators,
    indicatorsAsCol: false,
    defaultRowHeight: 200,
    defaultHeaderRowHeight: 50,
    defaultColWidth: 280,
    defaultHeaderColWidth: 100,
    indicatorTitle: "指标",
    autoWrapText: true,
    corner: {
      titleOnDimension: "row",
      headerStyle: { autoWrapText: true },
    },
    legends: {
      orient: "bottom",
      type: "discrete",
      data: [
        {
          label: "Consumer-Quantity",
          shape: { fill: "#2E62F1", symbolType: "circle" },
        },
        {
          label: "Consumer-Quantity",
          shape: { fill: "#4DC36A", symbolType: "square" },
        },
        {
          label: "Home Office-Quantity",
          shape: { fill: "#FF8406", symbolType: "square" },
        },
        {
          label: "Consumer-Sales",
          shape: { fill: "#FFCC00", symbolType: "square" },
        },
        {
          label: "Consumer-Sales",
          shape: { fill: "#4F44CF", symbolType: "square" },
        },
        {
          label: "Home Office-Sales",
          shape: { fill: "#5AC8FA", symbolType: "square" },
        },
        {
          label: "Consumer-Profit",
          shape: { fill: "#003A8C", symbolType: "square" },
        },
        {
          label: "Consumer-Profit",
          shape: { fill: "#B08AE2", symbolType: "square" },
        },
        {
          label: "Home Office-Profit",
          shape: { fill: "#FF6341", symbolType: "square" },
        },
      ],
    },
    theme: (themeStore.darkMode
      ? VTable.themes.DARK
      : VTable.themes.DEFAULT
    ).extends({
      bodyStyle: { borderColor: "gray", borderLineWidth: [1, 0, 0, 1] },
      headerStyle: {
        borderColor: "gray",
        borderLineWidth: [0, 0, 1, 1],
        hover: { cellBgColor: "#CCE0FF" },
      },
      rowHeaderStyle: {
        borderColor: "gray",
        borderLineWidth: [1, 1, 0, 0],
        hover: { cellBgColor: "#CCE0FF" },
      },
      cornerHeaderStyle: {
        borderColor: "gray",
        borderLineWidth: [0, 1, 1, 0],
        hover: { cellBgColor: "" },
      },
      cornerRightTopCellStyle: {
        borderColor: "gray",
        borderLineWidth: [0, 0, 1, 1],
        hover: { cellBgColor: "" },
      },
      cornerLeftBottomCellStyle: {
        borderColor: "gray",
        borderLineWidth: [1, 1, 0, 0],
        hover: { cellBgColor: "" },
      },
      cornerRightBottomCellStyle: {
        borderColor: "gray",
        borderLineWidth: [1, 0, 0, 1],
        hover: { cellBgColor: "" },
      },
      rightFrozenStyle: {
        borderColor: "gray",
        borderLineWidth: [1, 0, 1, 1],
        hover: { cellBgColor: "" },
      },
      bottomFrozenStyle: {
        borderColor: "gray",
        borderLineWidth: [1, 1, 0, 1],
        hover: { cellBgColor: "" },
      },
      selectionStyle: { cellBgColor: "", cellBorderColor: "" },
      frameStyle: { borderLineWidth: 0 },
    }),
    emptyTip: {
      text: "no data records",
    },
  };
});
const pivotChartRecords = ref({} as any);
const handleLegendItemClick = (args: { value: any }) => {
  (pivotChartRef?.value as any)?.vTableInstance.updateFilterRules([
    {
      filterKey: "Segment-Indicator",
      filteredValues: args.value,
    },
  ]);
};

onMounted(() => {
  fetch(
    "https://lf9-dp-fe-cms-tos.byteorg.com/obj/bit-cloud/VTable/North_American_Superstore_Pivot_Chart_data.json",
  )
    .then((res) => res.json())
    .then((data) => {
      pivotChartRecords.value = data;
    });
});
</script>

<template>
  <NCard
    title="Pivot Chart"
    :bordered="false"
    class="h-full w-2/3 card-wrapper"
  >
    <PivotChart
      ref="pivotChartRef"
      :options="pivotChartOptions"
      :records="pivotChartRecords"
      height="800px"
      @on-legend-item-click="handleLegendItemClick"
    />
  </NCard>
</template>
