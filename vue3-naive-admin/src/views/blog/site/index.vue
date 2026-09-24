<script setup lang="ts">
import { computed, onBeforeUnmount, onMounted, ref } from 'vue';
import { onBeforeRouteLeave } from 'vue-router';
import { useThemeVars } from 'naive-ui';
import { type Site, api } from '@/service/api/blog';
import { useBlogAuth } from '@/hooks/business/blog-auth';
import PageHeaderSettings from '../components/page-header-settings.vue';
import HomeCards from './components/HomeCards.vue';
import SocialLinks from './components/SocialLinks.vue';
import HomeHeroSettings from './components/home-hero-settings.vue';
import { useSiteSettings } from './modules/use-site-settings';

// Route names are used by the layout's KeepAlive include list.
// eslint-disable-next-line vue/component-definition-name-casing
defineOptions({ name: 'blog_site' });
const { hasAuth } = useBlogAuth();
const theme = useThemeVars();
const colors = computed(() => ({
  '--site-card': theme.value.cardColor,
  '--site-soft': theme.value.actionColor,
  '--site-border': theme.value.dividerColor,
  '--site-muted': theme.value.textColor3,
  '--site-text': theme.value.textColor1,
  '--site-primary': theme.value.primaryColor,
  '--site-error': theme.value.errorColor
}));
const { form, loading, saving, uploads, error, savedAt, dirty, locked, canSave, load, save, restore, trackUpload } =
  useSiteSettings(
    (method, data) => api<Site>('site', method, data),
    () => hasAuth('blog:site:update')
  );
const activeTab = ref('basic');
const scroller = ref<HTMLElement>();
const themes = [
  { label: '跟随系统', value: 'system' },
  { label: '浅色模式', value: 'light' },
  { label: '深色模式', value: 'dark' }
];
const toggles = [
  { key: 'effectsEnabled', title: '页面特效', hint: '开启博客页面的动态效果', icon: 'lucide:sparkles' },
  { key: 'showMusic', title: '音乐播放器', hint: '在博客中显示音乐播放入口', icon: 'lucide:music-2' },
  { key: 'showAside', title: '侧边信息栏', hint: '展示个人资料和侧栏内容', icon: 'lucide:panel-right' }
] as const;
const dateValue = computed(() => {
  const value = Date.parse(form.value?.startDate || '');
  return Number.isNaN(value) ? null : value;
});
const status = computed(() => {
  if (uploads.value) return '图片上传中…';
  if (saving.value) return '正在保存…';
  if (dirty.value) return '有未保存的修改';
  return savedAt.value ? `已保存于 ${savedAt.value}` : '所有修改已保存';
});
function confirmDiscard(title: string) {
  return new Promise<boolean>(resolve => {
    if (!window.$dialog) {
      resolve(false);
      return;
    }
    window.$dialog.warning({
      title,
      content: '未保存的修改将被放弃，已保存的站点配置不受影响。',
      positiveText: '放弃修改',
      negativeText: '继续编辑',
      onPositiveClick: () => resolve(true),
      onNegativeClick: () => resolve(false),
      onClose: () => resolve(false),
      onMaskClick: () => resolve(false)
    });
  });
}
async function undo() {
  if (await confirmDiscard('撤销本次修改？')) restore();
}
async function submit() {
  if (await save()) window.$message?.success('站点配置已保存');
}
function beforeUnload(event: BeforeUnloadEvent) {
  if (!dirty.value && !uploads.value && !saving.value) return;
  event.preventDefault();
  event.returnValue = '';
}
onBeforeRouteLeave(async () => {
  if (uploads.value || saving.value) {
    window.$message?.warning('请等待上传或保存完成后再离开');
    return false;
  }
  if (!dirty.value) return true;
  const leave = await confirmDiscard('尚有修改未保存，确认离开？');
  if (leave) restore();
  return leave;
});
onMounted(() => {
  load();
  window.addEventListener('beforeunload', beforeUnload);
});
onBeforeUnmount(() => window.removeEventListener('beforeunload', beforeUnload));
</script>

<template>
  <div class="site-settings" :style="colors">
    <header class="settings-header">
      <div class="heading-group">
        <div class="heading-icon"><SvgIcon icon="lucide:sliders-horizontal" /></div>
        <div>
          <h1>站点管理</h1>
          <p>让每一个细节，都成为你的网站风格。</p>
        </div>
      </div>
      <NTag size="small" :bordered="false" round>博客设置</NTag>
    </header>
    <div v-if="!form" class="initial-state">
      <NSpin v-if="loading" size="large"><div class="loading-placeholder">正在加载站点配置…</div></NSpin>
      <NEmpty v-else description="暂时无法加载站点配置">
        <template #extra><NButton secondary type="primary" @click="load">重新加载</NButton></template>
      </NEmpty>
    </div>
    <template v-else>
      <div class="settings-navigation">
        <div style="padding: 16px 24px 0"><PageHeaderSettings /></div>
        <NTabs v-model:value="activeTab" type="line" :animated="false" @update:value="scroller?.scrollTo({ top: 0 })">
          <NTab name="basic">
            <SvgIcon icon="lucide:settings-2" />
            基本信息
          </NTab>
          <NTab name="appearance">
            <SvgIcon icon="lucide:palette" />
            外观展示
          </NTab>
          <NTab name="cards">
            <SvgIcon icon="lucide:panels-top-left" />
            首页卡片
            <span class="tab-count">{{ form.homeCards.length }}</span>
          </NTab>
          <NTab name="hero">
            <SvgIcon icon="lucide:monitor" />
            首页大屏
          </NTab>
          <NTab name="socials">
            <SvgIcon icon="lucide:link" />
            社交链接
            <span class="tab-count">{{ form.socials.length }}</span>
          </NTab>
        </NTabs>
      </div>
      <div ref="scroller" class="settings-scroll">
        <NAlert v-if="error" type="error" class="feedback" closable @close="error = ''">{{ error }}</NAlert>
        <NAlert v-if="!hasAuth('blog:site:update')" type="info" class="feedback">当前账号仅可查看站点配置。</NAlert>
        <NForm :disabled="locked" label-placement="top" :show-feedback="false">
          <div v-show="activeTab === 'basic'" class="settings-columns">
            <div class="section-stack">
              <section class="settings-card">
                <div class="section-heading">
                  <h2>站点信息</h2>
                  <p>网站的名称、简介与对外展示的信息</p>
                </div>
                <div class="field-grid">
                  <NFormItem label="站点名称">
                    <NInput
                      v-model:value="form.title"
                      :maxlength="5000"
                      placeholder="给你的网站起个名字"
                      :input-props="{ 'aria-label': '站点名称' }"
                    />
                  </NFormItem>
                  <NFormItem label="副标题">
                    <NInput v-model:value="form.subtitle" :maxlength="5000" placeholder="一句话介绍你的网站" />
                  </NFormItem>
                  <NFormItem label="站点描述" class="full-width">
                    <NInput
                      v-model:value="form.description"
                      :maxlength="5000"
                      type="textarea"
                      :autosize="{ minRows: 3, maxRows: 6 }"
                      placeholder="分享网站的主题、内容或创作初衷"
                    />
                  </NFormItem>
                  <NFormItem label="每页文章数" class="full-width">
                    <div>
                      <NInputNumber :value="form.articlePageSize ?? 8" :min="1" :max="100" :precision="0" :disabled="locked" @update:value="value => (form!.articlePageSize = value ?? 8)" />
                      <p class="save-hint">首页、分类和标签文章列表统一生效，默认每页 8 篇，可设置 1–100 篇。</p>
                    </div>
                  </NFormItem>
                  <NFormItem label="受限内容媒体校验" class="full-width">
                    <div>
                      <NSwitch :value="form.restrictedMediaValidationEnabled ?? false" :disabled="locked" aria-label="受限内容媒体校验" @update:value="form.restrictedMediaValidationEnabled = $event" />
                      <p class="save-hint">默认关闭，整个博客模块统一生效。开启后，登录或密码访问的内容必须使用博客上传的图片、音视频；关闭时允许外链，不影响访问权限。</p>
                    </div>
                  </NFormItem>
                  <NFormItem label="公告" class="full-width">
                    <NInput
                      v-model:value="form.announcement"
                      :maxlength="5000"
                      type="textarea"
                      :autosize="{ minRows: 2, maxRows: 5 }"
                      placeholder="写下想告诉访客的近况或通知"
                    />
                  </NFormItem>
                </div>
              </section>
              <section class="settings-card">
                <div class="section-heading">
                  <h2>页脚与备案</h2>
                  <p>显示在网站底部的补充信息</p>
                </div>
                <div class="field-grid">
                  <NFormItem label="页脚文字" class="full-width">
                    <NInput v-model:value="form.footerText" :maxlength="5000" placeholder="版权说明或你喜欢的一句话" />
                  </NFormItem>
                  <NFormItem label="备案号">
                    <NInput v-model:value="form.icp" :maxlength="5000" placeholder="如：粤ICP备xxxxxxxx号" />
                  </NFormItem>
                  <NFormItem label="建站日期">
                    <NDatePicker
                      :value="dateValue"
                      type="date"
                      clearable
                      class="w-full"
                      @update:value="v => (form!.startDate = v === null ? '' : new Date(v).toISOString())"
                    />
                  </NFormItem>
                </div>
              </section>
            </div>
            <section class="settings-card">
              <div class="section-heading">
                <h2>品牌标识</h2>
                <p>用熟悉的图像，让访客记住你</p>
              </div>
              <NFormItem label="站点 Logo">
                <SiteImageField v-model="form.logo" label="站点 Logo" :disabled="locked" @uploading="trackUpload" />
              </NFormItem>
              <div class="field-divider" />
              <NFormItem label="个人头像">
                <SiteImageField v-model="form.avatar" label="个人头像" :disabled="locked" @uploading="trackUpload" />
              </NFormItem>
              <div class="section-note">
                <SvgIcon icon="lucide:info" />
                <span>建议使用清晰的方形图片。上传后保存配置，即可应用到博客。</span>
              </div>
            </section>
          </div>
          <div v-show="activeTab === 'appearance'" class="settings-columns">
            <section class="settings-card">
              <div class="section-heading">
                <h2>首页介绍卡片</h2>
                <p>设置首页内容区左侧、分类入口上方的介绍卡片</p>
              </div>
              <div class="field-grid">
                <NFormItem label="介绍卡片标题" class="full-width">
                  <NInput
                    v-model:value="form.heroTitle"
                    :maxlength="5000"
                    type="textarea"
                    :autosize="{ minRows: 2, maxRows: 4 }"
                    placeholder="填写介绍卡片标题，支持换行"
                  />
                </NFormItem>
                <NFormItem label="介绍卡片副标题" class="full-width">
                  <NInput v-model:value="form.heroSubtitle" :maxlength="5000" placeholder="填写介绍卡片的补充说明" />
                </NFormItem>
                <NFormItem label="介绍卡片背景" class="full-width">
                  <SiteImageField
                    v-model="form.heroImage"
                    label="介绍卡片背景"
                    wide
                    :disabled="locked"
                    @uploading="trackUpload"
                  />
                </NFormItem>
              </div>
            </section>
            <section class="settings-card">
              <div class="section-heading">
                <h2>主题与功能</h2>
                <p>调整博客的默认观感和展示模块</p>
              </div>
              <NFormItem label="默认主题"><NSelect v-model:value="form.defaultTheme" :options="themes" /></NFormItem>
              <div class="switch-list">
                <div v-for="toggle in toggles" :key="toggle.key" class="switch-row">
                  <div class="switch-icon"><SvgIcon :icon="toggle.icon" /></div>
                  <div class="switch-description">
                    <h3>{{ toggle.title }}</h3>
                    <p>{{ toggle.hint }}</p>
                  </div>
                  <NSwitch v-model:value="form[toggle.key]" :aria-label="toggle.title" />
                </div>
              </div>
              <div class="section-note">
                <SvgIcon icon="lucide:info" />
                <span>这里设置的是博客前台的默认主题。</span>
              </div>
            </section>
          </div>
          <HomeHeroSettings
            v-show="activeTab === 'hero'"
            v-model="form"
            :disabled="locked"
            :uploading="!!uploads"
            @uploading="trackUpload"
          />
          <HomeCards v-show="activeTab === 'cards'" :form="form" :locked="locked" :uploads="uploads" @uploading="trackUpload" />
          <SocialLinks v-show="activeTab === 'socials'" :form="form" :locked="locked" :uploads="uploads" />
        </NForm>
      </div>
      <footer class="settings-footer">
        <div class="save-status" role="status">
          <span class="status-dot" :class="{ 'status-dot--dirty': dirty || uploads }" />
          <span>{{ status }}</span>
          <span class="save-hint">保存后应用到博客</span>
        </div>
        <div class="footer-actions">
          <NButton :disabled="!dirty || locked || !!uploads" @click="undo">撤销修改</NButton>
          <NButton type="primary" :loading="saving" :disabled="!canSave" @click="submit">
            <template #icon><SvgIcon icon="lucide:check" /></template>
            保存配置
          </NButton>
        </div>
      </footer>
    </template>
  </div>
</template>

<style scoped src="./index.css"></style>
