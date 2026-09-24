import { Column, Entity, PrimaryColumn } from 'typeorm';
import { MusicLibraryState } from './music-library';
@Entity('blog_music_library')
export class BlogMusicLibrary {
  @PrimaryColumn() id: number;
  @Column({ type: 'json' }) state: MusicLibraryState;
}
