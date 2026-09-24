import { SetMetadata, Body, Controller, Delete, Post, UploadedFile, UseInterceptors } from '@nestjs/common';
import { FileInterceptor } from '@nestjs/platform-express';
import { ApiBody, ApiConsumes, ApiOperation, ApiTags } from '@nestjs/swagger';
import { ApiSecurityAuth } from '~/common/decorators/swagger.decorators';
import { AuthUser } from '~/modules/auth/decorators/auth-user.decorator';
import { definePermission, Perm } from '~/modules/auth/decorators/permission.decorator';
import { DeleteFileDto } from '~/common/dto/delete.dto';
import { UploadService } from './upload.service';
import { FileUploadDto } from './upload.dto';
import { StorageService } from '../storage/storage.service';

export const permissions = definePermission('upload', { UPLOAD: 'upload' } as const);

@ApiSecurityAuth()
@ApiTags('Tools - 上传模块')
@Controller('upload')
export class UploadController {
  constructor(private readonly storage: StorageService, private readonly uploads: UploadService) {}

  @SetMetadata('requestTimeout', 120000)
  @UseInterceptors(FileInterceptor('file', { limits: { fileSize: 100 * 1024 * 1024, files: 1 } }))
  @Post() @Perm(permissions.UPLOAD)
  @ApiOperation({ summary: '上传文件' }) @ApiConsumes('multipart/form-data') @ApiBody({ type: FileUploadDto })
  upload(@UploadedFile() file: Express.Multer.File, @AuthUser() user) {
    return this.uploads.upload(file, user.uid);
  }

  @Delete('delete') @Perm(permissions.UPLOAD)
  @ApiOperation({ summary: '删除自己的普通上传文件' })
  delete(@Body() dto: DeleteFileDto, @AuthUser() user) {
    return this.storage.deleteFilesByFileName(dto.fileNames, user.uid);
  }
}
