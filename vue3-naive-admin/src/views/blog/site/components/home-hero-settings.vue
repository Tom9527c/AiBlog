<script setup lang="ts">
import type { Site } from '@/service/api/blog';
import SiteImageField from './site-image-field.vue';

const form = defineModel<Site>({ required: true });
const props = defineProps<{ disabled: boolean; uploading: boolean }>();
const emit = defineEmits<{ uploading: [active: boolean] }>();
const keys = new WeakMap<object, number>();
let nextKey = 0;
function rowKey(row: object) {
  if (!keys.has(row)) {
    nextKey += 1;
    keys.set(row, nextKey);
  }
  return keys.get(row)!;
}
function move(index: number, step: number) {
  if (props.disabled || props.uploading) return;
  const rows = form.value.homeHeroSlides;
  const target = index + step;
  if (target < 0 || target >= rows.length) return;
  const [row] = rows.splice(index, 1);
  rows.splice(target, 0, row);
}
</script>

<template>
  <div class="hero-settings">
    <section class="hero-card">
      <div class="hero-heading">
        <div>
          <h2>首页大屏</h2>
          <p>设置首页顶部的全屏欢迎区域，包括大屏文案、图片或视频与切换效果。</p>
        </div>
        <NSwitch v-model:value="form.homeHeroEnabled" :disabled="disabled" aria-label="显示首页大屏" />
      </div>
      <div class="hero-copy">
        <NFormItem label="大屏标题">
          <NInput
            v-model:value="form.homeHeroTitle"
            type="textarea"
            :maxlength="5000"
            :autosize="{ minRows: 2, maxRows: 4 }"
            placeholder="填写全屏欢迎标题，留空不显示"
          />
        </NFormItem>
        <NFormItem label="大屏副标题">
          <NInput v-model:value="form.homeHeroSubtitle" :maxlength="5000" placeholder="填写大屏副标题，留空不显示" />
        </NFormItem>
      </div>
      <div class="hero-grid">
        <NFormItem label="素材适配">
          <NSelect
            v-model:value="form.homeHeroFit"
            :options="[
              { label: '铺满屏幕（允许裁切）', value: 'cover' },
              { label: '完整展示（允许留边）', value: 'contain' }
            ]"
          />
        </NFormItem>
        <NFormItem label="素材对齐">
          <NSelect
            v-model:value="form.homeHeroPosition"
            :options="[
              { label: '居中', value: 'center' },
              { label: '顶部', value: 'top' },
              { label: '底部', value: 'bottom' }
            ]"
          />
        </NFormItem>
        <NFormItem label="遮罩深度（%）">
          <NInputNumber v-model:value="form.homeHeroOverlay" :min="0" :max="80" :precision="0" :clearable="false" />
        </NFormItem>
        <NFormItem label="鼠标跟随视差">
          <NSwitch v-model:value="form.homeHeroParallax" aria-label="鼠标跟随视差" />
        </NFormItem>
        <NFormItem label="随机展示">
          <NSwitch v-model:value="form.homeHeroRandom" aria-label="随机展示" />
        </NFormItem>
        <NFormItem label="自动轮播">
          <NSwitch v-model:value="form.homeHeroAutoplay" aria-label="自动轮播" />
        </NFormItem>
        <NFormItem v-if="form.homeHeroAutoplay" label="切换间隔（秒）">
          <NInputNumber v-model:value="form.homeHeroInterval" :min="3" :max="600" :precision="0" :clearable="false" />
        </NFormItem>
      </div>
      <p class="hero-note">
        默认展示第一项素材；开启随机后每次进入首页随机选择素材，轮播时避免连续重复。完整展示模式和触屏设备不启用视差。
        大屏文案和素材仅在此处设置。系统开启减少动态效果时，停用自动轮播、视频自动播放和视差。
      </p>
    </section>
    <section class="hero-card">
      <div class="hero-heading">
        <div>
          <h2>
            大屏素材
            <small>{{ form.homeHeroSlides.length }} / 30</small>
          </h2>
          <p>支持图片、动图和 MP4 视频。视频静音循环播放，手机素材留空时使用桌面素材。</p>
        </div>
        <NButton
          secondary
          type="primary"
          :disabled="disabled || form.homeHeroSlides.length >= 30"
          @click="form.homeHeroSlides.push({ image: '', mobileImage: '', type: 'image', mobileType: 'image' })"
        >
          <template #icon><SvgIcon icon="lucide:plus" /></template>
          添加素材
        </NButton>
      </div>
      <NEmpty v-if="!form.homeHeroSlides.length" description="请添加大屏素材，未配置素材时不展示首页大屏" />
      <div class="hero-slides">
        <article v-for="(slide, index) in form.homeHeroSlides" :key="rowKey(slide)" class="hero-slide">
          <div class="hero-heading">
            <strong>素材 {{ index + 1 }}</strong>
            <NSpace :size="4">
              <NButton
                size="small"
                quaternary
                :disabled="disabled || uploading || index === 0"
                @click="move(index, -1)"
              >
                上移
              </NButton>
              <NButton
                size="small"
                quaternary
                :disabled="disabled || uploading || index === form.homeHeroSlides.length - 1"
                @click="move(index, 1)"
              >
                下移
              </NButton>
              <NButton
                size="small"
                quaternary
                type="error"
                :disabled="disabled || uploading"
                @click="form.homeHeroSlides.splice(index, 1)"
              >
                删除
              </NButton>
            </NSpace>
          </div>
          <NFormItem label="桌面素材（建议横屏）">
            <SiteImageField
              v-model="slide.image"
              v-model:media-type="slide.type"
              allow-video
              :label="`大屏素材 ${index + 1}`"
              :maxlength="2000"
              wide
              :disabled="disabled"
              @uploading="emit('uploading', $event)"
            />
          </NFormItem>
          <NFormItem label="手机素材（可选，建议竖屏）">
            <SiteImageField
              v-model="slide.mobileImage"
              v-model:media-type="slide.mobileType"
              allow-video
              :label="`大屏手机素材 ${index + 1}`"
              :maxlength="2000"
              :disabled="disabled"
              @uploading="emit('uploading', $event)"
            />
          </NFormItem>
        </article>
      </div>
    </section>
  </div>
</template>

<style scoped>
.hero-copy {
  display: grid;
  gap: 18px;
  margin-bottom: 24px;
}
.hero-settings {
  display: grid;
  gap: 20px;
}
.hero-card {
  padding: 24px;
  border: 1px solid var(--site-border);
  border-radius: 16px;
  background: var(--site-card);
}
.hero-heading {
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 16px;
  margin-bottom: 20px;
}
.hero-heading h2 {
  margin: 0;
  font-size: 17px;
}
.hero-heading p,
.hero-note {
  margin: 6px 0 0;
  color: var(--site-muted);
  font-size: 12px;
  line-height: 1.8;
}
.hero-heading small {
  margin-left: 8px;
  color: var(--site-muted);
  font-size: 12px;
  font-weight: 400;
}
.hero-grid {
  display: grid;
  grid-template-columns: repeat(3, minmax(0, 1fr));
  gap: 20px;
}
.hero-grid :deep(.n-input-number) {
  width: 100%;
}
.hero-note {
  margin-top: 18px;
}
.hero-slides {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 20px;
}
.hero-slide {
  display: grid;
  gap: 16px;
  min-width: 0;
  padding: 18px;
  border: 1px solid var(--site-border);
  border-radius: 12px;
}
.hero-slide .hero-heading {
  margin-bottom: 0;
}
@media (max-width: 900px) {
  .hero-grid {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }
  .hero-slides {
    grid-template-columns: minmax(0, 1fr);
  }
}
@media (max-width: 600px) {
  .hero-card {
    padding: 16px;
  }
  .hero-heading {
    flex-wrap: wrap;
  }
  .hero-grid {
    grid-template-columns: minmax(0, 1fr);
  }
}
</style>
