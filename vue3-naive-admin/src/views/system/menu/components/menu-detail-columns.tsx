import { NTag } from "naive-ui";
import { useDetailDescriptions } from "@/hooks/common/detail-descriptions";
import { $t } from "@/locales";
import {
  menuTypeRecord,
  enableStatusRecord,
  menuIconTypeRecord,
} from "@/constants/business";
import SvgIcon from "@/components/custom/svg-icon.vue";
import { Icon } from "@iconify/vue";

export function useMenuDetailColumns(
  isPermission: () => boolean,
  hideComponent: () => boolean,
) {
  return useDetailDescriptions<Api.SystemManage.Menu>(() => [
    {
      key: "type",
      label: $t("page.manage.menu.menuType"),
      render: (row) => {
        const label = $t(menuTypeRecord[row.type]);
        const tagMap: Record<Api.SystemManage.MenuType, NaiveUI.ThemeColor> = {
          0: "warning",
          1: "success",
          2: "error",
        };
        return <NTag type={tagMap[row.type]}>{label}</NTag>;
      },
    },
    {
      key: "parentId",
      label: $t("page.manage.menu.parent"),
      render: (row) => {
        if (!row.parentI18Key) return null;
        return $t(row.parentI18Key);
      },
    },
    {
      key: "title",
      label: $t("page.manage.menu.title"),
    },
    {
      key: "i18nKey",
      label: $t("page.manage.menu.i18nKey"),
    },
    {
      key: "iconType",
      label: $t("page.manage.menu.iconTypeTitle"),
      hide: (): boolean => {
        return isPermission();
      },
      render: (row) => {
        const label = $t(menuIconTypeRecord[row.iconType]);
        const tagMap: Record<Api.SystemManage.IconType, NaiveUI.ThemeColor> = {
          0: "primary",
          1: "success",
        };
        return <NTag type={tagMap[row.iconType]}>{label}</NTag>;
      },
    },
    {
      key: "icon",
      label: $t("page.manage.menu.icon"),
      hide: (): boolean => {
        return isPermission();
      },
      render: (row) => {
        if (!row.icon) {
          return null;
        }
        return <SvgIcon icon={row.icon} class="p-5px text-30px" />;
      },
    },
    {
      key: "path",
      label: $t("page.manage.menu.routePath"),
      hide: (): boolean => {
        return isPermission();
      },
    },
    {
      key: "name",
      label: $t("page.manage.menu.routeName"),
      hide: (): boolean => {
        return isPermission();
      },
    },
    {
      key: "component",
      label: $t("page.manage.menu.component"),
      hide: (): boolean => {
        return isPermission() || hideComponent();
      },
    },
    {
      key: "permission",
      label: $t("page.manage.menu.permission"),
      hide: () => {
        return !isPermission();
      },
    },
    {
      key: "keepAlive",
      label: $t("page.manage.menu.keepAlive"),
      hide: (): boolean => {
        return isPermission();
      },
      render: (row) => {
        return row.keepAlive
          ? $t("common.yesOrNo.yes")
          : $t("common.yesOrNo.no");
      },
    },
    {
      key: "hideInMenu",
      label: $t("page.manage.menu.hideInMenu"),
      hide: (): boolean => {
        return isPermission();
      },
      render: (row) => {
        return row.hideInMenu
          ? $t("common.yesOrNo.yes")
          : $t("common.yesOrNo.no");
      },
    },
    {
      key: "activeMenu",
      label: $t("page.manage.menu.activeMenu"),
      hide: (row): boolean => {
        return !row.hideInMenu;
      },
    },
    {
      key: "isExt",
      label: $t("page.manage.menu.isExt"),
      hide: (row): boolean => {
        return Boolean(row.hideInMenu) || isPermission();
      },
      render: (row) => {
        return row.isExt ? $t("common.yesOrNo.yes") : $t("common.yesOrNo.no");
      },
    },
    {
      key: "extOpenMode",
      label: "",
      hide: (row): boolean => {
        return !row.isExt;
      },
      render: (row) => {
        return row.extOpenMode === 0
          ? $t("page.manage.menu.inner")
          : $t("page.manage.menu.black");
      },
    },
    {
      key: "href",
      label: $t("page.manage.menu.href"),
      hide: (row): boolean => {
        return !row.isExt;
      },
    },
    {
      key: "multiTab",
      label: $t("page.manage.menu.multiTab"),
      hide: (row): boolean => {
        return isPermission() || row.extOpenMode === 1;
      },
      render: (row) => {
        return row.multiTab
          ? $t("common.yesOrNo.yes")
          : $t("common.yesOrNo.no");
      },
    },
    {
      key: "fixedIndexInTab",
      label: $t("page.manage.menu.fixedIndexInTab"),
      hide: (row): boolean => {
        return isPermission() || row.extOpenMode === 1;
      },
    },
    {
      key: "order",
      label: $t("page.manage.menu.order"),
    },
    {
      key: "status",
      label: $t("common.status"),
      render: (row) => {
        if (row.status === null) return null;
        const label = $t(enableStatusRecord[row.status]);
        const tagMap: Record<Api.Common.EnableStatus, NaiveUI.ThemeColor> = {
          1: "success",
          0: "error",
        };
        return <NTag type={tagMap[row.status]}>{label}</NTag>;
      },
    },
  ]);
}
