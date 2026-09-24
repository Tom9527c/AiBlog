import { BlogMusicLibrary } from './music/music-library.entity';
import { MusicLibraryStore } from './music/music-library.store';
import { MusicLibraryService } from './music/music-library.service';
import { QQMusicProvider } from './music/qq-music.provider';
import { MusicLibraryAdminController, MusicLibraryPublicController } from './music/music-library.controller';
import { Module } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AuthModule } from '../auth/auth.module';
import { BlogAccessPolicy } from './blog-access.policy';
import { BlogAuthService } from './blog-auth.service';
import { BlogAdminController } from './blog-admin.controller';
import { BlogPublicController } from './blog-public.controller';
import { BlogService } from './blog.service';
import { BlogMediaService } from './media/blog-media.service';
import { BlogSite, BlogMenu, BlogMedia, BlogMediaReference, CONTENT_ENTITIES } from './blog.entity';
import { StorageModule } from '../tools/storage/storage.module';
import { CommentsService } from './comments/comments.service';

@Module({
  imports: [AuthModule, StorageModule, TypeOrmModule.forFeature([...Object.values(CONTENT_ENTITIES), BlogMusicLibrary, BlogSite, BlogMenu, BlogMedia, BlogMediaReference])],
  controllers: [ BlogAdminController, BlogPublicController, MusicLibraryAdminController, MusicLibraryPublicController],
  providers: [ MusicLibraryStore, MusicLibraryService, QQMusicProvider, BlogService, CommentsService, BlogAuthService, BlogMediaService, {
    provide: BlogAccessPolicy, inject: [ConfigService],
    useFactory: (config: ConfigService) => new BlogAccessPolicy(config.getOrThrow<string>('security.jwtSecret')),
  }],
})
export class BlogModule {}
