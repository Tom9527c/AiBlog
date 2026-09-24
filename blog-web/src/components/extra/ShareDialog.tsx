import { useEffect, useState } from "react";
import { Modal } from "../feedback/Modal";

export function ShareDialog({ onClose }: { onClose: () => void }) {
  const [image, setImage] = useState("");
  const [error, setError] = useState("");
  useEffect(() => {
    let active = true;
    import("qrcode")
      .then(({ default: QRCode }) =>
        QRCode.toDataURL(window.location.href, {
          width: 320,
          margin: 2,
          errorCorrectionLevel: "M",
        }),
      )
      .then((url: string) => {
        if (active) setImage(url);
      })
      .catch(() => {
        if (active) setError("二维码生成失败，请复制链接分享");
      });
    return () => {
      active = false;
    };
  }, []);
  return (
    <Modal title="分享本页" onClose={onClose}>
      <div className="share-qr">
        {image && <img src={image} alt="本页分享二维码" />}
        {error && <p role="alert">{error}</p>}
        <p>扫一扫，在手机上继续阅读</p>
        <input
          aria-label="分享链接"
          readOnly
          value={window.location.href}
          onFocus={(e) => e.target.select()}
        />
      </div>
    </Modal>
  );
}
