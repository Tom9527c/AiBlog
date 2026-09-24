<script setup lang="ts">
import { computed, onBeforeUnmount, onMounted, ref } from 'vue';
import { onBeforeRouteLeave } from 'vue-router';
import { useThemeVars } from 'naive-ui';
import { api, type Content } from '@/service/api/blog';
import { useBlogAuth } from '@/hooks/business/blog-auth';
import BodyEditor from '../components/body-editor.vue';
import AboutField from './components/about-field.vue';
import { tabs, groups, collections } from './modules/about-fields';
import { useAboutSettings } from './modules/use-about-settings';
defineOptions({ name: 'blog_about' });
const { hasAuth } = useBlogAuth();
const theme = useThemeVars();
const colors = computed(() => ({ '--site-card': theme.value.cardColor, '--site-soft': theme.value.actionColor, '--site-border': theme.value.dividerColor, '--site-muted': theme.value.textColor3, '--site-text': theme.value.textColor1, '--site-primary': theme.value.primaryColor, '--site-error': theme.value.errorColor }));
const state = useAboutSettings((method, data) => api<Content>('about', method, data), () => hasAuth('blog:about:update'));
const { form, loading, saving, uploads, error, savedAt, dirty, locked, canSave, load, save, restore, trackUpload } = state;
const activeTab = ref('basic');
const pageRoot = ref<HTMLElement>();
function selectTab(key: string) { activeTab.value = key; pageRoot.value?.scrollIntoView({ block: 'start' }); }
const status = computed(() => uploads.value ? '图片上传中…' : saving.value ? '正在保存…' : dirty.value ? '有未保存的修改' : savedAt.value ? `已保存于 ${savedAt.value}` : '已加载个人资料');
const rowIds = new WeakMap<object, number>();
let nextId = 0;
function rowKey(row: object) { if (!rowIds.has(row)) rowIds.set(row, ++nextId); return rowIds.get(row)!; }
function move(rows: any[], index: number, direction: number) { if (locked.value || uploads.value) return; const target = index + direction; if (target < 0 || target >= rows.length) return; rows.splice(target, 0, ...rows.splice(index, 1)); }
function add(key: string, fields: { key: string }[]) { if (!form.value || locked.value) return; form.value.metadata[key].push(Object.fromEntries(fields.map(field => [field.key, '']))); }
function remove(rows: any[], index: number) { if (!locked.value && !uploads.value) rows.splice(index, 1); }
function confirmDiscard() { return new Promise<boolean>(resolve => { if (!window.$dialog) return resolve(false); window.$dialog.warning({ title: '放弃未保存的修改？', content: '已保存的个人资料不会受到影响。', positiveText: '放弃修改', negativeText: '继续编辑', onPositiveClick: () => resolve(true), onNegativeClick: () => resolve(false), onClose: () => resolve(false), onMaskClick: () => resolve(false) }); }); }
async function undo() { if (await confirmDiscard()) restore(); }
async function submit() { if (await save()) window.$message?.success('个人资料已保存'); }
function beforeUnload(event: BeforeUnloadEvent) { if (dirty.value || saving.value || uploads.value) { event.preventDefault(); event.returnValue = ''; } }
onBeforeRouteLeave(async () => { if (saving.value || uploads.value) { window.$message?.warning('请等待上传或保存完成'); return false; } if (!dirty.value) return true; const leave = await confirmDiscard(); if (leave) restore(); return leave; });
onMounted(() => { load(); window.addEventListener('beforeunload', beforeUnload); });
onBeforeUnmount(() => window.removeEventListener('beforeunload', beforeUnload));
</script>

<template>
  <div ref="pageRoot" class="about-settings" :style="colors">
    <header class="about-header">
      <div class="about-heading"><div class="heading-icon"><SvgIcon icon="lucide:contact-round" /></div><div><div class="eyebrow">个人主页 · ABOUT ME</div><h1>关于本人</h1><p>在这里编辑博客关于页的每一个细节。</p></div></div>
      <NTag round :bordered="false" :type="form?.status === 'published' ? 'success' : 'warning'">{{ form?.status === 'published' ? '已发布' : '草稿' }}</NTag>
    </header>
    <NAlert v-if="error" type="error" class="feedback">{{ error }}</NAlert>
    <div v-if="!form" class="initial-state"><NSpin v-if="loading" size="large" /><NEmpty v-else description="个人资料暂时无法加载"><template #extra><NButton @click="load">重新加载</NButton></template></NEmpty></div>
    <template v-else>
      <NAlert v-if="!hasAuth('blog:about:update')" type="info" class="feedback">当前账号仅可查看个人资料。</NAlert>
      <div class="about-workspace">
        <nav class="about-nav" aria-label="个人资料分区"><button v-for="tab in tabs" :key="tab.key" :class="{ active: activeTab === tab.key }" @click="selectTab(tab.key)"><SvgIcon :icon="tab.icon" />{{ tab.title }}<SvgIcon icon="lucide:chevron-right" class="nav-arrow" /></button><p>留空的内容不会展示。关闭模块后，已填写的数据仍会保留。</p></nav>
        <main class="about-editor">
          <NForm label-placement="top" :show-feedback="false" :disabled="locked">
            <section v-show="activeTab === 'basic'" class="settings-card">
              <div class="section-heading"><div><h2>页面设置</h2><p>统一保存个人资料，发布后在博客中展示。</p></div></div>
              <NAlert v-if="form.accessMode !== 'public'" type="info" class="feedback">仅在站点设置开启“受限内容媒体校验”时，登录或密码访问的内容才要求使用上传图片；默认关闭，可使用外链。</NAlert>
              <div class="field-grid"><NFormItem label="页面标题" required><NInput v-model:value="form.title" :maxlength="200" :input-props="{ 'aria-label': '页面标题' }" /></NFormItem><NFormItem label="发布状态"><NSelect v-model:value="form.status" :options="[{ label: '草稿', value: 'draft' }, { label: '发布', value: 'published' }]" /></NFormItem><NFormItem label="访问方式"><NSelect v-model:value="form.accessMode" :options="[{ label: '公开', value: 'public' }, { label: '登录可见', value: 'login' }, { label: '密码访问', value: 'password' }]" /></NFormItem><NFormItem v-if="form.accessMode === 'password'" label="访问密码"><NInput v-model:value="form.password" type="password" show-password-on="click" placeholder="已设置时留空保持原密码" /></NFormItem><NFormItem label="发布时间（留空立即发布）"><NDatePicker :value="form.publishedAt ? Date.parse(form.publishedAt) : null" type="datetime" clearable @update:value="value => form!.publishedAt = value === null ? null : new Date(value).toISOString()" /></NFormItem></div>
            </section>
            <template v-for="tab in tabs" :key="tab.key">
              <section v-for="group in groups[tab.key]" v-show="activeTab === tab.key" :key="group.key" class="settings-card">
                <div class="section-heading"><div><h2>{{ group.title }}</h2><p>{{ group.hint }}</p></div><NSwitch v-if="group.toggle" :value="form.metadata.sections[group.toggle] !== false" :disabled="locked" :aria-label="`显示${group.title}`" @update:value="form.metadata.sections[group.toggle!] = $event" /></div>
                <div class="field-grid"><AboutField v-for="field in group.fields" :key="field.key" v-model="form.metadata[field.key]" :field="field" :disabled="locked" @uploading="trackUpload" /></div>
              </section>
            </template>
            <section v-for="collection in collections" v-show="activeTab === collection.tab" :key="collection.key" class="settings-card">
              <div class="section-heading"><div><h2>{{ collection.title }} <span class="count">{{ form.metadata[collection.key].length }} / 100</span></h2><p>按下方顺序展示，可上移、下移或移除。</p></div><div class="section-actions"><NSwitch :value="form.metadata.sections[collection.toggle] !== false" :disabled="locked" :aria-label="`显示${collection.title}`" @update:value="form.metadata.sections[collection.toggle] = $event" /><NButton secondary type="primary" :disabled="locked || form.metadata[collection.key].length >= 100" @click="add(collection.key, collection.fields)">添加</NButton></div></div>
              <NEmpty v-if="!form.metadata[collection.key].length" description="暂无内容，点击添加开始编辑" class="empty" />
              <div class="entries"><article v-for="(row, index) in form.metadata[collection.key]" :key="rowKey(row)" class="entry-card"><div class="entry-heading"><strong>{{ String(Number(index) + 1).padStart(2, '0') }} · {{ row.name || row.title || row.label || '新条目' }}</strong><div><NButton size="small" quaternary :disabled="locked || !!uploads || index === 0" :aria-label="`上移${collection.title} ${Number(index) + 1}`" @click="move(form.metadata[collection.key], Number(index), -1)">↑</NButton><NButton size="small" quaternary :disabled="locked || !!uploads || index === form.metadata[collection.key].length - 1" :aria-label="`下移${collection.title} ${Number(index) + 1}`" @click="move(form.metadata[collection.key], Number(index), 1)">↓</NButton><NButton size="small" quaternary type="error" :disabled="locked || !!uploads" @click="remove(form.metadata[collection.key], Number(index))">移除</NButton></div></div><div class="field-grid"><AboutField v-for="field in collection.fields" :key="field.key" v-model="row[field.key]" :field="field" :disabled="locked" @uploading="trackUpload" /></div></article></div>
            </section>
            <section v-show="activeTab === 'body'" class="settings-card"><div class="section-heading"><div><h2>补充介绍</h2><p>显示在卡片下方，可写下更多关于你的故事。</p></div><NSwitch :value="form.metadata.sections.body !== false" :disabled="locked" aria-label="显示补充介绍" @update:value="form.metadata.sections.body = $event" /></div><NFormItem label="正文格式"><NSelect v-model:value="form.format" :options="[{ label: 'Markdown', value: 'markdown' }, { label: '富文本 HTML', value: 'html' }]" /></NFormItem><div :inert="locked || undefined"><BodyEditor :key="`${form.id}-${form.format}`" v-model="form.body" :format="form.format || 'markdown'" /></div></section>
          </NForm>
        </main>
      </div>
      <footer class="about-savebar"><span :class="{ dirty }"><i />{{ status }}</span><div><NButton :disabled="!dirty || locked || !!uploads" @click="undo">撤销修改</NButton><NButton type="primary" :loading="saving" :disabled="!canSave" @click="submit"><template #icon><SvgIcon icon="lucide:save" /></template>保存个人资料</NButton></div></footer>
    </template>
  </div>
</template>

<style scoped>
.about-settings { color: var(--site-text); padding-bottom: 12px; }
.about-header { display: flex; align-items: center; justify-content: space-between; padding: 8px 6px 24px; gap: 16px; }
.about-heading { display: flex; gap: 16px; align-items: center; }
.heading-icon { display: grid; place-items: center; width: 54px; height: 54px; border: 1px solid var(--site-border); border-radius: 18px; color: var(--site-primary); background: var(--site-card); font-size: 27px; }
.eyebrow { font-size: 11px; letter-spacing: 1.5px; color: var(--site-muted); }
h1 { font-size: 25px; margin: 3px 0 4px; }
.about-header p { margin: 0; color: var(--site-muted); font-size: 13px; }
.about-workspace { display: grid; grid-template-columns: 185px minmax(0,1fr); gap: 22px; align-items: start; }
.about-nav { position: sticky; top: 12px; padding: 10px; border: 1px solid var(--site-border); border-radius: 16px; background: var(--site-card); }
.about-nav button { display: flex; align-items: center; gap: 10px; width: 100%; border: 0; border-radius: 10px; padding: 13px 11px; background: transparent; color: inherit; text-align: left; cursor: pointer; margin-bottom: 4px; }
.about-nav button.active { color: var(--site-primary); background: color-mix(in srgb,var(--site-primary) 10%,transparent); font-weight: 600; }
.about-nav .nav-arrow { margin-left: auto; }
.about-nav p { color: var(--site-muted); line-height: 1.8; font-size: 12px; padding: 10px; }
.settings-card { background: var(--site-card); border: 1px solid var(--site-border); border-radius: 16px; padding: 24px; margin-bottom: 18px; }
.section-heading { display: flex; justify-content: space-between; align-items: center; gap: 16px; margin-bottom: 22px; }
.section-heading h2 { margin: 0; font-size: 17px; font-weight: 650; }
.section-heading p { margin: 5px 0 0; color: var(--site-muted); font-size: 12px; }
.section-actions { display: flex; align-items: center; gap: 12px; }
.field-grid { display: grid; grid-template-columns: repeat(2,minmax(0,1fr)); gap: 20px; }
.field-grid :deep(.field-wide) { grid-column: 1 / -1; }
.count { font-size: 11px; font-weight: 400; color: var(--site-muted); margin-left: 8px; }
.entries { display: grid; gap: 16px; }
.entry-card { border: 1px solid var(--site-border); border-radius: 12px; padding: 18px; }
.entry-heading { display: flex; align-items: center; justify-content: space-between; gap: 12px; border-bottom: 1px solid var(--site-border); padding-bottom: 12px; margin-bottom: 18px; }
.entry-heading strong { overflow-wrap: anywhere; }
.entry-heading > div { flex-shrink: 0; }
.empty { padding: 30px 0; }
.about-savebar { display: flex; align-items: center; justify-content: space-between; gap: 18px; position: sticky; bottom: 0; z-index: 10; border: 1px solid var(--site-border); padding: 16px 24px; border-radius: 14px; background: var(--site-card); box-shadow: 0 -6px 24px #00000006; }
.about-savebar > div { display: flex; gap: 10px; }
.about-savebar > span { font-size: 12px; color: var(--site-muted); display: flex; align-items: center; gap: 8px; }
.about-savebar i { width: 7px; height: 7px; border-radius: 50%; background: #43b882; }
.about-savebar .dirty i { background: #e8ad45; }
.feedback { margin-bottom: 18px; }
.initial-state { display: grid; place-items: center; min-height: 350px; }
@media(max-width:1000px) { .about-workspace { grid-template-columns: minmax(0,1fr); gap: 14px; } .about-nav { display: flex; overflow-x: auto; position: static; } .about-nav button { width: auto; flex-shrink: 0; margin: 0; } .about-nav p, .nav-arrow { display: none; } }
@media(max-width:600px) { .field-grid { grid-template-columns: minmax(0,1fr); } .settings-card { padding: 18px; } .about-savebar { padding: 14px; flex-wrap: wrap; } .section-heading { align-items: flex-start; } }
</style>
