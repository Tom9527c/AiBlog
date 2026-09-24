import { useAuthStore } from '@/store/modules/auth';

/** Blog editing uses explicit permissions; only superadmin has a bypass. */
export function useBlogAuth() {
  const auth = useAuthStore();
  function hasAuth(permission: string) {
    return auth.isLogin &&
      (auth.userInfo.roles.includes('superadmin') || auth.userInfo.permissions.includes(permission));
  }
  return { hasAuth };
}
