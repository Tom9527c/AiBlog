export interface LyricLine { time: number; text: string }
export function parseLyrics(source: string): LyricLine[] {
  const result: LyricLine[] = [];
  const offset = Number(source.match(/\[offset:([+-]?\d+)\]/i)?.[1] || 0) / 1000;
  for (const line of source.split(/\r?\n/)) {
    const stamps = [...line.matchAll(/\[(\d+):(\d{2})(?:[.:](\d{1,3}))?\]/g)];
    const text = line.replace(/\[[^\]]*\]/g, '').trim();
    if (!text) continue;
    for (const match of stamps) result.push({ time: Math.max(0, Number(match[1]) * 60 + Number(match[2]) + Number(`0.${match[3] || 0}`) + offset), text });
  }
  return result.sort((a, b) => a.time - b.time);
}
export function lyricIndex(lines: LyricLine[], time: number) {
  let index = -1;
  for (let i = 0; i < lines.length && lines[i].time <= time; i += 1) index = i;
  return index;
}
