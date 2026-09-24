/* Only navigation-only legacy roles lose the reused /blog parent grant. */
function legacyParentGrantRoles(parentId, menus, assignments, roles) {
  const descendants = new Set([parentId]);
  let previousSize = -1;
  while (previousSize !== descendants.size) {
    previousSize = descendants.size;
    for (const menu of menus) {
      if (descendants.has(menu.parent_id)) descendants.add(menu.id);
    }
  }
  const managementIds = new Set(menus.filter(menu => menu.id !== parentId
    && descendants.has(menu.id)
    && !['blog_zym', 'blog_zym-href'].includes(menu.name)
    && ((menu.type === 1 && !menu.is_ext && menu.path?.startsWith('/blog/'))
      || (menu.type === 2 && menu.permission?.startsWith('blog:')))).map(menu => menu.id));
  const managementRoles = new Set(assignments.filter(row => managementIds.has(row.menu_id)).map(row => row.role_id));
  const superadmins = new Set(roles.filter(role => role.value === 'superadmin').map(role => role.id));
  return [...new Set(assignments.filter(row => row.menu_id === parentId
    && !superadmins.has(row.role_id) && !managementRoles.has(row.role_id)).map(row => row.role_id))];
}

module.exports = { legacyParentGrantRoles };
