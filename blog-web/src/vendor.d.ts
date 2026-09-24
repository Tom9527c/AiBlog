declare module "qrcode" {
  const QRCode: {
    toDataURL(
      text: string,
      options?: {
        width?: number;
        margin?: number;
        errorCorrectionLevel?: string;
      },
    ): Promise<string>;
  };
  export default QRCode;
}
declare module "opencc-js" {
  export function Converter(options: {
    from: string;
    to: string;
  }): (text: string) => string;
}
