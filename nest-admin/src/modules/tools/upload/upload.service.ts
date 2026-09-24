import { Injectable } from '@nestjs/common';
import { StorageService } from '../storage/storage.service';

@Injectable()
export class UploadService {
  constructor(private readonly storage: StorageService) {}
  async upload(file: Express.Multer.File, userId: string) {
    return (await this.storage.upload(file, userId, 'general')).url;
  }
}
