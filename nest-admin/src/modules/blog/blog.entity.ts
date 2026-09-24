import { Column, CreateDateColumn, Entity, Index, PrimaryGeneratedColumn, UpdateDateColumn } from 'typeorm';

export abstract class BlogContent {
  @PrimaryGeneratedColumn() id: number;
  @Column({ length: 200 }) title: string;
  @Index({ unique: true }) @Column({ length: 200 }) slug: string;
  @Column({ type: 'text' }) summary: string;
  @Column({ type: 'longtext' }) body: string;
  @Column({ length: 12, default: 'markdown' }) format: string;
  @Column({ type: 'text' }) cover: string;
  @Column({ type: 'text' }) url: string;
  @Column({ length: 100, default: '' }) groupName: string;
  @Column({ type: 'int', default: 0 }) sort: number;
  @Column({ length: 12, default: 'draft' }) status: string;
  @Column({ length: 12, default: 'public' }) accessMode: string;
  @Column({ length: 255, default: '', select: false }) passwordHash: string;
  @Column({ default: 1 }) accessVersion: number;
  @Column({ type: 'int', nullable: true }) parentId: number | null;
  @Column({ type: 'int', nullable: true }) categoryId: number | null;
  @Column({ type: 'json' }) tagIds: number[];
  @Column({ type: 'json' }) metadata: Record<string, any>;
  @Column({ type: 'int', nullable: true }) authorId: number | null;
  @Column({ type: 'datetime', nullable: true }) publishedAt: Date | null;
  @CreateDateColumn() createdAt: Date;
  @UpdateDateColumn() updatedAt: Date;
}

@Entity('blog_document') export class BlogDocument extends BlogContent {}
@Entity('blog_category') export class BlogCategory extends BlogContent {}
@Entity('blog_tag') export class BlogTag extends BlogContent {}
@Entity('blog_album') export class BlogAlbum extends BlogContent {}
@Entity('blog_photo') export class BlogPhoto extends BlogContent {}
@Entity('blog_bangumi') export class BlogBangumi extends BlogContent {}
@Entity('blog_about') export class BlogAbout extends BlogContent {}
@Entity('blog_essay') export class BlogEssay extends BlogContent {}
@Entity('blog_link') export class BlogLink extends BlogContent {}
@Entity('blog_moment') export class BlogMoment extends BlogContent {}
@Entity('blog_collection') export class BlogCollection extends BlogContent {}
@Entity('blog_music') export class BlogMusic extends BlogContent {}
@Entity('blog_comment') export class BlogComment extends BlogContent {}

export const CONTENT_ENTITIES = { documents: BlogDocument, categories: BlogCategory, tags: BlogTag,
  albums: BlogAlbum, photos: BlogPhoto, bangumis: BlogBangumi, about: BlogAbout, essays: BlogEssay,
  links: BlogLink, moments: BlogMoment, collections: BlogCollection, music: BlogMusic, comments: BlogComment };
export type BlogKind = keyof typeof CONTENT_ENTITIES;

@Entity('blog_site')
export class BlogSite {
  @PrimaryGeneratedColumn() id: number;
  @Column({ type: 'json' }) settings: Record<string, any>;
}

@Entity('blog_menu')
export class BlogMenu {
  @PrimaryGeneratedColumn() id: number;
  @Column({ type: 'int', nullable: true }) parentId: number | null;
  @Column({ length: 100 }) title: string;
  @Column({ length: 1000 }) path: string;
  @Column({ length: 100, default: '' }) icon: string;
  @Column({ default: 0 }) sort: number;
  @Column({ default: true }) enabled: boolean;
  @Column({ default: false }) external: boolean;
  @Column({ default: false }) newWindow: boolean;
}

@Entity('blog_media')
export class BlogMedia {
  @PrimaryGeneratedColumn() id: number;
  @Column({ length: 255 }) name: string;
  @Column({ length: 100 }) filename: string;
  @Column({ length: 100 }) mime: string;
  @Column() size: number;
  @Column() uploaderId: number;
  @CreateDateColumn() createdAt: Date;

}

@Entity('blog_media_reference')
@Index(['mediaId', 'kind', 'contentId'], { unique: true })
export class BlogMediaReference {
  @PrimaryGeneratedColumn() id: number;
  @Column() mediaId: number;
  @Column({ length: 30 }) kind: string;
  @Column() contentId: number;
}
