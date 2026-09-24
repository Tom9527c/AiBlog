export async function imageBlob(src: string) {
  const response = await fetch(src);
  if (!response.ok) throw new Error("图片下载失败");
  const blob = await response.blob();
  if (!blob.type.startsWith("image/")) throw new Error("当前地址不是图片");
  return blob;
}
export async function downloadImage(src: string) {
  const blob = await imageBlob(src);
  const url = URL.createObjectURL(blob);
  const a = document.createElement("a");
  a.href = url;
  a.download = `image-${Date.now()}.${blob.type.split("/")[1].replace("jpeg", "jpg").replace("svg+xml", "svg")}`;
  a.click();
  setTimeout(() => URL.revokeObjectURL(url), 1000);
}
export async function copyImage(src: string) {
  if (!navigator.clipboard?.write || typeof ClipboardItem === "undefined")
    throw new Error("浏览器不支持图片复制，请使用下载图片");
  // Convert formats to PNG, the browser clipboard's interoperable image type.
  const pending = imageBlob(src).then(async (blob) => {
    const bitmap = await createImageBitmap(blob);
    const canvas = document.createElement("canvas");
    canvas.width = bitmap.width;
    canvas.height = bitmap.height;
    const ctx = canvas.getContext("2d");
    if (!ctx) {
      bitmap.close();
      throw new Error("无法读取图片");
    }
    ctx.drawImage(bitmap, 0, 0);
    bitmap.close();
    return new Promise<Blob>((resolve, reject) =>
      canvas.toBlob(
        (value) => (value ? resolve(value) : reject(new Error("图片转换失败"))),
        "image/png",
      ),
    );
  });
  await navigator.clipboard.write([
    new ClipboardItem({ "image/png": pending }),
  ]);
}

