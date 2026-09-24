import * as VTableGantt from "@visactor/vtable-gantt";
import { linkGanttRecords } from "./data";

const linkGanttColumns = [
  {
    field: "title",
    title: "title",
    width: "auto",
    tree: true,
  },
  {
    field: "start",
    title: "start",
    width: "auto",
    editor: "date-input",
  },
  {
    field: "end",
    title: "end",
    width: "auto",
    editor: "date-input",
  },
  {
    field: "priority",
    title: "priority",
    width: "auto",
    editor: "input",
  },
  {
    field: "progress",
    title: "progress",
    width: "auto",
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
export const linkGanttOption: VTableGantt.GanttConstructorOptions = {
  records: linkGanttRecords,
  taskListTable: {
    columns: linkGanttColumns,
    tableWidth: 400,
    minTableWidth: 100,
    maxTableWidth: 600,
  },
  dependency: {
    links: [
      {
        type: VTableGantt.TYPES.DependencyType.FinishToStart,
        linkedFromTaskKey: 1,
        linkedToTaskKey: 2,
      },
      {
        type: VTableGantt.TYPES.DependencyType.StartToFinish,
        linkedFromTaskKey: 2,
        linkedToTaskKey: 3,
      },
      {
        type: VTableGantt.TYPES.DependencyType.StartToStart,
        linkedFromTaskKey: 3,
        linkedToTaskKey: 4,
      },
      {
        type: VTableGantt.TYPES.DependencyType.FinishToFinish,
        linkedFromTaskKey: 4,
        linkedToTaskKey: 5,
      },
    ],
    // linkSelectable: false,
    linkSelectedLineStyle: {
      shadowBlur: 5, // 阴影宽度
      shadowColor: "red",
      lineColor: "red",
      lineWidth: 1,
    },
  },
  frame: {
    verticalSplitLineMoveable: true,
    outerFrameStyle: {
      borderLineWidth: 2,
      // borderColor: 'red',
      cornerRadius: 8,
    },
    verticalSplitLine: {
      lineWidth: 3,
      lineColor: "#e1e4e8",
    },
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
  headerRowHeight: 60,
  rowHeight: 40,

  taskBar: {
    startDateField: "start",
    endDateField: "end",
    progressField: "progress",
    labelText: "{title} {progress}%",
    labelTextStyle: {
      fontFamily: "Arial",
      fontSize: 16,
      textAlign: "left",
    },
    barStyle: {
      width: 20,
      /** 任务条的颜色 */
      barColor: "#ee8800",
      /** 已完成部分任务条的颜色 */
      completedBarColor: "#91e8e0",
      /** 任务条的圆角 */
      cornerRadius: 10,
    },
    selectedBarStyle: {
      shadowBlur: 5, // 阴影宽度
      shadowOffsetX: 0, // x方向偏移
      shadowOffsetY: 0, // Y方向偏移
      shadowColor: "black", // 阴影颜色
      borderColor: "red", // 边框颜色
      borderLineWidth: 1, // 边框宽度
    },
  },
  timelineHeader: {
    verticalLine: {
      lineWidth: 1,
      lineColor: "#e1e4e8",
    },
    horizontalLine: {
      lineWidth: 1,
      lineColor: "#e1e4e8",
    },
    backgroundColor: "#EEF1F5",
    colWidth: 60,
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
          color: "red",
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
          color: "red",
        },
      },
    ],
  },
  minDate: "2024-07-14",
  maxDate: "2024-10-15",

  rowSeriesNumber: {
    title: "行号",
    dragOrder: true,
  },
  scrollStyle: {
    visible: "scrolling",
  },
  overscrollBehavior: "none",
};
