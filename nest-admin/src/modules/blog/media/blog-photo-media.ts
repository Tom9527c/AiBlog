export function photoMetadata(metadata: Record<string, any>, url: string, mime?: string) {
  const mediaType = mime ? (mime.startsWith('video/') ? 'video' : 'image')
    : metadata.mediaType || (/\.(mp4|webm|mov)(?:[?#]|$)/i.test(url) ? 'video' : 'image');
  return { ...metadata, mediaType };
}
