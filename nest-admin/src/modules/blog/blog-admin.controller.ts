import { SetMetadata, Body, Controller, Delete, Get, Param, ParseIntPipe, Post, Put, Query, Req, UploadedFile, UseInterceptors, UseFilters } from '@nestjs/common';
import { FileInterceptor } from '@nestjs/platform-express';
import { BlogAuthService, BlogRequest } from './blog-auth.service';
import { BlogContentDto, BlogMenuDto, BlogQuery, CommentModerateDto, CommentReplyDto } from './blog.dto';
import { BlogService } from './blog.service';
import { BlogMediaService } from './media/blog-media.service';
import { BlogExceptionFilter } from './blog-exception.filter';
import { CommentsService } from './comments/comments.service';

@Controller('blog/admin')
@UseFilters(BlogExceptionFilter)
export class BlogAdminController {
  constructor(private readonly blog: BlogService, private readonly comments: CommentsService, private readonly auth: BlogAuthService, private readonly media: BlogMediaService) {}
  @Get('about') async about(@Req() req: BlogRequest) { await this.auth.permit(req, 'about', 'list'); return this.blog.about(req, true); }
  @Put('about') async saveAbout(@Req() req: BlogRequest, @Body() dto: BlogContentDto) { const user = await this.auth.permit(req, 'about', 'update'); return this.blog.saveAbout(dto, user.uid); }
  @Get('site') async site(@Req() req: BlogRequest) { await this.auth.permit(req, 'site', 'list'); return this.blog.site(); }
  @Put('site') async saveSite(@Req() req: BlogRequest, @Body() dto: Record<string, any>) { const user = await this.auth.permit(req, 'site', 'update'); return this.blog.saveSite(dto, user.uid); }
  @Get('menus') async menus(@Req() req: BlogRequest) { await this.auth.permit(req, 'menus', 'list'); return this.blog.menus(); }
  @Post('menus') async addMenu(@Req() req: BlogRequest, @Body() dto: BlogMenuDto) { await this.auth.permit(req, 'menus', 'create'); return this.blog.saveMenu(dto); }
  @Put('menus/:id') async updateMenu(@Req() req: BlogRequest, @Param('id', ParseIntPipe) id: number, @Body() dto: BlogMenuDto) { await this.auth.permit(req, 'menus', 'update'); return this.blog.saveMenu(dto, id); }
  @Delete('menus/:id') async removeMenu(@Req() req: BlogRequest, @Param('id', ParseIntPipe) id: number) { await this.auth.permit(req, 'menus', 'delete'); return this.blog.deleteMenu(id); }
  @Get('content/:kind') async list(@Req() req: BlogRequest, @Param('kind') kind: string, @Query() query: BlogQuery) { await this.auth.permit(req, this.blog.kind(kind), 'list'); return this.blog.list(kind, query, req, true); }
  @Get('content/:kind/:id') async detail(@Req() req: BlogRequest, @Param('kind') kind: string, @Param('id', ParseIntPipe) id: number) { await this.auth.permit(req, this.blog.kind(kind), 'list'); return this.blog.detail(kind, String(id), req, true); }
  @Post('content/:kind') async create(@Req() req: BlogRequest, @Param('kind') kind: string, @Body() dto: BlogContentDto) { const user = await this.auth.permit(req, this.blog.kind(kind), 'create'); return this.blog.save(kind, dto, user.uid); }
  @Put('content/:kind/:id') async update(@Req() req: BlogRequest, @Param('kind') kind: string, @Param('id', ParseIntPipe) id: number, @Body() dto: BlogContentDto) { const user = await this.auth.permit(req, this.blog.kind(kind), 'update'); return this.blog.save(kind, dto, user.uid, id); }
  @Delete('content/:kind/:id') async remove(@Req() req: BlogRequest, @Param('kind') kind: string, @Param('id', ParseIntPipe) id: number) { await this.auth.permit(req, this.blog.kind(kind), 'delete'); return this.blog.remove(kind, id); }
  @Get('comments') async commentsList(@Req() req: BlogRequest, @Query() query: any) { await this.auth.permit(req, 'comments', 'list'); return this.comments.adminList(query); }
  @Post('comments/moderate') async moderate(@Req() req: BlogRequest, @Body() dto: CommentModerateDto) { await this.auth.permit(req, 'comments', 'update'); return this.comments.moderate(dto.ids, dto.status, dto.reason); }
  @Post('comments/:id/reply') async reply(@Req() req: BlogRequest, @Param('id', ParseIntPipe) id: number, @Body() dto: CommentReplyDto) { const user = await this.auth.permit(req, 'comments', 'create'); return this.comments.adminReply(req, id, dto.body, user); }
  @SetMetadata('requestTimeout', 120000)
  @Post('upload') @UseInterceptors(FileInterceptor('file', { limits: { fileSize: 25 * 1024 * 1024, files: 1 } }))
  async upload(@Req() req: BlogRequest, @UploadedFile() file: Express.Multer.File) { return this.media.upload(file, req); }
}
