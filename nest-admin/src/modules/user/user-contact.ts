import { Repository } from 'typeorm';
import { BizException } from '~/common/exceptions/biz.exception';
import { ErrorEnum } from '~/constants/error.constant';
import { UserEntity } from './user.entity';

export async function checkContact(repository: Repository<UserEntity>, kind: 'email' | 'phone', value: string, uid?: number) {
  const user = await repository.findOne({ where: { profile: { [kind]: value } }, relations: ['profile'] });
  if (user && (!uid || user.id !== uid)) {
    throw new BizException(kind === 'email' ? ErrorEnum.USER_EMAIL_EXIST : ErrorEnum.USER_PHONE_EXIST);
  }
}
