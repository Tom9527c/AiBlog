import { useSearchForm } from "@/hooks/common/search-form";
import { $t } from "@/locales";
import { StatusEnum } from "@/constants/enum";

export function useUserSearchForm() {
  return useSearchForm<Api.SystemManage.UserSearchParams>(() => [
    {
      key: "username",
      label: $t("page.manage.user.username"),
      type: "Input",
      props: {
        placeholder: $t("common.pleaseEnter") + $t("page.manage.user.username"),
      },
    },
    {
      key: "nickName",
      label: $t("page.manage.user.nickName"),
      type: "Input",
      props: {
        placeholder: $t("common.pleaseEnter") + $t("page.manage.user.nickName"),
      },
    },
    {
      key: "email",
      label: $t("page.manage.user.email"),
      type: "Input",
      props: {
        placeholder: $t("common.pleaseEnter") + $t("page.manage.user.email"),
      },
    },
    {
      key: "status",
      label: $t("common.status"),
      type: "Select",
      props: {
        placeholder: $t("common.pleaseSelect") + $t("common.status"),
        options: [
          {
            value: StatusEnum.ENABLE,
            label: $t("common.enable"),
          },
          {
            value: StatusEnum.DISABLE,
            label: $t("common.disable"),
          },
        ],
      },
    },
    {
      key: "roleId",
      label: $t("page.manage.user.role"),
      type: "Select",
      props: {
        placeholder: $t("common.pleaseSelect") + $t("page.manage.user.role"),
        options: [
          {
            value: "43df8dd8-a7ab-4fdc-82bf-c322f206d8e1",
            label: "测试",
          },
          {
            value: "bf468315-8ceb-4e18-8fc7-bd9743c5a4c7",
            label: "管理员",
          },
        ],
      },
    },
  ]);
}
