import { Like, Repository } from 'typeorm';
import { isNil } from 'lodash';
import { paginate } from '~/helper/pagination';
import { Pagination } from '~/helper/pagination/pagination';
import { andWhereConditions, excludeFields } from '~/utils';
import { RoleEntity } from '../system/role/role.entity';
import { DeptEntity } from '../system/dept/dept.entity';
import { UserEntity } from './user.entity';
import { UserInfo } from './user.model';
import { UserQueryDto } from './dto/user.dto';

export async function listUsers(
  repository: Repository<UserEntity>,
  {
    currentPage,
    pageSize,
    username,
    status,
    nickName,
    phone,
    email,
    deptIds,
    roleId,
  }: UserQueryDto,
): Promise<Pagination<UserInfo>> {
  const queryBuilder = await repository
    .createQueryBuilder('user')
    .leftJoinAndSelect('user.profile', 'profile')
    .leftJoinAndSelect('user.dept', 'dept')
    .leftJoinAndSelect('user.roles', 'roles')
    .where({
      ...(username && { username: Like(`%${username}%`) }),
      ...(!isNil(status) && { status }),
    })
    .orderBy({ 'user.createdAt': 'ASC' });

  // 连表查询时 使用 andWhere
  const conditions = {
    nickName: {
      field: 'profile.nick_name',
      value: nickName,
      operator: 'LIKE',
    },
    phone: {
      field: 'profile.phone',
      value: phone,
      operator: 'LIKE',
    },
    email: {
      field: 'profile.email',
      value: email,
      operator: 'LIKE',
    },
    deptIds: {
      field: 'dept.id',
      value: deptIds,
      operator: 'IN',
    },
    roleId: {
      field: 'roles.id',
      value: roleId,
      operator: '=',
    },
  };
  andWhereConditions(queryBuilder, conditions);

  const { list, total } = await paginate<UserEntity>(queryBuilder, {
    currentPage,
    pageSize,
  });

  return {
    currentPage,
    pageSize,
    // 对列表进行扁平化 方便前端使用
    list: list.map((user) => {
      user.dept = {
        name: user.dept.name,
        id: user.dept.id,
      } as DeptEntity;
      user.roles = user.roles.map((role) => {
        return {
          id: role.id,
          name: role.name,
          value: role.value,
        } as RoleEntity;
      });

      const profile = excludeFields(user.profile, [
        'id',
        'createdAt',
        'updatedAt',
      ]);

      const flatUser = { ...user, ...profile };
      delete flatUser.password;
      delete flatUser.profile;
      return flatUser;
    }),
    total,
  };
}
