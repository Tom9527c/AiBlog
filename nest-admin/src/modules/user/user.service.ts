import { checkContact } from './user-contact';
import { forbidUser, forbidUsers } from './user-session';
import { listUsers } from './user-list';
import { RoleEntity } from '../system/role/role.entity';
import { DeptEntity } from '../system/dept/dept.entity';
import { Inject, Injectable, NotFoundException } from '@nestjs/common';
import { In, Repository } from 'typeorm';
import { InjectRepository } from '@nestjs/typeorm';
import * as argon2 from 'argon2';

import { UserEntity } from './user.entity';
import {
  UserCreateDto,
  UserPasswordDto,
  UserProfileDto,
  UserQueryDto,
  UserResetPasswordDto,
  UserStatusDto,
  UserUpdateDto,
} from './dto/user.dto';
import { ProfileEntity } from './profile.entity';
import { Pagination } from '~/helper/pagination/pagination';
import { excludeFields, randomNickName } from '~/utils';
import {
  BizException,
  BusinessException,
} from '~/common/exceptions/biz.exception';
import { ErrorEnum } from '~/constants/error.constant';
import { InjectRedis } from '~/common/decorators/inject-redis.decorator';
import Redis from 'ioredis';
import { UserInfo } from './user.model';
import { isNil, isEmpty } from 'lodash';
import { ISecurityConfig, SecurityConfig } from '~/config';
import { REG_PWD } from '~/constants/reg';
import { Roles } from '../auth/auth.constant';
import { PasswordUpdateDto } from '../auth/dto/auth.dto';

@Injectable()
export class UserService {
  constructor(
    @InjectRedis()
    private readonly redis: Redis,
    @InjectRepository(UserEntity)
    private readonly userRepository: Repository<UserEntity>,
    @InjectRepository(ProfileEntity)
    private readonly profileRepository: Repository<ProfileEntity>,
    @Inject(SecurityConfig.KEY)
    private readonly securityConfig: ISecurityConfig,
  ) {}

  list(query: UserQueryDto): Promise<Pagination<UserInfo>> {
    return listUsers(this.userRepository, query);
  }

  async exist(username: string): Promise<UserEntity> {
    const user = await this.userRepository.findOne({
      where: {
        username,
      },
    });

    const emailUser = await this.userRepository.findOne({
      where: {
        profile: {
          email: username,
        },
      },
      relations: ['profile'],
    });

    return user || emailUser;
  }

  async checkUserExist(username?: string, email?: string): Promise<void> {
    if (username) {
      const user = await this.userRepository.findOne({
        where: {
          username,
        },
      });

      if (user) throw new BizException(ErrorEnum.USER_USERNAME_EXIST);
    }

    if (email) {
      const emailUser = await this.userRepository.findOne({
        where: {
          profile: {
            email: email,
          },
        },
        relations: ['profile'],
      });

      if (emailUser) throw new BizException(ErrorEnum.USER_EMAIL_EXIST);
    }
  }

  async checkThirdUserExist(from: string, uniqueId: number): Promise<void> {
    const user = await this.userRepository.findOne({
      where: {
        from,
        uniqueId,
      },
    });

    if (user) throw new BizException(ErrorEnum.USER_EMAIL_EXIST);
  }

  // 获取用户所有的信息
  async findUserInfo(id: number): Promise<UserEntity> {
    return await this.userRepository.findOne({
      where: {
        id,
      },
      relations: ['profile', 'roles', 'dept'],
    });
  }

  // 获取用户详细信息
  async findUserProfile(id: number): Promise<UserProfileDto> {
    const user = await this.userRepository.findOne({
      where: {
        id,
      },
      relations: ['profile', 'dept', 'roles'],
    });

    // 排除一些基础属性
    const profile = excludeFields(user.profile, [
      'id',
      'createdAt',
      'updatedAt',
    ]);

    return {
      id: user.id,
      roles: user.roles.map((role) => role.value),
      rolesName: user.roles.map((role) => role.name),
      dept: user.dept.name,
      username: user.username,
      ...profile,
    };
  }

  async findUserInfoByEmail(email: string): Promise<UserEntity> {
    const user = await this.userRepository.findOne({
      where: {
        profile: { email },
      },
    });

    if (isEmpty(user)) {
      throw new NotFoundException(ErrorEnum.USER_EMAIL_NOT_EXIST);
    }

    return user;
  }

  async findUserInfoByUsername(username: string): Promise<UserEntity> {
    const user = await this.userRepository.findOne({
      where: {
        username,
      },
    });

    if (isEmpty(user)) {
      throw new NotFoundException(ErrorEnum.USER_EMAIL_NOT_EXIST);
    }

    return user;
  }

  async findUserInfoByUniqueId(
    from: string,
    uniqueId: number,
  ): Promise<UserEntity> {
    const user = await this.userRepository.findOne({
      where: {
        from,
        uniqueId,
      },
    });

    return user;
  }

  async create(
    { deptId, roleIds, ...user }: Partial<UserCreateDto>,
    generateProfile: boolean = false,
  ): Promise<void> {
    await this.userRepository.manager.transaction(async (manager) => {
      const defaultRole = await manager.findOne(RoleEntity, {
        where: {
          default: 1,
        },
      });
      const defaultDept = await manager.findOne(DeptEntity, {
        where: {
          default: 1,
        },
      });

      let createProfile: ProfileEntity;
      // 注册的时候用户没有填写详细信息 要自动生成
      if (generateProfile) {
        createProfile = this.profileRepository.create({
          email: user.email,
          nickName: randomNickName(),
          avatar:
            'https://myblogimgbucket.oss-cn-beijing.aliyuncs.com/WechatIMG435.jpg',
        });
      } else {
        const { username, password, ...rest } = user;
        createProfile = this.profileRepository.create({
          ...rest,
        });
      }

      const profile = await this.profileRepository.save(createProfile);

      const createUser = manager.create(UserEntity, {
        ...user,
        roles: !isEmpty(roleIds)
          ? await manager.find(RoleEntity, {
              where: {
                id: In(roleIds),
              },
            })
          : defaultRole
            ? [defaultRole]
            : [],
        dept: deptId
          ? await manager.findOne(DeptEntity, {
              where: {
                id: deptId,
              },
            })
          : defaultDept,
        profile: profile,
      });
      return await manager.save(createUser);
    });
  }

  async update(id: number, updateDto: UserUpdateDto): Promise<void> {
    await this.userRepository.manager.transaction(async (manager) => {
      const defaultRole = await manager.findOne(RoleEntity, {
        where: {
          default: 1,
        },
      });
      const defaultDept = await manager.findOne(DeptEntity, {
        where: {
          default: 1,
        },
      });
      const user = await this.findUserInfo(id);
      if (!user) {
        throw new BizException(ErrorEnum.USER_NOT_EXIST);
      }

      const isAdmin = await this.isAdmin(user.id);

      if (isAdmin && updateDto.status === 0) {
        throw new BusinessException(
          ErrorEnum.USER_NOT_ALLOWED_TO_DISABLE_ADMIN,
        );
      }

      const { roleIds, deptId, status, ...profile } = updateDto;

      user.status = isNil(status) ? user.status : status;

      user.roles = !isEmpty(roleIds)
        ? await manager.find(RoleEntity, {
            where: {
              id: In(roleIds),
            },
          })
        : defaultRole
          ? [defaultRole]
          : [];

      // 保存用户的部门
      user.dept = deptId
        ? await manager.findOne(DeptEntity, {
            where: {
              id: deptId,
            },
          })
        : defaultDept;

      // 判断邮箱是否已经被注册
      profile.email && (await this.checkEmail(profile.email, user.id));

      // 判断手机号是否已经被绑定
      profile.phone && (await this.checkPhone(profile.phone, user.id));

      await this.updateProfile(user.id, profile);
      await manager.save(user);

      if (user.status === 0) {
        await this.forbiddenUserByIds([user.id]);
      }
    });
  }

  checkEmail(email: string, uid?: number) {
    return checkContact(this.userRepository, 'email', email, uid);
  }

  checkPhone(phone: string, uid?: number) {
    return checkContact(this.userRepository, 'phone', phone, uid);
  }

  async updatePassword(
    id: number,
    passwordDto: UserPasswordDto,
  ): Promise<void> {
    const { oldPassword, newPassword } = passwordDto;
    const user = await this.findUserInfo(id);
    if (!user) {
      throw new BizException(ErrorEnum.USER_NOT_EXIST);
    }

    if (!(await argon2.verify(user.password, oldPassword))) {
      throw new BizException(ErrorEnum.USER_PASSWORD_ERROR);
    }

    user.password = await argon2.hash(newPassword);

    await this.userRepository.save(user);
  }

  async updatePasswordByCode(passwordDto: PasswordUpdateDto): Promise<void> {
    const { email, password } = passwordDto;
    const user = await this.findUserInfoByEmail(email);

    user.password = await argon2.hash(password);

    await this.userRepository.save(user);
  }

  async resetPassword(id: number, dto: UserResetPasswordDto): Promise<void> {
    if (!REG_PWD.test(dto.password)) {
      throw new BizException(ErrorEnum.USER_PASSWORD_ERROR_RULE);
    }

    const user = await this.findUserInfo(id);
    if (!user) {
      throw new BizException(ErrorEnum.USER_NOT_EXIST);
    }

    user.password = await argon2.hash(dto.password);

    await this.userRepository.save(user);
  }

  async updateProfile(id: number, profile: UserProfileDto): Promise<void> {
    const user = await this.findUserInfo(id);
    if (!user) {
      throw new BizException(ErrorEnum.USER_NOT_EXIST);
    }

    if (profile.email) {
      await this.checkEmail(profile.email, user.id);
    }

    if (profile.phone) {
      await this.checkPhone(profile.phone, user.id);
    }

    this.profileRepository.merge(user.profile, profile);

    await this.profileRepository.save(user.profile);
  }

  async batchUpdateStatus({ ids, status }: UserStatusDto): Promise<void> {
    const users = await this.userRepository.find({
      where: {
        id: In(ids),
      },
      relations: ['roles'],
    });
    if (!isEmpty(users)) {
      users.forEach((user) => {
        if (
          user.roles.some(
            (role) =>
              role.value === Roles.ADMIN || role.value === Roles.SUPERADMIN,
          )
        ) {
          throw new BusinessException(
            ErrorEnum.USER_NOT_ALLOWED_TO_DISABLE_ADMIN,
          );
        }
      });

      await this.userRepository.update({ id: In(ids) }, { status });
      if (status === 0) {
        await this.forbiddenUserByIds(ids);
      }
    }
  }

  /**
   * 判断用户是否是管理员
   * @param id
   */
  async isAdmin(id: number) {
    const user = await this.findUserInfo(id);
    return (
      user &&
      user.roles.some(
        (role) => role.value === Roles.ADMIN || role.value === Roles.SUPERADMIN,
      )
    );
  }

  /**
   * 禁用用户
   * @param uid 用户 id
   * @param accessToken token
   */
  forbidden(uid: number, accessToken?: string): Promise<void> {
    return forbidUser(this.redis, uid, accessToken);
  }

  forbiddenUserByIds(ids: number[]): Promise<void> {
    return forbidUsers(this.redis, this.securityConfig, ids);
  }

  async delete(id: number) {
    const user = await this.findUserInfo(id);
    if (!user) {
      throw new BizException(ErrorEnum.USER_NOT_EXIST);
    }

    if (
      user.roles.some(
        (role) => role.value === Roles.ADMIN || role.value === Roles.SUPERADMIN,
      )
    ) {
      throw new BusinessException(ErrorEnum.USER_NOT_ALLOWED_TO_DELETE_ADMIN);
    }
    await this.forbiddenUserByIds([user.id]);
    await this.userRepository.delete(id);
    await this.profileRepository.delete(user.profile.id);
  }
}
