import { Body, Controller, Get, Header, Param, Post, Req, SetMetadata, UseFilters, UseGuards } from '@nestjs/common';
import { Throttle, ThrottlerGuard } from '@nestjs/throttler';
import { Public } from '../../auth/decorators/public.decorator';
import { BlogAuthService, BlogRequest } from '../blog-auth.service';
import { BlogExceptionFilter } from '../blog-exception.filter';
import { MusicLibraryService } from './music-library.service';
@Controller('blog/admin/music-library')
@UseFilters(BlogExceptionFilter)
export class MusicLibraryAdminController {
  constructor(private readonly music: MusicLibraryService, private readonly auth: BlogAuthService) {}
  @Get() @Header('Cache-Control', 'no-store')
  async state(@Req() req: BlogRequest) { await this.auth.permit(req, 'music', 'list'); return this.music.admin(); }
  @Post('preview') @SetMetadata('requestTimeout', 30000)
  async preview(@Req() req: BlogRequest, @Body() body: { source: string; revision: number }) { await this.auth.permit(req, 'music', 'update'); return this.music.preview(body?.source, body?.revision); }
  @Post('import')
  async import(@Req() req: BlogRequest, @Body() body: { snapshot: unknown; revision: number }) { await this.auth.permit(req, 'music', 'update'); return this.music.importSnapshot(body?.snapshot, body?.revision); }
  @Post('apply')
  async apply(@Req() req: BlogRequest, @Body() body: { token: string; revision: number }) { await this.auth.permit(req, 'music', 'update'); return this.music.apply(body?.token, body?.revision); }
}
@Public()
@Controller('blog/public/music')
@UseFilters(BlogExceptionFilter)
export class MusicLibraryPublicController {
  constructor(private readonly music: MusicLibraryService) {}
  @Get() @Header('Cache-Control', 'no-store')
  snapshot() { return this.music.publicSnapshot(); }
  @Get('tracks/:id/media') @Header('Cache-Control', 'no-store') @UseGuards(ThrottlerGuard) @Throttle({ default: { limit: 30, ttl: 60000 } })
  media(@Param('id') id: string) { return this.music.media(id); }
}
