export interface Field { key: string; label: string; type?: 'image' | 'lines' | 'tags' | 'number' }
export interface Group { key: string; title: string; hint: string; toggle?: string; fields: Field[] }
const fields = (pairs: string[][]): Field[] => pairs.map(([key, label, type]) => ({ key, label, type: type as Field['type'] }));
export const tabs = [
  { key: 'basic', title: '基础资料', icon: 'lucide:user-round' },
  { key: 'intro', title: '首屏介绍', icon: 'lucide:sparkles' },
  { key: 'skills', title: '技能与经历', icon: 'lucide:graduation-cap' },
  { key: 'life', title: '性格与生活', icon: 'lucide:coffee' },
  { key: 'cards', title: '展示卡片', icon: 'lucide:panels-top-left' },
  { key: 'socials', title: '社交与打赏', icon: 'lucide:heart' },
  { key: 'body', title: '补充介绍', icon: 'lucide:file-text' }
];
export const groups: Record<string, Group[]> = {
  basic: [
    { key: 'profile', title: '个人名片', hint: '展示在关于页顶部，头像与站点头像可分别设置。', fields: fields([['avatar','关于页头像','image'],['heading','主标题'],['subtitle','一句话介绍','lines'],['profileTags','头像旁标签（按顺序左右分列）','tags']]) },
    { key: 'info', title: '个人信息', hint: '清空的字段不会展示，出生年份可留空。', toggle: 'info', fields: fields([['locationPrefix','居住地引导语'],['location','居住地'],['mapImage','地图 / 居住地背景','image'],['mapDarkImage','深色模式地图（留空沿用普通地图）','image'],['birthLabel','出生年份标签'],['birthYear','出生年份','number'],['birthYearText','未填写年份时的文案（如保密，清空则隐藏）'],['professionLabel','专业标签'],['profession','专业'],['jobLabel','职业标签'],['currentJob','现在职业']]) }
  ],
  intro: [
    { key: 'intro', title: '自我介绍', hint: '对应渐变色介绍卡片。', toggle: 'intro', fields: fields([['greeting','问候语'],['namePrefix','姓名前缀'],['name','姓名 / 昵称'],['rolePrefix','职业前缀'],['role','职业称呼']]) },
    { key: 'pursuit', title: '追求', hint: '支持多行标题与多个关键词。', toggle: 'pursuit', fields: fields([['pursuitLabel','栏目标签'],['pursuitTitle','追求文案','lines'],['pursuitWords','关键词','tags']]) },
    { key: 'hello', title: 'Hello 互动卡片', hint: '鼠标移动时显示光影效果。', toggle: 'hello', fields: fields([['helloText','展示文案']]) }
  ],
  skills: [
    { key: 'skills', title: '技能', hint: '图标、名称与背景色全部由下方技能卡片控制。', toggle: 'skills', fields: fields([['skillsLabel','栏目标签'],['skillsTitle','栏目标题']]) },
    { key: 'careers', title: '生涯', hint: '经历为空时展示概述；有经历时按顺序展示，背景图可替换或清空。', toggle: 'careers', fields: fields([['careersLabel','栏目标签'],['careersTitle','栏目标题'],['career','经历概述','lines'],['careersImage','生涯背景图','image']]) }
  ],
  life: [
    { key: 'personality', title: '性格', hint: '填写人格类型、插画与说明页面地址。', toggle: 'personality', fields: fields([['personalityLabel','栏目标签'],['personality','人格名称'],['personalityCode','人格代码'],['personalityImage','人格插画','image'],['personalityLinkText','链接文案'],['personalityUrl','链接地址']]) },
    { key: 'photo', title: '个人照片', hint: '照片清空后隐藏。', toggle: 'photo', fields: fields([['photo','照片','image']]) },
    { key: 'maxim', title: '座右铭', hint: '支持换行。', toggle: 'maxim', fields: fields([['mottoLabel','栏目标签'],['motto','座右铭','lines']]) },
    { key: 'buff', title: '特长', hint: '分享你的特点。', toggle: 'buff', fields: fields([['buffLabel','栏目标签'],['buff','特长文案','lines']]) },
    { key: 'game', title: '游戏', hint: '游戏名称、账号展示文案和背景均可编辑。', toggle: 'game', fields: fields([['gameLabel','栏目标签'],['gameTitle','游戏名称'],['gameUid','账号 / UID 展示文案'],['gameImage','游戏背景','image']]) },
    { key: 'comics', title: '番剧', hint: '在下方编辑作品与封面，不会自动引用追番列表。', toggle: 'comics', fields: fields([['comicsLabel','栏目标签'],['comicsTitle','栏目标题']]) },
    { key: 'technology', title: '关注偏好', hint: '可用于数码、摄影或其他兴趣。', toggle: 'technology', fields: fields([['technologyLabel','栏目标签'],['technologyTitle','偏好名称'],['technologyDescription','补充说明','lines'],['technologyImage','背景图片','image']]) },
    { key: 'music', title: '音乐偏好', hint: '推荐内容与按钮跳转地址。', toggle: 'music', fields: fields([['musicLabel','栏目标签'],['musicTitle','音乐偏好'],['musicDescription','补充说明','lines'],['musicImage','背景图片','image'],['musicLinkText','按钮文案'],['musicUrl','按钮跳转地址']]) }
  ],
  cards: [],
  socials: [{ key: 'donation', title: '支持创作', hint: '上传二维码后展示支持入口。', toggle: 'donation', fields: fields([['donationTitle','按钮 / 弹窗标题'],['donationText','打赏说明','lines'],['donationImage','二维码','image']]) }],
  body: []
};
export const collections = [
  { tab: 'skills', key: 'skillItems', title: '技能卡片', toggle: 'skills', fields: fields([['name','技能名称'],['image','技能图标','image'],['color','背景色（十六进制，如 #ffffff）']]) },
  { tab: 'skills', key: 'experiences', title: '个人经历', toggle: 'careers', fields: fields([['title','经历标题'],['date','时间'],['description','经历描述','lines']]) },
  { tab: 'life', key: 'comics', title: '番剧作品', toggle: 'comics', fields: fields([['title','作品名称'],['image','作品封面','image'],['url','跳转地址']]) },
  { tab: 'cards', key: 'cards', title: '自定义展示卡片', toggle: 'cards', fields: fields([['title','卡片标题'],['description','卡片描述','lines'],['image','卡片图片','image'],['url','跳转地址']]) },
  { tab: 'socials', key: 'socials', title: '社交链接', toggle: 'socials', fields: fields([['label','链接名称'],['url','链接地址']]) }
];
