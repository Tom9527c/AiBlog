import { ApiProperty } from '@nestjs/swagger';
import { Column, Entity, Index } from 'typeorm';
import { CommonEntity } from '~/common/entity/common.eneity';

@Entity({ name: 'tool_storage' })
export class Storage extends CommonEntity {
  @Column({ type: 'varchar', length: 200, comment: '文件名' })
  @ApiProperty({ description: '文件名' })
  name: string;

  @Column({
    type: 'varchar',
    length: 200,
    nullable: true,
    comment: '真实文件名',
  })
  @ApiProperty({ description: '真实文件名' })
  fileName: string;

  @Column({ name: 'ext_name', type: 'varchar', nullable: true })
  @ApiProperty({ description: '扩展名' })
  extName: string;

  @Column({ type: 'varchar' })
  @ApiProperty({ description: '文件类型' })
  path: string;

  @Column({ type: 'varchar', nullable: true })
  @ApiProperty({ description: '文件类型' })
  type: string;

  @Column({ type: 'varchar', nullable: true })
  @ApiProperty({ description: '文件大小' })
  size: string;

  @Column({ nullable: true, name: 'user_id' })
  @ApiProperty({ description: '用户ID' })
  userId: string;

  @Column({ type: 'varchar', length: 16, default: 'public' })
  visibility: 'public' | 'private';

  @Column({ type: 'varchar', length: 24, default: 'general' })
  source: string;

  @Column({ name: 'storage_key', type: 'varchar', length: 500, nullable: true })
  storageKey: string;

  @Column({ type: 'varchar', length: 20, nullable: true })
  provider: string;

  @Index({ unique: true })
  @Column({ name: 'blog_media_id', nullable: true })
  blogMediaId: number;

  @Column({ type: 'varchar', length: 100, nullable: true })
  mime: string;

  @Column({ name: 'storage_profile', type: 'text', nullable: true, select: false })
  storageProfile: string;

  @Column({ name: 'previous_locations', type: 'longtext', nullable: true, select: false })
  previousLocations: string;
}
