import { SetMetadata, Body, Controller, Get, Post, Query, Param, ParseIntPipe, Res } from '@nestjs/common';
import { StorageService } from './storage.service';
import { ApiOperation, ApiTags } from '@nestjs/swagger';
import { ApiSecurityAuth } from '~/common/decorators/swagger.decorators';
import {
  definePermission,
  Perm,
} from '~/modules/auth/decorators/permission.decorator';
import { StorageInfo } from './storage.modal';
import { Response } from 'express';
import { Bypass } from '~/common/decorators/bypass.decorator';
import { ApiResult } from '~/common/decorators/api-result.decorator';
import { StorageDeleteDto, StoragePageDto } from './storage.dto';

export const permissions = definePermission('tool:storage', {
  LIST: 'list',
  DELETE: 'delete',
  MIGRATE: 'migrate',
} as const);

@ApiTags('Tools - 存储模块')
@ApiSecurityAuth()
@Controller('storage')
export class StorageController {
  constructor(private readonly storageService: StorageService) {}

  @Get('list')
  @ApiOperation({ summary: '获取统一文件列表' })
  @ApiResult({ type: [StorageInfo], isPage: true })
  @Perm(permissions.LIST)
  async list(@Query() dto: StoragePageDto) {
    return this.storageService.list(dto);
  }

  @Get(':id/preview') @Perm(permissions.LIST) @Bypass()
  async preview(@Param('id', ParseIntPipe) id: number, @Res() res: Response) {
    const file = await this.storageService.read(id);
    const inline = /^(image\/(png|jpeg|gif|webp|avif)|video\/mp4|audio\/mpeg)$/.test(file.mime);
    res.set({ 'Content-Type': inline ? file.mime : 'application/octet-stream', 'Cache-Control': 'private, no-store',
      'X-Content-Type-Options': 'nosniff', 'Content-Security-Policy': "default-src 'none'; sandbox",
      'Content-Disposition': `${inline ? 'inline' : 'attachment'}; filename*=UTF-8''${encodeURIComponent(file.name)}` }).send(file.buffer);
  }

  @SetMetadata('requestTimeout', 120000)
  @Post(':id/migrate') @Perm(permissions.MIGRATE)
  migrate(@Param('id', ParseIntPipe) id: number) { return this.storageService.migrate(id); }

  @ApiOperation({ summary: '删除文件' })
  @Post('delete')
  @Perm(permissions.DELETE)
  async delete(@Body() dto: StorageDeleteDto): Promise<void> {
    await this.storageService.delete(dto.ids);
  }
}
