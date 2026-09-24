import * as VTableGantt from "@visactor/vtable-gantt";
import { basicGanttRecords } from "./data";

const basicGanttColumns = [
  {
    field: "title",
    title: "title",
    width: "auto",
    sort: true,
    tree: true,
    editor: "input",
  },
  {
    field: "start",
    title: "start",
    width: "auto",
    sort: true,
    editor: "date-input",
  },
  {
    field: "end",
    title: "end",
    width: "auto",
    sort: true,
    editor: "date-input",
  },
  {
    field: "priority",
    title: "priority",
    width: "auto",
    sort: true,
    editor: "input",
  },
  {
    field: "progress",
    title: "progress",
    width: "auto",
    sort: true,
    headerStyle: {
      borderColor: "#e1e4e8",
    },
    style: {
      borderColor: "#e1e4e8",
      color: "green",
    },
    editor: "input",
  },
];
export const basicGanttOption: VTableGantt.GanttConstructorOptions = {
  overscrollBehavior: "none",
  records: basicGanttRecords,
  taskListTable: {
    columns: basicGanttColumns,
    tableWidth: 250,
    minTableWidth: 100,
    maxTableWidth: 600,
    // rightFrozenColCount: 1
  },
  frame: {
    outerFrameStyle: {
      borderLineWidth: 2,
      borderColor: "#e1e4e8",
      cornerRadius: 8,
    },
    verticalSplitLine: {
      lineColor: "#e1e4e8",
      lineWidth: 3,
    },
    horizontalSplitLine: {
      lineColor: "#e1e4e8",
      lineWidth: 3,
    },
    verticalSplitLineMoveable: true,
    verticalSplitLineHighlight: {
      lineColor: "green",
      lineWidth: 3,
    },
  },
  grid: {
    // backgroundColor: 'gray',
    verticalLine: {
      lineWidth: 1,
      lineColor: "#e1e4e8",
    },
    horizontalLine: {
      lineWidth: 1,
      lineColor: "#e1e4e8",
    },
  },
  headerRowHeight: 40,
  rowHeight: 40,
  taskBar: {
    startDateField: "start",
    endDateField: "end",
    progressField: "progress",
    // resizable: false,
    moveable: true,
    hoverBarStyle: {
      barOverlayColor: "rgba(99, 144, 0, 0.4)",
    },
    labelText: "{title} {progress}%",
    labelTextStyle: {
      // padding: 2,
      fontFamily: "Arial",
      fontSize: 16,
      textAlign: "left",
      textOverflow: "ellipsis",
    },
    barStyle: {
      width: 20,
      /** 任务条的颜色 */
      barColor: "#ee8800",
      /** 已完成部分任务条的颜色 */
      completedBarColor: "#91e8e0",
      /** 任务条的圆角 */
      cornerRadius: 8,
    },
  },
  timelineHeader: {
    colWidth: 100,
    backgroundColor: "#EEF1F5",
    horizontalLine: {
      lineWidth: 1,
      lineColor: "#e1e4e8",
    },
    verticalLine: {
      lineWidth: 1,
      lineColor: "#e1e4e8",
    },
    scales: [
      {
        unit: "week",
        step: 1,
        startOfWeek: "sunday",
        format(date: any) {
          return `Week ${date.dateIndex}`;
        },
        style: {
          fontSize: 20,
          fontWeight: "bold",
          color: "white",
          strokeColor: "black",
          textAlign: "right",
          textBaseline: "bottom",
          textStick: true,
          // padding: [0, 30, 0, 20]
        },
      },
      {
        unit: "day",
        step: 1,
        format(date: any) {
          return date.dateIndex.toString();
        },
        style: {
          fontSize: 20,
          fontWeight: "bold",
          color: "white",
          strokeColor: "black",
          textAlign: "right",
          textBaseline: "bottom",
        },
      },
    ],
  },
  markLine: [
    {
      date: "2024-07-28",
      style: {
        lineWidth: 1,
        lineColor: "blue",
        lineDash: [8, 4],
      },
    },
    {
      date: "2024-08-17",
      style: {
        lineWidth: 2,
        lineColor: "red",
        lineDash: [8, 4],
      },
    },
  ],
  rowSeriesNumber: {
    title: "行号",
    dragOrder: true,
  },
  scrollStyle: {
    scrollRailColor: "RGBA(246,246,246,0.5)",
    visible: "scrolling",
    width: 6,
    scrollSliderCornerRadius: 2,
    scrollSliderColor: "#5cb85c",
  },
};
