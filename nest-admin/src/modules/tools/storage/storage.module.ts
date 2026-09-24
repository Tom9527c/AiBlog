import { Module } from '@nestjs/common';
import { StorageService } from './storage.service';
import { StorageController } from './storage.controller';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Storage } from './storage.entity';
import { UserEntity } from '~/modules/user/user.entity';
import { BlogMedia, BlogMediaReference } from '../../blog/blog.entity';
import { ObjectStorageService } from './object-storage.service';

@Module({
  imports: [TypeOrmModule.forFeature([Storage, UserEntity, BlogMedia, BlogMediaReference])],
  controllers: [StorageController],
  providers: [StorageService, ObjectStorageService],
  exports: [TypeOrmModule, StorageService, ObjectStorageService],
})
export class StorageModule {}
