import { useState } from "react";
import { FloatingWindow } from "../window/FloatingWindow";

export function BackgroundSettings({
  onClose,
  onChange,
  hero,
}: {
  onClose: () => void;
  onChange: (value: string) => void;
  hero: string;
}) {
  const [color, setColor] = useState("#7D9D9C");
  return (
    <FloatingWindow title="切换背景" onClose={onClose}>
      <div className="background-options">
        <button onClick={() => onChange("")}>恢复默认背景</button>
        <h3>纯色</h3>
        <input
          type="color"
          aria-label="背景颜色"
          value={color}
          onChange={(e) => {
            setColor(e.target.value);
            onChange(e.target.value);
          }}
        />
        <h3>渐变色</h3>
        <button
          style={{ background: "linear-gradient(to right, #eecda3, #ef629f)" }}
          onClick={() =>
            onChange("linear-gradient(to right, #eecda3, #ef629f)")
          }
        >
          柔和渐变
        </button>
        {hero && (
          <>
            <h3>站点封面</h3>
            <button onClick={() => onChange("@site-hero")}>
              使用站点封面背景
            </button>
          </>
        )}
      </div>
    </FloatingWindow>
  );
}
