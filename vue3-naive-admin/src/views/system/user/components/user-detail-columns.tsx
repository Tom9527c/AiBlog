import { NAvatar, NTag, NTime } from "naive-ui";
import { useDetailDescriptions } from "@/hooks/common/detail-descriptions";
import { $t } from "@/locales";
import { userGenderRecord } from "@/constants/business";
import { StatusEnum } from "@/constants/enum";

export function useUserDetailColumns() {
  return useDetailDescriptions<Api.SystemManage.User>(() => [
    {
      key: "avatar",
      label: $t("page.manage.user.avatar"),
      span: 2,
      render: (row) => {
        if (row.avatar === null) {
          return null;
        }

        return <NAvatar src={row.avatar as string} size={64}></NAvatar>;
      },
    },
    {
      key: "dept",
      label: $t("page.manage.user.dept"),
      render: (row) => {
        if (row.dept === null) {
          return null;
        }
        return <NTag>{row.dept.name}</NTag>;
      },
    },
    {
      key: "roles",
      label: $t("page.manage.user.role"),
      render: (row) => {
        if (row.roles.length === 0) return null;
        const roleMap: Record<any, NaiveUI.ThemeColor> = {
          superadmin: "primary",
          admin: "success",
        };

        return row.roles.map((role: { value: string | number; name: any }) => (
          <NTag class={"mr-8px"} type={roleMap[role.value] || "info"}>
            {role.name}
          </NTag>
        ));
      },
    },
    {
      key: "username",
      label: $t("page.manage.user.username"),
    },
    {
      key: "nickName",
      label: $t("page.manage.user.nickName"),
    },
    {
      key: "gender",
      label: $t("page.manage.user.userGender"),
      render: (row) => {
        if (row.gender === null) {
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
      key: "email",
      label: $t("page.manage.user.email"),
    },

    {
      key: "phone",
      label: $t("page.manage.user.phone"),
    },

    {
      key: "address",
      label: $t("page.manage.user.address"),
    },
    {
      key: "birthDate",
      label: $t("page.manage.user.birthDate"),
      render: (row) => {
        if (!row.birthDate) {
          return null;
        }
        return <NTime time={new Date(row.birthDate)} format="yyyy-MM-dd" />;
      },
    },
    {
      key: "status",
      label: $t("common.status"),
      render: (row) => {
        return (
          <NTag type={row.status === StatusEnum.ENABLE ? "success" : "error"}>
            {row.status === StatusEnum.ENABLE
              ? $t("common.enable")
              : $t("common.disable")}
          </NTag>
        );
      },
    },
    {
      key: "signature",
      label: $t("page.manage.user.signature"),
      span: 2,
    },
    {
      key: "introduction",
      label: $t("page.manage.user.introduction"),
      span: 2,
    },
  ]);
}
