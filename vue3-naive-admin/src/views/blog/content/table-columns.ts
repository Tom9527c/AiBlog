import { h } from 'vue';
import { NButton, NPopconfirm, NSpace, NTag } from 'naive-ui';
import type { Content, Kind } from '@/service/api/blog';

const metric = (value: unknown) => {
  const number = Number(value);
  return Number.isFinite(number) && value !== null && value !== undefined && value !== '' ? number.toLocaleString('zh-CN') : '—';
};
export const createColumns = (kind: Kind, can: (action: string) => boolean, edit: (id: number) => void, remove: (id: number) => void) => [
  {
    title: '标题 / 名称',
    key: 'title',
    minWidth: 220,
    render: (row: Content) =>
      h('div', { class: 'content-cell-title' }, [
        h('strong', { class: 'content-cell-title__name' }, row.title || '未命名'),
        row.summary ? h('span', { class: 'content-cell-title__summary' }, row.summary) : null
      ])
  },
  {
    title: '标识',
    key: 'slug',
    minWidth: 150,
    render: (row: Content) =>
      row.slug
        ? h('code', { class: 'content-cell-code' }, row.slug)
        : h('span', { class: 'content-cell-muted' }, '自动生成')
  },
  ...(kind === 'bangumis'
    ? [
        {
          title: '播放 / 追番',
          key: 'bangumiStats',
          width: 150,
          render: (row: Content) =>
            h('div', { class: 'content-cell-metrics' }, [
              h('span', { class: 'content-cell-metrics__main' }, metric(row.metadata?.plays)),
              h('span', { class: 'content-cell-metrics__sub' }, `追番 ${metric(row.metadata?.followers)}`)
            ])
        }
      ]
    : []),
  { title: '排序', key: 'sort', width: 80 },
  {
    title: '状态',
    key: 'status',
    width: 130,
    render: (row: Content) =>
      h(
        NTag,
        {
          size: 'small',
          round: true,
          bordered: false,
          type: row.status === 'published' ? 'success' : 'warning'
        },
        () => (row.status === 'published' ? '发布' : '草稿')
      )
  },
  {
    title: '访问规则',
    key: 'accessMode',
    width: 100,
    render: (row: Content) => {
      const access = {
        public: { label: '公开', type: 'info' as const },
        login: { label: '登录', type: 'warning' as const },
        password: { label: '密码', type: 'error' as const }
      }[row.accessMode] ?? { label: '未知', type: 'default' as const };
      return h(NTag, { size: 'small', round: true, bordered: false, type: access.type }, () => access.label);
    }
  },
  {
    title: '操作',
    key: 'actions',
    width: 150,
    render: (row: Content) =>
      h(NSpace, { size: 4, class: 'content-row-actions' }, () => [
        h(
          NButton,
          {
            size: 'small',
            quaternary: true,
            type: 'primary',
            disabled: !can('update'),
            onClick: () => edit(row.id)
          },
          () => '编辑'
        ),
        h(
          NPopconfirm,
          { onPositiveClick: () => remove(row.id) },
          {
            trigger: () =>
              h(
                NButton,
                {
                  size: 'small',
                  quaternary: true,
                  type: 'error',
                  disabled: !can('delete')
                },
                () => '删除'
              ),
            default: () => '确认删除？存在关联数据时需先解除关联。'
          }
        )
      ])
  }
];
