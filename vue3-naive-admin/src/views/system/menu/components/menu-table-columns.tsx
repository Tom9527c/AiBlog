import { NButton, NPopconfirm, NTag } from "naive-ui";
import { Icon } from "@iconify/vue";
import { $t, getLocale } from "@/locales";
import { enableStatusRecord, menuTypeRecord } from "@/constants/business";

export function createMenuColumns(actions: {
  detail: (row: Api.SystemManage.Menu) => void;
  add: (id: number, type: Api.SystemManage.MenuType) => void;
  edit: (id: number) => void;
  deleteMenu: (id: number) => void;
  hasAuth: (key: string) => boolean;
}) {
  const { detail, add, edit, hasAuth } = actions;
  const handleDelete = actions.deleteMenu;
  return [
    {
      fixed: "left",
      key: "title",
      title: $t("page.manage.menu.title"), // $t('page.manage.Menu.role'),
      align: "left",
      width: 180,
      tree: true,
      render: (row: Api.SystemManage.Menu) => {
        return (
          <span class={"detail-link"} onClick={() => detail(row)}>
            {row.i18nKey ? $t(row.i18nKey) : row.title}
          </span>
        );
      },
    },
    {
      key: "icon",
      title: $t("page.manage.menu.icon"),
      align: "center",
      width: 50,
      render: (row: Api.SystemManage.Menu) => {
        if (!row.icon) {
          return null;
        }
        return (
          <div class={"flex justify-center"}>
            <Icon class={"text-icon"} icon={row.icon} />
          </div>
        );
      },
    },
    {
      key: "type",
      title: $t("page.manage.menu.menuType"), // $t('page.manage.Menu.role'),
      align: "center",
      width: 100,
      render: (row: Api.SystemManage.Menu) => {
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
      key: "component",
      title: $t("page.manage.menu.component"),
      align: "center",
      width: 180,
      ellipsis: {
        tooltip: true,
      },
    },
    {
      key: "permission",
      title: $t("page.manage.menu.permission"),
      align: "center",
      width: 150,
      ellipsis: {
        tooltip: true,
      },
      render: (row: Api.SystemManage.Menu) => {
        if (!row.permission) {
          return null;
        }
        return <NTag type={"primary"}>{row.permission}</NTag>;
      },
    },
    {
      key: "order",
      title: $t("page.manage.menu.order"),
      align: "center",
      width: 100,
    },
    {
      key: "status",
      title: $t("common.status"),
      align: "center",
      width: 100,
      render: (row: Api.SystemManage.Menu) => {
        if (row.status === null) {
          return null;
        }

        const tagMap: Record<Api.Common.EnableStatus, NaiveUI.ThemeColor> = {
          1: "success",
          0: "error",
        };

        const label = $t(enableStatusRecord[row.status]);

        return <NTag type={tagMap[row.status]}>{label}</NTag>;
      },
    },
    {
      key: "operate",
      title: $t("common.operate"),
      align: "center",
      width: getLocale.value === "zh-CN" ? 220 : 260,
      render: (row: Api.SystemManage.Menu) => (
        <div class="flex justify-items-start gap-8px">
          {row.type === 0 && (
            <NButton
              disabled={!hasAuth("system:menu:create")}
              type="success"
              ghost
              size="small"
              onClick={() => add(row.id, 1)}
            >
              {$t("page.manage.menu.addChildMenu")}
            </NButton>
          )}
          {row.type === 1 && (
            <NButton
              disabled={!hasAuth("system:menu:create")}
              type="error"
              ghost
              size="small"
              onClick={() => add(row.id, 2)}
            >
              {$t("page.manage.menu.addPermission")}
            </NButton>
          )}
          <NButton
            disabled={!hasAuth("system:menu:update")}
            type="primary"
            ghost
            size="small"
            onClick={() => edit(row.id)}
          >
            {$t("common.edit")}
          </NButton>
          <NPopconfirm onPositiveClick={() => handleDelete(row.id)}>
            {{
              default: () => $t("common.confirmDelete"),
              trigger: () => (
                <NButton
                  disabled={!hasAuth("system:menu:delete")}
                  type="error"
                  ghost
                  size="small"
                >
                  {$t("common.delete")}
                </NButton>
              ),
            }}
          </NPopconfirm>
        </div>
      ),
    },
  ] satisfies NaiveUI.TableColumn<
    NaiveUI.TableDataWithIndex<Api.SystemManage.Menu>
  >[];
}
