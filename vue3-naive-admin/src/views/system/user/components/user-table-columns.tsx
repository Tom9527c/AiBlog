import { NAvatar, NButton, NPopconfirm, NTag } from "naive-ui";
import { $t, getLocale } from "@/locales";
import { userGenderRecord, enableStatusRecord } from "@/constants/business";

export function createUserColumns(actions: {
  detail: (id: number) => void;
  edit: (id: number) => void;
  changeStatus: (id: number, status: number | null) => void;
  resetPassword: (id: number) => void;
  deleteUser: (id: number) => void;
  hasAuth: (key: string) => boolean;
}) {
  const { detail, edit, hasAuth, deleteUser } = actions;
  const handleChangeStatus = actions.changeStatus;
  const resetPasswordEvent = actions.resetPassword;
  return [
    {
      fixed: "left",
      type: "selection",
      align: "center",
      width: 48,
    },
    {
      fixed: "left",
      key: "username",
      title: $t("page.manage.user.username"),
      align: "center",
      width: 100,
      ellipsis: {
        tooltip: true,
      },
      render: (row: Api.SystemManage.User) => {
        return (
          <span class={"detail-link"} onClick={() => detail(row.id)}>
            {row.username}
          </span>
        );
      },
    },
    {
      key: "avatar",
      title: $t("page.manage.user.avatar"), // $t('page.manage.user.userGender'),
      align: "center",
      width: 60,
      render: (row: Api.SystemManage.User) => {
        if (row.avatar === null) {
          return null;
        }

        return (
          <NAvatar src={row.avatar as string} round size="medium"></NAvatar>
        );
      },
    },
    {
      key: "nickName",
      title: $t("page.manage.user.nickName"),
      align: "center",
      width: 100,
      ellipsis: {
        tooltip: true,
      },
    },
    {
      key: "dept",
      title: $t("page.manage.user.dept"),
      align: "center",
      width: 120,
      render: (row: Api.SystemManage.User) => {
        if (row.dept === null) return null;
        return <NTag>{row.dept.name}</NTag>;
      },
    },
    {
      key: "roles",
      title: $t("page.manage.user.role"),
      align: "left",
      width: 160,
      render: (row: Api.SystemManage.User) => {
        if (row.roles.length === 0) return null;
        const roleMap: Record<any, NaiveUI.ThemeColor> = {
          superadmin: "primary",
          admin: "success",
        };
        return row.roles.map((role) => (
          <NTag class={"mr-8px"} type={roleMap[role.value] || ""}>
            {role.name}
          </NTag>
        ));
      },
    },
    {
      key: "gender",
      title: $t("page.manage.user.userGender"),
      align: "center",
      width: 80,
      render: (row: Api.SystemManage.User) => {
        if (row.gender === null || !row.gender) {
          return null;
        }

        const tagMap: Record<Api.SystemManage.UserGender, NaiveUI.ThemeColor> =
          {
            1: "primary",
            0: "error",
          };

        const label = $t(userGenderRecord[row.gender]);

        return <NTag type={tagMap[row.gender]}>{label}</NTag>;
      },
    },
    {
      key: "status",
      title: $t("common.status"),
      align: "center",
      width: 100,
      render: (row: Api.SystemManage.User) => {
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
      width: getLocale.value === "zh-CN" ? 240 : 300,
      render: (row: Api.SystemManage.User) => (
        <div class="flex-center gap-8px">
          <NButton
            disabled={!hasAuth("system:user:update")}
            type="primary"
            ghost
            size="small"
            onClick={() => edit(row.id)}
          >
            {$t("common.edit")}
          </NButton>
          <NPopconfirm
            onPositiveClick={() => handleChangeStatus(row.id, row.status)}
          >
            {{
              default: () =>
                $t(
                  row.status
                    ? "page.manage.common.status.disable"
                    : "page.manage.common.status.enable",
                ),
              trigger: () => (
                <NButton
                  disabled={!hasAuth("system:user:update")}
                  type={row.status ? "error" : "success"}
                  ghost
                  size="small"
                >
                  {$t(
                    row.status
                      ? "page.manage.common.status.disable"
                      : "page.manage.common.status.enable",
                  )}
                </NButton>
              ),
            }}
          </NPopconfirm>
          <NButton
            onClick={() => resetPasswordEvent(row.id)}
            disabled={!hasAuth("system:user:pass:reset")}
            type={"error"}
            ghost
            size="small"
          >
            {$t("page.manage.user.resetPassword")}
          </NButton>
          <NPopconfirm onPositiveClick={() => deleteUser(row.id)}>
            {{
              default: () => $t("common.confirmDelete"),
              trigger: () => (
                <NButton
                  disabled={!hasAuth("system:user:delete")}
                  type={"error"}
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
    NaiveUI.TableDataWithIndex<Api.SystemManage.User>
  >[];
}
