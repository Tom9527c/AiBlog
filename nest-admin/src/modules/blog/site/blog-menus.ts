import {
  BadRequestException,
  ConflictException,
  NotFoundException,
} from '@nestjs/common';
import { DataSource } from 'typeorm';
import { BlogMenu } from '../blog.entity';
import { BlogMenuDto } from '../blog.dto';
import { safeUrl } from './blog-settings';

export async function listMenus(db: DataSource, publicOnly = false) {
  const rows = await db
    .getRepository(BlogMenu)
    .find({ order: { sort: 'ASC', id: 'ASC' } });
  if (!publicOnly) return rows;
  const enabled = (row: BlogMenu, seen = new Set<number>()): boolean => {
    if (!row.enabled || seen.has(row.id)) return false;
    if (!row.parentId) return true;
    seen.add(row.id);
    const parent = rows.find((item) => item.id === row.parentId);
    return !!parent && enabled(parent, seen);
  };
  return rows.filter((row) => enabled(row));
}
export async function saveMenu(db: DataSource, dto: BlogMenuDto, id?: number) {
  const repo = db.getRepository(BlogMenu);
  const previous = id ? await repo.findOneBy({ id }) : null;
  if (id && !previous) throw new NotFoundException('菜单不存在');
  const fields = Object.fromEntries(
    Object.entries(dto).filter(([, value]) => value !== undefined),
  );
  const row = repo.create({
    parentId: null,
    title: '',
    path: '',
    icon: '',
    sort: 0,
    enabled: true,
    external: false,
    newWindow: false,
    ...previous,
    ...fields,
  });
  if (!row.title.trim() || !safeUrl(row.path))
    throw new BadRequestException('请填写菜单名称及有效链接');
  if (row.external && !/^https?:\/\//i.test(row.path))
    throw new BadRequestException('外链需要 HTTP(S) 地址');
  let parentId = row.parentId;
  const seen = new Set(id ? [id] : []);
  while (parentId) {
    if (seen.has(parentId)) throw new BadRequestException('菜单不能循环嵌套');
    seen.add(parentId);
    const parent = await repo.findOneBy({ id: parentId });
    if (!parent) throw new BadRequestException('父菜单不存在');
    parentId = parent.parentId;
  }
  return repo.save(row);
}
export async function deleteMenu(db: DataSource, id: number) {
  const repo = db.getRepository(BlogMenu);
  if (await repo.countBy({ parentId: id }))
    throw new ConflictException('请先删除子菜单');
  if (!(await repo.delete(id)).affected)
    throw new NotFoundException('菜单不存在');
}
