import { In } from 'typeorm';
import Redis from 'ioredis';
import { isEmpty } from 'lodash';
import { ISecurityConfig } from '~/config';
import { AccessTokenEntity } from '../auth/entities/access-token.entity';
import {
  genAuthPermKey,
  genOnlineUserKey,
  genTokenBlacklistKey,
} from '~/helper/gen-redis-key';

export async function forbidUser(
  redis: Redis,
  uid: number,
  accessToken?: string,
): Promise<void> {
  // 移除用户的权限缓存
  await redis.del(genAuthPermKey(uid));
  // token 从表里删除
  if (accessToken) {
    const token = await AccessTokenEntity.findOne({
      where: {
        value: accessToken,
      },
      relations: ['refreshToken'],
    });
    if (token) {
      await redis.del(genOnlineUserKey(token.id));
      await token.refreshToken.remove();
      await token.remove();
    }
  }
}
/**
 * 通过传入用户 id 来禁用用户的token 从而让用户状态变化时 token 能及时被禁用
 * @param ids
 */
export async function forbidUsers(
  redis: Redis,
  securityConfig: ISecurityConfig,
  ids: number[],
) {
  const [list, _count] = await AccessTokenEntity.findAndCount({
    where: {
      user: {
        id: In(ids),
      },
    },
    relations: ['user'],
  });

  if (isEmpty(list)) return;

  list.forEach(async (item) => {
    await redis.set(
      genTokenBlacklistKey(item.value),
      item.value,
      'EX',
      securityConfig.jwtExpire,
    );
    await forbidUser(redis, item.user.id, item.value);
  });
}
