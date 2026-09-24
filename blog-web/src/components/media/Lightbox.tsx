import Viewer, { type LightboxExternalProps } from 'yet-another-react-lightbox';
import Captions from 'yet-another-react-lightbox/plugins/captions';
import Counter from 'yet-another-react-lightbox/plugins/counter';
import Fullscreen from 'yet-another-react-lightbox/plugins/fullscreen';
import Slideshow from 'yet-another-react-lightbox/plugins/slideshow';
import Thumbnails from 'yet-another-react-lightbox/plugins/thumbnails';
import Zoom from 'yet-another-react-lightbox/plugins/zoom';
import 'yet-another-react-lightbox/styles.css';
import 'yet-another-react-lightbox/plugins/captions.css';
import 'yet-another-react-lightbox/plugins/counter.css';
import 'yet-another-react-lightbox/plugins/thumbnails.css';
import '../../styles/lightbox.css';

/** Shared full-screen viewer for article images and album media. */
export function Lightbox(props: LightboxExternalProps) {
  return <Viewer
    open
    className="media-lightbox"
    plugins={[Captions, Counter, Fullscreen, Slideshow, Thumbnails, Zoom]}
    labels={{
      Close: '关闭', Next: '下一张', Previous: '上一张',
      'Zoom in': '放大', 'Zoom out': '缩小',
      'Enter Fullscreen': '进入全屏', 'Exit Fullscreen': '退出全屏',
      Play: '自动播放', Pause: '暂停播放',
      'Show thumbnails': '显示缩略图', 'Hide thumbnails': '隐藏缩略图',
      Thumbnails: '缩略图', Lightbox: '图片浏览',
      'Photo gallery': '图片列表', Slide: '图片', Carousel: '图片浏览', '{index} of {total}': '第 {index} 张，共 {total} 张',
    }}
    carousel={{ preload: 1, padding: '48px', spacing: '10%' }}
    controller={{ closeOnBackdropClick: true, closeOnPullDown: true }}
    thumbnails={{ hidden: true, showToggle: true, width: 88, height: 64, gap: 6, padding: 0, border: 2, borderRadius: 5 }}
    zoom={{ scrollToZoom: true, maxZoomPixelRatio: 4 }}
    captions={{ descriptionTextAlign: 'center', descriptionMaxLines: 3 }}
    {...props}
  />;
}
export default Lightbox;
