import { Injectable } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { BlogMusicLibrary } from './music-library.entity';
import { emptyLibrary, MusicLibraryState } from './music-library';
@Injectable()
export class MusicLibraryStore {
  constructor(private readonly db: DataSource) {}
  async read(): Promise<MusicLibraryState> {
    return (await this.db.getRepository(BlogMusicLibrary).findOneBy({ id: 1 }))?.state || emptyLibrary();
  }
  async update(change: (state: MusicLibraryState) => void): Promise<MusicLibraryState> {
    return this.db.transaction(async manager => {
      await manager.query('INSERT IGNORE INTO blog_music_library (id, state) VALUES (1, ?)', [JSON.stringify(emptyLibrary())]);
      const repo = manager.getRepository(BlogMusicLibrary);
      const row = await repo.findOne({ where: { id: 1 }, lock: { mode: 'pessimistic_write' } });
      change(row.state);
      await repo.save(row);
      return row.state;
    });
  }
}
