import { Type } from 'class-transformer';
import { ArrayMaxSize, IsArray, IsBoolean, IsDateString, IsEmail, IsIn, IsInt, IsObject, IsOptional, IsString, Max, MaxLength, Min, ValidateIf } from 'class-validator';

export class BlogQuery {
  @IsOptional() @IsIn(['public']) accessMode?: 'public';
  @IsOptional() @Type(() => Number) @IsInt() @Min(1) page = 1;
  @IsOptional() @Type(() => Number) @IsInt() @Min(1) @Max(100) pageSize = 12;
  @IsOptional() @IsString() @MaxLength(200) keyword?: string;
  @IsOptional() @Type(() => Number) @IsInt() @Min(1970) @Max(9999) year?: number;
  @IsOptional() @Type(() => Number) @IsInt() @Min(1) @Max(12) month?: number;
  @IsOptional() @IsIn(['draft', 'published']) status?: string;
  @IsOptional() @Type(() => Number) @IsInt() @Min(1) categoryId?: number;
  @IsOptional() @Type(() => Number) @IsInt() @Min(1) tagId?: number;
  @IsOptional() @Type(() => Number) @IsInt() @Min(1) parentId?: number;
  @IsOptional() @IsString() @MaxLength(100) groupName?: string;
  @IsOptional() @IsIn(['wish', 'watching', 'finished']) state?: string;
  @IsOptional() @IsString() @MaxLength(30) targetKind?: string;
  @IsOptional() @Type(() => Number) @IsInt() @Min(1) targetId?: number;
}

export class BlogContentDto {
  @IsOptional() @IsString() @MaxLength(200) title?: string;
  @IsOptional() @IsString() @MaxLength(200) slug?: string;
  @IsOptional() @IsString() @MaxLength(2000) summary?: string;
  @IsOptional() @IsString() @MaxLength(1000000) body?: string;
  @IsOptional() @IsIn(['markdown', 'html']) format?: string;
  @IsOptional() @IsString() @MaxLength(2000) cover?: string;
  @IsOptional() @IsString() @MaxLength(2000) url?: string;
  @IsOptional() @IsString() @MaxLength(100) groupName?: string;
  @IsOptional() @IsInt() @Min(-100000) @Max(100000) sort?: number;
  @IsOptional() @IsIn(['draft', 'published']) status?: string;
  @IsOptional() @IsIn(['public', 'login', 'password']) accessMode?: string;
  @IsOptional() @IsString() @MaxLength(128) password?: string;
  @IsOptional() @IsInt() @Min(1) parentId?: number | null;
  @IsOptional() @IsInt() @Min(1) categoryId?: number | null;
  @IsOptional() @IsArray() @ArrayMaxSize(100) @IsInt({ each: true }) @Min(1, { each: true }) tagIds?: number[];
  @IsOptional() @IsObject() metadata?: Record<string, any>;
  @IsOptional() @IsDateString() publishedAt?: string | null;
}

export class BlogMenuDto {
  @IsOptional() @IsInt() @Min(1) parentId?: number | null;
  @IsOptional() @IsString() @MaxLength(100) title?: string;
  @IsOptional() @IsString() @MaxLength(1000) path?: string;
  @IsOptional() @IsString() @MaxLength(100) icon?: string;
  @IsOptional() @IsInt() @Min(-100000) @Max(100000) sort?: number;
  @IsOptional() @IsBoolean() enabled?: boolean;
  @IsOptional() @IsBoolean() external?: boolean;
  @IsOptional() @IsBoolean() newWindow?: boolean;
}

export class BlogUnlockDto {
  @IsString() @MaxLength(128) password: string;
}

export class BlogCommentDto {
  @IsString() @MaxLength(5000) body: string;
  @IsOptional() @IsInt() @Min(1) parentId?: number;
  @IsOptional() @IsString() @MaxLength(100) nickname?: string;
  @ValidateIf((_object, value) => value !== undefined && value !== null && value !== '') @IsEmail() @MaxLength(254) email?: string;
  @IsOptional() @IsString() @MaxLength(2000) website?: string;
  @IsOptional() @IsString() @MaxLength(200) honeypot?: string;
  @IsObject() metadata: { targetKind?: string; targetId?: number };
}

export class CommentReactionDto { @IsIn([1, -1, 0]) value: number; }
export class CommentModerateDto {
  @IsArray() @ArrayMaxSize(100) @IsInt({ each: true }) @Min(1, { each: true }) ids: number[];
  @IsIn(['approved', 'rejected', 'pending']) status: 'approved' | 'rejected' | 'pending';
  @IsOptional() @IsString() @MaxLength(1000) reason?: string;
}
export class CommentReplyDto { @IsString() @MaxLength(5000) body: string; }
