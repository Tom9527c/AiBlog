import { Body, Controller, Get, Header, Param, ParseIntPipe, Post, Query, Req, Res, UseGuards, UseFilters } from '@nestjs/common';
import { Throttle, ThrottlerGuard } from '@nestjs/throttler';
import { Response } from 'express';
import { DataSource } from 'typeorm';
import { Public } from '../auth/decorators/public.decorator';
import { AuthService } from '../auth/auth.service';
import { UserEntity } from '../user/user.entity';
import { Bypass } from '~/common/decorators/bypass.decorator';
import { BlogAuthService, BlogRequest } from './blog-auth.service';
import { BlogCommentDto, BlogQuery, BlogUnlockDto, CommentReactionDto } from './blog.dto';
import { BlogService } from './blog.service';
import { BlogMediaService } from './media/blog-media.service';
import { BlogExceptionFilter } from './blog-exception.filter';
import { CommentsService } from './comments/comments.service';

@Public()
@Controller('blog/public')
@UseFilters(BlogExceptionFilter)
export class BlogPublicController {
  constructor(private readonly blog: BlogService, private readonly comments: CommentsService, private readonly auth: BlogAuthService, private readonly accounts: AuthService, private readonly db: DataSource, private readonly media: BlogMediaService) {}
  @Get('about') @Header('Cache-Control', 'private, no-store')
  about(@Req() req: BlogRequest) { return this.blog.about(req); }
  @Get('site') site() { return this.blog.site(); }
  @Get('menus') menus() { return this.blog.menus(true); }
  @Get('stats') stats() { return this.blog.stats(); }
  @Get('content/:kind') @Header('Cache-Control', 'private, no-store')
  list(@Req() req: BlogRequest, @Param('kind') kind: string, @Query() query: BlogQuery) { return this.blog.list(kind, query, req); }
  @Get('content/:kind/:slug') @Header('Cache-Control', 'private, no-store')
  detail(@Req() req: BlogRequest, @Param('kind') kind: string, @Param('slug') slug: string) { return this.blog.detail(kind, slug, req); }
  @Post('content/:kind/:id/unlock') @UseGuards(ThrottlerGuard) @Throttle({ default: { limit: 8, ttl: 60000 } }) @Header('Cache-Control', 'no-store')
  unlock(@Param('kind') kind: string, @Param('id', ParseIntPipe) id: number, @Body() dto: BlogUnlockDto) { return this.blog.unlock(kind, id, dto.password); }
  @Get('session') @Header('Cache-Control', 'no-store')
  async session(@Req() req: BlogRequest) {
    const user = await this.auth.identify(req, true);
    const account = await this.db.getRepository(UserEntity).findOne({ where: { id: user.uid }, relations: ['profile'] });
    return { id: account.id, username: account.username, nickName: account.profile?.nickName || account.username, avatar: account.profile?.avatar || '' };
  }
  @Post('logout') async logout(@Req() req: BlogRequest) {
    const user = await this.auth.identify(req, true);
    await this.accounts.clearLoginStatus(req.headers.authorization.replace(/^Bearer\s+/i, ''), user);
  }
  @Post('comments') @Header('Accept-CH', 'Sec-CH-UA-Platform-Version, Sec-CH-UA-Full-Version-List') @UseGuards(ThrottlerGuard) @Throttle({ default: { limit: 5, ttl: 60000 } })
  comment(@Req() req: BlogRequest, @Body() dto: BlogCommentDto) { return this.comments.create(req, dto); }
  @Get('comments') @Header('Cache-Control', 'private, no-store') @Header('Accept-CH', 'Sec-CH-UA-Platform-Version, Sec-CH-UA-Full-Version-List')
  commentsList(@Req() req: BlogRequest, @Query() query: BlogQuery & { order?: string }) { return this.comments.list(req, query); }
  @Post('comments/:id/reaction') @UseGuards(ThrottlerGuard) @Throttle({ default: { limit: 30, ttl: 60000 } })
  react(@Req() req: BlogRequest, @Param('id', ParseIntPipe) id: number, @Body() dto: CommentReactionDto) { return this.comments.react(req, id, dto.value); }
  @Get('media/:id') @Bypass()
  async readMedia(@Req() req: BlogRequest, @Param('id', ParseIntPipe) id: number, @Res() res: Response) {
    const file = await this.media.read(id, req);
    res.set({ 'Content-Type': file.mime, 'Cache-Control': 'private, no-store', 'X-Content-Type-Options': 'nosniff', 'Content-Length': String(file.buffer.length) }).send(file.buffer);
  }
}
