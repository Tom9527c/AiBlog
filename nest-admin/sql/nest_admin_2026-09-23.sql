/*
 Navicat Premium Dump SQL

 Source Server         : nest_Mysql
 Source Server Type    : MySQL
 Source Server Version : 80408 (8.4.8)
 Source Host           : 127.0.0.1:3306
 Source Schema         : nest_admin

 Target Server Type    : MySQL
 Target Server Version : 80408 (8.4.8)
 File Encoding         : 65001

 Date: 23/09/2026 14:38:29
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for blog_about
-- ----------------------------
DROP TABLE IF EXISTS `blog_about`;
CREATE TABLE `blog_about` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `summary` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `body` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `format` varchar(12) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'markdown',
  `cover` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `url` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `groupName` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `sort` int NOT NULL DEFAULT '0',
  `status` varchar(12) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'draft',
  `accessMode` varchar(12) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'public',
  `passwordHash` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `accessVersion` int NOT NULL DEFAULT '1',
  `parentId` int DEFAULT NULL,
  `categoryId` int DEFAULT NULL,
  `tagIds` json NOT NULL,
  `metadata` json NOT NULL,
  `authorId` int DEFAULT NULL,
  `publishedAt` datetime DEFAULT NULL,
  `createdAt` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updatedAt` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `IDX_598eeebdf80c41f778099c99fb` (`slug`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of blog_about
-- ----------------------------
BEGIN;
INSERT INTO `blog_about` (`id`, `title`, `slug`, `summary`, `body`, `format`, `cover`, `url`, `groupName`, `sort`, `status`, `accessMode`, `passwordHash`, `accessVersion`, `parentId`, `categoryId`, `tagIds`, `metadata`, `authorId`, `publishedAt`, `createdAt`, `updatedAt`) VALUES (7, '关于本人', 'ca731666-9c2f-4ced-a43d-ee17bc048f7b', '', '12312312312312312啊实打实的\n\n', 'markdown', '', '', '', 0, 'published', 'public', '', 2, NULL, NULL, '[]', '{\"buff\": \"脑回路新奇的 酸菜鱼\\n二次元指数 MAX\", \"name\": \"Tom\", \"role\": \"前端工程师\", \"cards\": [{\"url\": \"\", \"image\": \"/blog-media/116\", \"title\": \"1231\", \"description\": \"312312\"}], \"motto\": \"路虽远行则将至，\\n事虽难则做必成。\", \"photo\": \"/blog-media/11\", \"avatar\": \"/blog-media/124\", \"career\": \"EDU,软件工程专业\", \"comics\": [{\"url\": \"https://www.bilibili.com/bangumi/media/md5267750/\", \"image\": \"/blog-media/123\", \"title\": \"约定的梦幻岛\"}, {\"url\": \"https://www.bilibili.com/bangumi/media/md28229899/\", \"image\": \"/blog-media/110\", \"title\": \"咒术回战\"}, {\"url\": \"https://www.bilibili.com/bangumi/media/md8892/\", \"image\": \"/blog-media/111\", \"title\": \"紫罗兰永恒花园\"}, {\"url\": \"https://www.bilibili.com/bangumi/media/md22718131/\", \"image\": \"/blog-media/112\", \"title\": \"鬼灭之刃\"}, {\"url\": \"https://www.bilibili.com/bangumi/media/md135652/\", \"image\": \"/blog-media/113\", \"title\": \"JOJO的奇妙冒险 黄金之风\"}], \"skills\": [], \"gameUid\": \"UID: 125766904\", \"heading\": \"关于我\", \"socials\": [], \"greeting\": \"你好，很高兴认识你👋\", \"jobLabel\": \"现在职业\", \"location\": \"中国,广州\", \"mapImage\": \"/blog-media/11\", \"musicUrl\": \"/music/\", \"sections\": {\"body\": true, \"buff\": true, \"game\": true, \"info\": true, \"cards\": true, \"hello\": true, \"intro\": true, \"maxim\": true, \"music\": true, \"photo\": true, \"comics\": true, \"skills\": true, \"careers\": true, \"pursuit\": true, \"socials\": true, \"donation\": true, \"technology\": true, \"personality\": true}, \"subtitle\": \"路虽远行则将至，事虽难则做必成✨\", \"buffLabel\": \"特长\", \"gameImage\": \"/blog-media/114\", \"gameLabel\": \"爱好游戏\", \"gameTitle\": \"原神\", \"helloText\": \"Hello there!\", \"birthLabel\": \"生于\", \"currentJob\": \"社畜\", \"mottoLabel\": \"座右铭\", \"musicImage\": \"/blog-media/122\", \"musicLabel\": \"音乐偏好\", \"musicTitle\": \"许嵩、民谣、华语流行\", \"namePrefix\": \"我叫\", \"profession\": \"软件工程\", \"rolePrefix\": \"是一名\", \"skillItems\": [{\"name\": \"12312\", \"color\": \"\", \"image\": \"/blog-media/118\"}, {\"name\": \"为企鹅\", \"color\": \"\", \"image\": \"/blog-media/119\"}, {\"name\": \"测试 1231\", \"color\": \"\", \"image\": \"/blog-media/120\"}, {\"name\": \"测啥事i啊\", \"color\": \"\", \"image\": \"/blog-media/121\"}], \"comicsLabel\": \"爱好番剧\", \"comicsTitle\": \"追番\", \"experiences\": [{\"date\": \"123123\", \"title\": \"1231\", \"description\": \"12312\"}, {\"date\": \"12312312\", \"title\": \"3123\", \"description\": \"312312\"}], \"personality\": \"执政官\", \"profileTags\": [\"🤖️ 数码科技爱好者\", \"🔍 分享与热心帮助\", \"🏠 智能家居小能手\", \"🔨 设计开发一条龙\", \"专修交互与设计 🤝\", \"脚踏实地行动派 🏃\", \"团队小组发动机 🧱\", \"壮汉人狠话不多 💢\"], \"skillsLabel\": \"技能\", \"skillsTitle\": \"开启创造力\", \"careersImage\": \"/blog-media/117\", \"careersLabel\": \"生涯\", \"careersTitle\": \"无限进步\", \"donationText\": \"\", \"mapDarkImage\": \"\", \"pursuitLabel\": \"追求\", \"pursuitTitle\": \"源于\\n热爱而去 感受\", \"pursuitWords\": [\"学习\", \"生活\", \"程序\", \"体验\"], \"birthYearText\": \"保密\", \"donationImage\": \"\", \"donationTitle\": \"支持创作\", \"musicLinkText\": \"更多推荐\", \"locationPrefix\": \"我现在住在\", \"personalityUrl\": \"https://www.16personalities.com/ch/esfj-人格\", \"personalityCode\": \"ESFJ-A\", \"professionLabel\": \"专业\", \"technologyImage\": \"/blog-media/115\", \"technologyLabel\": \"关注偏好\", \"technologyTitle\": \"数码科技\", \"musicDescription\": \"跟 Tom 一起欣赏更多音乐\", \"personalityImage\": \"https://npm.elemecdn.com/anzhiyu-blog@2.0.8/img/svg/ESFJ-A.svg\", \"personalityLabel\": \"性格\", \"personalityLinkText\": \"了解更多关于我的性格\", \"technologyDescription\": \"手机、电脑软硬件\"}', 2, '2026-09-21 22:54:52', '2026-09-21 22:54:52.724800', '2026-09-22 14:23:35.000000');
COMMIT;

-- ----------------------------
-- Table structure for blog_album
-- ----------------------------
DROP TABLE IF EXISTS `blog_album`;
CREATE TABLE `blog_album` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `summary` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `body` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `format` varchar(12) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'markdown',
  `cover` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `url` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `groupName` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `sort` int NOT NULL DEFAULT '0',
  `status` varchar(12) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'draft',
  `accessMode` varchar(12) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'public',
  `passwordHash` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `accessVersion` int NOT NULL DEFAULT '1',
  `parentId` int DEFAULT NULL,
  `categoryId` int DEFAULT NULL,
  `tagIds` json NOT NULL,
  `metadata` json NOT NULL,
  `authorId` int DEFAULT NULL,
  `publishedAt` datetime DEFAULT NULL,
  `createdAt` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updatedAt` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `IDX_27b6e725f2c0401cf7d8a4e0ce` (`slug`)
) ENGINE=InnoDB AUTO_INCREMENT=50 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of blog_album
-- ----------------------------
BEGIN;
INSERT INTO `blog_album` (`id`, `title`, `slug`, `summary`, `body`, `format`, `cover`, `url`, `groupName`, `sort`, `status`, `accessMode`, `passwordHash`, `accessVersion`, `parentId`, `categoryId`, `tagIds`, `metadata`, `authorId`, `publishedAt`, `createdAt`, `updatedAt`) VALUES (9, '测试相册', 'eaf6efe5-ea41-4161-bea4-4535e2ad5f3d', '相册', '阿维 \n\n\n![图片](/blog-media/23)\n', 'markdown', '/blog-media/22', '', '', 0, 'published', 'public', '', 1, NULL, NULL, '[]', '{\"layout\": \"waterfall\"}', 2, '2026-09-10 13:46:42', '2026-09-10 13:47:00.290675', '2026-09-21 16:24:19.000000');
INSERT INTO `blog_album` (`id`, `title`, `slug`, `summary`, `body`, `format`, `cover`, `url`, `groupName`, `sort`, `status`, `accessMode`, `passwordHash`, `accessVersion`, `parentId`, `categoryId`, `tagIds`, `metadata`, `authorId`, `publishedAt`, `createdAt`, `updatedAt`) VALUES (10, '测试相册1', '7a3bf7e7-e1fe-4563-a378-fc0cc2008c0f', '摘要 / 说明', '', 'markdown', '/blog-media/35', '', '', 0, 'published', 'public', '', 1, NULL, NULL, '[]', '{\"layout\": \"waterfall\"}', 2, '2026-09-21 16:07:19', '2026-09-21 16:07:19.540082', '2026-09-21 17:27:15.000000');
INSERT INTO `blog_album` (`id`, `title`, `slug`, `summary`, `body`, `format`, `cover`, `url`, `groupName`, `sort`, `status`, `accessMode`, `passwordHash`, `accessVersion`, `parentId`, `categoryId`, `tagIds`, `metadata`, `authorId`, `publishedAt`, `createdAt`, `updatedAt`) VALUES (11, '测试相册22', 'db4325f3-6648-405a-9d10-cdd0d6899958', '', '', 'markdown', '/blog-media/36', '', '', 0, 'published', 'public', '', 1, NULL, NULL, '[]', '{\"layout\": \"gallery\"}', 2, '2026-09-21 16:08:33', '2026-09-21 16:08:33.235889', '2026-09-21 16:33:30.000000');
INSERT INTO `blog_album` (`id`, `title`, `slug`, `summary`, `body`, `format`, `cover`, `url`, `groupName`, `sort`, `status`, `accessMode`, `passwordHash`, `accessVersion`, `parentId`, `categoryId`, `tagIds`, `metadata`, `authorId`, `publishedAt`, `createdAt`, `updatedAt`) VALUES (12, '测试相册3', '1514a4e2-2f23-4daa-adf8-7bf62c0538a5', '', '', 'markdown', '/blog-media/37', '', '', 0, 'published', 'public', '', 1, NULL, NULL, '[]', '{\"layout\": \"grid\"}', 2, '2026-09-21 16:08:54', '2026-09-21 16:08:54.436310', '2026-09-21 16:34:34.000000');
COMMIT;

-- ----------------------------
-- Table structure for blog_bangumi
-- ----------------------------
DROP TABLE IF EXISTS `blog_bangumi`;
CREATE TABLE `blog_bangumi` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `summary` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `body` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `format` varchar(12) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'markdown',
  `cover` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `url` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `groupName` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `sort` int NOT NULL DEFAULT '0',
  `status` varchar(12) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'draft',
  `accessMode` varchar(12) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'public',
  `passwordHash` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `accessVersion` int NOT NULL DEFAULT '1',
  `parentId` int DEFAULT NULL,
  `categoryId` int DEFAULT NULL,
  `tagIds` json NOT NULL,
  `metadata` json NOT NULL,
  `authorId` int DEFAULT NULL,
  `publishedAt` datetime DEFAULT NULL,
  `createdAt` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updatedAt` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `IDX_b5b38edd266cfa64731da4aba1` (`slug`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of blog_bangumi
-- ----------------------------
BEGIN;
INSERT INTO `blog_bangumi` (`id`, `title`, `slug`, `summary`, `body`, `format`, `cover`, `url`, `groupName`, `sort`, `status`, `accessMode`, `passwordHash`, `accessVersion`, `parentId`, `categoryId`, `tagIds`, `metadata`, `authorId`, `publishedAt`, `createdAt`, `updatedAt`) VALUES (6, '测试追番', '5f2be27e-3efa-4aff-9464-2f1392873a0a', '', '123123\n\n', 'markdown', '/blog-media/102', '', '', 0, 'published', 'public', '', 1, NULL, NULL, '[]', '{\"state\": \"wish\", \"total\": 15, \"rating\": 9, \"progress\": 12}', 2, '2026-09-10 13:48:05', '2026-09-10 13:48:16.060104', '2026-09-21 18:10:40.000000');
COMMIT;

-- ----------------------------
-- Table structure for blog_category
-- ----------------------------
DROP TABLE IF EXISTS `blog_category`;
CREATE TABLE `blog_category` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `summary` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `body` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `format` varchar(12) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'markdown',
  `cover` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `url` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `groupName` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `sort` int NOT NULL DEFAULT '0',
  `status` varchar(12) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'draft',
  `accessMode` varchar(12) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'public',
  `passwordHash` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `accessVersion` int NOT NULL DEFAULT '1',
  `parentId` int DEFAULT NULL,
  `categoryId` int DEFAULT NULL,
  `tagIds` json NOT NULL,
  `metadata` json NOT NULL,
  `authorId` int DEFAULT NULL,
  `publishedAt` datetime DEFAULT NULL,
  `createdAt` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updatedAt` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `IDX_4f874e7b690965b1e0078512e5` (`slug`)
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of blog_category
-- ----------------------------
BEGIN;
INSERT INTO `blog_category` (`id`, `title`, `slug`, `summary`, `body`, `format`, `cover`, `url`, `groupName`, `sort`, `status`, `accessMode`, `passwordHash`, `accessVersion`, `parentId`, `categoryId`, `tagIds`, `metadata`, `authorId`, `publishedAt`, `createdAt`, `updatedAt`) VALUES (7, '测试分类', '7580c260-f204-4e7a-9eea-3cb296dff421', '测试分类事实上', '', 'markdown', '/blog-media/20', '', '', 0, 'published', 'public', '', 1, NULL, NULL, '[]', '{}', 1, '2026-09-09 13:46:33', '2026-09-09 13:46:33.160524', '2026-09-20 18:06:56.000000');
INSERT INTO `blog_category` (`id`, `title`, `slug`, `summary`, `body`, `format`, `cover`, `url`, `groupName`, `sort`, `status`, `accessMode`, `passwordHash`, `accessVersion`, `parentId`, `categoryId`, `tagIds`, `metadata`, `authorId`, `publishedAt`, `createdAt`, `updatedAt`) VALUES (8, '测试分类1', 'c99bd37d-9bde-4bef-9d3f-8518c239388b', '', '', 'markdown', '', '', '', 0, 'published', 'public', '', 1, NULL, NULL, '[]', '{}', 2, '2026-09-10 14:01:19', '2026-09-10 14:01:19.382687', '2026-09-10 14:01:19.382687');
INSERT INTO `blog_category` (`id`, `title`, `slug`, `summary`, `body`, `format`, `cover`, `url`, `groupName`, `sort`, `status`, `accessMode`, `passwordHash`, `accessVersion`, `parentId`, `categoryId`, `tagIds`, `metadata`, `authorId`, `publishedAt`, `createdAt`, `updatedAt`) VALUES (9, '测试分类2', '791b6539-8952-450b-bb01-c7360afa08bc', '', '', 'markdown', '', '', '', 0, 'published', 'public', '', 1, NULL, NULL, '[]', '{}', 2, '2026-09-10 14:01:59', '2026-09-10 14:01:25.996970', '2026-09-10 14:01:59.000000');
INSERT INTO `blog_category` (`id`, `title`, `slug`, `summary`, `body`, `format`, `cover`, `url`, `groupName`, `sort`, `status`, `accessMode`, `passwordHash`, `accessVersion`, `parentId`, `categoryId`, `tagIds`, `metadata`, `authorId`, `publishedAt`, `createdAt`, `updatedAt`) VALUES (10, '测试分类3', 'a0f2b064-1410-4e5f-944c-92ef0b4c9e07', '', '', 'markdown', '', '', '', 0, 'published', 'public', '', 1, NULL, NULL, '[]', '{}', 2, '2026-09-10 14:01:54', '2026-09-10 14:01:32.682451', '2026-09-10 14:01:54.000000');
COMMIT;

-- ----------------------------
-- Table structure for blog_collection
-- ----------------------------
DROP TABLE IF EXISTS `blog_collection`;
CREATE TABLE `blog_collection` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `summary` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `body` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `format` varchar(12) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'markdown',
  `cover` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `url` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `groupName` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `sort` int NOT NULL DEFAULT '0',
  `status` varchar(12) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'draft',
  `accessMode` varchar(12) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'public',
  `passwordHash` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `accessVersion` int NOT NULL DEFAULT '1',
  `parentId` int DEFAULT NULL,
  `categoryId` int DEFAULT NULL,
  `tagIds` json NOT NULL,
  `metadata` json NOT NULL,
  `authorId` int DEFAULT NULL,
  `publishedAt` datetime DEFAULT NULL,
  `createdAt` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updatedAt` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `IDX_d2e60be0d5b6f950037a1ab466` (`slug`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of blog_collection
-- ----------------------------
BEGIN;
INSERT INTO `blog_collection` (`id`, `title`, `slug`, `summary`, `body`, `format`, `cover`, `url`, `groupName`, `sort`, `status`, `accessMode`, `passwordHash`, `accessVersion`, `parentId`, `categoryId`, `tagIds`, `metadata`, `authorId`, `publishedAt`, `createdAt`, `updatedAt`) VALUES (6, '测试收藏', '2d498b7c-178f-4867-90c1-f40745fe0e5e', '123123', '', 'markdown', '', '', '', 0, 'published', 'public', '', 1, NULL, NULL, '[]', '{}', 2, '2026-09-10 13:49:56', '2026-09-10 13:50:08.583876', '2026-09-10 13:50:08.583876');
INSERT INTO `blog_collection` (`id`, `title`, `slug`, `summary`, `body`, `format`, `cover`, `url`, `groupName`, `sort`, `status`, `accessMode`, `passwordHash`, `accessVersion`, `parentId`, `categoryId`, `tagIds`, `metadata`, `authorId`, `publishedAt`, `createdAt`, `updatedAt`) VALUES (7, '财务收入', '83cc72aa-7fb7-4d91-9b59-336dca9ec66c', '环境健康和v好', '', 'markdown', '/blog-media/103', '', '', 0, 'published', 'public', '', 1, NULL, NULL, '[]', '{\"icon\": \"game\", \"rating\": 4, \"category\": \"游戏\"}', 2, '2026-09-21 22:56:24', '2026-09-21 22:56:24.112238', '2026-09-21 22:56:24.112238');
COMMIT;

-- ----------------------------
-- Table structure for blog_comment
-- ----------------------------
DROP TABLE IF EXISTS `blog_comment`;
CREATE TABLE `blog_comment` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `summary` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `body` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `format` varchar(12) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'markdown',
  `cover` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `url` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `groupName` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `sort` int NOT NULL DEFAULT '0',
  `status` varchar(12) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'draft',
  `accessMode` varchar(12) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'public',
  `passwordHash` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `accessVersion` int NOT NULL DEFAULT '1',
  `parentId` int DEFAULT NULL,
  `categoryId` int DEFAULT NULL,
  `tagIds` json NOT NULL,
  `metadata` json NOT NULL,
  `authorId` int DEFAULT NULL,
  `publishedAt` datetime DEFAULT NULL,
  `createdAt` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updatedAt` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `IDX_4b315ea8b8c7a841d97f1a89d4` (`slug`)
) ENGINE=InnoDB AUTO_INCREMENT=66 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of blog_comment
-- ----------------------------
BEGIN;
INSERT INTO `blog_comment` (`id`, `title`, `slug`, `summary`, `body`, `format`, `cover`, `url`, `groupName`, `sort`, `status`, `accessMode`, `passwordHash`, `accessVersion`, `parentId`, `categoryId`, `tagIds`, `metadata`, `authorId`, `publishedAt`, `createdAt`, `updatedAt`) VALUES (5, '测试评论', '923c9dc6-703a-4203-810e-b3140d51c09b', '123123', '123123123', 'markdown', '', '', '', 0, 'published', 'public', '', 1, NULL, NULL, '[]', '{}', 2, '2026-09-10 13:49:35', '2026-09-10 13:49:41.385724', '2026-09-10 13:49:41.385724');
INSERT INTO `blog_comment` (`id`, `title`, `slug`, `summary`, `body`, `format`, `cover`, `url`, `groupName`, `sort`, `status`, `accessMode`, `passwordHash`, `accessVersion`, `parentId`, `categoryId`, `tagIds`, `metadata`, `authorId`, `publishedAt`, `createdAt`, `updatedAt`) VALUES (15, '评论', '54b9be50-0657-4a36-bb54-c1f05544c950', '', '123123', 'markdown', '', '', '', 0, 'published', 'public', '', 1, NULL, NULL, '[]', '{\"targetId\": 46, \"authorName\": \"管理员\", \"targetKind\": \"documents\", \"authorAvatar\": \"/upload/2026-09-10/other/1789025169455-å®å®æç©º.webp\"}', 2, '2026-09-22 16:40:29', '2026-09-22 16:40:04.293440', '2026-09-22 16:40:29.000000');
INSERT INTO `blog_comment` (`id`, `title`, `slug`, `summary`, `body`, `format`, `cover`, `url`, `groupName`, `sort`, `status`, `accessMode`, `passwordHash`, `accessVersion`, `parentId`, `categoryId`, `tagIds`, `metadata`, `authorId`, `publishedAt`, `createdAt`, `updatedAt`) VALUES (16, '评论', '8c0094fb-f45e-42d7-a23d-1617e84dbf8e', '', '123123123', 'markdown', '', '', '', 0, 'published', 'public', '', 1, 15, NULL, '[]', '{\"targetId\": 46, \"authorName\": \"管理员\", \"targetKind\": \"documents\", \"authorAvatar\": \"/upload/2026-09-10/other/1789025169455-å®å®æç©º.webp\"}', 2, '2026-09-22 16:40:52', '2026-09-22 16:40:42.603711', '2026-09-22 16:40:52.000000');
INSERT INTO `blog_comment` (`id`, `title`, `slug`, `summary`, `body`, `format`, `cover`, `url`, `groupName`, `sort`, `status`, `accessMode`, `passwordHash`, `accessVersion`, `parentId`, `categoryId`, `tagIds`, `metadata`, `authorId`, `publishedAt`, `createdAt`, `updatedAt`) VALUES (22, '评论', '460b91fc-1779-431e-98b0-3fd6f645c0a5', '', 'UI_COMMENT_CHECK_20260922 留言与审核界面验证 😊', 'markdown', '', '', '', 0, 'published', 'public', '', 1, NULL, NULL, '[]', '{\"os\": \"macOS\", \"votes\": {}, \"browser\": \"Chrome\", \"isOwner\": false, \"authorName\": \"界面验证访客\", \"targetKind\": \"\", \"authorAvatar\": \"\", \"moderationStatus\": \"approved\"}', NULL, '2026-09-22 17:22:36', '2026-09-22 17:21:43.760510', '2026-09-22 17:22:35.000000');
INSERT INTO `blog_comment` (`id`, `title`, `slug`, `summary`, `body`, `format`, `cover`, `url`, `groupName`, `sort`, `status`, `accessMode`, `passwordHash`, `accessVersion`, `parentId`, `categoryId`, `tagIds`, `metadata`, `authorId`, `publishedAt`, `createdAt`, `updatedAt`) VALUES (27, '回复', '2140d90d-0e00-4ce0-bf94-011b22144eef', '', 'UI_COMMENT_REPLY_20260922 谢谢你的留言，欢迎常来 😊', 'markdown', '', '', '', 0, 'published', 'public', '', 1, 22, NULL, '[]', '{\"votes\": {}, \"isOwner\": true, \"authorName\": \"管理员\", \"targetKind\": \"\", \"replyToName\": \"界面验证访客\", \"authorAvatar\": \"/upload/2026-09-10/other/1789025169455-å®å®æç©º.webp\", \"moderationStatus\": \"approved\"}', 2, '2026-09-22 17:24:53', '2026-09-22 17:24:53.196212', '2026-09-22 17:24:53.196212');
INSERT INTO `blog_comment` (`id`, `title`, `slug`, `summary`, `body`, `format`, `cover`, `url`, `groupName`, `sort`, `status`, `accessMode`, `passwordHash`, `accessVersion`, `parentId`, `categoryId`, `tagIds`, `metadata`, `authorId`, `publishedAt`, `createdAt`, `updatedAt`) VALUES (28, '回复', '13cc4f0f-cbe6-417b-93ef-90cf7892688f', '', '123456', 'markdown', '', '', '', 0, 'published', 'public', '', 1, 22, NULL, '[]', '{\"votes\": {}, \"isOwner\": true, \"authorName\": \"管理员\", \"targetKind\": \"\", \"replyToName\": \"管理员\", \"authorAvatar\": \"/upload/2026-09-10/other/1789025169455-å®å®æç©º.webp\", \"moderationStatus\": \"approved\"}', 2, '2026-09-22 17:25:52', '2026-09-22 17:25:52.465890', '2026-09-22 17:25:52.465890');
INSERT INTO `blog_comment` (`id`, `title`, `slug`, `summary`, `body`, `format`, `cover`, `url`, `groupName`, `sort`, `status`, `accessMode`, `passwordHash`, `accessVersion`, `parentId`, `categoryId`, `tagIds`, `metadata`, `authorId`, `publishedAt`, `createdAt`, `updatedAt`) VALUES (61, '评论', '536ce97f-821b-4b57-b10b-706f1cf1dbd9', '', '12312', 'markdown', '', '', '', 0, 'published', 'public', '', 1, 5, NULL, '[]', '{\"os\": \"macOS 10.15.7\", \"votes\": {}, \"browser\": \"Chrome 153.0.0.0\", \"isOwner\": false, \"location\": \"本地/内网\", \"authorName\": \"tom\", \"targetKind\": \"\", \"authorAvatar\": \"\", \"moderationStatus\": \"approved\"}', NULL, '2026-09-22 18:27:36', '2026-09-22 18:27:25.964764', '2026-09-22 18:27:36.000000');
INSERT INTO `blog_comment` (`id`, `title`, `slug`, `summary`, `body`, `format`, `cover`, `url`, `groupName`, `sort`, `status`, `accessMode`, `passwordHash`, `accessVersion`, `parentId`, `categoryId`, `tagIds`, `metadata`, `authorId`, `publishedAt`, `createdAt`, `updatedAt`) VALUES (62, '评论', 'a20c9464-14db-4b9d-8b89-8f0a181139e8', '', '666', 'markdown', '', '', '', 0, 'published', 'public', '', 1, 5, NULL, '[]', '{\"os\": \"macOS 10.15.7\", \"votes\": {}, \"browser\": \"Safari 18.6\", \"isOwner\": false, \"location\": \"本地/内网\", \"authorName\": \"123\", \"targetKind\": \"\", \"replyToName\": \"tom\", \"authorAvatar\": \"\", \"moderationStatus\": \"approved\"}', NULL, '2026-09-22 18:28:15', '2026-09-22 18:28:06.715971', '2026-09-22 18:29:01.000000');
INSERT INTO `blog_comment` (`id`, `title`, `slug`, `summary`, `body`, `format`, `cover`, `url`, `groupName`, `sort`, `status`, `accessMode`, `passwordHash`, `accessVersion`, `parentId`, `categoryId`, `tagIds`, `metadata`, `authorId`, `publishedAt`, `createdAt`, `updatedAt`) VALUES (63, '评论', '2591d5b7-e4c4-466d-8438-c5b05387862e', '', '123123123', 'markdown', '', '', '', 0, 'published', 'public', '', 1, NULL, NULL, '[]', '{\"os\": \"macOS 10.15.7\", \"rawIp\": \"127.0.0.1\", \"votes\": {}, \"browser\": \"Chrome 153.0.0.0\", \"isOwner\": false, \"location\": \"本地/内网\", \"targetId\": 20, \"authorName\": \"爱上\", \"targetKind\": \"essays\", \"authorAvatar\": \"\", \"moderationStatus\": \"approved\"}', NULL, '2026-09-23 10:10:32', '2026-09-23 10:09:45.501300', '2026-09-23 10:10:32.000000');
INSERT INTO `blog_comment` (`id`, `title`, `slug`, `summary`, `body`, `format`, `cover`, `url`, `groupName`, `sort`, `status`, `accessMode`, `passwordHash`, `accessVersion`, `parentId`, `categoryId`, `tagIds`, `metadata`, `authorId`, `publishedAt`, `createdAt`, `updatedAt`) VALUES (64, '评论', '62e6c617-b338-4f2a-9d2a-f9da2ad589b4', '', '1231231', 'markdown', '', '', '', 0, 'published', 'public', '', 1, NULL, NULL, '[]', '{\"os\": \"macOS 10.15.7\", \"rawIp\": \"127.0.0.1\", \"votes\": {}, \"browser\": \"Chrome 153.0.0.0\", \"isOwner\": false, \"location\": \"本地/内网\", \"targetId\": 20, \"authorName\": \"爱上\", \"targetKind\": \"essays\", \"authorEmail\": \"lpy2906302609@gmail.com\", \"authorAvatar\": \"\", \"authorWebsite\": \"https://www.baidu.com\", \"moderationStatus\": \"approved\"}', NULL, '2026-09-23 10:13:42', '2026-09-23 10:13:34.181667', '2026-09-23 10:13:42.000000');
INSERT INTO `blog_comment` (`id`, `title`, `slug`, `summary`, `body`, `format`, `cover`, `url`, `groupName`, `sort`, `status`, `accessMode`, `passwordHash`, `accessVersion`, `parentId`, `categoryId`, `tagIds`, `metadata`, `authorId`, `publishedAt`, `createdAt`, `updatedAt`) VALUES (65, '评论', 'd18a4d83-6aab-46da-b6ab-d4c827916d9e', '', '起312231', 'markdown', '', '', '', 0, 'published', 'public', '', 1, 64, NULL, '[]', '{\"os\": \"macOS 10.15.7\", \"rawIp\": \"127.0.0.1\", \"votes\": {}, \"browser\": \"Chrome 153.0.0.0\", \"isOwner\": false, \"location\": \"本地/内网\", \"targetId\": 20, \"authorName\": \"44444\", \"targetKind\": \"essays\", \"replyToName\": \"爱上\", \"authorAvatar\": \"\", \"moderationStatus\": \"approved\"}', NULL, '2026-09-23 10:39:58', '2026-09-23 10:39:53.203902', '2026-09-23 10:39:58.000000');
COMMIT;

-- ----------------------------
-- Table structure for blog_document
-- ----------------------------
DROP TABLE IF EXISTS `blog_document`;
CREATE TABLE `blog_document` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `summary` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `body` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `format` varchar(12) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'markdown',
  `cover` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `url` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `groupName` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `sort` int NOT NULL DEFAULT '0',
  `status` varchar(12) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'draft',
  `accessMode` varchar(12) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'public',
  `passwordHash` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `accessVersion` int NOT NULL DEFAULT '1',
  `parentId` int DEFAULT NULL,
  `categoryId` int DEFAULT NULL,
  `tagIds` json NOT NULL,
  `metadata` json NOT NULL,
  `authorId` int DEFAULT NULL,
  `publishedAt` datetime DEFAULT NULL,
  `createdAt` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updatedAt` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `IDX_ec832f27427d0374b218a5fb4e` (`slug`)
) ENGINE=InnoDB AUTO_INCREMENT=153 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of blog_document
-- ----------------------------
BEGIN;
INSERT INTO `blog_document` (`id`, `title`, `slug`, `summary`, `body`, `format`, `cover`, `url`, `groupName`, `sort`, `status`, `accessMode`, `passwordHash`, `accessVersion`, `parentId`, `categoryId`, `tagIds`, `metadata`, `authorId`, `publishedAt`, `createdAt`, `updatedAt`) VALUES (33, '测试文章标题', 'fa2d1051-d199-47bb-9958-737a344e069b', '1231', '123121212阿萨德看书看\n\n', 'markdown', '', '', '文章', 0, 'published', 'public', '', 1, NULL, NULL, '[]', '{}', 1, '2026-09-09 13:46:07', '2026-09-09 13:46:07.920420', '2026-09-09 13:46:07.920420');
INSERT INTO `blog_document` (`id`, `title`, `slug`, `summary`, `body`, `format`, `cover`, `url`, `groupName`, `sort`, `status`, `accessMode`, `passwordHash`, `accessVersion`, `parentId`, `categoryId`, `tagIds`, `metadata`, `authorId`, `publishedAt`, `createdAt`, `updatedAt`) VALUES (34, '测试文章1', '9d52f52e-3726-41f2-8667-862681f11b34', '1231231231', '23121231231\n\n', 'markdown', '', '', '', 0, 'published', 'public', '', 1, NULL, 7, '[7]', '{}', 1, '2026-09-09 13:47:24', '2026-09-09 13:47:34.438977', '2026-09-09 13:47:34.438977');
INSERT INTO `blog_document` (`id`, `title`, `slug`, `summary`, `body`, `format`, `cover`, `url`, `groupName`, `sort`, `status`, `accessMode`, `passwordHash`, `accessVersion`, `parentId`, `categoryId`, `tagIds`, `metadata`, `authorId`, `publishedAt`, `createdAt`, `updatedAt`) VALUES (35, '测试文档', '2866a037-4afe-4683-a106-c293d96266cd', '', '介绍\n\nsass同less 一样也是 CSS 预处理语言。其语法也极其相似。 [sass中文网](https://www.sass.hk/)\n\n### 安装\n\n#### vscode 插件\n\n1. vscode 中安装插件 *Live Sass Compiler*\n2. `ctrl+shift+P`键入`Live Sass: Watch Sass`以开始实时编译，或者按键入`Live Sass: Stop Watching Sass`以停止实时编译。\n\n#### webpack环境\n\n在webpack4中使用 `node-sass`和 `sass-loader`。详情请参考webpack 开发环境配置。\n\n## 语法\n\nsass 文件后缀有两种 : `.scss` 和更早期的 `.sass`。这两种后缀在语法上是有差异的。**建议使用**`.scss` ，这种格式仅在 CSS3 语法的基础上进行拓展，所有 CSS3 语法在 SCSS 中都是通用的，同时加入 Sass 的特色功能。\n\n### 注释\n\n```scss\n/* 这是多行注释 */\n// 这是单行注释\n```\n\n> // 这种注释内容不会出现在生成的css文件中\n> \n> /\\* 这种注释内容会出现在生成的css文件中 \\*/\n\n### @import\n\n使用 `@import` 导入 css或 `.scss`文件，如果是 `.scss`文件后缀可以省略。\n\n```scss\n@import \'./index.css\';\n@import \'./public\'; //public.scss\n```\n\n### 数据类型\n\nSass 支持 6 种主要的数据类型：\n\n* 数字，`1, 2, 13, 10px`\n* 字符串，有引号字符串与无引号字符串，`\"foo\", \'bar\', baz`\n* 颜色，`blue, #04a3f9, rgba(255,0,0,0.5)`\n* 布尔型，`true, false`\n* 空值，`null`\n* 数组 (list)，用空格或逗号作分隔符，`1.5em 1em 0 2em, Helvetica, Arial, sans-serif`\n* maps, 相当于 JavaScript 的 object，`(key1: value1, key2: value2)`\n\n### 变量\n\n使用 `$` 声明变量\n\n```scss\n// 声明变量\n$bg-color: yellow;\n\n.box{\n    // 引用变量\n    background: $bg-color;\n}\n```\n\n### 运算\n\n#### 算术运算\n\n支持数字的加减乘除、取整等运算 (`+, -, *, /, %`)，如果必要会在不同单位间转换值。计算的结果以最左侧操作数的单位类型为准。\n\n```scss\n$box-size: 20px;\n\n.box{\n    font-size: $box-size - 2;\n}\n```\n\n#### 字符串运算\n\n`+` 可用于连接字符串\n\n```scss\n$text: \'-resize\';\n.box{\n    cursor: e + $text;\n}\n```\n\n编译输出：\n\n```css\n.box {\n    cursor: e-resize;\n}\n```\n\n#### 运算优先级（）\n\n圆括号（）可以用来影响运算的顺序\n\n```scss\np {\n  width: 1em + (2em * 3);\n}\n```\n\n编译输出为：\n\n```css\np{\n    width: 7em;\n}\n```\n\n### Mixin 混入\n\n使用`@mixin` 声明要混入数据，`@include` 使用混入数据。\n\n```scss\n// 声明要混入样式\n@mixin box-border {\n    border: 1px solid gray ;\n    border-radius: 5px;\n    box-shadow: 0 0 8px gray;\n}\n.box2{\n    width: 100px;\n    height: 100px;\n    // 混入数据\n    @include box-border;\n}\n```\n\n#### 带参数的Mixin\n\n带参数的Mixin类型 js 中的函数传参。 在 `@mixin` 中定义参数列表，在 `@include` 时传入对应的参数。\n\n> 注意在传入参数时需要和定义时一一对应。\n\n```scss\n// 声明要混入样式\n@mixin box-border($border-width,$color) {\n    border: $border-width solid $color ;\n    border-radius: 5px;\n    box-shadow: 0 0 8px $color;\n}\n.box2{\n    width: 100px;\n    height: 100px;\n    // 混入数据\n    @include box-border(1px, red);\n}\n```\n\nsass 允许使用 `$name: value`的方式向 `@mixin` 传参，这种语法可以不理会参数的先后 顺序。\n\n```scss\n// 声明要混入样式\n@mixin box-border($border-width,$color) {\n    border: $border-width solid $color ;\n    border-radius: 5px;\n    box-shadow: 0 0 8px $color;\n}\n.box3{\n    width: 200px;\n    height: 200px;\n    // 混入数据\n    @include box-border($color:yellow , $border-width:10px )\n}\n```\n\n### 嵌套CSS 规则\n\n```scss\n#content {\n  article {\n    h1 { color: #333 }\n    p { margin-bottom: 1.4em }\n  }\n  aside { background-color: #EEE }\n}\n```\n\n编译输出为：\n\n```css\n/* 编译后 */\n#content article h1 { color: #333 }\n#content article p { margin-bottom: 1.4em }\n#content aside { background-color: #EEE }\n```\n\n#### & 父选择器\n\n```scss\narticle a {\n  color: blue;\n  &:hover { color: red }\n}\n```\n\n编译输出为：\n\n```css\narticle a { color: blue }\narticle a:hover { color: red }\n```\n\n#### 关系选择器\n\n```scss\narticle {\n  ~ article { border-top: 1px dashed #ccc }\n  > section { background: #eee }\n  dl > {\n    dt { color: #333 }\n    dd { color: #555 }\n  }\n  nav + & { margin-top: 0 }\n}\n```\n\n编译输出为：\n\n```css\narticle ~ article { border-top: 1px dashed #ccc }\narticle > footer { background: #eee }\narticle dl > dt { color: #333 }\narticle dl > dd { color: #555 }\nnav + article { margin-top: 0 }\n```\n\n### 继承 @extend\n\n```scss\n//通过选择器继承继承样式\n.error {\n  border: 1px solid red;\n  background-color: #fdd;\n}\n.seriousError {\n    // 继承\n  @extend .error;\n  border-width: 3px;\n}\n```\n\n编译输出为：\n\n```css\n.error, .seriousError {\n  border: 1px solid red;\n  background-color: #fdd;\n}\n\n.seriousError {\n  border-width: 3px;\n}\n```\n\n混合器`@mixin`主要用于展示性样式的重用，而  `@extend` 类名用于语义化样式的重用。因为继承是基于类的（有时是基于其他类型的选择器），所以继承应该是建立在语义化的关系上。当一个元素拥有的类（比如说.seriousError）表明它属于另一个类（比如说.error），这时使用继承再合适不过了。\n\n#\n\n', 'markdown', '', '', '', 0, 'published', 'public', '', 1, NULL, 7, '[7]', '{}', 2, '2026-09-10 13:57:09', '2026-09-10 13:58:06.249788', '2026-09-10 13:58:24.000000');
INSERT INTO `blog_document` (`id`, `title`, `slug`, `summary`, `body`, `format`, `cover`, `url`, `groupName`, `sort`, `status`, `accessMode`, `passwordHash`, `accessVersion`, `parentId`, `categoryId`, `tagIds`, `metadata`, `authorId`, `publishedAt`, `createdAt`, `updatedAt`) VALUES (36, '测试文章2', '08997575-3db8-4c44-a8de-8da6516b7653', '', '', 'markdown', '', '', '', 0, 'published', 'public', '', 1, NULL, NULL, '[]', '{}', 2, '2026-09-10 16:04:11', '2026-09-10 16:04:11.052026', '2026-09-10 16:04:22.000000');
INSERT INTO `blog_document` (`id`, `title`, `slug`, `summary`, `body`, `format`, `cover`, `url`, `groupName`, `sort`, `status`, `accessMode`, `passwordHash`, `accessVersion`, `parentId`, `categoryId`, `tagIds`, `metadata`, `authorId`, `publishedAt`, `createdAt`, `updatedAt`) VALUES (37, '测试文章3', '6e982485-3f50-41ee-b814-cf2784962783', '', '', 'markdown', '', '', '', 0, 'published', 'public', '', 1, NULL, NULL, '[]', '{}', 2, '2026-09-10 16:04:30', '2026-09-10 16:04:30.773331', '2026-09-10 16:04:30.773331');
INSERT INTO `blog_document` (`id`, `title`, `slug`, `summary`, `body`, `format`, `cover`, `url`, `groupName`, `sort`, `status`, `accessMode`, `passwordHash`, `accessVersion`, `parentId`, `categoryId`, `tagIds`, `metadata`, `authorId`, `publishedAt`, `createdAt`, `updatedAt`) VALUES (38, '测试文章4', '8a4b38cd-d8c0-4de8-aadc-c03b9736674f', '', '', 'markdown', '', '', '', 0, 'published', 'public', '', 1, NULL, NULL, '[]', '{}', 2, '2026-09-10 16:04:37', '2026-09-10 16:04:37.853125', '2026-09-10 16:04:37.853125');
INSERT INTO `blog_document` (`id`, `title`, `slug`, `summary`, `body`, `format`, `cover`, `url`, `groupName`, `sort`, `status`, `accessMode`, `passwordHash`, `accessVersion`, `parentId`, `categoryId`, `tagIds`, `metadata`, `authorId`, `publishedAt`, `createdAt`, `updatedAt`) VALUES (39, '测试文章5', 'f2356614-2a10-4a89-b74b-5851faaa78fa', '', '', 'markdown', '', '', '', 0, 'published', 'public', '', 1, NULL, NULL, '[]', '{}', 2, '2026-09-10 16:04:44', '2026-09-10 16:04:44.658799', '2026-09-10 16:04:44.658799');
INSERT INTO `blog_document` (`id`, `title`, `slug`, `summary`, `body`, `format`, `cover`, `url`, `groupName`, `sort`, `status`, `accessMode`, `passwordHash`, `accessVersion`, `parentId`, `categoryId`, `tagIds`, `metadata`, `authorId`, `publishedAt`, `createdAt`, `updatedAt`) VALUES (40, '测试文章6', '55d7069d-51ed-4d48-9847-982179c22ea0', '', '', 'markdown', '', '', '', 0, 'draft', 'public', '', 1, NULL, NULL, '[]', '{}', 2, NULL, '2026-09-10 16:04:50.386574', '2026-09-10 16:04:50.386574');
INSERT INTO `blog_document` (`id`, `title`, `slug`, `summary`, `body`, `format`, `cover`, `url`, `groupName`, `sort`, `status`, `accessMode`, `passwordHash`, `accessVersion`, `parentId`, `categoryId`, `tagIds`, `metadata`, `authorId`, `publishedAt`, `createdAt`, `updatedAt`) VALUES (41, '测试文章7', '1a586c07-360c-44ac-b066-5ce154f9ac1a', '', '', 'markdown', '', '', '', 0, 'draft', 'public', '', 1, NULL, NULL, '[]', '{}', 2, NULL, '2026-09-10 16:04:59.448987', '2026-09-10 16:04:59.448987');
INSERT INTO `blog_document` (`id`, `title`, `slug`, `summary`, `body`, `format`, `cover`, `url`, `groupName`, `sort`, `status`, `accessMode`, `passwordHash`, `accessVersion`, `parentId`, `categoryId`, `tagIds`, `metadata`, `authorId`, `publishedAt`, `createdAt`, `updatedAt`) VALUES (42, '测试文章8', '617a2298-9007-42ef-a64b-2ff45abe67bb', '', '', 'markdown', '', '', '', 0, 'published', 'public', '', 1, NULL, NULL, '[]', '{}', 2, '2026-09-10 16:05:06', '2026-09-10 16:05:06.450766', '2026-09-10 16:05:06.450766');
INSERT INTO `blog_document` (`id`, `title`, `slug`, `summary`, `body`, `format`, `cover`, `url`, `groupName`, `sort`, `status`, `accessMode`, `passwordHash`, `accessVersion`, `parentId`, `categoryId`, `tagIds`, `metadata`, `authorId`, `publishedAt`, `createdAt`, `updatedAt`) VALUES (43, '测试文章9', 'ffbb7a6e-12e3-4442-b0c7-e8f9b5f4d29a', '', '', 'markdown', '', '', '', 0, 'draft', 'public', '', 1, NULL, NULL, '[]', '{}', 2, NULL, '2026-09-10 16:05:12.811590', '2026-09-10 16:05:12.811590');
INSERT INTO `blog_document` (`id`, `title`, `slug`, `summary`, `body`, `format`, `cover`, `url`, `groupName`, `sort`, `status`, `accessMode`, `passwordHash`, `accessVersion`, `parentId`, `categoryId`, `tagIds`, `metadata`, `authorId`, `publishedAt`, `createdAt`, `updatedAt`) VALUES (44, '测试文章10', '0d252fd0-1105-4dca-8136-ea8ea7b6a394', '', '', 'markdown', '', '', '', 0, 'published', 'public', '', 1, NULL, NULL, '[]', '{}', 2, '2026-09-10 16:05:20', '2026-09-10 16:05:20.650477', '2026-09-10 16:05:20.650477');
INSERT INTO `blog_document` (`id`, `title`, `slug`, `summary`, `body`, `format`, `cover`, `url`, `groupName`, `sort`, `status`, `accessMode`, `passwordHash`, `accessVersion`, `parentId`, `categoryId`, `tagIds`, `metadata`, `authorId`, `publishedAt`, `createdAt`, `updatedAt`) VALUES (45, '测试文章12', '59684a53-7f3c-4241-9ce7-422fafed6386', '', '', 'markdown', '', '', '', 0, 'published', 'password', '$argon2id$v=19$m=65536,t=3,p=4$33W4Yt3B9eFo3DYkn2iraw$nvFN4DoZN5KmBSiqu4hZZ6bIFgGLrPJdVlL9TbLN+xI', 1, NULL, NULL, '[]', '{}', 2, '2026-09-10 16:05:33', '2026-09-10 16:05:33.241988', '2026-09-10 16:05:33.241988');
INSERT INTO `blog_document` (`id`, `title`, `slug`, `summary`, `body`, `format`, `cover`, `url`, `groupName`, `sort`, `status`, `accessMode`, `passwordHash`, `accessVersion`, `parentId`, `categoryId`, `tagIds`, `metadata`, `authorId`, `publishedAt`, `createdAt`, `updatedAt`) VALUES (46, '测试文章14', '5f3d59af-eb91-4702-99ed-e10273dbb609', '', '', 'markdown', '', '', '', 0, 'published', 'login', '', 1, NULL, NULL, '[]', '{}', 2, '2026-09-10 16:06:38', '2026-09-10 16:05:42.744953', '2026-09-10 16:06:45.000000');
INSERT INTO `blog_document` (`id`, `title`, `slug`, `summary`, `body`, `format`, `cover`, `url`, `groupName`, `sort`, `status`, `accessMode`, `passwordHash`, `accessVersion`, `parentId`, `categoryId`, `tagIds`, `metadata`, `authorId`, `publishedAt`, `createdAt`, `updatedAt`) VALUES (47, '测试文章13', 'ac5be3cc-e11d-41d1-bdf1-60fd742cf67f', '摘要 / 说明', '12312\n\n![图片](/blog-media/13)\n\n2131231231\n\n\n![图片](/blog-media/14)\n', 'markdown', '/blog-media/8', '', '分组 / 歌单', 0, 'published', 'public', '', 1, NULL, 7, '[7]', '{}', 2, '2026-09-10 16:06:31', '2026-09-10 16:06:31.851384', '2026-09-20 15:43:13.000000');
COMMIT;

-- ----------------------------
-- Table structure for blog_essay
-- ----------------------------
DROP TABLE IF EXISTS `blog_essay`;
CREATE TABLE `blog_essay` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `summary` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `body` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `format` varchar(12) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'markdown',
  `cover` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `url` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `groupName` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `sort` int NOT NULL DEFAULT '0',
  `status` varchar(12) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'draft',
  `accessMode` varchar(12) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'public',
  `passwordHash` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `accessVersion` int NOT NULL DEFAULT '1',
  `parentId` int DEFAULT NULL,
  `categoryId` int DEFAULT NULL,
  `tagIds` json NOT NULL,
  `metadata` json NOT NULL,
  `authorId` int DEFAULT NULL,
  `publishedAt` datetime DEFAULT NULL,
  `createdAt` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updatedAt` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `IDX_2cd06068e67ed4856523db39c8` (`slug`)
) ENGINE=InnoDB AUTO_INCREMENT=72 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of blog_essay
-- ----------------------------
BEGIN;
INSERT INTO `blog_essay` (`id`, `title`, `slug`, `summary`, `body`, `format`, `cover`, `url`, `groupName`, `sort`, `status`, `accessMode`, `passwordHash`, `accessVersion`, `parentId`, `categoryId`, `tagIds`, `metadata`, `authorId`, `publishedAt`, `createdAt`, `updatedAt`) VALUES (13, '测试说说', 'aecd6d9c-6d7c-4770-9283-f3c5923d1aae', '摘要 / 说明q we q q', '2312312312\n\n', 'markdown', '', '', '', 0, 'published', 'public', '', 1, NULL, NULL, '[]', '{}', 2, '2026-09-10 13:48:26', '2026-09-10 13:48:37.375121', '2026-09-10 13:48:37.375121');
INSERT INTO `blog_essay` (`id`, `title`, `slug`, `summary`, `body`, `format`, `cover`, `url`, `groupName`, `sort`, `status`, `accessMode`, `passwordHash`, `accessVersion`, `parentId`, `categoryId`, `tagIds`, `metadata`, `authorId`, `publishedAt`, `createdAt`, `updatedAt`) VALUES (20, '测试朋友圈', '6ecafc90-654f-4603-a0f5-75b4326e79ed', '12312', '123123123\n\n', 'markdown', '', '', '', 0, 'published', 'public', '', 1, NULL, NULL, '[]', '{\"mood\": \"开心 😊\", \"tags\": [], \"media\": [{\"url\": \"/blog-media/128\", \"type\": \"video\", \"title\": \"1231231\", \"poster\": \"/blog-media/132\"}, {\"url\": \"/blog-media/133\", \"type\": \"video\", \"title\": \"123\", \"poster\": \"/blog-media/134\"}, {\"url\": \"/blog-media/135\", \"type\": \"image\", \"title\": \"123\"}], \"source\": \"测试\", \"weather\": \"多云 ⛅\", \"location\": \"广州\", \"occurredAt\": \"2026-09-22T08:09:21.000Z\"}', 2, '2026-09-10 13:49:13', '2026-09-10 13:49:21.611000', '2026-09-22 16:09:34.000000');
COMMIT;

-- ----------------------------
-- Table structure for blog_essay_migration
-- ----------------------------
DROP TABLE IF EXISTS `blog_essay_migration`;
CREATE TABLE `blog_essay_migration` (
  `momentId` int NOT NULL,
  `essayId` int NOT NULL,
  PRIMARY KEY (`momentId`),
  UNIQUE KEY `essayId` (`essayId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Records of blog_essay_migration
-- ----------------------------
BEGIN;
INSERT INTO `blog_essay_migration` (`momentId`, `essayId`) VALUES (6, 20);
COMMIT;

-- ----------------------------
-- Table structure for blog_link
-- ----------------------------
DROP TABLE IF EXISTS `blog_link`;
CREATE TABLE `blog_link` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `summary` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `body` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `format` varchar(12) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'markdown',
  `cover` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `url` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `groupName` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `sort` int NOT NULL DEFAULT '0',
  `status` varchar(12) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'draft',
  `accessMode` varchar(12) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'public',
  `passwordHash` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `accessVersion` int NOT NULL DEFAULT '1',
  `parentId` int DEFAULT NULL,
  `categoryId` int DEFAULT NULL,
  `tagIds` json NOT NULL,
  `metadata` json NOT NULL,
  `authorId` int DEFAULT NULL,
  `publishedAt` datetime DEFAULT NULL,
  `createdAt` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updatedAt` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `IDX_e2d57358ea22ae2eff8d0a85fb` (`slug`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of blog_link
-- ----------------------------
BEGIN;
INSERT INTO `blog_link` (`id`, `title`, `slug`, `summary`, `body`, `format`, `cover`, `url`, `groupName`, `sort`, `status`, `accessMode`, `passwordHash`, `accessVersion`, `parentId`, `categoryId`, `tagIds`, `metadata`, `authorId`, `publishedAt`, `createdAt`, `updatedAt`) VALUES (6, '测试友链', 'b2e88580-1666-472f-8596-18181d05d4e8', '测啊是', '', 'markdown', '', '', '', 0, 'published', 'public', '', 1, NULL, NULL, '[]', '{}', 2, '2026-09-10 13:48:55', '2026-09-10 13:48:59.557334', '2026-09-10 13:48:59.557334');
COMMIT;

-- ----------------------------
-- Table structure for blog_media
-- ----------------------------
DROP TABLE IF EXISTS `blog_media`;
CREATE TABLE `blog_media` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `filename` varchar(100) NOT NULL,
  `mime` varchar(100) NOT NULL,
  `size` int NOT NULL,
  `uploaderId` int NOT NULL,
  `createdAt` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=150 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Records of blog_media
-- ----------------------------
BEGIN;
INSERT INTO `blog_media` (`id`, `name`, `filename`, `mime`, `size`, `uploaderId`, `createdAt`) VALUES (6, 'æ±¤å§é®ç®±ï¼æ¼«ï¼.JPG', 'bc9a5595-ba01-4921-b571-aba957bd7b00', 'image/jpeg', 97330, 2, '2026-09-20 14:44:03.876172');
INSERT INTO `blog_media` (`id`, `name`, `filename`, `mime`, `size`, `uploaderId`, `createdAt`) VALUES (7, '1625-1182619662.jpeg', '8dbe557d-25dd-449c-9187-0f0c286dbf5d', 'image/jpeg', 62875, 2, '2026-09-20 14:44:25.262747');
INSERT INTO `blog_media` (`id`, `name`, `filename`, `mime`, `size`, `uploaderId`, `createdAt`) VALUES (8, 'img169.jpg', '55c2f484-17ea-4b4a-bab8-0fe9bc5ccf32', 'image/jpeg', 314943, 2, '2026-09-20 14:45:48.088543');
INSERT INTO `blog_media` (`id`, `name`, `filename`, `mime`, `size`, `uploaderId`, `createdAt`) VALUES (9, 'img6.jpg', 'bc08987c-db11-4524-a247-72e2b242688a', 'image/jpeg', 251313, 2, '2026-09-20 14:45:55.884986');
INSERT INTO `blog_media` (`id`, `name`, `filename`, `mime`, `size`, `uploaderId`, `createdAt`) VALUES (10, 'img10.jpg', '128be3a0-723d-4791-ac3e-426d1eda8d15', 'image/jpeg', 320913, 2, '2026-09-20 14:46:26.066124');
INSERT INTO `blog_media` (`id`, `name`, `filename`, `mime`, `size`, `uploaderId`, `createdAt`) VALUES (11, 'img191.jpg', '484047ff-e026-4b9e-aa19-47dbcba760d1', 'image/jpeg', 238383, 2, '2026-09-20 14:48:44.855018');
INSERT INTO `blog_media` (`id`, `name`, `filename`, `mime`, `size`, `uploaderId`, `createdAt`) VALUES (12, 'img2.jpg', 'e9477864-e3e8-48e1-893c-b80bd4e9c3a8', 'image/jpeg', 508048, 2, '2026-09-20 14:49:04.611401');
INSERT INTO `blog_media` (`id`, `name`, `filename`, `mime`, `size`, `uploaderId`, `createdAt`) VALUES (13, 'img8.jpg', '4ec8a8be-dfe8-47c8-854b-624f11d6dba5', 'image/jpeg', 136545, 2, '2026-09-20 14:50:40.485297');
INSERT INTO `blog_media` (`id`, `name`, `filename`, `mime`, `size`, `uploaderId`, `createdAt`) VALUES (14, '37550a78bb6abcc036f2125fb8b77a3b.JPG', 'b4acd4c6-9d56-4758-9556-d5ab1ec5b6ec', 'image/jpeg', 38745, 2, '2026-09-20 14:51:00.753969');
INSERT INTO `blog_media` (`id`, `name`, `filename`, `mime`, `size`, `uploaderId`, `createdAt`) VALUES (15, 'img6.jpg', '5adb00ff-e2a4-4f83-94a8-df8977cc7756', 'image/jpeg', 251313, 2, '2026-09-20 16:58:48.583289');
INSERT INTO `blog_media` (`id`, `name`, `filename`, `mime`, `size`, `uploaderId`, `createdAt`) VALUES (16, 'img9.jpg', '144e8f71-5b51-4385-ab2a-46aacdfbaec2', 'image/jpeg', 258042, 2, '2026-09-20 16:59:06.039981');
INSERT INTO `blog_media` (`id`, `name`, `filename`, `mime`, `size`, `uploaderId`, `createdAt`) VALUES (17, 'img14.jpg', '6de13faa-f363-4d90-abe8-877aa0d24dba', 'image/jpeg', 305695, 2, '2026-09-20 16:59:17.885559');
INSERT INTO `blog_media` (`id`, `name`, `filename`, `mime`, `size`, `uploaderId`, `createdAt`) VALUES (18, 'img16.jpg', '1a85b333-7365-4653-8b97-51f501742be8', 'image/jpeg', 274427, 2, '2026-09-20 16:59:28.042246');
INSERT INTO `blog_media` (`id`, `name`, `filename`, `mime`, `size`, `uploaderId`, `createdAt`) VALUES (19, 'ç»ç­-ç­ç±105Â°çä½ (èå).mp4', 'aefa4b19-c84d-4ae7-940c-c6719b6178cd', 'video/mp4', 16332014, 2, '2026-09-20 17:08:04.968915');
INSERT INTO `blog_media` (`id`, `name`, `filename`, `mime`, `size`, `uploaderId`, `createdAt`) VALUES (20, 'img3.jpg', 'd1a51d02-c6f9-4e1f-9b1d-20fcabecd339', 'image/jpeg', 510185, 2, '2026-09-20 18:06:55.769810');
INSERT INTO `blog_media` (`id`, `name`, `filename`, `mime`, `size`, `uploaderId`, `createdAt`) VALUES (21, 'æé³å¾å±á¥«á©£.HEIC', 'd2785c1c-a0a3-4f1c-8e3d-090d1c9dacfb', 'video/mp4', 135938, 2, '2026-09-21 09:46:05.550132');
INSERT INTO `blog_media` (`id`, `name`, `filename`, `mime`, `size`, `uploaderId`, `createdAt`) VALUES (22, 'img411.jpg', '6cbea557-33bb-4a22-af0f-fdda73767031', 'image/jpeg', 276739, 2, '2026-09-21 09:46:33.160001');
INSERT INTO `blog_media` (`id`, `name`, `filename`, `mime`, `size`, `uploaderId`, `createdAt`) VALUES (23, 'img409.jpg', 'bd27e539-d187-4a75-9672-367e07a0492a', 'image/jpeg', 134542, 2, '2026-09-21 09:46:48.424089');
INSERT INTO `blog_media` (`id`, `name`, `filename`, `mime`, `size`, `uploaderId`, `createdAt`) VALUES (24, 'img410.jpg', '9c8d5326-3a20-4bb1-a317-00458d36ac0a', 'image/jpeg', 109508, 2, '2026-09-21 09:47:52.216146');
INSERT INTO `blog_media` (`id`, `name`, `filename`, `mime`, `size`, `uploaderId`, `createdAt`) VALUES (25, 'img407.jpg', '054cac9d-48dc-4cb5-a5fc-e0156682be4a', 'image/jpeg', 228676, 2, '2026-09-21 09:47:59.837357');
INSERT INTO `blog_media` (`id`, `name`, `filename`, `mime`, `size`, `uploaderId`, `createdAt`) VALUES (26, 'img642.jpg', 'd5be9213-352e-469c-95fa-93fe2dd027b8', 'image/jpeg', 243911, 2, '2026-09-21 09:48:09.209989');
INSERT INTO `blog_media` (`id`, `name`, `filename`, `mime`, `size`, `uploaderId`, `createdAt`) VALUES (27, 'img414.jpg', '9d0dfaaa-299b-4826-95a7-1648fbd526b6', 'image/jpeg', 142762, 2, '2026-09-21 09:48:19.562070');
INSERT INTO `blog_media` (`id`, `name`, `filename`, `mime`, `size`, `uploaderId`, `createdAt`) VALUES (28, 'img409.jpg', '82dc7a05-847a-45d2-8869-6167ee64cfe8', 'image/jpeg', 134542, 2, '2026-09-21 10:26:31.384290');
INSERT INTO `blog_media` (`id`, `name`, `filename`, `mime`, `size`, `uploaderId`, `createdAt`) VALUES (29, 'img516.jpg', '115a64e6-e633-4e5b-b4b4-e1b4f0bf13f8', 'image/jpeg', 134224, 2, '2026-09-21 11:09:40.559792');
INSERT INTO `blog_media` (`id`, `name`, `filename`, `mime`, `size`, `uploaderId`, `createdAt`) VALUES (30, 'img407.jpg', 'b0013500-9b26-40bb-8c20-fe73090cfbe3', 'image/jpeg', 228676, 2, '2026-09-21 14:03:34.131510');
INSERT INTO `blog_media` (`id`, `name`, `filename`, `mime`, `size`, `uploaderId`, `createdAt`) VALUES (35, 'img408.jpg', '270f2c07-9019-4b8c-b992-e68294ef5de0.jpg', 'image/jpeg', 136018, 2, '2026-09-21 16:07:09.877079');
INSERT INTO `blog_media` (`id`, `name`, `filename`, `mime`, `size`, `uploaderId`, `createdAt`) VALUES (36, 'img409.jpg', 'e7b8d566-bf23-4278-9973-523c10e128f3.jpg', 'image/jpeg', 134542, 2, '2026-09-21 16:08:30.198470');
INSERT INTO `blog_media` (`id`, `name`, `filename`, `mime`, `size`, `uploaderId`, `createdAt`) VALUES (37, 'img414.jpg', 'b94e34d3-86a6-441a-be8a-d4f3a6c81400.jpg', 'image/jpeg', 142762, 2, '2026-09-21 16:08:49.823647');
INSERT INTO `blog_media` (`id`, `name`, `filename`, `mime`, `size`, `uploaderId`, `createdAt`) VALUES (38, '760495b66551e2abf32c7a188085c7af.mp4', '44923a4c-3a3b-4450-8b8b-e4ec6b8da4ae.mp4', 'video/mp4', 486886, 2, '2026-09-21 16:24:16.145122');
INSERT INTO `blog_media` (`id`, `name`, `filename`, `mime`, `size`, `uploaderId`, `createdAt`) VALUES (43, 'img1.jpg', '33873e83-814e-4db2-81e3-637d33e4b652.jpg', 'image/jpeg', 380645, 2, '2026-09-21 16:32:34.494382');
INSERT INTO `blog_media` (`id`, `name`, `filename`, `mime`, `size`, `uploaderId`, `createdAt`) VALUES (44, 'img2.jpg', '6b1d0fa0-1d37-4387-a669-37e2d9a9a191.jpg', 'image/jpeg', 508048, 2, '2026-09-21 16:32:34.619068');
INSERT INTO `blog_media` (`id`, `name`, `filename`, `mime`, `size`, `uploaderId`, `createdAt`) VALUES (45, 'img3.jpg', '61db9017-b035-4a4c-9201-7a95894e8619.jpg', 'image/jpeg', 510185, 2, '2026-09-21 16:32:34.707707');
INSERT INTO `blog_media` (`id`, `name`, `filename`, `mime`, `size`, `uploaderId`, `createdAt`) VALUES (46, 'img4.jpg', 'ffe3bea8-1740-4893-bd3d-69ed3c4dab5c.jpg', 'image/jpeg', 477107, 2, '2026-09-21 16:32:34.818452');
INSERT INTO `blog_media` (`id`, `name`, `filename`, `mime`, `size`, `uploaderId`, `createdAt`) VALUES (47, 'img5.jpg', 'c4325ecd-ebfb-4e9c-b57f-7c3290ae346e.jpg', 'image/jpeg', 233119, 2, '2026-09-21 16:32:34.882351');
INSERT INTO `blog_media` (`id`, `name`, `filename`, `mime`, `size`, `uploaderId`, `createdAt`) VALUES (48, 'img6.jpg', 'bdde9fad-248e-4ef0-9365-f178c59616c7.jpg', 'image/jpeg', 251313, 2, '2026-09-21 16:32:34.961508');
INSERT INTO `blog_media` (`id`, `name`, `filename`, `mime`, `size`, `uploaderId`, `createdAt`) VALUES (49, 'img7.jpg', 'a48d4061-fe06-4cbe-91c2-7a607b069f1a.jpg', 'image/jpeg', 308165, 2, '2026-09-21 16:32:35.075581');
INSERT INTO `blog_media` (`id`, `name`, `filename`, `mime`, `size`, `uploaderId`, `createdAt`) VALUES (50, 'img8.jpg', 'c70999a5-25d3-4569-b2f4-d140f5d39b6b.jpg', 'image/jpeg', 136545, 2, '2026-09-21 16:32:35.139018');
INSERT INTO `blog_media` (`id`, `name`, `filename`, `mime`, `size`, `uploaderId`, `createdAt`) VALUES (51, 'img9.jpg', 'da1dc14d-c033-4c18-88cc-29ed4c80c635.jpg', 'image/jpeg', 258042, 2, '2026-09-21 16:32:35.209975');
INSERT INTO `blog_media` (`id`, `name`, `filename`, `mime`, `size`, `uploaderId`, `createdAt`) VALUES (52, 'img10.jpg', '86fe1cd9-3161-459c-9d98-793508da198e.jpg', 'image/jpeg', 320913, 2, '2026-09-21 16:32:35.263699');
INSERT INTO `blog_media` (`id`, `name`, `filename`, `mime`, `size`, `uploaderId`, `createdAt`) VALUES (53, 'img11.jpg', 'a35d0731-ce71-4575-9fec-9a82893f91c2.jpg', 'image/jpeg', 604510, 2, '2026-09-21 16:32:35.412680');
INSERT INTO `blog_media` (`id`, `name`, `filename`, `mime`, `size`, `uploaderId`, `createdAt`) VALUES (54, 'img1.jpg', '7e59e10e-23c7-4b5a-9cfc-bb9f78ff91cd.jpg', 'image/jpeg', 380645, 2, '2026-09-21 16:33:22.580977');
INSERT INTO `blog_media` (`id`, `name`, `filename`, `mime`, `size`, `uploaderId`, `createdAt`) VALUES (55, 'img2.jpg', 'b937d8db-9e11-4d17-ad8b-4561d11f6e46.jpg', 'image/jpeg', 508048, 2, '2026-09-21 16:33:22.874113');
INSERT INTO `blog_media` (`id`, `name`, `filename`, `mime`, `size`, `uploaderId`, `createdAt`) VALUES (56, 'img3.jpg', 'd9b82dbd-c0cf-4e90-bd7a-cfd169a03dd5.jpg', 'image/jpeg', 510185, 2, '2026-09-21 16:33:23.513197');
INSERT INTO `blog_media` (`id`, `name`, `filename`, `mime`, `size`, `uploaderId`, `createdAt`) VALUES (57, 'img4.jpg', '7d932fbf-9437-410d-9d52-de4b55dcb35e.jpg', 'image/jpeg', 477107, 2, '2026-09-21 16:33:23.778301');
INSERT INTO `blog_media` (`id`, `name`, `filename`, `mime`, `size`, `uploaderId`, `createdAt`) VALUES (58, 'img5.jpg', 'df1aa508-06c8-401a-b494-c524b3b97afd.jpg', 'image/jpeg', 233119, 2, '2026-09-21 16:33:24.000147');
INSERT INTO `blog_media` (`id`, `name`, `filename`, `mime`, `size`, `uploaderId`, `createdAt`) VALUES (59, 'img6.jpg', '9b37ee9b-8fee-48a3-acfd-59cc4a278577.jpg', 'image/jpeg', 251313, 2, '2026-09-21 16:33:26.125810');
INSERT INTO `blog_media` (`id`, `name`, `filename`, `mime`, `size`, `uploaderId`, `createdAt`) VALUES (60, 'img7.jpg', '167c88e2-6110-41b4-a34e-89cc8a496b3e.jpg', 'image/jpeg', 308165, 2, '2026-09-21 16:33:26.325965');
INSERT INTO `blog_media` (`id`, `name`, `filename`, `mime`, `size`, `uploaderId`, `createdAt`) VALUES (61, 'img8.jpg', '42b59779-13b9-4fbf-a769-b69e7c5ed950.jpg', 'image/jpeg', 136545, 2, '2026-09-21 16:33:26.395626');
INSERT INTO `blog_media` (`id`, `name`, `filename`, `mime`, `size`, `uploaderId`, `createdAt`) VALUES (62, 'img9.jpg', 'f79151e8-650f-4920-98ed-d6ec2198be0d.jpg', 'image/jpeg', 258042, 2, '2026-09-21 16:33:26.974691');
INSERT INTO `blog_media` (`id`, `name`, `filename`, `mime`, `size`, `uploaderId`, `createdAt`) VALUES (63, 'img10.jpg', '4a3bd025-805a-4c66-9c03-11f6682029d3.jpg', 'image/jpeg', 320913, 2, '2026-09-21 16:33:27.080532');
INSERT INTO `blog_media` (`id`, `name`, `filename`, `mime`, `size`, `uploaderId`, `createdAt`) VALUES (64, 'img11.jpg', '99676ba1-182d-482b-bcf3-382b59a7662e.jpg', 'image/jpeg', 604510, 2, '2026-09-21 16:33:27.378810');
INSERT INTO `blog_media` (`id`, `name`, `filename`, `mime`, `size`, `uploaderId`, `createdAt`) VALUES (65, 'img12.jpg', '493546a7-637d-4c8e-bcf5-aaa43054687e.jpg', 'image/jpeg', 380905, 2, '2026-09-21 16:33:27.559691');
INSERT INTO `blog_media` (`id`, `name`, `filename`, `mime`, `size`, `uploaderId`, `createdAt`) VALUES (66, 'img13.jpg', 'bc2e9058-5956-4df1-a8d0-598f1d84a17b.jpg', 'image/jpeg', 301054, 2, '2026-09-21 16:33:27.691037');
INSERT INTO `blog_media` (`id`, `name`, `filename`, `mime`, `size`, `uploaderId`, `createdAt`) VALUES (67, 'img1.jpg', '3921621b-193a-4371-8f04-1792a98972ad.jpg', 'image/jpeg', 380645, 2, '2026-09-21 16:34:30.798019');
INSERT INTO `blog_media` (`id`, `name`, `filename`, `mime`, `size`, `uploaderId`, `createdAt`) VALUES (68, 'img2.jpg', 'b2a06898-ffd7-4de7-b407-0c11f2ec9199.jpg', 'image/jpeg', 508048, 2, '2026-09-21 16:34:30.871419');
INSERT INTO `blog_media` (`id`, `name`, `filename`, `mime`, `size`, `uploaderId`, `createdAt`) VALUES (69, 'img3.jpg', '5d2fa71f-72e3-44aa-a04f-8cd8a9771fb5.jpg', 'image/jpeg', 510185, 2, '2026-09-21 16:34:31.062620');
INSERT INTO `blog_media` (`id`, `name`, `filename`, `mime`, `size`, `uploaderId`, `createdAt`) VALUES (70, 'img4.jpg', '15a44ce6-cd6f-4c72-a8ce-d92a1aecc383.jpg', 'image/jpeg', 477107, 2, '2026-09-21 16:34:31.126796');
INSERT INTO `blog_media` (`id`, `name`, `filename`, `mime`, `size`, `uploaderId`, `createdAt`) VALUES (71, 'img5.jpg', 'bf24ab50-df14-4110-b6aa-eb5fa27928f5.jpg', 'image/jpeg', 233119, 2, '2026-09-21 16:34:31.254342');
INSERT INTO `blog_media` (`id`, `name`, `filename`, `mime`, `size`, `uploaderId`, `createdAt`) VALUES (72, 'img6.jpg', 'd17a81f7-8a27-468e-92d7-4d24c772a5b6.jpg', 'image/jpeg', 251313, 2, '2026-09-21 16:34:31.317995');
INSERT INTO `blog_media` (`id`, `name`, `filename`, `mime`, `size`, `uploaderId`, `createdAt`) VALUES (73, 'img7.jpg', '6750b989-a60e-4f4f-9b13-ffc8f4a6c4dc.jpg', 'image/jpeg', 308165, 2, '2026-09-21 16:34:31.407038');
INSERT INTO `blog_media` (`id`, `name`, `filename`, `mime`, `size`, `uploaderId`, `createdAt`) VALUES (74, 'img8.jpg', 'aa527934-d979-4ceb-a69e-9e7ca4dc65e6.jpg', 'image/jpeg', 136545, 2, '2026-09-21 16:34:32.113724');
INSERT INTO `blog_media` (`id`, `name`, `filename`, `mime`, `size`, `uploaderId`, `createdAt`) VALUES (75, 'img9.jpg', '9c60d100-28c3-4f08-aa87-41fa8fcbe9c0.jpg', 'image/jpeg', 258042, 2, '2026-09-21 16:34:32.171000');
INSERT INTO `blog_media` (`id`, `name`, `filename`, `mime`, `size`, `uploaderId`, `createdAt`) VALUES (76, 'img10.jpg', '4b386dbe-6f7a-4eb2-87e2-699970998b28.jpg', 'image/jpeg', 320913, 2, '2026-09-21 16:34:32.227338');
INSERT INTO `blog_media` (`id`, `name`, `filename`, `mime`, `size`, `uploaderId`, `createdAt`) VALUES (77, 'img11.jpg', 'aba69545-ac44-48ea-a0cd-3844d2812575.jpg', 'image/jpeg', 604510, 2, '2026-09-21 16:34:32.287992');
INSERT INTO `blog_media` (`id`, `name`, `filename`, `mime`, `size`, `uploaderId`, `createdAt`) VALUES (78, 'img12.jpg', 'f15b6e3a-f426-4944-bd12-edeae083ef06.jpg', 'image/jpeg', 380905, 2, '2026-09-21 16:34:32.342957');
INSERT INTO `blog_media` (`id`, `name`, `filename`, `mime`, `size`, `uploaderId`, `createdAt`) VALUES (79, 'img13.jpg', '8583fe46-889a-4398-b8b0-92a12b2be929.jpg', 'image/jpeg', 301054, 2, '2026-09-21 16:34:32.431517');
INSERT INTO `blog_media` (`id`, `name`, `filename`, `mime`, `size`, `uploaderId`, `createdAt`) VALUES (80, 'çå¿§ä¼¤ï¼æ¼«ï¼.jpg', '20a1cc54-aede-4626-ac4d-a4d1b9a60fbb.jpg', 'image/jpeg', 181054, 2, '2026-09-21 17:27:05.268430');
INSERT INTO `blog_media` (`id`, `name`, `filename`, `mime`, `size`, `uploaderId`, `createdAt`) VALUES (81, 'ç»ç­-ç­ç±105Â°çä½ (èå).mp4', 'ba45a44a-4031-439a-b840-d7bd441b6b8e.mp4', 'video/mp4', 16332014, 2, '2026-09-21 17:27:05.824538');
INSERT INTO `blog_media` (`id`, `name`, `filename`, `mime`, `size`, `uploaderId`, `createdAt`) VALUES (82, 'æ°çå¿§ä¼¤ï¼æ¼«ï¼.jpg', 'efb77ef6-0090-4a4e-9170-6dcfe1306a56.jpg', 'image/jpeg', 461620, 2, '2026-09-21 17:27:06.077159');
INSERT INTO `blog_media` (`id`, `name`, `filename`, `mime`, `size`, `uploaderId`, `createdAt`) VALUES (83, 'æ°çå¿§ä¼¤ï¼äººï¼.jpg', '6584f6bb-57a6-447e-b57c-b4d0c8bce5cf.jpg', 'image/jpeg', 288466, 2, '2026-09-21 17:27:06.128752');
INSERT INTO `blog_media` (`id`, `name`, `filename`, `mime`, `size`, `uploaderId`, `createdAt`) VALUES (84, 'å¾®ä¿¡å¾ç_20201112103431.jpg', '40bc7cc6-f94d-4d32-a270-117df315d1ea.jpg', 'image/jpeg', 46703, 2, '2026-09-21 17:27:06.185773');
INSERT INTO `blog_media` (`id`, `name`, `filename`, `mime`, `size`, `uploaderId`, `createdAt`) VALUES (85, 'å¾®ä¿¡å¾ç_20201125084331.jpg', '50d4770f-49d9-4885-8a8b-97f953ab59c5.jpg', 'image/jpeg', 59066, 2, '2026-09-21 17:27:06.230143');
INSERT INTO `blog_media` (`id`, `name`, `filename`, `mime`, `size`, `uploaderId`, `createdAt`) VALUES (86, 'å¾®ä¿¡å¾ç_20201201145036.jpg', 'db201ee6-b447-46ea-b138-df775f6da79c.jpg', 'image/jpeg', 42614, 2, '2026-09-21 17:27:06.493625');
INSERT INTO `blog_media` (`id`, `name`, `filename`, `mime`, `size`, `uploaderId`, `createdAt`) VALUES (87, 'å¾®ä¿¡å¾ç_20201214130342.jpg', '0fcab820-b9ec-4559-873a-bd4dbb06e8c5.jpg', 'image/jpeg', 156549, 2, '2026-09-21 17:27:06.566326');
INSERT INTO `blog_media` (`id`, `name`, `filename`, `mime`, `size`, `uploaderId`, `createdAt`) VALUES (88, 'å¾®ä¿¡å¾ç_20211115193158.png', 'a0f20ba4-34aa-4a1c-8b1d-a45224b9dde6.png', 'image/png', 481646, 2, '2026-09-21 17:27:06.758680');
INSERT INTO `blog_media` (`id`, `name`, `filename`, `mime`, `size`, `uploaderId`, `createdAt`) VALUES (89, 'ä¸è½½.png', '1d0f5078-3020-42b4-a64f-a85c20ab490f.png', 'image/png', 75341, 2, '2026-09-21 17:27:06.822498');
INSERT INTO `blog_media` (`id`, `name`, `filename`, `mime`, `size`, `uploaderId`, `createdAt`) VALUES (90, 'å®å®æç©º.jpg', '7a7384eb-93cd-4c99-8b1c-94200641d2e1.jpg', 'image/jpeg', 136155, 2, '2026-09-21 17:27:06.952943');
INSERT INTO `blog_media` (`id`, `name`, `filename`, `mime`, `size`, `uploaderId`, `createdAt`) VALUES (91, 'c8c1bd59f552b149202800e354041535.mp4', '573141f8-4542-4d10-9e16-0865b1ed4d96.mp4', 'video/mp4', 3758363, 2, '2026-09-21 17:27:07.807953');
INSERT INTO `blog_media` (`id`, `name`, `filename`, `mime`, `size`, `uploaderId`, `createdAt`) VALUES (92, 'cy.png', '5b3a227c-6857-42f6-ac64-2658643034d3.png', 'image/png', 87662, 2, '2026-09-21 17:27:07.917222');
INSERT INTO `blog_media` (`id`, `name`, `filename`, `mime`, `size`, `uploaderId`, `createdAt`) VALUES (93, 'IMG_0006.JPG', '9a20f09c-fe79-4ed4-8039-f3441370ec47.jpg', 'image/jpeg', 60459, 2, '2026-09-21 17:27:07.976857');
INSERT INTO `blog_media` (`id`, `name`, `filename`, `mime`, `size`, `uploaderId`, `createdAt`) VALUES (94, 'IMG_0007.JPG', '7a4167a5-5d0a-45ea-bacf-4df362542b72.jpg', 'image/jpeg', 50910, 2, '2026-09-21 17:27:08.065371');
INSERT INTO `blog_media` (`id`, `name`, `filename`, `mime`, `size`, `uploaderId`, `createdAt`) VALUES (95, 'IMG_0008.JPG', '5be97272-511e-47d4-896d-b82883cae9dd.jpg', 'image/jpeg', 65211, 2, '2026-09-21 17:27:08.338770');
INSERT INTO `blog_media` (`id`, `name`, `filename`, `mime`, `size`, `uploaderId`, `createdAt`) VALUES (96, 'IMG_0058.JPG', 'a4fd4b2d-3125-45a0-ba20-860acbb68c35.jpg', 'image/jpeg', 39489, 2, '2026-09-21 17:27:08.423043');
INSERT INTO `blog_media` (`id`, `name`, `filename`, `mime`, `size`, `uploaderId`, `createdAt`) VALUES (97, 'IMG_0289.JPG', 'e0103db8-6570-4743-8c52-ed7516c79eb3.jpg', 'image/jpeg', 160599, 2, '2026-09-21 17:27:08.492623');
INSERT INTO `blog_media` (`id`, `name`, `filename`, `mime`, `size`, `uploaderId`, `createdAt`) VALUES (98, 'IMG_0430.JPG', '4a6de7fb-b0ed-474f-9661-ff4747f0515d.jpg', 'image/jpeg', 112208, 2, '2026-09-21 17:27:08.803261');
INSERT INTO `blog_media` (`id`, `name`, `filename`, `mime`, `size`, `uploaderId`, `createdAt`) VALUES (99, 'IMG_1598.JPG', 'ca5f05a2-25d5-45ce-96c5-4fdeb64cbc7e.jpg', 'image/jpeg', 54334, 2, '2026-09-21 17:27:08.868884');
INSERT INTO `blog_media` (`id`, `name`, `filename`, `mime`, `size`, `uploaderId`, `createdAt`) VALUES (100, 'IMG_1765.PNG', '29980290-b04b-4260-a919-31d3b2b7ef31.png', 'image/png', 3566271, 2, '2026-09-21 17:27:08.974550');
INSERT INTO `blog_media` (`id`, `name`, `filename`, `mime`, `size`, `uploaderId`, `createdAt`) VALUES (101, 'psc11.jpg', '75a753aa-f217-4e18-bd63-11d379533399.jpg', 'image/jpeg', 3947625, 2, '2026-09-21 17:27:09.033254');
INSERT INTO `blog_media` (`id`, `name`, `filename`, `mime`, `size`, `uploaderId`, `createdAt`) VALUES (102, '1625-1182619662.jpeg', 'e7743b72-159d-41bd-a5da-6b86fa2a31d2.jpeg', 'image/jpeg', 62875, 2, '2026-09-21 18:10:23.398756');
INSERT INTO `blog_media` (`id`, `name`, `filename`, `mime`, `size`, `uploaderId`, `createdAt`) VALUES (103, 'img49.jpg', '316127a1-860d-4de4-921e-932411bd7f8d.jpg', 'image/jpeg', 198332, 2, '2026-09-21 22:56:11.667859');
INSERT INTO `blog_media` (`id`, `name`, `filename`, `mime`, `size`, `uploaderId`, `createdAt`) VALUES (104, 'å¾å¾å¾.mp3', 'bb13d94e-e65a-4af6-923f-bce6ac2a14b1.mp3', 'video/mp4', 21021076, 2, '2026-09-22 09:11:14.412625');
INSERT INTO `blog_media` (`id`, `name`, `filename`, `mime`, `size`, `uploaderId`, `createdAt`) VALUES (105, '1625-1182619662.jpeg', '7c14c3a1-ff02-43f4-acf9-818674458757.jpeg', 'image/jpeg', 62875, 2, '2026-09-22 09:11:21.945419');
INSERT INTO `blog_media` (`id`, `name`, `filename`, `mime`, `size`, `uploaderId`, `createdAt`) VALUES (107, 'çå¿§ä¼¤ï¼æ¼«ï¼.jpg', 'ae9e286a-36b4-4569-ba2b-e057c13076fd.jpg', 'image/jpeg', 181054, 2, '2026-09-22 11:07:32.760030');
INSERT INTO `blog_media` (`id`, `name`, `filename`, `mime`, `size`, `uploaderId`, `createdAt`) VALUES (108, 'æ°çå¿§ä¼¤ï¼äººï¼.jpg', 'fa4a4f1c-bd72-41d1-a960-58fd38bf3b40.jpg', 'image/jpeg', 288466, 2, '2026-09-22 11:08:36.331963');
INSERT INTO `blog_media` (`id`, `name`, `filename`, `mime`, `size`, `uploaderId`, `createdAt`) VALUES (109, 'img7.jpg', 'a158cdca-213b-4881-9561-550f8a4e4ae6.jpg', 'image/jpeg', 308165, 2, '2026-09-22 11:09:57.860725');
INSERT INTO `blog_media` (`id`, `name`, `filename`, `mime`, `size`, `uploaderId`, `createdAt`) VALUES (110, 'img13.jpg', '05c8d023-e6ee-465a-8b8d-2276b9d8f7b7.jpg', 'image/jpeg', 301054, 2, '2026-09-22 11:10:03.528906');
INSERT INTO `blog_media` (`id`, `name`, `filename`, `mime`, `size`, `uploaderId`, `createdAt`) VALUES (111, 'img12.jpg', 'e208e5c5-175e-4ab2-9112-079041dbcf26.jpg', 'image/jpeg', 380905, 2, '2026-09-22 11:10:08.873286');
INSERT INTO `blog_media` (`id`, `name`, `filename`, `mime`, `size`, `uploaderId`, `createdAt`) VALUES (112, 'img14.jpg', '2dfee616-70d1-44f9-a79f-e3fa8cc89e4e.jpg', 'image/jpeg', 305695, 2, '2026-09-22 11:10:12.790958');
INSERT INTO `blog_media` (`id`, `name`, `filename`, `mime`, `size`, `uploaderId`, `createdAt`) VALUES (113, 'img4.jpg', '252cb868-3987-4b16-b4af-4184b86532e7.jpg', 'image/jpeg', 477107, 2, '2026-09-22 11:10:17.760836');
INSERT INTO `blog_media` (`id`, `name`, `filename`, `mime`, `size`, `uploaderId`, `createdAt`) VALUES (114, 'img47.jpg', 'f8799218-bec3-45e0-b1a9-104d46260842.jpg', 'image/jpeg', 354143, 2, '2026-09-22 12:11:29.450515');
INSERT INTO `blog_media` (`id`, `name`, `filename`, `mime`, `size`, `uploaderId`, `createdAt`) VALUES (115, 'img11.jpg', '0e4c1b06-0cbb-4f2f-bdb1-816ae86adec6.jpg', 'image/jpeg', 604510, 2, '2026-09-22 12:11:39.224664');
INSERT INTO `blog_media` (`id`, `name`, `filename`, `mime`, `size`, `uploaderId`, `createdAt`) VALUES (116, 'img7.jpg', 'e4b77afa-3f89-467f-8cad-a3d62a1bfacb.jpg', 'image/jpeg', 308165, 2, '2026-09-22 12:11:58.352115');
INSERT INTO `blog_media` (`id`, `name`, `filename`, `mime`, `size`, `uploaderId`, `createdAt`) VALUES (117, 'img12.jpg', 'cc3b4f78-3ac0-4ca6-a21d-80acad18a5bb.jpg', 'image/jpeg', 380905, 2, '2026-09-22 12:12:35.022424');
INSERT INTO `blog_media` (`id`, `name`, `filename`, `mime`, `size`, `uploaderId`, `createdAt`) VALUES (118, 'img13.jpg', '85de950e-4cd3-4ded-a669-dd3aafcb3601.jpg', 'image/jpeg', 301054, 2, '2026-09-22 14:01:08.015027');
INSERT INTO `blog_media` (`id`, `name`, `filename`, `mime`, `size`, `uploaderId`, `createdAt`) VALUES (119, 'img26.jpg', '547365d3-81ca-43d8-ad58-c6f17333918a.jpg', 'image/jpeg', 278836, 2, '2026-09-22 14:01:13.229680');
INSERT INTO `blog_media` (`id`, `name`, `filename`, `mime`, `size`, `uploaderId`, `createdAt`) VALUES (120, 'img11.jpg', '8649bac1-f32e-46c6-81d3-1098a070a43d.jpg', 'image/jpeg', 604510, 2, '2026-09-22 14:01:30.823578');
INSERT INTO `blog_media` (`id`, `name`, `filename`, `mime`, `size`, `uploaderId`, `createdAt`) VALUES (121, 'img147.jpg', '159ff600-160d-4742-857a-061949debfec.jpg', 'image/jpeg', 308142, 2, '2026-09-22 14:01:47.262325');
INSERT INTO `blog_media` (`id`, `name`, `filename`, `mime`, `size`, `uploaderId`, `createdAt`) VALUES (122, 'img9.jpg', '43dacd43-d376-4f5f-a4ba-b2945462ca01.jpg', 'image/jpeg', 258042, 2, '2026-09-22 14:22:08.821670');
INSERT INTO `blog_media` (`id`, `name`, `filename`, `mime`, `size`, `uploaderId`, `createdAt`) VALUES (123, 'img8.jpg', 'e9fa2380-b350-4175-b135-b3bd1e31af2c.jpg', 'image/jpeg', 136545, 2, '2026-09-22 14:22:12.992225');
INSERT INTO `blog_media` (`id`, `name`, `filename`, `mime`, `size`, `uploaderId`, `createdAt`) VALUES (124, 'img1.jpg', '3d004345-d20a-4576-bce5-c4d53b7e0853.jpg', 'image/jpeg', 380645, 2, '2026-09-22 14:22:30.999568');
INSERT INTO `blog_media` (`id`, `name`, `filename`, `mime`, `size`, `uploaderId`, `createdAt`) VALUES (128, 'ç»ç­-ç­ç±105Â°çä½ (èå).mp4', '78a5f187-9b07-451c-a4d8-bdc97d482244.mp4', 'video/mp4', 16332014, 2, '2026-09-22 15:51:45.537828');
INSERT INTO `blog_media` (`id`, `name`, `filename`, `mime`, `size`, `uploaderId`, `createdAt`) VALUES (130, '1625-1182619662.jpeg', '42b5792c-6972-4545-bf97-34c1bacc2462.jpeg', 'image/jpeg', 62875, 2, '2026-09-22 16:07:51.922954');
INSERT INTO `blog_media` (`id`, `name`, `filename`, `mime`, `size`, `uploaderId`, `createdAt`) VALUES (131, 'å¾å¾å¾.mp3', '02b6a833-97c3-43c8-aadb-179729d7fcab.mp3', 'video/mp4', 21021076, 2, '2026-09-22 16:08:05.241854');
INSERT INTO `blog_media` (`id`, `name`, `filename`, `mime`, `size`, `uploaderId`, `createdAt`) VALUES (132, 'img8.jpg', '8526a671-d3b6-4474-b5a7-e04360bfd1e7.jpg', 'image/jpeg', 136545, 2, '2026-09-22 16:08:39.573173');
INSERT INTO `blog_media` (`id`, `name`, `filename`, `mime`, `size`, `uploaderId`, `createdAt`) VALUES (133, 'å¾å¾å¾.mp3', '8752a779-7216-43a0-908e-525c12f21819.mp3', 'video/mp4', 21021076, 2, '2026-09-22 16:08:47.313689');
INSERT INTO `blog_media` (`id`, `name`, `filename`, `mime`, `size`, `uploaderId`, `createdAt`) VALUES (134, 'çµèèææºé®é¢.png', '0c785408-95c0-4b31-884f-9857470a8909.png', 'image/png', 27250, 2, '2026-09-22 16:08:56.286487');
INSERT INTO `blog_media` (`id`, `name`, `filename`, `mime`, `size`, `uploaderId`, `createdAt`) VALUES (135, 'img7.jpg', '68abd90d-e585-4b1a-ba3b-73748de5c540.jpg', 'image/jpeg', 308165, 2, '2026-09-22 16:09:29.386742');
INSERT INTO `blog_media` (`id`, `name`, `filename`, `mime`, `size`, `uploaderId`, `createdAt`) VALUES (149, 'img10.jpg', '68b8e572-7d6a-4434-ad15-ae8d2ad7cf77.jpg', 'image/jpeg', 320913, 2, '2026-09-23 12:29:05.096685');
COMMIT;

-- ----------------------------
-- Table structure for blog_media_reference
-- ----------------------------
DROP TABLE IF EXISTS `blog_media_reference`;
CREATE TABLE `blog_media_reference` (
  `id` int NOT NULL AUTO_INCREMENT,
  `mediaId` int NOT NULL,
  `kind` varchar(30) NOT NULL,
  `contentId` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `IDX_6bc0f9baaa57c92761683e38b5` (`mediaId`,`kind`,`contentId`)
) ENGINE=InnoDB AUTO_INCREMENT=977 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Records of blog_media_reference
-- ----------------------------
BEGIN;
INSERT INTO `blog_media_reference` (`id`, `mediaId`, `kind`, `contentId`) VALUES (967, 6, 'site', 1);
INSERT INTO `blog_media_reference` (`id`, `mediaId`, `kind`, `contentId`) VALUES (968, 7, 'site', 1);
INSERT INTO `blog_media_reference` (`id`, `mediaId`, `kind`, `contentId`) VALUES (22, 8, 'documents', 47);
INSERT INTO `blog_media_reference` (`id`, `mediaId`, `kind`, `contentId`) VALUES (357, 11, 'about', 7);
INSERT INTO `blog_media_reference` (`id`, `mediaId`, `kind`, `contentId`) VALUES (969, 11, 'site', 1);
INSERT INTO `blog_media_reference` (`id`, `mediaId`, `kind`, `contentId`) VALUES (970, 12, 'site', 1);
INSERT INTO `blog_media_reference` (`id`, `mediaId`, `kind`, `contentId`) VALUES (20, 13, 'documents', 47);
INSERT INTO `blog_media_reference` (`id`, `mediaId`, `kind`, `contentId`) VALUES (21, 14, 'documents', 47);
INSERT INTO `blog_media_reference` (`id`, `mediaId`, `kind`, `contentId`) VALUES (971, 16, 'site', 1);
INSERT INTO `blog_media_reference` (`id`, `mediaId`, `kind`, `contentId`) VALUES (972, 17, 'site', 1);
INSERT INTO `blog_media_reference` (`id`, `mediaId`, `kind`, `contentId`) VALUES (973, 18, 'site', 1);
INSERT INTO `blog_media_reference` (`id`, `mediaId`, `kind`, `contentId`) VALUES (974, 19, 'site', 1);
INSERT INTO `blog_media_reference` (`id`, `mediaId`, `kind`, `contentId`) VALUES (92, 20, 'categories', 7);
INSERT INTO `blog_media_reference` (`id`, `mediaId`, `kind`, `contentId`) VALUES (147, 22, 'albums', 9);
INSERT INTO `blog_media_reference` (`id`, `mediaId`, `kind`, `contentId`) VALUES (148, 23, 'albums', 9);
INSERT INTO `blog_media_reference` (`id`, `mediaId`, `kind`, `contentId`) VALUES (112, 24, 'photos', 8);
INSERT INTO `blog_media_reference` (`id`, `mediaId`, `kind`, `contentId`) VALUES (113, 26, 'photos', 8);
INSERT INTO `blog_media_reference` (`id`, `mediaId`, `kind`, `contentId`) VALUES (111, 27, 'photos', 8);
INSERT INTO `blog_media_reference` (`id`, `mediaId`, `kind`, `contentId`) VALUES (122, 28, 'tags', 7);
INSERT INTO `blog_media_reference` (`id`, `mediaId`, `kind`, `contentId`) VALUES (118, 29, 'tags', 8);
INSERT INTO `blog_media_reference` (`id`, `mediaId`, `kind`, `contentId`) VALUES (975, 30, 'site', 1);
INSERT INTO `blog_media_reference` (`id`, `mediaId`, `kind`, `contentId`) VALUES (217, 35, 'albums', 10);
INSERT INTO `blog_media_reference` (`id`, `mediaId`, `kind`, `contentId`) VALUES (179, 36, 'albums', 11);
INSERT INTO `blog_media_reference` (`id`, `mediaId`, `kind`, `contentId`) VALUES (193, 37, 'albums', 12);
INSERT INTO `blog_media_reference` (`id`, `mediaId`, `kind`, `contentId`) VALUES (146, 38, 'photos', 9);
INSERT INTO `blog_media_reference` (`id`, `mediaId`, `kind`, `contentId`) VALUES (154, 43, 'photos', 12);
INSERT INTO `blog_media_reference` (`id`, `mediaId`, `kind`, `contentId`) VALUES (155, 44, 'photos', 13);
INSERT INTO `blog_media_reference` (`id`, `mediaId`, `kind`, `contentId`) VALUES (156, 45, 'photos', 14);
INSERT INTO `blog_media_reference` (`id`, `mediaId`, `kind`, `contentId`) VALUES (157, 46, 'photos', 15);
INSERT INTO `blog_media_reference` (`id`, `mediaId`, `kind`, `contentId`) VALUES (158, 47, 'photos', 16);
INSERT INTO `blog_media_reference` (`id`, `mediaId`, `kind`, `contentId`) VALUES (159, 48, 'photos', 17);
INSERT INTO `blog_media_reference` (`id`, `mediaId`, `kind`, `contentId`) VALUES (160, 49, 'photos', 18);
INSERT INTO `blog_media_reference` (`id`, `mediaId`, `kind`, `contentId`) VALUES (161, 50, 'photos', 19);
INSERT INTO `blog_media_reference` (`id`, `mediaId`, `kind`, `contentId`) VALUES (162, 51, 'photos', 20);
INSERT INTO `blog_media_reference` (`id`, `mediaId`, `kind`, `contentId`) VALUES (163, 52, 'photos', 21);
INSERT INTO `blog_media_reference` (`id`, `mediaId`, `kind`, `contentId`) VALUES (164, 53, 'photos', 22);
INSERT INTO `blog_media_reference` (`id`, `mediaId`, `kind`, `contentId`) VALUES (166, 54, 'photos', 23);
INSERT INTO `blog_media_reference` (`id`, `mediaId`, `kind`, `contentId`) VALUES (167, 55, 'photos', 24);
INSERT INTO `blog_media_reference` (`id`, `mediaId`, `kind`, `contentId`) VALUES (168, 56, 'photos', 25);
INSERT INTO `blog_media_reference` (`id`, `mediaId`, `kind`, `contentId`) VALUES (169, 57, 'photos', 26);
INSERT INTO `blog_media_reference` (`id`, `mediaId`, `kind`, `contentId`) VALUES (170, 58, 'photos', 27);
INSERT INTO `blog_media_reference` (`id`, `mediaId`, `kind`, `contentId`) VALUES (171, 59, 'photos', 28);
INSERT INTO `blog_media_reference` (`id`, `mediaId`, `kind`, `contentId`) VALUES (172, 60, 'photos', 29);
INSERT INTO `blog_media_reference` (`id`, `mediaId`, `kind`, `contentId`) VALUES (173, 61, 'photos', 30);
INSERT INTO `blog_media_reference` (`id`, `mediaId`, `kind`, `contentId`) VALUES (174, 62, 'photos', 31);
INSERT INTO `blog_media_reference` (`id`, `mediaId`, `kind`, `contentId`) VALUES (175, 63, 'photos', 32);
INSERT INTO `blog_media_reference` (`id`, `mediaId`, `kind`, `contentId`) VALUES (176, 64, 'photos', 33);
INSERT INTO `blog_media_reference` (`id`, `mediaId`, `kind`, `contentId`) VALUES (177, 65, 'photos', 34);
INSERT INTO `blog_media_reference` (`id`, `mediaId`, `kind`, `contentId`) VALUES (178, 66, 'photos', 35);
INSERT INTO `blog_media_reference` (`id`, `mediaId`, `kind`, `contentId`) VALUES (180, 67, 'photos', 36);
INSERT INTO `blog_media_reference` (`id`, `mediaId`, `kind`, `contentId`) VALUES (181, 68, 'photos', 37);
INSERT INTO `blog_media_reference` (`id`, `mediaId`, `kind`, `contentId`) VALUES (182, 69, 'photos', 38);
INSERT INTO `blog_media_reference` (`id`, `mediaId`, `kind`, `contentId`) VALUES (183, 70, 'photos', 39);
INSERT INTO `blog_media_reference` (`id`, `mediaId`, `kind`, `contentId`) VALUES (184, 71, 'photos', 40);
INSERT INTO `blog_media_reference` (`id`, `mediaId`, `kind`, `contentId`) VALUES (185, 72, 'photos', 41);
INSERT INTO `blog_media_reference` (`id`, `mediaId`, `kind`, `contentId`) VALUES (186, 73, 'photos', 42);
INSERT INTO `blog_media_reference` (`id`, `mediaId`, `kind`, `contentId`) VALUES (187, 74, 'photos', 43);
INSERT INTO `blog_media_reference` (`id`, `mediaId`, `kind`, `contentId`) VALUES (188, 75, 'photos', 44);
INSERT INTO `blog_media_reference` (`id`, `mediaId`, `kind`, `contentId`) VALUES (189, 76, 'photos', 45);
INSERT INTO `blog_media_reference` (`id`, `mediaId`, `kind`, `contentId`) VALUES (190, 77, 'photos', 46);
INSERT INTO `blog_media_reference` (`id`, `mediaId`, `kind`, `contentId`) VALUES (191, 78, 'photos', 47);
INSERT INTO `blog_media_reference` (`id`, `mediaId`, `kind`, `contentId`) VALUES (192, 79, 'photos', 48);
INSERT INTO `blog_media_reference` (`id`, `mediaId`, `kind`, `contentId`) VALUES (194, 80, 'photos', 49);
INSERT INTO `blog_media_reference` (`id`, `mediaId`, `kind`, `contentId`) VALUES (195, 81, 'photos', 50);
INSERT INTO `blog_media_reference` (`id`, `mediaId`, `kind`, `contentId`) VALUES (196, 82, 'photos', 51);
INSERT INTO `blog_media_reference` (`id`, `mediaId`, `kind`, `contentId`) VALUES (197, 83, 'photos', 52);
INSERT INTO `blog_media_reference` (`id`, `mediaId`, `kind`, `contentId`) VALUES (198, 84, 'photos', 53);
INSERT INTO `blog_media_reference` (`id`, `mediaId`, `kind`, `contentId`) VALUES (199, 85, 'photos', 54);
INSERT INTO `blog_media_reference` (`id`, `mediaId`, `kind`, `contentId`) VALUES (200, 86, 'photos', 55);
INSERT INTO `blog_media_reference` (`id`, `mediaId`, `kind`, `contentId`) VALUES (201, 87, 'photos', 56);
INSERT INTO `blog_media_reference` (`id`, `mediaId`, `kind`, `contentId`) VALUES (202, 88, 'photos', 57);
INSERT INTO `blog_media_reference` (`id`, `mediaId`, `kind`, `contentId`) VALUES (203, 89, 'photos', 58);
INSERT INTO `blog_media_reference` (`id`, `mediaId`, `kind`, `contentId`) VALUES (204, 90, 'photos', 59);
INSERT INTO `blog_media_reference` (`id`, `mediaId`, `kind`, `contentId`) VALUES (205, 91, 'photos', 60);
INSERT INTO `blog_media_reference` (`id`, `mediaId`, `kind`, `contentId`) VALUES (206, 92, 'photos', 61);
INSERT INTO `blog_media_reference` (`id`, `mediaId`, `kind`, `contentId`) VALUES (207, 93, 'photos', 62);
INSERT INTO `blog_media_reference` (`id`, `mediaId`, `kind`, `contentId`) VALUES (208, 94, 'photos', 63);
INSERT INTO `blog_media_reference` (`id`, `mediaId`, `kind`, `contentId`) VALUES (209, 95, 'photos', 64);
INSERT INTO `blog_media_reference` (`id`, `mediaId`, `kind`, `contentId`) VALUES (210, 96, 'photos', 65);
INSERT INTO `blog_media_reference` (`id`, `mediaId`, `kind`, `contentId`) VALUES (211, 97, 'photos', 66);
INSERT INTO `blog_media_reference` (`id`, `mediaId`, `kind`, `contentId`) VALUES (212, 98, 'photos', 67);
INSERT INTO `blog_media_reference` (`id`, `mediaId`, `kind`, `contentId`) VALUES (213, 99, 'photos', 68);
INSERT INTO `blog_media_reference` (`id`, `mediaId`, `kind`, `contentId`) VALUES (214, 100, 'photos', 69);
INSERT INTO `blog_media_reference` (`id`, `mediaId`, `kind`, `contentId`) VALUES (215, 101, 'photos', 70);
INSERT INTO `blog_media_reference` (`id`, `mediaId`, `kind`, `contentId`) VALUES (218, 102, 'bangumis', 6);
INSERT INTO `blog_media_reference` (`id`, `mediaId`, `kind`, `contentId`) VALUES (219, 103, 'collections', 7);
INSERT INTO `blog_media_reference` (`id`, `mediaId`, `kind`, `contentId`) VALUES (927, 104, 'music', 6);
INSERT INTO `blog_media_reference` (`id`, `mediaId`, `kind`, `contentId`) VALUES (928, 105, 'music', 6);
INSERT INTO `blog_media_reference` (`id`, `mediaId`, `kind`, `contentId`) VALUES (358, 110, 'about', 7);
INSERT INTO `blog_media_reference` (`id`, `mediaId`, `kind`, `contentId`) VALUES (359, 111, 'about', 7);
INSERT INTO `blog_media_reference` (`id`, `mediaId`, `kind`, `contentId`) VALUES (360, 112, 'about', 7);
INSERT INTO `blog_media_reference` (`id`, `mediaId`, `kind`, `contentId`) VALUES (361, 113, 'about', 7);
INSERT INTO `blog_media_reference` (`id`, `mediaId`, `kind`, `contentId`) VALUES (362, 114, 'about', 7);
INSERT INTO `blog_media_reference` (`id`, `mediaId`, `kind`, `contentId`) VALUES (363, 115, 'about', 7);
INSERT INTO `blog_media_reference` (`id`, `mediaId`, `kind`, `contentId`) VALUES (364, 116, 'about', 7);
INSERT INTO `blog_media_reference` (`id`, `mediaId`, `kind`, `contentId`) VALUES (365, 117, 'about', 7);
INSERT INTO `blog_media_reference` (`id`, `mediaId`, `kind`, `contentId`) VALUES (366, 118, 'about', 7);
INSERT INTO `blog_media_reference` (`id`, `mediaId`, `kind`, `contentId`) VALUES (367, 119, 'about', 7);
INSERT INTO `blog_media_reference` (`id`, `mediaId`, `kind`, `contentId`) VALUES (368, 120, 'about', 7);
INSERT INTO `blog_media_reference` (`id`, `mediaId`, `kind`, `contentId`) VALUES (369, 121, 'about', 7);
INSERT INTO `blog_media_reference` (`id`, `mediaId`, `kind`, `contentId`) VALUES (370, 122, 'about', 7);
INSERT INTO `blog_media_reference` (`id`, `mediaId`, `kind`, `contentId`) VALUES (371, 123, 'about', 7);
INSERT INTO `blog_media_reference` (`id`, `mediaId`, `kind`, `contentId`) VALUES (372, 124, 'about', 7);
INSERT INTO `blog_media_reference` (`id`, `mediaId`, `kind`, `contentId`) VALUES (530, 128, 'essays', 20);
INSERT INTO `blog_media_reference` (`id`, `mediaId`, `kind`, `contentId`) VALUES (531, 132, 'essays', 20);
INSERT INTO `blog_media_reference` (`id`, `mediaId`, `kind`, `contentId`) VALUES (532, 133, 'essays', 20);
INSERT INTO `blog_media_reference` (`id`, `mediaId`, `kind`, `contentId`) VALUES (533, 134, 'essays', 20);
INSERT INTO `blog_media_reference` (`id`, `mediaId`, `kind`, `contentId`) VALUES (534, 135, 'essays', 20);
INSERT INTO `blog_media_reference` (`id`, `mediaId`, `kind`, `contentId`) VALUES (976, 149, 'site', 1);
COMMIT;

-- ----------------------------
-- Table structure for blog_menu
-- ----------------------------
DROP TABLE IF EXISTS `blog_menu`;
CREATE TABLE `blog_menu` (
  `id` int NOT NULL AUTO_INCREMENT,
  `parentId` int DEFAULT NULL,
  `title` varchar(100) NOT NULL,
  `path` varchar(1000) NOT NULL,
  `icon` varchar(100) NOT NULL DEFAULT '',
  `sort` int NOT NULL DEFAULT '0',
  `enabled` tinyint NOT NULL DEFAULT '1',
  `external` tinyint NOT NULL DEFAULT '0',
  `newWindow` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=49 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Records of blog_menu
-- ----------------------------
BEGIN;
INSERT INTO `blog_menu` (`id`, `parentId`, `title`, `path`, `icon`, `sort`, `enabled`, `external`, `newWindow`) VALUES (1, NULL, '首页', '/', '', 10, 0, 0, 0);
INSERT INTO `blog_menu` (`id`, `parentId`, `title`, `path`, `icon`, `sort`, `enabled`, `external`, `newWindow`) VALUES (2, NULL, '文章', '', '', 0, 1, 0, 0);
INSERT INTO `blog_menu` (`id`, `parentId`, `title`, `path`, `icon`, `sort`, `enabled`, `external`, `newWindow`) VALUES (3, 2, '分类', '/categories/', 'anzhiyu-icon-shapes', 0, 1, 0, 0);
INSERT INTO `blog_menu` (`id`, `parentId`, `title`, `path`, `icon`, `sort`, `enabled`, `external`, `newWindow`) VALUES (4, 2, '标签', '/tags/', 'anzhiyu-icon-tags', 1, 1, 0, 0);
INSERT INTO `blog_menu` (`id`, `parentId`, `title`, `path`, `icon`, `sort`, `enabled`, `external`, `newWindow`) VALUES (5, 22, '相册集', '/album/', 'anzhiyu-icon-images', 2, 1, 0, 0);
INSERT INTO `blog_menu` (`id`, `parentId`, `title`, `path`, `icon`, `sort`, `enabled`, `external`, `newWindow`) VALUES (6, 22, '追番页', '/bangumis/', 'anzhiyu-icon-bilibili', 1, 1, 0, 0);
INSERT INTO `blog_menu` (`id`, `parentId`, `title`, `path`, `icon`, `sort`, `enabled`, `external`, `newWindow`) VALUES (7, 13, '即刻短文', '/essay/', 'anzhiyu-icon-lightbulb', 1, 1, 0, 0);
INSERT INTO `blog_menu` (`id`, `parentId`, `title`, `path`, `icon`, `sort`, `enabled`, `external`, `newWindow`) VALUES (8, NULL, '友链', '', '', 1, 1, 0, 0);
INSERT INTO `blog_menu` (`id`, `parentId`, `title`, `path`, `icon`, `sort`, `enabled`, `external`, `newWindow`) VALUES (9, 8, '即刻短文', '/essay/', 'anzhiyu-icon-user-group', 1, 0, 0, 0);
INSERT INTO `blog_menu` (`id`, `parentId`, `title`, `path`, `icon`, `sort`, `enabled`, `external`, `newWindow`) VALUES (10, 22, '藏宝阁', '/collect/', 'anzhiyu-icon-book-open', 3, 1, 0, 0);
INSERT INTO `blog_menu` (`id`, `parentId`, `title`, `path`, `icon`, `sort`, `enabled`, `external`, `newWindow`) VALUES (11, 22, '音乐馆', '/music/', 'anzhiyu-icon-music', 0, 1, 0, 0);
INSERT INTO `blog_menu` (`id`, `parentId`, `title`, `path`, `icon`, `sort`, `enabled`, `external`, `newWindow`) VALUES (12, 8, '留言板', '/comments/', 'anzhiyu-icon-envelope', 0, 1, 0, 0);
INSERT INTO `blog_menu` (`id`, `parentId`, `title`, `path`, `icon`, `sort`, `enabled`, `external`, `newWindow`) VALUES (13, NULL, '关于', '', '', 3, 1, 0, 0);
INSERT INTO `blog_menu` (`id`, `parentId`, `title`, `path`, `icon`, `sort`, `enabled`, `external`, `newWindow`) VALUES (22, NULL, '我的', '', '', 2, 1, 0, 0);
INSERT INTO `blog_menu` (`id`, `parentId`, `title`, `path`, `icon`, `sort`, `enabled`, `external`, `newWindow`) VALUES (23, 13, '关于本人', '/about/', 'anzhiyu-icon-paper-plane', 0, 1, 0, 0);
INSERT INTO `blog_menu` (`id`, `parentId`, `title`, `path`, `icon`, `sort`, `enabled`, `external`, `newWindow`) VALUES (24, 13, '随便逛逛', '/random/', 'anzhiyu-icon-shoe-prints1', 2, 1, 0, 0);
COMMIT;

-- ----------------------------
-- Table structure for blog_moment
-- ----------------------------
DROP TABLE IF EXISTS `blog_moment`;
CREATE TABLE `blog_moment` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `summary` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `body` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `format` varchar(12) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'markdown',
  `cover` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `url` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `groupName` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `sort` int NOT NULL DEFAULT '0',
  `status` varchar(12) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'draft',
  `accessMode` varchar(12) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'public',
  `passwordHash` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `accessVersion` int NOT NULL DEFAULT '1',
  `parentId` int DEFAULT NULL,
  `categoryId` int DEFAULT NULL,
  `tagIds` json NOT NULL,
  `metadata` json NOT NULL,
  `authorId` int DEFAULT NULL,
  `publishedAt` datetime DEFAULT NULL,
  `createdAt` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updatedAt` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `IDX_bf53e0caf7132596ae3336217d` (`slug`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of blog_moment
-- ----------------------------
BEGIN;
INSERT INTO `blog_moment` (`id`, `title`, `slug`, `summary`, `body`, `format`, `cover`, `url`, `groupName`, `sort`, `status`, `accessMode`, `passwordHash`, `accessVersion`, `parentId`, `categoryId`, `tagIds`, `metadata`, `authorId`, `publishedAt`, `createdAt`, `updatedAt`) VALUES (6, '测试朋友圈', '6ecafc90-654f-4603-a0f5-75b4326e79ed', '12312', '123123123\n\n', 'markdown', '', '', '', 0, 'published', 'public', '', 1, NULL, NULL, '[]', '{}', 2, '2026-09-10 13:49:13', '2026-09-10 13:49:21.611183', '2026-09-10 13:49:21.611183');
COMMIT;

-- ----------------------------
-- Table structure for blog_music
-- ----------------------------
DROP TABLE IF EXISTS `blog_music`;
CREATE TABLE `blog_music` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `summary` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `body` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `format` varchar(12) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'markdown',
  `cover` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `url` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `groupName` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `sort` int NOT NULL DEFAULT '0',
  `status` varchar(12) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'draft',
  `accessMode` varchar(12) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'public',
  `passwordHash` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `accessVersion` int NOT NULL DEFAULT '1',
  `parentId` int DEFAULT NULL,
  `categoryId` int DEFAULT NULL,
  `tagIds` json NOT NULL,
  `metadata` json NOT NULL,
  `authorId` int DEFAULT NULL,
  `publishedAt` datetime DEFAULT NULL,
  `createdAt` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updatedAt` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `IDX_9806356abfb8d3ef3461fd3723` (`slug`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of blog_music
-- ----------------------------
BEGIN;
INSERT INTO `blog_music` (`id`, `title`, `slug`, `summary`, `body`, `format`, `cover`, `url`, `groupName`, `sort`, `status`, `accessMode`, `passwordHash`, `accessVersion`, `parentId`, `categoryId`, `tagIds`, `metadata`, `authorId`, `publishedAt`, `createdAt`, `updatedAt`) VALUES (5, '测试音乐', 'f933ceae-bf88-41bd-8fed-4dc5c1560932', '21312', '3123123\n\n', 'markdown', '', '', '', 0, 'published', 'public', '', 1, NULL, NULL, '[]', '{\"lyrics\": \"\"}', 2, '2026-09-10 13:50:22', '2026-09-10 13:50:33.506833', '2026-09-23 10:44:37.000000');
INSERT INTO `blog_music` (`id`, `title`, `slug`, `summary`, `body`, `format`, `cover`, `url`, `groupName`, `sort`, `status`, `accessMode`, `passwordHash`, `accessVersion`, `parentId`, `categoryId`, `tagIds`, `metadata`, `authorId`, `publishedAt`, `createdAt`, `updatedAt`) VALUES (6, '得得得', '12f9916c-5757-435c-8f13-7202076ec20e', '得得得得得', '', 'markdown', '/blog-media/105', '/blog-media/104', '', 0, 'published', 'public', '', 1, NULL, NULL, '[]', '{\"artist\": \"卢\"}', 2, '2026-09-23 10:44:42', '2026-09-22 09:11:39.117660', '2026-09-23 10:44:42.000000');
COMMIT;

-- ----------------------------
-- Table structure for blog_music_library
-- ----------------------------
DROP TABLE IF EXISTS `blog_music_library`;
CREATE TABLE `blog_music_library` (
  `id` int NOT NULL,
  `state` json NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Records of blog_music_library
-- ----------------------------
BEGIN;
INSERT INTO `blog_music_library` (`id`, `state`) VALUES (1, '{\"pending\": null, \"revision\": 2, \"snapshot\": {\"title\": \"新建歌单8\", \"source\": {\"id\": \"9766739035\", \"url\": \"https://y.qq.com/n/ryqq/playlist/9766739035\", \"provider\": \"tencent\"}, \"tracks\": [{\"id\": \"tencent:000rrgTW1BzFh6\", \"mid\": \"000rrgTW1BzFh6\", \"url\": \"\", \"album\": \"你在看孤独的风景\", \"cover\": \"https://y.gtimg.cn/music/photo_new/T002R500x500M000004YBQ4346867J.jpg\", \"lyric\": \"\", \"title\": \"你在看孤独的风景\", \"artist\": \"本兮 / 单小源\", \"duration\": 250, \"provider\": \"tencent\", \"externalUrl\": \"https://y.qq.com/n/ryqq/songDetail/000rrgTW1BzFh6\"}, {\"id\": \"tencent:0014wzyK4Ly2lD\", \"mid\": \"0014wzyK4Ly2lD\", \"url\": \"\", \"album\": \"影子小姐\", \"cover\": \"https://y.gtimg.cn/music/photo_new/T002R500x500M000004QEiMC2OK9e1.jpg\", \"lyric\": \"\", \"title\": \"影子小姐\", \"artist\": \"封茗囧菌\", \"duration\": 250, \"provider\": \"tencent\", \"externalUrl\": \"https://y.qq.com/n/ryqq/songDetail/0014wzyK4Ly2lD\"}, {\"id\": \"tencent:002lAvdY1D0Rxf\", \"mid\": \"002lAvdY1D0Rxf\", \"url\": \"\", \"album\": \"哼着你爱听的歌\", \"cover\": \"https://y.gtimg.cn/music/photo_new/T002R500x500M0000000kIJP2s5I6u.jpg\", \"lyric\": \"\", \"title\": \"哼着你爱听的歌\", \"artist\": \"杨小壮\", \"duration\": 201, \"provider\": \"tencent\", \"externalUrl\": \"https://y.qq.com/n/ryqq/songDetail/002lAvdY1D0Rxf\"}, {\"id\": \"tencent:000ifGrD2lq0w1\", \"mid\": \"000ifGrD2lq0w1\", \"url\": \"\", \"album\": \"Follow\", \"cover\": \"https://y.gtimg.cn/music/photo_new/T002R500x500M000003rRgZY4NWnKn.jpg\", \"lyric\": \"\", \"title\": \"够钟\", \"artist\": \"周柏豪\", \"duration\": 228, \"provider\": \"tencent\", \"externalUrl\": \"https://y.qq.com/n/ryqq/songDetail/000ifGrD2lq0w1\"}, {\"id\": \"tencent:000fDVjg0GRalJ\", \"mid\": \"000fDVjg0GRalJ\", \"url\": \"\", \"album\": \"WHITE\", \"cover\": \"https://y.gtimg.cn/music/photo_new/T002R500x500M000000zukkZ4SMSzY.jpg\", \"lyric\": \"\", \"title\": \"小白\", \"artist\": \"周柏豪\", \"duration\": 222, \"provider\": \"tencent\", \"externalUrl\": \"https://y.qq.com/n/ryqq/songDetail/000fDVjg0GRalJ\"}, {\"id\": \"tencent:0016dO233HjjnJ\", \"mid\": \"0016dO233HjjnJ\", \"url\": \"\", \"album\": \"须尽欢\", \"cover\": \"https://y.gtimg.cn/music/photo_new/T002R500x500M000004T2wYr3YwSJb.jpg\", \"lyric\": \"\", \"title\": \"须尽欢\", \"artist\": \"郑浩\", \"duration\": 277, \"provider\": \"tencent\", \"externalUrl\": \"https://y.qq.com/n/ryqq/songDetail/0016dO233HjjnJ\"}, {\"id\": \"tencent:003DIITP0XU3ZP\", \"mid\": \"003DIITP0XU3ZP\", \"url\": \"\", \"album\": \"梦的翅膀受了伤\", \"cover\": \"https://y.gtimg.cn/music/photo_new/T002R500x500M000000Crt8i12TzLc.jpg\", \"lyric\": \"\", \"title\": \"梦的翅膀受了伤\", \"artist\": \"蒋雪儿Snow.J\", \"duration\": 275, \"provider\": \"tencent\", \"externalUrl\": \"https://y.qq.com/n/ryqq/songDetail/003DIITP0XU3ZP\"}, {\"id\": \"tencent:002iZWSL3uulcl\", \"mid\": \"002iZWSL3uulcl\", \"url\": \"\", \"album\": \"Angela\", \"cover\": \"https://y.gtimg.cn/music/photo_new/T002R500x500M000000Tt5rH2ydSt6.jpg\", \"lyric\": \"\", \"title\": \"不只爱情\", \"artist\": \"区文诗\", \"duration\": 202, \"provider\": \"tencent\", \"externalUrl\": \"https://y.qq.com/n/ryqq/songDetail/002iZWSL3uulcl\"}, {\"id\": \"tencent:00237ukL0M4uuN\", \"mid\": \"00237ukL0M4uuN\", \"url\": \"\", \"album\": \"这世界里的你\", \"cover\": \"https://y.gtimg.cn/music/photo_new/T002R500x500M000004HVVxn3G80iF.jpg\", \"lyric\": \"\", \"title\": \"这世界里的你\", \"artist\": \"Sissie\", \"duration\": 180, \"provider\": \"tencent\", \"externalUrl\": \"https://y.qq.com/n/ryqq/songDetail/00237ukL0M4uuN\"}, {\"id\": \"tencent:001mnsWp3icfhQ\", \"mid\": \"001mnsWp3icfhQ\", \"url\": \"\", \"album\": \"试爱TT\", \"cover\": \"https://y.gtimg.cn/music/photo_new/T002R500x500M000002zWFVU0vks2B.jpg\", \"lyric\": \"\", \"title\": \"试爱TT\", \"artist\": \"菲菲公主（陆绮菲） / pro\", \"duration\": 193, \"provider\": \"tencent\", \"externalUrl\": \"https://y.qq.com/n/ryqq/songDetail/001mnsWp3icfhQ\"}, {\"id\": \"tencent:000o8yTg1tI4LH\", \"mid\": \"000o8yTg1tI4LH\", \"url\": \"\", \"album\": \"暮雨\", \"cover\": \"https://y.gtimg.cn/music/photo_new/T002R500x500M000002tezN93AkeAq.jpg\", \"lyric\": \"\", \"title\": \"暮雨\", \"artist\": \"池年\", \"duration\": 257, \"provider\": \"tencent\", \"externalUrl\": \"https://y.qq.com/n/ryqq/songDetail/000o8yTg1tI4LH\"}, {\"id\": \"tencent:001vOjDX2XQy4Z\", \"mid\": \"001vOjDX2XQy4Z\", \"url\": \"\", \"album\": \"Run Away\", \"cover\": \"https://y.gtimg.cn/music/photo_new/T002R500x500M000002SJcmZ0HgaaQ.jpg\", \"lyric\": \"\", \"title\": \"逢场作戏\", \"artist\": \"本兮\", \"duration\": 207, \"provider\": \"tencent\", \"externalUrl\": \"https://y.qq.com/n/ryqq/songDetail/001vOjDX2XQy4Z\"}, {\"id\": \"tencent:000yZzR60j5Gqh\", \"mid\": \"000yZzR60j5Gqh\", \"url\": \"\", \"album\": \"都过去吧\", \"cover\": \"https://y.gtimg.cn/music/photo_new/T002R500x500M000001YlcvJ0eGnPr.jpg\", \"lyric\": \"\", \"title\": \"都过去吧\", \"artist\": \"陈小满\", \"duration\": 196, \"provider\": \"tencent\", \"externalUrl\": \"https://y.qq.com/n/ryqq/songDetail/000yZzR60j5Gqh\"}, {\"id\": \"tencent:003TIuWr46IdCd\", \"mid\": \"003TIuWr46IdCd\", \"url\": \"\", \"album\": \"风执意远走\", \"cover\": \"https://y.gtimg.cn/music/photo_new/T002R500x500M0000004csrz2ZXAGU.jpg\", \"lyric\": \"\", \"title\": \"风执意远走\", \"artist\": \"袁kk\", \"duration\": 168, \"provider\": \"tencent\", \"externalUrl\": \"https://y.qq.com/n/ryqq/songDetail/003TIuWr46IdCd\"}, {\"id\": \"tencent:003mu4hB2Q1QEd\", \"mid\": \"003mu4hB2Q1QEd\", \"url\": \"\", \"album\": \"紫荆花盛开（原版）\", \"cover\": \"https://y.gtimg.cn/music/photo_new/T002R500x500M000000CTswi2tpAF2.jpg\", \"lyric\": \"\", \"title\": \"冬天的约定\", \"artist\": \"K.D\", \"duration\": 139, \"provider\": \"tencent\", \"externalUrl\": \"https://y.qq.com/n/ryqq/songDetail/003mu4hB2Q1QEd\"}, {\"id\": \"tencent:004coQnm1mlRRn\", \"mid\": \"004coQnm1mlRRn\", \"url\": \"\", \"album\": \"舍离去 (男女合唱版)\", \"cover\": \"https://y.gtimg.cn/music/photo_new/T002R500x500M000003jDSD02QDoXq.jpg\", \"lyric\": \"\", \"title\": \"舍离去 (男女合唱版)\", \"artist\": \"王子健 / 拂言\", \"duration\": 185, \"provider\": \"tencent\", \"externalUrl\": \"https://y.qq.com/n/ryqq/songDetail/004coQnm1mlRRn\"}, {\"id\": \"tencent:001ZyWOf0y35pX\", \"mid\": \"001ZyWOf0y35pX\", \"url\": \"\", \"album\": \"寻觅\", \"cover\": \"https://y.gtimg.cn/music/photo_new/T002R500x500M000001Jt9jr0FKx5o.jpg\", \"lyric\": \"\", \"title\": \"寻觅\", \"artist\": \"格子兮\", \"duration\": 232, \"provider\": \"tencent\", \"externalUrl\": \"https://y.qq.com/n/ryqq/songDetail/001ZyWOf0y35pX\"}, {\"id\": \"tencent:002B7pdv0j1bFz\", \"mid\": \"002B7pdv0j1bFz\", \"url\": \"\", \"album\": \"知觉钝化\", \"cover\": \"https://y.gtimg.cn/music/photo_new/T002R500x500M000002jrAr206Ioyq.jpg\", \"lyric\": \"\", \"title\": \"知觉钝化\", \"artist\": \"王子健\", \"duration\": 250, \"provider\": \"tencent\", \"externalUrl\": \"https://y.qq.com/n/ryqq/songDetail/002B7pdv0j1bFz\"}, {\"id\": \"tencent:000WwWJd4QqWdt\", \"mid\": \"000WwWJd4QqWdt\", \"url\": \"\", \"album\": \"放养\", \"cover\": \"https://y.gtimg.cn/music/photo_new/T002R500x500M000003TnF2S2BqM6a.jpg\", \"lyric\": \"\", \"title\": \"放养\", \"artist\": \"欧阳朵\", \"duration\": 255, \"provider\": \"tencent\", \"externalUrl\": \"https://y.qq.com/n/ryqq/songDetail/000WwWJd4QqWdt\"}, {\"id\": \"tencent:001FICVU3aNDQK\", \"mid\": \"001FICVU3aNDQK\", \"url\": \"\", \"album\": \"越爱越难过\", \"cover\": \"https://y.gtimg.cn/music/photo_new/T002R500x500M000003JDpDA2eIWtn.jpg\", \"lyric\": \"\", \"title\": \"越爱越难过\", \"artist\": \"夏婉安\", \"duration\": 209, \"provider\": \"tencent\", \"externalUrl\": \"https://y.qq.com/n/ryqq/songDetail/001FICVU3aNDQK\"}, {\"id\": \"tencent:001Qsakh2WQK4W\", \"mid\": \"001Qsakh2WQK4W\", \"url\": \"\", \"album\": \"红马\", \"cover\": \"https://y.gtimg.cn/music/photo_new/T002R500x500M000003xr8t90PxrrF.jpg\", \"lyric\": \"\", \"title\": \"红马\", \"artist\": \"林臻娅\", \"duration\": 197, \"provider\": \"tencent\", \"externalUrl\": \"https://y.qq.com/n/ryqq/songDetail/001Qsakh2WQK4W\"}, {\"id\": \"tencent:001a8UcJ3vBxS3\", \"mid\": \"001a8UcJ3vBxS3\", \"url\": \"\", \"album\": \"一路高飞\", \"cover\": \"https://y.gtimg.cn/music/photo_new/T002R500x500M000000D4rXU2tBaWO.jpg\", \"lyric\": \"\", \"title\": \"像羽毛一样轻\", \"artist\": \"妞妞\", \"duration\": 283, \"provider\": \"tencent\", \"externalUrl\": \"https://y.qq.com/n/ryqq/songDetail/001a8UcJ3vBxS3\"}, {\"id\": \"tencent:003ioTDF1EXY7x\", \"mid\": \"003ioTDF1EXY7x\", \"url\": \"\", \"album\": \"末日独白\", \"cover\": \"https://y.gtimg.cn/music/photo_new/T002R500x500M000000JJmIn3mVFzP.jpg\", \"lyric\": \"\", \"title\": \"末日独白\", \"artist\": \"pro / 王樾安\", \"duration\": 192, \"provider\": \"tencent\", \"externalUrl\": \"https://y.qq.com/n/ryqq/songDetail/003ioTDF1EXY7x\"}, {\"id\": \"tencent:000ulRvv0jQGwA\", \"mid\": \"000ulRvv0jQGwA\", \"url\": \"\", \"album\": \"可我们不会再见了\", \"cover\": \"https://y.gtimg.cn/music/photo_new/T002R500x500M000000RpjHR3SIKAi.jpg\", \"lyric\": \"\", \"title\": \"可我们不会再见了\", \"artist\": \"赵乃吉\", \"duration\": 160, \"provider\": \"tencent\", \"externalUrl\": \"https://y.qq.com/n/ryqq/songDetail/000ulRvv0jQGwA\"}, {\"id\": \"tencent:003dsAeg1uPaf6\", \"mid\": \"003dsAeg1uPaf6\", \"url\": \"\", \"album\": \"一宣一夏\", \"cover\": \"https://y.gtimg.cn/music/photo_new/T002R500x500M000003yzYRH2GvYxT.jpg\", \"lyric\": \"\", \"title\": \"海市蜃楼\", \"artist\": \"Vicky宣宣\", \"duration\": 288, \"provider\": \"tencent\", \"externalUrl\": \"https://y.qq.com/n/ryqq/songDetail/003dsAeg1uPaf6\"}, {\"id\": \"tencent:004H7YGF0yL3uc\", \"mid\": \"004H7YGF0yL3uc\", \"url\": \"\", \"album\": \"山色轻呢\", \"cover\": \"https://y.gtimg.cn/music/photo_new/T002R500x500M000002oRn3s2ag3Md.jpg\", \"lyric\": \"\", \"title\": \"山色轻呢\", \"artist\": \"江苹果 / 御鹿神谷\", \"duration\": 231, \"provider\": \"tencent\", \"externalUrl\": \"https://y.qq.com/n/ryqq/songDetail/004H7YGF0yL3uc\"}, {\"id\": \"tencent:004Yltom3ZTHMx\", \"mid\": \"004Yltom3ZTHMx\", \"url\": \"\", \"album\": \"你不曾爱过我\", \"cover\": \"https://y.gtimg.cn/music/photo_new/T002R500x500M00000407Ajj3wzsOs.jpg\", \"lyric\": \"\", \"title\": \"你不曾爱过我\", \"artist\": \"庄东茹\", \"duration\": 158, \"provider\": \"tencent\", \"externalUrl\": \"https://y.qq.com/n/ryqq/songDetail/004Yltom3ZTHMx\"}, {\"id\": \"tencent:004CpVzS2ugq3p\", \"mid\": \"004CpVzS2ugq3p\", \"url\": \"\", \"album\": \"忽远忽近的爱\", \"cover\": \"https://y.gtimg.cn/music/photo_new/T002R500x500M000000fUI1Q3wlUdG.jpg\", \"lyric\": \"\", \"title\": \"忽远忽近的爱\", \"artist\": \"梨笑笑\", \"duration\": 234, \"provider\": \"tencent\", \"externalUrl\": \"https://y.qq.com/n/ryqq/songDetail/004CpVzS2ugq3p\"}, {\"id\": \"tencent:000y3fdw02FoDv\", \"mid\": \"000y3fdw02FoDv\", \"url\": \"\", \"album\": \"不结\", \"cover\": \"https://y.gtimg.cn/music/photo_new/T002R500x500M0000049Yoyp1EsFIy.jpg\", \"lyric\": \"\", \"title\": \"不结\", \"artist\": \"张鑫 / 邹沛沛\", \"duration\": 239, \"provider\": \"tencent\", \"externalUrl\": \"https://y.qq.com/n/ryqq/songDetail/000y3fdw02FoDv\"}, {\"id\": \"tencent:0032oiOL24taYa\", \"mid\": \"0032oiOL24taYa\", \"url\": \"\", \"album\": \"秋叶飞过的天\", \"cover\": \"https://y.gtimg.cn/music/photo_new/T002R500x500M000003dQ8uT3tmKrW.jpg\", \"lyric\": \"\", \"title\": \"秋叶飞过的天\", \"artist\": \"卢润泽\", \"duration\": 203, \"provider\": \"tencent\", \"externalUrl\": \"https://y.qq.com/n/ryqq/songDetail/0032oiOL24taYa\"}, {\"id\": \"tencent:002e6m1D3uFpXc\", \"mid\": \"002e6m1D3uFpXc\", \"url\": \"\", \"album\": \"蔚蓝色\", \"cover\": \"https://y.gtimg.cn/music/photo_new/T002R500x500M0000031YBID2PEECw.jpg\", \"lyric\": \"\", \"title\": \"咸咸的\", \"artist\": \"纯白P / uzakin\", \"duration\": 249, \"provider\": \"tencent\", \"externalUrl\": \"https://y.qq.com/n/ryqq/songDetail/002e6m1D3uFpXc\"}, {\"id\": \"tencent:003q6H8u4WIvZc\", \"mid\": \"003q6H8u4WIvZc\", \"url\": \"\", \"album\": \"路再荒你在旁\", \"cover\": \"https://y.gtimg.cn/music/photo_new/T002R500x500M000004VyEl44Spf8l.jpg\", \"lyric\": \"\", \"title\": \"路再荒你在旁\", \"artist\": \"连诗雅\", \"duration\": 187, \"provider\": \"tencent\", \"externalUrl\": \"https://y.qq.com/n/ryqq/songDetail/003q6H8u4WIvZc\"}, {\"id\": \"tencent:004coPh71qOmKh\", \"mid\": \"004coPh71qOmKh\", \"url\": \"\", \"album\": \"中环至半山\", \"cover\": \"https://y.gtimg.cn/music/photo_new/T002R500x500M000004EblD01dCnau.jpg\", \"lyric\": \"\", \"title\": \"中环至半山\", \"artist\": \"刘莉旻 / 励志豪\", \"duration\": 204, \"provider\": \"tencent\", \"externalUrl\": \"https://y.qq.com/n/ryqq/songDetail/004coPh71qOmKh\"}, {\"id\": \"tencent:001fZnF92INqTc\", \"mid\": \"001fZnF92INqTc\", \"url\": \"\", \"album\": \"In My Head\", \"cover\": \"https://y.gtimg.cn/music/photo_new/T002R500x500M000003c6Y8R0h0KJ2.jpg\", \"lyric\": \"\", \"title\": \"In My Head (Slowed)\", \"artist\": \"MIKS\", \"duration\": 161, \"provider\": \"tencent\", \"externalUrl\": \"https://y.qq.com/n/ryqq/songDetail/001fZnF92INqTc\"}, {\"id\": \"tencent:003ycYHx0fJ1sr\", \"mid\": \"003ycYHx0fJ1sr\", \"url\": \"\", \"album\": \"第几个我\", \"cover\": \"https://y.gtimg.cn/music/photo_new/T002R500x500M000003hLubx2N3SM6.jpg\", \"lyric\": \"\", \"title\": \"第几个我\", \"artist\": \"封茗囧菌\", \"duration\": 203, \"provider\": \"tencent\", \"externalUrl\": \"https://y.qq.com/n/ryqq/songDetail/003ycYHx0fJ1sr\"}, {\"id\": \"tencent:003fzeZH3xJy1g\", \"mid\": \"003fzeZH3xJy1g\", \"url\": \"\", \"album\": \"被神明写的歌\", \"cover\": \"https://y.gtimg.cn/music/photo_new/T002R500x500M000002IQwr92lqflF.jpg\", \"lyric\": \"\", \"title\": \"被神明写的歌\", \"artist\": \"K.D\", \"duration\": 184, \"provider\": \"tencent\", \"externalUrl\": \"https://y.qq.com/n/ryqq/songDetail/003fzeZH3xJy1g\"}], \"version\": 1}, \"lastError\": \"\", \"lastAttemptAt\": \"2026-09-23T05:29:40.437Z\", \"lastSuccessAt\": \"2026-09-23T05:29:40.793Z\", \"previousSnapshot\": {\"title\": \"新建歌单8\", \"source\": {\"id\": \"9766739035\", \"url\": \"https://y.qq.com/n/ryqq/playlist/9766739035\", \"provider\": \"tencent\"}, \"tracks\": [{\"id\": \"tencent:000rrgTW1BzFh6\", \"mid\": \"000rrgTW1BzFh6\", \"url\": \"\", \"album\": \"你在看孤独的风景\", \"cover\": \"https://y.gtimg.cn/music/photo_new/T002R500x500M000004YBQ4346867J.jpg\", \"lyric\": \"\", \"title\": \"你在看孤独的风景\", \"artist\": \"本兮 / 单小源\", \"duration\": 250, \"provider\": \"tencent\", \"externalUrl\": \"https://y.qq.com/n/ryqq/songDetail/000rrgTW1BzFh6\"}, {\"id\": \"tencent:0014wzyK4Ly2lD\", \"mid\": \"0014wzyK4Ly2lD\", \"url\": \"\", \"album\": \"影子小姐\", \"cover\": \"https://y.gtimg.cn/music/photo_new/T002R500x500M000004QEiMC2OK9e1.jpg\", \"lyric\": \"\", \"title\": \"影子小姐\", \"artist\": \"封茗囧菌\", \"duration\": 250, \"provider\": \"tencent\", \"externalUrl\": \"https://y.qq.com/n/ryqq/songDetail/0014wzyK4Ly2lD\"}, {\"id\": \"tencent:002lAvdY1D0Rxf\", \"mid\": \"002lAvdY1D0Rxf\", \"url\": \"\", \"album\": \"哼着你爱听的歌\", \"cover\": \"https://y.gtimg.cn/music/photo_new/T002R500x500M0000000kIJP2s5I6u.jpg\", \"lyric\": \"\", \"title\": \"哼着你爱听的歌\", \"artist\": \"杨小壮\", \"duration\": 201, \"provider\": \"tencent\", \"externalUrl\": \"https://y.qq.com/n/ryqq/songDetail/002lAvdY1D0Rxf\"}, {\"id\": \"tencent:000ifGrD2lq0w1\", \"mid\": \"000ifGrD2lq0w1\", \"url\": \"\", \"album\": \"Follow\", \"cover\": \"https://y.gtimg.cn/music/photo_new/T002R500x500M000003rRgZY4NWnKn.jpg\", \"lyric\": \"\", \"title\": \"够钟\", \"artist\": \"周柏豪\", \"duration\": 228, \"provider\": \"tencent\", \"externalUrl\": \"https://y.qq.com/n/ryqq/songDetail/000ifGrD2lq0w1\"}, {\"id\": \"tencent:000fDVjg0GRalJ\", \"mid\": \"000fDVjg0GRalJ\", \"url\": \"\", \"album\": \"WHITE\", \"cover\": \"https://y.gtimg.cn/music/photo_new/T002R500x500M000000zukkZ4SMSzY.jpg\", \"lyric\": \"\", \"title\": \"小白\", \"artist\": \"周柏豪\", \"duration\": 222, \"provider\": \"tencent\", \"externalUrl\": \"https://y.qq.com/n/ryqq/songDetail/000fDVjg0GRalJ\"}, {\"id\": \"tencent:0016dO233HjjnJ\", \"mid\": \"0016dO233HjjnJ\", \"url\": \"\", \"album\": \"须尽欢\", \"cover\": \"https://y.gtimg.cn/music/photo_new/T002R500x500M000004T2wYr3YwSJb.jpg\", \"lyric\": \"\", \"title\": \"须尽欢\", \"artist\": \"郑浩\", \"duration\": 277, \"provider\": \"tencent\", \"externalUrl\": \"https://y.qq.com/n/ryqq/songDetail/0016dO233HjjnJ\"}, {\"id\": \"tencent:003DIITP0XU3ZP\", \"mid\": \"003DIITP0XU3ZP\", \"url\": \"\", \"album\": \"梦的翅膀受了伤\", \"cover\": \"https://y.gtimg.cn/music/photo_new/T002R500x500M000000Crt8i12TzLc.jpg\", \"lyric\": \"\", \"title\": \"梦的翅膀受了伤\", \"artist\": \"蒋雪儿Snow.J\", \"duration\": 275, \"provider\": \"tencent\", \"externalUrl\": \"https://y.qq.com/n/ryqq/songDetail/003DIITP0XU3ZP\"}, {\"id\": \"tencent:002iZWSL3uulcl\", \"mid\": \"002iZWSL3uulcl\", \"url\": \"\", \"album\": \"Angela\", \"cover\": \"https://y.gtimg.cn/music/photo_new/T002R500x500M000000Tt5rH2ydSt6.jpg\", \"lyric\": \"\", \"title\": \"不只爱情\", \"artist\": \"区文诗\", \"duration\": 202, \"provider\": \"tencent\", \"externalUrl\": \"https://y.qq.com/n/ryqq/songDetail/002iZWSL3uulcl\"}, {\"id\": \"tencent:00237ukL0M4uuN\", \"mid\": \"00237ukL0M4uuN\", \"url\": \"\", \"album\": \"这世界里的你\", \"cover\": \"https://y.gtimg.cn/music/photo_new/T002R500x500M000004HVVxn3G80iF.jpg\", \"lyric\": \"\", \"title\": \"这世界里的你\", \"artist\": \"Sissie\", \"duration\": 180, \"provider\": \"tencent\", \"externalUrl\": \"https://y.qq.com/n/ryqq/songDetail/00237ukL0M4uuN\"}, {\"id\": \"tencent:001mnsWp3icfhQ\", \"mid\": \"001mnsWp3icfhQ\", \"url\": \"\", \"album\": \"试爱TT\", \"cover\": \"https://y.gtimg.cn/music/photo_new/T002R500x500M000002zWFVU0vks2B.jpg\", \"lyric\": \"\", \"title\": \"试爱TT\", \"artist\": \"菲菲公主（陆绮菲） / pro\", \"duration\": 193, \"provider\": \"tencent\", \"externalUrl\": \"https://y.qq.com/n/ryqq/songDetail/001mnsWp3icfhQ\"}, {\"id\": \"tencent:000o8yTg1tI4LH\", \"mid\": \"000o8yTg1tI4LH\", \"url\": \"\", \"album\": \"暮雨\", \"cover\": \"https://y.gtimg.cn/music/photo_new/T002R500x500M000002tezN93AkeAq.jpg\", \"lyric\": \"\", \"title\": \"暮雨\", \"artist\": \"池年\", \"duration\": 257, \"provider\": \"tencent\", \"externalUrl\": \"https://y.qq.com/n/ryqq/songDetail/000o8yTg1tI4LH\"}, {\"id\": \"tencent:001vOjDX2XQy4Z\", \"mid\": \"001vOjDX2XQy4Z\", \"url\": \"\", \"album\": \"Run Away\", \"cover\": \"https://y.gtimg.cn/music/photo_new/T002R500x500M000002SJcmZ0HgaaQ.jpg\", \"lyric\": \"\", \"title\": \"逢场作戏\", \"artist\": \"本兮\", \"duration\": 207, \"provider\": \"tencent\", \"externalUrl\": \"https://y.qq.com/n/ryqq/songDetail/001vOjDX2XQy4Z\"}, {\"id\": \"tencent:000yZzR60j5Gqh\", \"mid\": \"000yZzR60j5Gqh\", \"url\": \"\", \"album\": \"都过去吧\", \"cover\": \"https://y.gtimg.cn/music/photo_new/T002R500x500M000001YlcvJ0eGnPr.jpg\", \"lyric\": \"\", \"title\": \"都过去吧\", \"artist\": \"陈小满\", \"duration\": 196, \"provider\": \"tencent\", \"externalUrl\": \"https://y.qq.com/n/ryqq/songDetail/000yZzR60j5Gqh\"}, {\"id\": \"tencent:003TIuWr46IdCd\", \"mid\": \"003TIuWr46IdCd\", \"url\": \"\", \"album\": \"风执意远走\", \"cover\": \"https://y.gtimg.cn/music/photo_new/T002R500x500M0000004csrz2ZXAGU.jpg\", \"lyric\": \"\", \"title\": \"风执意远走\", \"artist\": \"袁kk\", \"duration\": 168, \"provider\": \"tencent\", \"externalUrl\": \"https://y.qq.com/n/ryqq/songDetail/003TIuWr46IdCd\"}, {\"id\": \"tencent:003mu4hB2Q1QEd\", \"mid\": \"003mu4hB2Q1QEd\", \"url\": \"\", \"album\": \"紫荆花盛开（原版）\", \"cover\": \"https://y.gtimg.cn/music/photo_new/T002R500x500M000000CTswi2tpAF2.jpg\", \"lyric\": \"\", \"title\": \"冬天的约定\", \"artist\": \"K.D\", \"duration\": 139, \"provider\": \"tencent\", \"externalUrl\": \"https://y.qq.com/n/ryqq/songDetail/003mu4hB2Q1QEd\"}, {\"id\": \"tencent:004coQnm1mlRRn\", \"mid\": \"004coQnm1mlRRn\", \"url\": \"\", \"album\": \"舍离去 (男女合唱版)\", \"cover\": \"https://y.gtimg.cn/music/photo_new/T002R500x500M000003jDSD02QDoXq.jpg\", \"lyric\": \"\", \"title\": \"舍离去 (男女合唱版)\", \"artist\": \"王子健 / 拂言\", \"duration\": 185, \"provider\": \"tencent\", \"externalUrl\": \"https://y.qq.com/n/ryqq/songDetail/004coQnm1mlRRn\"}, {\"id\": \"tencent:001ZyWOf0y35pX\", \"mid\": \"001ZyWOf0y35pX\", \"url\": \"\", \"album\": \"寻觅\", \"cover\": \"https://y.gtimg.cn/music/photo_new/T002R500x500M000001Jt9jr0FKx5o.jpg\", \"lyric\": \"\", \"title\": \"寻觅\", \"artist\": \"格子兮\", \"duration\": 232, \"provider\": \"tencent\", \"externalUrl\": \"https://y.qq.com/n/ryqq/songDetail/001ZyWOf0y35pX\"}, {\"id\": \"tencent:002B7pdv0j1bFz\", \"mid\": \"002B7pdv0j1bFz\", \"url\": \"\", \"album\": \"知觉钝化\", \"cover\": \"https://y.gtimg.cn/music/photo_new/T002R500x500M000002jrAr206Ioyq.jpg\", \"lyric\": \"\", \"title\": \"知觉钝化\", \"artist\": \"王子健\", \"duration\": 250, \"provider\": \"tencent\", \"externalUrl\": \"https://y.qq.com/n/ryqq/songDetail/002B7pdv0j1bFz\"}, {\"id\": \"tencent:000WwWJd4QqWdt\", \"mid\": \"000WwWJd4QqWdt\", \"url\": \"\", \"album\": \"放养\", \"cover\": \"https://y.gtimg.cn/music/photo_new/T002R500x500M000003TnF2S2BqM6a.jpg\", \"lyric\": \"\", \"title\": \"放养\", \"artist\": \"欧阳朵\", \"duration\": 255, \"provider\": \"tencent\", \"externalUrl\": \"https://y.qq.com/n/ryqq/songDetail/000WwWJd4QqWdt\"}, {\"id\": \"tencent:001FICVU3aNDQK\", \"mid\": \"001FICVU3aNDQK\", \"url\": \"\", \"album\": \"越爱越难过\", \"cover\": \"https://y.gtimg.cn/music/photo_new/T002R500x500M000003JDpDA2eIWtn.jpg\", \"lyric\": \"\", \"title\": \"越爱越难过\", \"artist\": \"夏婉安\", \"duration\": 209, \"provider\": \"tencent\", \"externalUrl\": \"https://y.qq.com/n/ryqq/songDetail/001FICVU3aNDQK\"}, {\"id\": \"tencent:001Qsakh2WQK4W\", \"mid\": \"001Qsakh2WQK4W\", \"url\": \"\", \"album\": \"红马\", \"cover\": \"https://y.gtimg.cn/music/photo_new/T002R500x500M000003xr8t90PxrrF.jpg\", \"lyric\": \"\", \"title\": \"红马\", \"artist\": \"林臻娅\", \"duration\": 197, \"provider\": \"tencent\", \"externalUrl\": \"https://y.qq.com/n/ryqq/songDetail/001Qsakh2WQK4W\"}, {\"id\": \"tencent:001a8UcJ3vBxS3\", \"mid\": \"001a8UcJ3vBxS3\", \"url\": \"\", \"album\": \"一路高飞\", \"cover\": \"https://y.gtimg.cn/music/photo_new/T002R500x500M000000D4rXU2tBaWO.jpg\", \"lyric\": \"\", \"title\": \"像羽毛一样轻\", \"artist\": \"妞妞\", \"duration\": 283, \"provider\": \"tencent\", \"externalUrl\": \"https://y.qq.com/n/ryqq/songDetail/001a8UcJ3vBxS3\"}, {\"id\": \"tencent:003ioTDF1EXY7x\", \"mid\": \"003ioTDF1EXY7x\", \"url\": \"\", \"album\": \"末日独白\", \"cover\": \"https://y.gtimg.cn/music/photo_new/T002R500x500M000000JJmIn3mVFzP.jpg\", \"lyric\": \"\", \"title\": \"末日独白\", \"artist\": \"pro / 王樾安\", \"duration\": 192, \"provider\": \"tencent\", \"externalUrl\": \"https://y.qq.com/n/ryqq/songDetail/003ioTDF1EXY7x\"}, {\"id\": \"tencent:000ulRvv0jQGwA\", \"mid\": \"000ulRvv0jQGwA\", \"url\": \"\", \"album\": \"可我们不会再见了\", \"cover\": \"https://y.gtimg.cn/music/photo_new/T002R500x500M000000RpjHR3SIKAi.jpg\", \"lyric\": \"\", \"title\": \"可我们不会再见了\", \"artist\": \"赵乃吉\", \"duration\": 160, \"provider\": \"tencent\", \"externalUrl\": \"https://y.qq.com/n/ryqq/songDetail/000ulRvv0jQGwA\"}, {\"id\": \"tencent:003dsAeg1uPaf6\", \"mid\": \"003dsAeg1uPaf6\", \"url\": \"\", \"album\": \"一宣一夏\", \"cover\": \"https://y.gtimg.cn/music/photo_new/T002R500x500M000003yzYRH2GvYxT.jpg\", \"lyric\": \"\", \"title\": \"海市蜃楼\", \"artist\": \"Vicky宣宣\", \"duration\": 288, \"provider\": \"tencent\", \"externalUrl\": \"https://y.qq.com/n/ryqq/songDetail/003dsAeg1uPaf6\"}, {\"id\": \"tencent:004H7YGF0yL3uc\", \"mid\": \"004H7YGF0yL3uc\", \"url\": \"\", \"album\": \"山色轻呢\", \"cover\": \"https://y.gtimg.cn/music/photo_new/T002R500x500M000002oRn3s2ag3Md.jpg\", \"lyric\": \"\", \"title\": \"山色轻呢\", \"artist\": \"江苹果 / 御鹿神谷\", \"duration\": 231, \"provider\": \"tencent\", \"externalUrl\": \"https://y.qq.com/n/ryqq/songDetail/004H7YGF0yL3uc\"}, {\"id\": \"tencent:004Yltom3ZTHMx\", \"mid\": \"004Yltom3ZTHMx\", \"url\": \"\", \"album\": \"你不曾爱过我\", \"cover\": \"https://y.gtimg.cn/music/photo_new/T002R500x500M00000407Ajj3wzsOs.jpg\", \"lyric\": \"\", \"title\": \"你不曾爱过我\", \"artist\": \"庄东茹\", \"duration\": 158, \"provider\": \"tencent\", \"externalUrl\": \"https://y.qq.com/n/ryqq/songDetail/004Yltom3ZTHMx\"}, {\"id\": \"tencent:004CpVzS2ugq3p\", \"mid\": \"004CpVzS2ugq3p\", \"url\": \"\", \"album\": \"忽远忽近的爱\", \"cover\": \"https://y.gtimg.cn/music/photo_new/T002R500x500M000000fUI1Q3wlUdG.jpg\", \"lyric\": \"\", \"title\": \"忽远忽近的爱\", \"artist\": \"梨笑笑\", \"duration\": 234, \"provider\": \"tencent\", \"externalUrl\": \"https://y.qq.com/n/ryqq/songDetail/004CpVzS2ugq3p\"}, {\"id\": \"tencent:000y3fdw02FoDv\", \"mid\": \"000y3fdw02FoDv\", \"url\": \"\", \"album\": \"不结\", \"cover\": \"https://y.gtimg.cn/music/photo_new/T002R500x500M0000049Yoyp1EsFIy.jpg\", \"lyric\": \"\", \"title\": \"不结\", \"artist\": \"张鑫 / 邹沛沛\", \"duration\": 239, \"provider\": \"tencent\", \"externalUrl\": \"https://y.qq.com/n/ryqq/songDetail/000y3fdw02FoDv\"}, {\"id\": \"tencent:0032oiOL24taYa\", \"mid\": \"0032oiOL24taYa\", \"url\": \"\", \"album\": \"秋叶飞过的天\", \"cover\": \"https://y.gtimg.cn/music/photo_new/T002R500x500M000003dQ8uT3tmKrW.jpg\", \"lyric\": \"\", \"title\": \"秋叶飞过的天\", \"artist\": \"卢润泽\", \"duration\": 203, \"provider\": \"tencent\", \"externalUrl\": \"https://y.qq.com/n/ryqq/songDetail/0032oiOL24taYa\"}, {\"id\": \"tencent:002e6m1D3uFpXc\", \"mid\": \"002e6m1D3uFpXc\", \"url\": \"\", \"album\": \"蔚蓝色\", \"cover\": \"https://y.gtimg.cn/music/photo_new/T002R500x500M0000031YBID2PEECw.jpg\", \"lyric\": \"\", \"title\": \"咸咸的\", \"artist\": \"纯白P / uzakin\", \"duration\": 249, \"provider\": \"tencent\", \"externalUrl\": \"https://y.qq.com/n/ryqq/songDetail/002e6m1D3uFpXc\"}, {\"id\": \"tencent:003q6H8u4WIvZc\", \"mid\": \"003q6H8u4WIvZc\", \"url\": \"\", \"album\": \"路再荒你在旁\", \"cover\": \"https://y.gtimg.cn/music/photo_new/T002R500x500M000004VyEl44Spf8l.jpg\", \"lyric\": \"\", \"title\": \"路再荒你在旁\", \"artist\": \"连诗雅\", \"duration\": 187, \"provider\": \"tencent\", \"externalUrl\": \"https://y.qq.com/n/ryqq/songDetail/003q6H8u4WIvZc\"}, {\"id\": \"tencent:004coPh71qOmKh\", \"mid\": \"004coPh71qOmKh\", \"url\": \"\", \"album\": \"中环至半山\", \"cover\": \"https://y.gtimg.cn/music/photo_new/T002R500x500M000004EblD01dCnau.jpg\", \"lyric\": \"\", \"title\": \"中环至半山\", \"artist\": \"刘莉旻 / 励志豪\", \"duration\": 204, \"provider\": \"tencent\", \"externalUrl\": \"https://y.qq.com/n/ryqq/songDetail/004coPh71qOmKh\"}, {\"id\": \"tencent:001fZnF92INqTc\", \"mid\": \"001fZnF92INqTc\", \"url\": \"\", \"album\": \"In My Head\", \"cover\": \"https://y.gtimg.cn/music/photo_new/T002R500x500M000003c6Y8R0h0KJ2.jpg\", \"lyric\": \"\", \"title\": \"In My Head (Slowed)\", \"artist\": \"MIKS\", \"duration\": 161, \"provider\": \"tencent\", \"externalUrl\": \"https://y.qq.com/n/ryqq/songDetail/001fZnF92INqTc\"}, {\"id\": \"tencent:003ycYHx0fJ1sr\", \"mid\": \"003ycYHx0fJ1sr\", \"url\": \"\", \"album\": \"第几个我\", \"cover\": \"https://y.gtimg.cn/music/photo_new/T002R500x500M000003hLubx2N3SM6.jpg\", \"lyric\": \"\", \"title\": \"第几个我\", \"artist\": \"封茗囧菌\", \"duration\": 203, \"provider\": \"tencent\", \"externalUrl\": \"https://y.qq.com/n/ryqq/songDetail/003ycYHx0fJ1sr\"}, {\"id\": \"tencent:003fzeZH3xJy1g\", \"mid\": \"003fzeZH3xJy1g\", \"url\": \"\", \"album\": \"被神明写的歌\", \"cover\": \"https://y.gtimg.cn/music/photo_new/T002R500x500M000002IQwr92lqflF.jpg\", \"lyric\": \"\", \"title\": \"被神明写的歌\", \"artist\": \"K.D\", \"duration\": 184, \"provider\": \"tencent\", \"externalUrl\": \"https://y.qq.com/n/ryqq/songDetail/003fzeZH3xJy1g\"}], \"version\": 1}, \"consecutiveFailures\": 0}');
COMMIT;

-- ----------------------------
-- Table structure for blog_photo
-- ----------------------------
DROP TABLE IF EXISTS `blog_photo`;
CREATE TABLE `blog_photo` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `summary` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `body` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `format` varchar(12) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'markdown',
  `cover` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `url` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `groupName` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `sort` int NOT NULL DEFAULT '0',
  `status` varchar(12) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'draft',
  `accessMode` varchar(12) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'public',
  `passwordHash` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `accessVersion` int NOT NULL DEFAULT '1',
  `parentId` int DEFAULT NULL,
  `categoryId` int DEFAULT NULL,
  `tagIds` json NOT NULL,
  `metadata` json NOT NULL,
  `authorId` int DEFAULT NULL,
  `publishedAt` datetime DEFAULT NULL,
  `createdAt` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updatedAt` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `IDX_cf62da1d97ab1fa4e13c5a5272` (`slug`)
) ENGINE=InnoDB AUTO_INCREMENT=107 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of blog_photo
-- ----------------------------
BEGIN;
INSERT INTO `blog_photo` (`id`, `title`, `slug`, `summary`, `body`, `format`, `cover`, `url`, `groupName`, `sort`, `status`, `accessMode`, `passwordHash`, `accessVersion`, `parentId`, `categoryId`, `tagIds`, `metadata`, `authorId`, `publishedAt`, `createdAt`, `updatedAt`) VALUES (8, '测试图片', 'a38ae595-3195-425e-856c-094b0704c5e3', '摘要 / 说明（', '1231231\n\n\n![图片](/blog-media/27)\n', 'markdown', '/blog-media/24', '/blog-media/26', '', 0, 'published', 'public', '', 1, 9, NULL, '[]', '{\"width\": 24, \"height\": 24}', 2, '2026-09-10 13:47:13', '2026-09-10 13:47:37.751339', '2026-09-21 09:48:21.000000');
INSERT INTO `blog_photo` (`id`, `title`, `slug`, `summary`, `body`, `format`, `cover`, `url`, `groupName`, `sort`, `status`, `accessMode`, `passwordHash`, `accessVersion`, `parentId`, `categoryId`, `tagIds`, `metadata`, `authorId`, `publishedAt`, `createdAt`, `updatedAt`) VALUES (9, '760495b66551e2abf32c7a188085c7af.mp4', '57562a87-a6f6-44ac-9faa-8450a7a96479', '', '', 'markdown', '', '/blog-media/38', '', 0, 'published', 'public', '', 1, 9, NULL, '[]', '{\"mediaType\": \"video\"}', 2, '2026-09-21 16:24:16', '2026-09-21 16:24:16.195697', '2026-09-21 16:24:16.195697');
INSERT INTO `blog_photo` (`id`, `title`, `slug`, `summary`, `body`, `format`, `cover`, `url`, `groupName`, `sort`, `status`, `accessMode`, `passwordHash`, `accessVersion`, `parentId`, `categoryId`, `tagIds`, `metadata`, `authorId`, `publishedAt`, `createdAt`, `updatedAt`) VALUES (12, 'img1.jpg', 'd61295ca-0684-4d1f-8718-bda01863386b', '', '', 'markdown', '', '/blog-media/43', '', 0, 'published', 'public', '', 1, 10, NULL, '[]', '{\"mediaType\": \"image\"}', 2, '2026-09-21 16:32:34', '2026-09-21 16:32:34.585428', '2026-09-21 16:32:34.585428');
INSERT INTO `blog_photo` (`id`, `title`, `slug`, `summary`, `body`, `format`, `cover`, `url`, `groupName`, `sort`, `status`, `accessMode`, `passwordHash`, `accessVersion`, `parentId`, `categoryId`, `tagIds`, `metadata`, `authorId`, `publishedAt`, `createdAt`, `updatedAt`) VALUES (13, 'img2.jpg', 'a1bd10b4-f01c-42eb-8c05-a32b202de0d9', '', '', 'markdown', '', '/blog-media/44', '', 0, 'published', 'public', '', 1, 10, NULL, '[]', '{\"mediaType\": \"image\"}', 2, '2026-09-21 16:32:34', '2026-09-21 16:32:34.647633', '2026-09-21 16:32:34.647633');
INSERT INTO `blog_photo` (`id`, `title`, `slug`, `summary`, `body`, `format`, `cover`, `url`, `groupName`, `sort`, `status`, `accessMode`, `passwordHash`, `accessVersion`, `parentId`, `categoryId`, `tagIds`, `metadata`, `authorId`, `publishedAt`, `createdAt`, `updatedAt`) VALUES (14, 'img3.jpg', 'e3dc8a51-ef69-4ce8-ac40-481ddb009b18', '', '', 'markdown', '', '/blog-media/45', '', 0, 'published', 'public', '', 1, 10, NULL, '[]', '{\"mediaType\": \"image\"}', 2, '2026-09-21 16:32:34', '2026-09-21 16:32:34.791432', '2026-09-21 16:32:34.791432');
INSERT INTO `blog_photo` (`id`, `title`, `slug`, `summary`, `body`, `format`, `cover`, `url`, `groupName`, `sort`, `status`, `accessMode`, `passwordHash`, `accessVersion`, `parentId`, `categoryId`, `tagIds`, `metadata`, `authorId`, `publishedAt`, `createdAt`, `updatedAt`) VALUES (15, 'img4.jpg', '71510286-9d6a-4784-abc0-65505b2b7a6f', '', '', 'markdown', '', '/blog-media/46', '', 0, 'published', 'public', '', 1, 10, NULL, '[]', '{\"mediaType\": \"image\"}', 2, '2026-09-21 16:32:34', '2026-09-21 16:32:34.851357', '2026-09-21 16:32:34.851357');
INSERT INTO `blog_photo` (`id`, `title`, `slug`, `summary`, `body`, `format`, `cover`, `url`, `groupName`, `sort`, `status`, `accessMode`, `passwordHash`, `accessVersion`, `parentId`, `categoryId`, `tagIds`, `metadata`, `authorId`, `publishedAt`, `createdAt`, `updatedAt`) VALUES (16, 'img5.jpg', '2d64b9b2-5efa-4935-bb8d-68d8734b50df', '', '', 'markdown', '', '/blog-media/47', '', 0, 'published', 'public', '', 1, 10, NULL, '[]', '{\"mediaType\": \"image\"}', 2, '2026-09-21 16:32:34', '2026-09-21 16:32:34.915463', '2026-09-21 16:32:34.915463');
INSERT INTO `blog_photo` (`id`, `title`, `slug`, `summary`, `body`, `format`, `cover`, `url`, `groupName`, `sort`, `status`, `accessMode`, `passwordHash`, `accessVersion`, `parentId`, `categoryId`, `tagIds`, `metadata`, `authorId`, `publishedAt`, `createdAt`, `updatedAt`) VALUES (17, 'img6.jpg', 'e06e7bb9-c61f-42e2-b511-b53917a85d78', '', '', 'markdown', '', '/blog-media/48', '', 0, 'published', 'public', '', 1, 10, NULL, '[]', '{\"mediaType\": \"image\"}', 2, '2026-09-21 16:32:34', '2026-09-21 16:32:34.988283', '2026-09-21 16:32:34.988283');
INSERT INTO `blog_photo` (`id`, `title`, `slug`, `summary`, `body`, `format`, `cover`, `url`, `groupName`, `sort`, `status`, `accessMode`, `passwordHash`, `accessVersion`, `parentId`, `categoryId`, `tagIds`, `metadata`, `authorId`, `publishedAt`, `createdAt`, `updatedAt`) VALUES (18, 'img7.jpg', '8380d2a8-431f-41ac-bfc6-949c2420ef6f', '', '', 'markdown', '', '/blog-media/49', '', 0, 'published', 'public', '', 1, 10, NULL, '[]', '{\"mediaType\": \"image\"}', 2, '2026-09-21 16:32:35', '2026-09-21 16:32:35.106395', '2026-09-21 16:32:35.106395');
INSERT INTO `blog_photo` (`id`, `title`, `slug`, `summary`, `body`, `format`, `cover`, `url`, `groupName`, `sort`, `status`, `accessMode`, `passwordHash`, `accessVersion`, `parentId`, `categoryId`, `tagIds`, `metadata`, `authorId`, `publishedAt`, `createdAt`, `updatedAt`) VALUES (19, 'img8.jpg', '8235f568-c599-425b-b1f1-032c63d31cf9', '', '', 'markdown', '', '/blog-media/50', '', 0, 'published', 'public', '', 1, 10, NULL, '[]', '{\"mediaType\": \"image\"}', 2, '2026-09-21 16:32:35', '2026-09-21 16:32:35.185914', '2026-09-21 16:32:35.185914');
INSERT INTO `blog_photo` (`id`, `title`, `slug`, `summary`, `body`, `format`, `cover`, `url`, `groupName`, `sort`, `status`, `accessMode`, `passwordHash`, `accessVersion`, `parentId`, `categoryId`, `tagIds`, `metadata`, `authorId`, `publishedAt`, `createdAt`, `updatedAt`) VALUES (20, 'img9.jpg', '1a76550d-3c71-4277-9b8f-0bcedb1ad8cd', '', '', 'markdown', '', '/blog-media/51', '', 0, 'published', 'public', '', 1, 10, NULL, '[]', '{\"mediaType\": \"image\"}', 2, '2026-09-21 16:32:35', '2026-09-21 16:32:35.238625', '2026-09-21 16:32:35.238625');
INSERT INTO `blog_photo` (`id`, `title`, `slug`, `summary`, `body`, `format`, `cover`, `url`, `groupName`, `sort`, `status`, `accessMode`, `passwordHash`, `accessVersion`, `parentId`, `categoryId`, `tagIds`, `metadata`, `authorId`, `publishedAt`, `createdAt`, `updatedAt`) VALUES (21, 'img10.jpg', 'e4787b92-8233-4eee-8ab8-62cbe4e5b170', '', '', 'markdown', '', '/blog-media/52', '', 0, 'published', 'public', '', 1, 10, NULL, '[]', '{\"mediaType\": \"image\"}', 2, '2026-09-21 16:32:35', '2026-09-21 16:32:35.314231', '2026-09-21 16:32:35.314231');
INSERT INTO `blog_photo` (`id`, `title`, `slug`, `summary`, `body`, `format`, `cover`, `url`, `groupName`, `sort`, `status`, `accessMode`, `passwordHash`, `accessVersion`, `parentId`, `categoryId`, `tagIds`, `metadata`, `authorId`, `publishedAt`, `createdAt`, `updatedAt`) VALUES (22, 'img11.jpg', '6441a525-f72a-4c66-af1b-942b3440e967', '', '', 'markdown', '', '/blog-media/53', '', 0, 'published', 'public', '', 1, 10, NULL, '[]', '{\"mediaType\": \"image\"}', 2, '2026-09-21 16:32:35', '2026-09-21 16:32:35.456852', '2026-09-21 16:32:35.456852');
INSERT INTO `blog_photo` (`id`, `title`, `slug`, `summary`, `body`, `format`, `cover`, `url`, `groupName`, `sort`, `status`, `accessMode`, `passwordHash`, `accessVersion`, `parentId`, `categoryId`, `tagIds`, `metadata`, `authorId`, `publishedAt`, `createdAt`, `updatedAt`) VALUES (23, 'img1.jpg', '80eb69eb-bda0-4b0b-b334-90a7a010f291', '', '', 'markdown', '', '/blog-media/54', '', 0, 'published', 'public', '', 1, 11, NULL, '[]', '{\"mediaType\": \"image\"}', 2, '2026-09-21 16:33:22', '2026-09-21 16:33:22.794809', '2026-09-21 16:33:22.794809');
INSERT INTO `blog_photo` (`id`, `title`, `slug`, `summary`, `body`, `format`, `cover`, `url`, `groupName`, `sort`, `status`, `accessMode`, `passwordHash`, `accessVersion`, `parentId`, `categoryId`, `tagIds`, `metadata`, `authorId`, `publishedAt`, `createdAt`, `updatedAt`) VALUES (24, 'img2.jpg', 'c3baea93-29fd-4d37-9625-b2ef0b48e4a1', '', '', 'markdown', '', '/blog-media/55', '', 0, 'published', 'public', '', 1, 11, NULL, '[]', '{\"mediaType\": \"image\"}', 2, '2026-09-21 16:33:23', '2026-09-21 16:33:23.404312', '2026-09-21 16:33:23.404312');
INSERT INTO `blog_photo` (`id`, `title`, `slug`, `summary`, `body`, `format`, `cover`, `url`, `groupName`, `sort`, `status`, `accessMode`, `passwordHash`, `accessVersion`, `parentId`, `categoryId`, `tagIds`, `metadata`, `authorId`, `publishedAt`, `createdAt`, `updatedAt`) VALUES (25, 'img3.jpg', '1a7caad0-dd1c-456a-b989-f2283205324c', '', '', 'markdown', '', '/blog-media/56', '', 0, 'published', 'public', '', 1, 11, NULL, '[]', '{\"mediaType\": \"image\"}', 2, '2026-09-21 16:33:23', '2026-09-21 16:33:23.610483', '2026-09-21 16:33:23.610483');
INSERT INTO `blog_photo` (`id`, `title`, `slug`, `summary`, `body`, `format`, `cover`, `url`, `groupName`, `sort`, `status`, `accessMode`, `passwordHash`, `accessVersion`, `parentId`, `categoryId`, `tagIds`, `metadata`, `authorId`, `publishedAt`, `createdAt`, `updatedAt`) VALUES (26, 'img4.jpg', '6ea0e048-7aed-481c-b172-73adcce1f5c6', '', '', 'markdown', '', '/blog-media/57', '', 0, 'published', 'public', '', 1, 11, NULL, '[]', '{\"mediaType\": \"image\"}', 2, '2026-09-21 16:33:23', '2026-09-21 16:33:23.915260', '2026-09-21 16:33:23.915260');
INSERT INTO `blog_photo` (`id`, `title`, `slug`, `summary`, `body`, `format`, `cover`, `url`, `groupName`, `sort`, `status`, `accessMode`, `passwordHash`, `accessVersion`, `parentId`, `categoryId`, `tagIds`, `metadata`, `authorId`, `publishedAt`, `createdAt`, `updatedAt`) VALUES (27, 'img5.jpg', '4dab3ada-2638-4789-8482-1d75ab8c0e8d', '', '', 'markdown', '', '/blog-media/58', '', 0, 'published', 'public', '', 1, 11, NULL, '[]', '{\"mediaType\": \"image\"}', 2, '2026-09-21 16:33:25', '2026-09-21 16:33:25.449701', '2026-09-21 16:33:25.449701');
INSERT INTO `blog_photo` (`id`, `title`, `slug`, `summary`, `body`, `format`, `cover`, `url`, `groupName`, `sort`, `status`, `accessMode`, `passwordHash`, `accessVersion`, `parentId`, `categoryId`, `tagIds`, `metadata`, `authorId`, `publishedAt`, `createdAt`, `updatedAt`) VALUES (28, 'img6.jpg', '3c78f894-123f-4702-a69d-e4567f3e95cc', '', '', 'markdown', '', '/blog-media/59', '', 0, 'published', 'public', '', 1, 11, NULL, '[]', '{\"mediaType\": \"image\"}', 2, '2026-09-21 16:33:26', '2026-09-21 16:33:26.287253', '2026-09-21 16:33:26.287253');
INSERT INTO `blog_photo` (`id`, `title`, `slug`, `summary`, `body`, `format`, `cover`, `url`, `groupName`, `sort`, `status`, `accessMode`, `passwordHash`, `accessVersion`, `parentId`, `categoryId`, `tagIds`, `metadata`, `authorId`, `publishedAt`, `createdAt`, `updatedAt`) VALUES (29, 'img7.jpg', '4112d1a2-4db6-4ebd-81e5-4c5a52a3c6c9', '', '', 'markdown', '', '/blog-media/60', '', 0, 'published', 'public', '', 1, 11, NULL, '[]', '{\"mediaType\": \"image\"}', 2, '2026-09-21 16:33:26', '2026-09-21 16:33:26.362858', '2026-09-21 16:33:26.362858');
INSERT INTO `blog_photo` (`id`, `title`, `slug`, `summary`, `body`, `format`, `cover`, `url`, `groupName`, `sort`, `status`, `accessMode`, `passwordHash`, `accessVersion`, `parentId`, `categoryId`, `tagIds`, `metadata`, `authorId`, `publishedAt`, `createdAt`, `updatedAt`) VALUES (30, 'img8.jpg', '147e95ff-c049-4f81-9d41-d68e5c1b24a8', '', '', 'markdown', '', '/blog-media/61', '', 0, 'published', 'public', '', 1, 11, NULL, '[]', '{\"mediaType\": \"image\"}', 2, '2026-09-21 16:33:26', '2026-09-21 16:33:26.891847', '2026-09-21 16:33:26.891847');
INSERT INTO `blog_photo` (`id`, `title`, `slug`, `summary`, `body`, `format`, `cover`, `url`, `groupName`, `sort`, `status`, `accessMode`, `passwordHash`, `accessVersion`, `parentId`, `categoryId`, `tagIds`, `metadata`, `authorId`, `publishedAt`, `createdAt`, `updatedAt`) VALUES (31, 'img9.jpg', '4454ff27-44de-442e-baf0-d77d9f888ec7', '', '', 'markdown', '', '/blog-media/62', '', 0, 'published', 'public', '', 1, 11, NULL, '[]', '{\"mediaType\": \"image\"}', 2, '2026-09-21 16:33:27', '2026-09-21 16:33:27.031138', '2026-09-21 16:33:27.031138');
INSERT INTO `blog_photo` (`id`, `title`, `slug`, `summary`, `body`, `format`, `cover`, `url`, `groupName`, `sort`, `status`, `accessMode`, `passwordHash`, `accessVersion`, `parentId`, `categoryId`, `tagIds`, `metadata`, `authorId`, `publishedAt`, `createdAt`, `updatedAt`) VALUES (32, 'img10.jpg', 'a46b4d24-76a9-4d41-92a8-c59b761ba652', '', '', 'markdown', '', '/blog-media/63', '', 0, 'published', 'public', '', 1, 11, NULL, '[]', '{\"mediaType\": \"image\"}', 2, '2026-09-21 16:33:27', '2026-09-21 16:33:27.320268', '2026-09-21 16:33:27.320268');
INSERT INTO `blog_photo` (`id`, `title`, `slug`, `summary`, `body`, `format`, `cover`, `url`, `groupName`, `sort`, `status`, `accessMode`, `passwordHash`, `accessVersion`, `parentId`, `categoryId`, `tagIds`, `metadata`, `authorId`, `publishedAt`, `createdAt`, `updatedAt`) VALUES (33, 'img11.jpg', 'bcd41c96-fec6-43aa-945d-ee157676c9d0', '', '', 'markdown', '', '/blog-media/64', '', 0, 'published', 'public', '', 1, 11, NULL, '[]', '{\"mediaType\": \"image\"}', 2, '2026-09-21 16:33:27', '2026-09-21 16:33:27.425198', '2026-09-21 16:33:27.425198');
INSERT INTO `blog_photo` (`id`, `title`, `slug`, `summary`, `body`, `format`, `cover`, `url`, `groupName`, `sort`, `status`, `accessMode`, `passwordHash`, `accessVersion`, `parentId`, `categoryId`, `tagIds`, `metadata`, `authorId`, `publishedAt`, `createdAt`, `updatedAt`) VALUES (34, 'img12.jpg', 'fb9f0681-b4a8-4a9a-a7b5-165313eae257', '', '', 'markdown', '', '/blog-media/65', '', 0, 'published', 'public', '', 1, 11, NULL, '[]', '{\"mediaType\": \"image\"}', 2, '2026-09-21 16:33:27', '2026-09-21 16:33:27.607543', '2026-09-21 16:33:27.607543');
INSERT INTO `blog_photo` (`id`, `title`, `slug`, `summary`, `body`, `format`, `cover`, `url`, `groupName`, `sort`, `status`, `accessMode`, `passwordHash`, `accessVersion`, `parentId`, `categoryId`, `tagIds`, `metadata`, `authorId`, `publishedAt`, `createdAt`, `updatedAt`) VALUES (35, 'img13.jpg', 'cf0a1f03-e76a-458d-8187-62e5c90b3740', '', '', 'markdown', '', '/blog-media/66', '', 0, 'published', 'public', '', 1, 11, NULL, '[]', '{\"mediaType\": \"image\"}', 2, '2026-09-21 16:33:27', '2026-09-21 16:33:27.741828', '2026-09-21 16:33:27.741828');
INSERT INTO `blog_photo` (`id`, `title`, `slug`, `summary`, `body`, `format`, `cover`, `url`, `groupName`, `sort`, `status`, `accessMode`, `passwordHash`, `accessVersion`, `parentId`, `categoryId`, `tagIds`, `metadata`, `authorId`, `publishedAt`, `createdAt`, `updatedAt`) VALUES (36, 'img1.jpg', '48cd1fbc-326a-4a1d-b0dd-77564e496bda', '', '', 'markdown', '', '/blog-media/67', '', 0, 'published', 'public', '', 1, 12, NULL, '[]', '{\"mediaType\": \"image\"}', 2, '2026-09-21 16:34:30', '2026-09-21 16:34:30.842111', '2026-09-21 16:34:30.842111');
INSERT INTO `blog_photo` (`id`, `title`, `slug`, `summary`, `body`, `format`, `cover`, `url`, `groupName`, `sort`, `status`, `accessMode`, `passwordHash`, `accessVersion`, `parentId`, `categoryId`, `tagIds`, `metadata`, `authorId`, `publishedAt`, `createdAt`, `updatedAt`) VALUES (37, 'img2.jpg', '26d36b95-f904-45c0-9ec7-dcb19ec62cd7', '', '', 'markdown', '', '/blog-media/68', '', 0, 'published', 'public', '', 1, 12, NULL, '[]', '{\"mediaType\": \"image\"}', 2, '2026-09-21 16:34:31', '2026-09-21 16:34:31.032086', '2026-09-21 16:34:31.032086');
INSERT INTO `blog_photo` (`id`, `title`, `slug`, `summary`, `body`, `format`, `cover`, `url`, `groupName`, `sort`, `status`, `accessMode`, `passwordHash`, `accessVersion`, `parentId`, `categoryId`, `tagIds`, `metadata`, `authorId`, `publishedAt`, `createdAt`, `updatedAt`) VALUES (38, 'img3.jpg', '1fc81139-3c5b-4ea1-8b91-ff6ae04a3155', '', '', 'markdown', '', '/blog-media/69', '', 0, 'published', 'public', '', 1, 12, NULL, '[]', '{\"mediaType\": \"image\"}', 2, '2026-09-21 16:34:31', '2026-09-21 16:34:31.100221', '2026-09-21 16:34:31.100221');
INSERT INTO `blog_photo` (`id`, `title`, `slug`, `summary`, `body`, `format`, `cover`, `url`, `groupName`, `sort`, `status`, `accessMode`, `passwordHash`, `accessVersion`, `parentId`, `categoryId`, `tagIds`, `metadata`, `authorId`, `publishedAt`, `createdAt`, `updatedAt`) VALUES (39, 'img4.jpg', '8a12f7c9-7f93-46a8-be3b-1f4fcba1ecad', '', '', 'markdown', '', '/blog-media/70', '', 0, 'published', 'public', '', 1, 12, NULL, '[]', '{\"mediaType\": \"image\"}', 2, '2026-09-21 16:34:31', '2026-09-21 16:34:31.152828', '2026-09-21 16:34:31.152828');
INSERT INTO `blog_photo` (`id`, `title`, `slug`, `summary`, `body`, `format`, `cover`, `url`, `groupName`, `sort`, `status`, `accessMode`, `passwordHash`, `accessVersion`, `parentId`, `categoryId`, `tagIds`, `metadata`, `authorId`, `publishedAt`, `createdAt`, `updatedAt`) VALUES (40, 'img5.jpg', '5e1f0162-3b6c-4506-af79-91fbb64ce9f6', '', '', 'markdown', '', '/blog-media/71', '', 0, 'published', 'public', '', 1, 12, NULL, '[]', '{\"mediaType\": \"image\"}', 2, '2026-09-21 16:34:31', '2026-09-21 16:34:31.290326', '2026-09-21 16:34:31.290326');
INSERT INTO `blog_photo` (`id`, `title`, `slug`, `summary`, `body`, `format`, `cover`, `url`, `groupName`, `sort`, `status`, `accessMode`, `passwordHash`, `accessVersion`, `parentId`, `categoryId`, `tagIds`, `metadata`, `authorId`, `publishedAt`, `createdAt`, `updatedAt`) VALUES (41, 'img6.jpg', '03d9ccd2-1b6c-418a-9f23-04636ebf1fb1', '', '', 'markdown', '', '/blog-media/72', '', 0, 'published', 'public', '', 1, 12, NULL, '[]', '{\"mediaType\": \"image\"}', 2, '2026-09-21 16:34:31', '2026-09-21 16:34:31.369839', '2026-09-21 16:34:31.369839');
INSERT INTO `blog_photo` (`id`, `title`, `slug`, `summary`, `body`, `format`, `cover`, `url`, `groupName`, `sort`, `status`, `accessMode`, `passwordHash`, `accessVersion`, `parentId`, `categoryId`, `tagIds`, `metadata`, `authorId`, `publishedAt`, `createdAt`, `updatedAt`) VALUES (42, 'img7.jpg', 'a91ae009-0bc4-429f-aaa2-2fe1cbadb176', '', '', 'markdown', '', '/blog-media/73', '', 0, 'published', 'public', '', 1, 12, NULL, '[]', '{\"mediaType\": \"image\"}', 2, '2026-09-21 16:34:31', '2026-09-21 16:34:31.466183', '2026-09-21 16:34:31.466183');
INSERT INTO `blog_photo` (`id`, `title`, `slug`, `summary`, `body`, `format`, `cover`, `url`, `groupName`, `sort`, `status`, `accessMode`, `passwordHash`, `accessVersion`, `parentId`, `categoryId`, `tagIds`, `metadata`, `authorId`, `publishedAt`, `createdAt`, `updatedAt`) VALUES (43, 'img8.jpg', 'ed582ca3-85cf-40e9-a79c-5491f73af7a7', '', '', 'markdown', '', '/blog-media/74', '', 0, 'published', 'public', '', 1, 12, NULL, '[]', '{\"mediaType\": \"image\"}', 2, '2026-09-21 16:34:32', '2026-09-21 16:34:32.143341', '2026-09-21 16:34:32.143341');
INSERT INTO `blog_photo` (`id`, `title`, `slug`, `summary`, `body`, `format`, `cover`, `url`, `groupName`, `sort`, `status`, `accessMode`, `passwordHash`, `accessVersion`, `parentId`, `categoryId`, `tagIds`, `metadata`, `authorId`, `publishedAt`, `createdAt`, `updatedAt`) VALUES (44, 'img9.jpg', 'b7ac0d5d-7eef-4ccb-8a22-f96f17823f03', '', '', 'markdown', '', '/blog-media/75', '', 0, 'published', 'public', '', 1, 12, NULL, '[]', '{\"mediaType\": \"image\"}', 2, '2026-09-21 16:34:32', '2026-09-21 16:34:32.194114', '2026-09-21 16:34:32.194114');
INSERT INTO `blog_photo` (`id`, `title`, `slug`, `summary`, `body`, `format`, `cover`, `url`, `groupName`, `sort`, `status`, `accessMode`, `passwordHash`, `accessVersion`, `parentId`, `categoryId`, `tagIds`, `metadata`, `authorId`, `publishedAt`, `createdAt`, `updatedAt`) VALUES (45, 'img10.jpg', '49bb2a74-adf2-4be7-b90d-d28afdc7c6d4', '', '', 'markdown', '', '/blog-media/76', '', 0, 'published', 'public', '', 1, 12, NULL, '[]', '{\"mediaType\": \"image\"}', 2, '2026-09-21 16:34:32', '2026-09-21 16:34:32.259146', '2026-09-21 16:34:32.259146');
INSERT INTO `blog_photo` (`id`, `title`, `slug`, `summary`, `body`, `format`, `cover`, `url`, `groupName`, `sort`, `status`, `accessMode`, `passwordHash`, `accessVersion`, `parentId`, `categoryId`, `tagIds`, `metadata`, `authorId`, `publishedAt`, `createdAt`, `updatedAt`) VALUES (46, 'img11.jpg', '0485fe6a-96b1-4bbf-b769-50aa2423ebea', '', '', 'markdown', '', '/blog-media/77', '', 0, 'published', 'public', '', 1, 12, NULL, '[]', '{\"mediaType\": \"image\"}', 2, '2026-09-21 16:34:32', '2026-09-21 16:34:32.310436', '2026-09-21 16:34:32.310436');
INSERT INTO `blog_photo` (`id`, `title`, `slug`, `summary`, `body`, `format`, `cover`, `url`, `groupName`, `sort`, `status`, `accessMode`, `passwordHash`, `accessVersion`, `parentId`, `categoryId`, `tagIds`, `metadata`, `authorId`, `publishedAt`, `createdAt`, `updatedAt`) VALUES (47, 'img12.jpg', '63bfa172-7928-434f-accd-3116ee328c7b', '', '', 'markdown', '', '/blog-media/78', '', 0, 'published', 'public', '', 1, 12, NULL, '[]', '{\"mediaType\": \"image\"}', 2, '2026-09-21 16:34:32', '2026-09-21 16:34:32.378669', '2026-09-21 16:34:32.378669');
INSERT INTO `blog_photo` (`id`, `title`, `slug`, `summary`, `body`, `format`, `cover`, `url`, `groupName`, `sort`, `status`, `accessMode`, `passwordHash`, `accessVersion`, `parentId`, `categoryId`, `tagIds`, `metadata`, `authorId`, `publishedAt`, `createdAt`, `updatedAt`) VALUES (48, 'img13.jpg', 'da6584b0-03da-47ce-8319-d2ab30972e20', '', '', 'markdown', '', '/blog-media/79', '', 0, 'published', 'public', '', 1, 12, NULL, '[]', '{\"mediaType\": \"image\"}', 2, '2026-09-21 16:34:32', '2026-09-21 16:34:32.456862', '2026-09-21 16:34:32.456862');
INSERT INTO `blog_photo` (`id`, `title`, `slug`, `summary`, `body`, `format`, `cover`, `url`, `groupName`, `sort`, `status`, `accessMode`, `passwordHash`, `accessVersion`, `parentId`, `categoryId`, `tagIds`, `metadata`, `authorId`, `publishedAt`, `createdAt`, `updatedAt`) VALUES (49, 'çå¿§ä¼¤ï¼æ¼«ï¼.jpg', '5e1ce795-820b-4258-a73d-bfffed545fb6', '', '', 'markdown', '', '/blog-media/80', '', 0, 'published', 'public', '', 1, 10, NULL, '[]', '{\"mediaType\": \"image\"}', 2, '2026-09-21 17:27:05', '2026-09-21 17:27:05.335142', '2026-09-21 17:27:05.335142');
INSERT INTO `blog_photo` (`id`, `title`, `slug`, `summary`, `body`, `format`, `cover`, `url`, `groupName`, `sort`, `status`, `accessMode`, `passwordHash`, `accessVersion`, `parentId`, `categoryId`, `tagIds`, `metadata`, `authorId`, `publishedAt`, `createdAt`, `updatedAt`) VALUES (50, 'ç»ç­-ç­ç±105Â°çä½ (èå).mp4', 'ded374c4-411e-4139-9def-9ab4fd46efa8', '', '', 'markdown', '', '/blog-media/81', '', 0, 'published', 'public', '', 1, 10, NULL, '[]', '{\"mediaType\": \"video\"}', 2, '2026-09-21 17:27:06', '2026-09-21 17:27:06.037995', '2026-09-21 17:27:06.037995');
INSERT INTO `blog_photo` (`id`, `title`, `slug`, `summary`, `body`, `format`, `cover`, `url`, `groupName`, `sort`, `status`, `accessMode`, `passwordHash`, `accessVersion`, `parentId`, `categoryId`, `tagIds`, `metadata`, `authorId`, `publishedAt`, `createdAt`, `updatedAt`) VALUES (51, 'æ°çå¿§ä¼¤ï¼æ¼«ï¼.jpg', '89826db9-8057-4bb3-8226-2e490dd5db00', '', '', 'markdown', '', '/blog-media/82', '', 0, 'published', 'public', '', 1, 10, NULL, '[]', '{\"mediaType\": \"image\"}', 2, '2026-09-21 17:27:06', '2026-09-21 17:27:06.103770', '2026-09-21 17:27:06.103770');
INSERT INTO `blog_photo` (`id`, `title`, `slug`, `summary`, `body`, `format`, `cover`, `url`, `groupName`, `sort`, `status`, `accessMode`, `passwordHash`, `accessVersion`, `parentId`, `categoryId`, `tagIds`, `metadata`, `authorId`, `publishedAt`, `createdAt`, `updatedAt`) VALUES (52, 'æ°çå¿§ä¼¤ï¼äººï¼.jpg', 'ada540ef-5732-4435-853d-918a01749556', '', '', 'markdown', '', '/blog-media/83', '', 0, 'published', 'public', '', 1, 10, NULL, '[]', '{\"mediaType\": \"image\"}', 2, '2026-09-21 17:27:06', '2026-09-21 17:27:06.164596', '2026-09-21 17:27:06.164596');
INSERT INTO `blog_photo` (`id`, `title`, `slug`, `summary`, `body`, `format`, `cover`, `url`, `groupName`, `sort`, `status`, `accessMode`, `passwordHash`, `accessVersion`, `parentId`, `categoryId`, `tagIds`, `metadata`, `authorId`, `publishedAt`, `createdAt`, `updatedAt`) VALUES (53, 'å¾®ä¿¡å¾ç_20201112103431.jpg', '8ed1cbd8-b1ac-4de0-b121-4599a0ab5b22', '', '', 'markdown', '', '/blog-media/84', '', 0, 'published', 'public', '', 1, 10, NULL, '[]', '{\"mediaType\": \"image\"}', 2, '2026-09-21 17:27:06', '2026-09-21 17:27:06.208792', '2026-09-21 17:27:06.208792');
INSERT INTO `blog_photo` (`id`, `title`, `slug`, `summary`, `body`, `format`, `cover`, `url`, `groupName`, `sort`, `status`, `accessMode`, `passwordHash`, `accessVersion`, `parentId`, `categoryId`, `tagIds`, `metadata`, `authorId`, `publishedAt`, `createdAt`, `updatedAt`) VALUES (54, 'å¾®ä¿¡å¾ç_20201125084331.jpg', '8834cdaa-905e-40e5-98f0-0b363caa3824', '', '', 'markdown', '', '/blog-media/85', '', 0, 'published', 'public', '', 1, 10, NULL, '[]', '{\"mediaType\": \"image\"}', 2, '2026-09-21 17:27:06', '2026-09-21 17:27:06.253188', '2026-09-21 17:27:06.253188');
INSERT INTO `blog_photo` (`id`, `title`, `slug`, `summary`, `body`, `format`, `cover`, `url`, `groupName`, `sort`, `status`, `accessMode`, `passwordHash`, `accessVersion`, `parentId`, `categoryId`, `tagIds`, `metadata`, `authorId`, `publishedAt`, `createdAt`, `updatedAt`) VALUES (55, 'å¾®ä¿¡å¾ç_20201201145036.jpg', '281e3a82-1c85-4aca-b88b-06309abaec20', '', '', 'markdown', '', '/blog-media/86', '', 0, 'published', 'public', '', 1, 10, NULL, '[]', '{\"mediaType\": \"image\"}', 2, '2026-09-21 17:27:06', '2026-09-21 17:27:06.532039', '2026-09-21 17:27:06.532039');
INSERT INTO `blog_photo` (`id`, `title`, `slug`, `summary`, `body`, `format`, `cover`, `url`, `groupName`, `sort`, `status`, `accessMode`, `passwordHash`, `accessVersion`, `parentId`, `categoryId`, `tagIds`, `metadata`, `authorId`, `publishedAt`, `createdAt`, `updatedAt`) VALUES (56, 'å¾®ä¿¡å¾ç_20201214130342.jpg', '1d639867-3682-4d96-ad2b-cd59149704a1', '', '', 'markdown', '', '/blog-media/87', '', 0, 'published', 'public', '', 1, 10, NULL, '[]', '{\"mediaType\": \"image\"}', 2, '2026-09-21 17:27:06', '2026-09-21 17:27:06.652086', '2026-09-21 17:27:06.652086');
INSERT INTO `blog_photo` (`id`, `title`, `slug`, `summary`, `body`, `format`, `cover`, `url`, `groupName`, `sort`, `status`, `accessMode`, `passwordHash`, `accessVersion`, `parentId`, `categoryId`, `tagIds`, `metadata`, `authorId`, `publishedAt`, `createdAt`, `updatedAt`) VALUES (57, 'å¾®ä¿¡å¾ç_20211115193158.png', '5b4e1433-3a85-4df7-9c24-51f9673c9baa', '', '', 'markdown', '', '/blog-media/88', '', 0, 'published', 'public', '', 1, 10, NULL, '[]', '{\"mediaType\": \"image\"}', 2, '2026-09-21 17:27:06', '2026-09-21 17:27:06.785012', '2026-09-21 17:27:06.785012');
INSERT INTO `blog_photo` (`id`, `title`, `slug`, `summary`, `body`, `format`, `cover`, `url`, `groupName`, `sort`, `status`, `accessMode`, `passwordHash`, `accessVersion`, `parentId`, `categoryId`, `tagIds`, `metadata`, `authorId`, `publishedAt`, `createdAt`, `updatedAt`) VALUES (58, 'ä¸è½½.png', '26f13784-bbac-4782-9b85-e68fd9b1e6a6', '', '', 'markdown', '', '/blog-media/89', '', 0, 'published', 'public', '', 1, 10, NULL, '[]', '{\"mediaType\": \"image\"}', 2, '2026-09-21 17:27:06', '2026-09-21 17:27:06.920981', '2026-09-21 17:27:06.920981');
INSERT INTO `blog_photo` (`id`, `title`, `slug`, `summary`, `body`, `format`, `cover`, `url`, `groupName`, `sort`, `status`, `accessMode`, `passwordHash`, `accessVersion`, `parentId`, `categoryId`, `tagIds`, `metadata`, `authorId`, `publishedAt`, `createdAt`, `updatedAt`) VALUES (59, 'å®å®æç©º.jpg', 'ccd193a5-3a1e-40d8-8332-31b95bda161a', '', '', 'markdown', '', '/blog-media/90', '', 0, 'published', 'public', '', 1, 10, NULL, '[]', '{\"mediaType\": \"image\"}', 2, '2026-09-21 17:27:07', '2026-09-21 17:27:07.726157', '2026-09-21 17:27:07.726157');
INSERT INTO `blog_photo` (`id`, `title`, `slug`, `summary`, `body`, `format`, `cover`, `url`, `groupName`, `sort`, `status`, `accessMode`, `passwordHash`, `accessVersion`, `parentId`, `categoryId`, `tagIds`, `metadata`, `authorId`, `publishedAt`, `createdAt`, `updatedAt`) VALUES (60, 'c8c1bd59f552b149202800e354041535.mp4', '616f2f60-b922-4f4f-97d3-5e40d98b848b', '', '', 'markdown', '', '/blog-media/91', '', 0, 'published', 'public', '', 1, 10, NULL, '[]', '{\"mediaType\": \"video\"}', 2, '2026-09-21 17:27:07', '2026-09-21 17:27:07.878284', '2026-09-21 17:27:07.878284');
INSERT INTO `blog_photo` (`id`, `title`, `slug`, `summary`, `body`, `format`, `cover`, `url`, `groupName`, `sort`, `status`, `accessMode`, `passwordHash`, `accessVersion`, `parentId`, `categoryId`, `tagIds`, `metadata`, `authorId`, `publishedAt`, `createdAt`, `updatedAt`) VALUES (61, 'cy.png', '2805836a-97d3-4ac7-86d8-4d3aed87cacb', '', '', 'markdown', '', '/blog-media/92', '', 0, 'published', 'public', '', 1, 10, NULL, '[]', '{\"mediaType\": \"image\"}', 2, '2026-09-21 17:27:07', '2026-09-21 17:27:07.945263', '2026-09-21 17:27:07.945263');
INSERT INTO `blog_photo` (`id`, `title`, `slug`, `summary`, `body`, `format`, `cover`, `url`, `groupName`, `sort`, `status`, `accessMode`, `passwordHash`, `accessVersion`, `parentId`, `categoryId`, `tagIds`, `metadata`, `authorId`, `publishedAt`, `createdAt`, `updatedAt`) VALUES (62, 'IMG_0006.JPG', 'bda4bebd-7837-452b-9a15-0a4ef6281e6f', '', '', 'markdown', '', '/blog-media/93', '', 0, 'published', 'public', '', 1, 10, NULL, '[]', '{\"mediaType\": \"image\"}', 2, '2026-09-21 17:27:08', '2026-09-21 17:27:08.029381', '2026-09-21 17:27:08.029381');
INSERT INTO `blog_photo` (`id`, `title`, `slug`, `summary`, `body`, `format`, `cover`, `url`, `groupName`, `sort`, `status`, `accessMode`, `passwordHash`, `accessVersion`, `parentId`, `categoryId`, `tagIds`, `metadata`, `authorId`, `publishedAt`, `createdAt`, `updatedAt`) VALUES (63, 'IMG_0007.JPG', 'c7bce1ec-9dca-4ded-8787-2ab22deb2aa3', '', '', 'markdown', '', '/blog-media/94', '', 0, 'published', 'public', '', 1, 10, NULL, '[]', '{\"mediaType\": \"image\"}', 2, '2026-09-21 17:27:08', '2026-09-21 17:27:08.098426', '2026-09-21 17:27:08.098426');
INSERT INTO `blog_photo` (`id`, `title`, `slug`, `summary`, `body`, `format`, `cover`, `url`, `groupName`, `sort`, `status`, `accessMode`, `passwordHash`, `accessVersion`, `parentId`, `categoryId`, `tagIds`, `metadata`, `authorId`, `publishedAt`, `createdAt`, `updatedAt`) VALUES (64, 'IMG_0008.JPG', '3f729b73-70a1-4156-adcb-01ec5dca6092', '', '', 'markdown', '', '/blog-media/95', '', 0, 'published', 'public', '', 1, 10, NULL, '[]', '{\"mediaType\": \"image\"}', 2, '2026-09-21 17:27:08', '2026-09-21 17:27:08.380842', '2026-09-21 17:27:08.380842');
INSERT INTO `blog_photo` (`id`, `title`, `slug`, `summary`, `body`, `format`, `cover`, `url`, `groupName`, `sort`, `status`, `accessMode`, `passwordHash`, `accessVersion`, `parentId`, `categoryId`, `tagIds`, `metadata`, `authorId`, `publishedAt`, `createdAt`, `updatedAt`) VALUES (65, 'IMG_0058.JPG', '35d8ba9a-3e5e-47b1-b6a5-7e9b3360a348', '', '', 'markdown', '', '/blog-media/96', '', 0, 'published', 'public', '', 1, 10, NULL, '[]', '{\"mediaType\": \"image\"}', 2, '2026-09-21 17:27:08', '2026-09-21 17:27:08.457773', '2026-09-21 17:27:08.457773');
INSERT INTO `blog_photo` (`id`, `title`, `slug`, `summary`, `body`, `format`, `cover`, `url`, `groupName`, `sort`, `status`, `accessMode`, `passwordHash`, `accessVersion`, `parentId`, `categoryId`, `tagIds`, `metadata`, `authorId`, `publishedAt`, `createdAt`, `updatedAt`) VALUES (66, 'IMG_0289.JPG', 'd824800f-826a-4dfe-883a-d7e317d5b6c6', '', '', 'markdown', '', '/blog-media/97', '', 0, 'published', 'public', '', 1, 10, NULL, '[]', '{\"mediaType\": \"image\"}', 2, '2026-09-21 17:27:08', '2026-09-21 17:27:08.636360', '2026-09-21 17:27:08.636360');
INSERT INTO `blog_photo` (`id`, `title`, `slug`, `summary`, `body`, `format`, `cover`, `url`, `groupName`, `sort`, `status`, `accessMode`, `passwordHash`, `accessVersion`, `parentId`, `categoryId`, `tagIds`, `metadata`, `authorId`, `publishedAt`, `createdAt`, `updatedAt`) VALUES (67, 'IMG_0430.JPG', '26d2e52c-a116-4234-b46b-dfc584a1096a', '', '', 'markdown', '', '/blog-media/98', '', 0, 'published', 'public', '', 1, 10, NULL, '[]', '{\"mediaType\": \"image\"}', 2, '2026-09-21 17:27:08', '2026-09-21 17:27:08.837954', '2026-09-21 17:27:08.837954');
INSERT INTO `blog_photo` (`id`, `title`, `slug`, `summary`, `body`, `format`, `cover`, `url`, `groupName`, `sort`, `status`, `accessMode`, `passwordHash`, `accessVersion`, `parentId`, `categoryId`, `tagIds`, `metadata`, `authorId`, `publishedAt`, `createdAt`, `updatedAt`) VALUES (68, 'IMG_1598.JPG', '69a5f193-8f62-4aa2-96f6-873d9cca3933', '', '', 'markdown', '', '/blog-media/99', '', 0, 'published', 'public', '', 1, 10, NULL, '[]', '{\"mediaType\": \"image\"}', 2, '2026-09-21 17:27:08', '2026-09-21 17:27:08.898912', '2026-09-21 17:27:08.898912');
INSERT INTO `blog_photo` (`id`, `title`, `slug`, `summary`, `body`, `format`, `cover`, `url`, `groupName`, `sort`, `status`, `accessMode`, `passwordHash`, `accessVersion`, `parentId`, `categoryId`, `tagIds`, `metadata`, `authorId`, `publishedAt`, `createdAt`, `updatedAt`) VALUES (69, 'IMG_1765.PNG', 'd7685b24-29eb-4bf8-9f13-204db9e75725', '', '', 'markdown', '', '/blog-media/100', '', 0, 'published', 'public', '', 1, 10, NULL, '[]', '{\"mediaType\": \"image\"}', 2, '2026-09-21 17:27:08', '2026-09-21 17:27:08.993941', '2026-09-21 17:27:08.993941');
INSERT INTO `blog_photo` (`id`, `title`, `slug`, `summary`, `body`, `format`, `cover`, `url`, `groupName`, `sort`, `status`, `accessMode`, `passwordHash`, `accessVersion`, `parentId`, `categoryId`, `tagIds`, `metadata`, `authorId`, `publishedAt`, `createdAt`, `updatedAt`) VALUES (70, 'psc11.jpg', '349d903a-3352-40b8-98e2-62851c0761cc', '', '', 'markdown', '', '/blog-media/101', '', 0, 'published', 'public', '', 1, 10, NULL, '[]', '{\"mediaType\": \"image\"}', 2, '2026-09-21 17:27:09', '2026-09-21 17:27:09.082633', '2026-09-21 17:27:09.082633');
COMMIT;

-- ----------------------------
-- Table structure for blog_site
-- ----------------------------
DROP TABLE IF EXISTS `blog_site`;
CREATE TABLE `blog_site` (
  `id` int NOT NULL AUTO_INCREMENT,
  `settings` json NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Records of blog_site
-- ----------------------------
BEGIN;
INSERT INTO `blog_site` (`id`, `settings`) VALUES (1, '{\"icp\": \"这是备案号\", \"logo\": \"/blog-media/6\", \"title\": \"TOM的日常\", \"avatar\": \"/blog-media/7\", \"socials\": [{\"url\": \"https://www.baidu.com\", \"label\": \"qq\"}], \"subtitle\": \"副标题\", \"heroImage\": \"/blog-media/11\", \"heroTitle\": \"介绍卡片标题\", \"homeCards\": [{\"url\": \"\", \"image\": \"/blog-media/12\", \"title\": \"卡片标题\", \"description\": \"卡片说明\"}, {\"url\": \"\", \"image\": \"/blog-media/30\", \"title\": \"卡片标题1\", \"description\": \"卡片说明1\"}], \"showAside\": true, \"showMusic\": true, \"startDate\": \"2026-09-08T16:00:00.000Z\", \"essayCover\": \"\", \"essayTitle\": \"咸鱼的日常生活。\", \"footerText\": \"这是页脚文字\", \"description\": \"这是站点描述\", \"homeHeroFit\": \"cover\", \"pageHeaders\": {\"music\": {\"cover\": \"/blog-media/149\", \"title\": \"\", \"enabled\": true, \"subtitle\": \"\"}, \"essays\": {\"cover\": \"\", \"title\": \"咸鱼的日常生活。\", \"enabled\": true, \"subtitle\": \"随时随地，分享生活\"}, \"bangumis\": {\"cover\": \"\", \"title\": \"\", \"enabled\": true, \"subtitle\": \"\"}}, \"announcement\": \"这是公告\", \"defaultTheme\": \"system\", \"heroSubtitle\": \"介绍卡片副标题\", \"essaySubtitle\": \"随时随地，分享生活\", \"homeHeroTitle\": \"大屏标题\", \"effectsEnabled\": true, \"homeHeroRandom\": true, \"homeHeroSlides\": [{\"type\": \"video\", \"image\": \"/blog-media/19\", \"mobileImage\": \"\"}, {\"image\": \"/blog-media/16\", \"mobileImage\": \"\"}, {\"image\": \"/blog-media/17\", \"mobileImage\": \"\"}, {\"image\": \"/blog-media/18\", \"mobileImage\": \"\"}], \"articlePageSize\": 8, \"homeHeroEnabled\": true, \"homeHeroOverlay\": 25, \"homeHeroAutoplay\": true, \"homeHeroInterval\": 8, \"homeHeroParallax\": true, \"homeHeroPosition\": \"center\", \"homeHeroSubtitle\": \"大屏副标题\", \"restrictedMediaValidationEnabled\": false}');
COMMIT;

-- ----------------------------
-- Table structure for blog_tag
-- ----------------------------
DROP TABLE IF EXISTS `blog_tag`;
CREATE TABLE `blog_tag` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `summary` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `body` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `format` varchar(12) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'markdown',
  `cover` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `url` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `groupName` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `sort` int NOT NULL DEFAULT '0',
  `status` varchar(12) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'draft',
  `accessMode` varchar(12) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'public',
  `passwordHash` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `accessVersion` int NOT NULL DEFAULT '1',
  `parentId` int DEFAULT NULL,
  `categoryId` int DEFAULT NULL,
  `tagIds` json NOT NULL,
  `metadata` json NOT NULL,
  `authorId` int DEFAULT NULL,
  `publishedAt` datetime DEFAULT NULL,
  `createdAt` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updatedAt` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `IDX_4872314a8f9a4159e1fa234eea` (`slug`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of blog_tag
-- ----------------------------
BEGIN;
INSERT INTO `blog_tag` (`id`, `title`, `slug`, `summary`, `body`, `format`, `cover`, `url`, `groupName`, `sort`, `status`, `accessMode`, `passwordHash`, `accessVersion`, `parentId`, `categoryId`, `tagIds`, `metadata`, `authorId`, `publishedAt`, `createdAt`, `updatedAt`) VALUES (7, '测试标签', '76cb9f5b-d9e8-4be7-96f9-fbfc9d279a13', '测试标签', '', 'markdown', '/blog-media/28', '', '', 0, 'published', 'public', '', 1, NULL, NULL, '[]', '{\"color\": \"rgba(0, 0, 0, 1)\"}', 1, '2026-09-09 13:46:49', '2026-09-09 13:47:01.991490', '2026-09-21 11:24:19.000000');
INSERT INTO `blog_tag` (`id`, `title`, `slug`, `summary`, `body`, `format`, `cover`, `url`, `groupName`, `sort`, `status`, `accessMode`, `passwordHash`, `accessVersion`, `parentId`, `categoryId`, `tagIds`, `metadata`, `authorId`, `publishedAt`, `createdAt`, `updatedAt`) VALUES (8, '测试标签1', '41506813-c06e-4b11-9789-ab0b577f1226', '测试标签1摘要 / 说明', '', 'markdown', '/blog-media/29', '', '', 0, 'published', 'public', '', 1, NULL, NULL, '[]', '{\"color\": \"rgba(255, 0, 174, 1)\"}', 2, '2026-09-21 11:09:54', '2026-09-21 11:09:48.785505', '2026-09-21 11:09:54.000000');
COMMIT;

-- ----------------------------
-- Table structure for sys_captcha_log
-- ----------------------------
DROP TABLE IF EXISTS `sys_captcha_log`;
CREATE TABLE `sys_captcha_log` (
  `id` int NOT NULL AUTO_INCREMENT,
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  `account` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '账号',
  `code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '验证码',
  `provider` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '验证码提供商',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=95 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of sys_captcha_log
-- ----------------------------
BEGIN;
INSERT INTO `sys_captcha_log` (`id`, `created_at`, `updated_at`, `account`, `code`, `provider`) VALUES (1, '2026-09-08 11:28:23.749858', '2026-09-08 11:28:23.749858', '', 'h6Ls', 'captcha');
INSERT INTO `sys_captcha_log` (`id`, `created_at`, `updated_at`, `account`, `code`, `provider`) VALUES (2, '2026-09-08 11:28:23.921184', '2026-09-08 11:28:23.921184', '', 'y9Kr', 'captcha');
INSERT INTO `sys_captcha_log` (`id`, `created_at`, `updated_at`, `account`, `code`, `provider`) VALUES (3, '2026-09-08 11:59:29.923601', '2026-09-08 11:59:29.923601', '', 'rI3Q', 'captcha');
INSERT INTO `sys_captcha_log` (`id`, `created_at`, `updated_at`, `account`, `code`, `provider`) VALUES (4, '2026-09-08 11:59:30.097630', '2026-09-08 11:59:30.097630', '', 'tUJy', 'captcha');
INSERT INTO `sys_captcha_log` (`id`, `created_at`, `updated_at`, `account`, `code`, `provider`) VALUES (5, '2026-09-08 13:39:12.932360', '2026-09-08 13:39:12.932360', '', '3xYF', 'captcha');
INSERT INTO `sys_captcha_log` (`id`, `created_at`, `updated_at`, `account`, `code`, `provider`) VALUES (6, '2026-09-08 13:39:13.113696', '2026-09-08 13:39:13.113696', '', 'gkwh', 'captcha');
INSERT INTO `sys_captcha_log` (`id`, `created_at`, `updated_at`, `account`, `code`, `provider`) VALUES (7, '2026-09-08 13:44:07.577118', '2026-09-08 13:44:07.577118', '', '4VwM', 'captcha');
INSERT INTO `sys_captcha_log` (`id`, `created_at`, `updated_at`, `account`, `code`, `provider`) VALUES (8, '2026-09-08 13:44:07.769324', '2026-09-08 13:44:07.769324', '', 'qcuc', 'captcha');
INSERT INTO `sys_captcha_log` (`id`, `created_at`, `updated_at`, `account`, `code`, `provider`) VALUES (9, '2026-09-08 13:45:27.635037', '2026-09-08 13:45:27.635037', '', '6wuH', 'captcha');
INSERT INTO `sys_captcha_log` (`id`, `created_at`, `updated_at`, `account`, `code`, `provider`) VALUES (10, '2026-09-08 13:45:27.783857', '2026-09-08 13:45:27.783857', '', 'IDHe', 'captcha');
INSERT INTO `sys_captcha_log` (`id`, `created_at`, `updated_at`, `account`, `code`, `provider`) VALUES (11, '2026-09-08 13:45:27.907340', '2026-09-08 13:45:27.907340', '', '55ve', 'captcha');
INSERT INTO `sys_captcha_log` (`id`, `created_at`, `updated_at`, `account`, `code`, `provider`) VALUES (12, '2026-09-08 14:02:29.620884', '2026-09-08 14:02:29.620884', '', 'TRcp', 'captcha');
INSERT INTO `sys_captcha_log` (`id`, `created_at`, `updated_at`, `account`, `code`, `provider`) VALUES (13, '2026-09-08 14:02:29.820282', '2026-09-08 14:02:29.820282', '', 'kT9J', 'captcha');
INSERT INTO `sys_captcha_log` (`id`, `created_at`, `updated_at`, `account`, `code`, `provider`) VALUES (14, '2026-09-08 14:02:29.937249', '2026-09-08 14:02:29.937249', '', 'daCW', 'captcha');
INSERT INTO `sys_captcha_log` (`id`, `created_at`, `updated_at`, `account`, `code`, `provider`) VALUES (15, '2026-09-08 14:11:34.858997', '2026-09-08 14:11:34.858997', '', 'q33r', 'captcha');
INSERT INTO `sys_captcha_log` (`id`, `created_at`, `updated_at`, `account`, `code`, `provider`) VALUES (16, '2026-09-08 14:11:35.052672', '2026-09-08 14:11:35.052672', '', 'WsK7', 'captcha');
INSERT INTO `sys_captcha_log` (`id`, `created_at`, `updated_at`, `account`, `code`, `provider`) VALUES (17, '2026-09-08 14:11:35.167975', '2026-09-08 14:11:35.167975', '', 'CbOT', 'captcha');
INSERT INTO `sys_captcha_log` (`id`, `created_at`, `updated_at`, `account`, `code`, `provider`) VALUES (18, '2026-09-08 14:12:30.347107', '2026-09-08 14:12:30.347107', '', 'OITc', 'captcha');
INSERT INTO `sys_captcha_log` (`id`, `created_at`, `updated_at`, `account`, `code`, `provider`) VALUES (19, '2026-09-08 14:12:30.508810', '2026-09-08 14:12:30.508810', '', '9jjV', 'captcha');
INSERT INTO `sys_captcha_log` (`id`, `created_at`, `updated_at`, `account`, `code`, `provider`) VALUES (20, '2026-09-08 14:12:30.631515', '2026-09-08 14:12:30.631515', '', '9I8y', 'captcha');
INSERT INTO `sys_captcha_log` (`id`, `created_at`, `updated_at`, `account`, `code`, `provider`) VALUES (21, '2026-09-09 13:49:40.427579', '2026-09-09 13:49:40.427579', '', 'bSc3', 'captcha');
INSERT INTO `sys_captcha_log` (`id`, `created_at`, `updated_at`, `account`, `code`, `provider`) VALUES (22, '2026-09-09 13:49:40.437943', '2026-09-09 13:49:40.437943', '', 'MfYZ', 'captcha');
INSERT INTO `sys_captcha_log` (`id`, `created_at`, `updated_at`, `account`, `code`, `provider`) VALUES (23, '2026-09-20 18:24:43.411444', '2026-09-20 18:24:43.411444', '', 'EXkN', 'captcha');
INSERT INTO `sys_captcha_log` (`id`, `created_at`, `updated_at`, `account`, `code`, `provider`) VALUES (24, '2026-09-20 18:24:43.472525', '2026-09-20 18:24:43.472525', '', 'huzj', 'captcha');
INSERT INTO `sys_captcha_log` (`id`, `created_at`, `updated_at`, `account`, `code`, `provider`) VALUES (25, '2026-09-20 18:25:03.993004', '2026-09-20 18:25:03.993004', '', 'vLah', 'captcha');
INSERT INTO `sys_captcha_log` (`id`, `created_at`, `updated_at`, `account`, `code`, `provider`) VALUES (26, '2026-09-20 18:25:04.024618', '2026-09-20 18:25:04.024618', '', 'WB6R', 'captcha');
INSERT INTO `sys_captcha_log` (`id`, `created_at`, `updated_at`, `account`, `code`, `provider`) VALUES (27, '2026-09-20 18:25:12.106610', '2026-09-20 18:25:12.106610', '', 'DHbu', 'captcha');
INSERT INTO `sys_captcha_log` (`id`, `created_at`, `updated_at`, `account`, `code`, `provider`) VALUES (28, '2026-09-21 15:48:15.201923', '2026-09-21 15:48:15.201923', '', 'UNVr', 'captcha');
INSERT INTO `sys_captcha_log` (`id`, `created_at`, `updated_at`, `account`, `code`, `provider`) VALUES (29, '2026-09-21 15:48:15.388565', '2026-09-21 15:48:15.388565', '', '4EWS', 'captcha');
INSERT INTO `sys_captcha_log` (`id`, `created_at`, `updated_at`, `account`, `code`, `provider`) VALUES (30, '2026-09-21 16:02:42.385554', '2026-09-21 16:02:42.385554', '', '2NvV', 'captcha');
INSERT INTO `sys_captcha_log` (`id`, `created_at`, `updated_at`, `account`, `code`, `provider`) VALUES (31, '2026-09-21 16:02:42.551176', '2026-09-21 16:02:42.551176', '', 'ugue', 'captcha');
INSERT INTO `sys_captcha_log` (`id`, `created_at`, `updated_at`, `account`, `code`, `provider`) VALUES (32, '2026-09-21 16:26:36.436610', '2026-09-21 16:26:36.436610', '', 'kIsU', 'captcha');
INSERT INTO `sys_captcha_log` (`id`, `created_at`, `updated_at`, `account`, `code`, `provider`) VALUES (33, '2026-09-21 16:26:36.600902', '2026-09-21 16:26:36.600902', '', '5asx', 'captcha');
INSERT INTO `sys_captcha_log` (`id`, `created_at`, `updated_at`, `account`, `code`, `provider`) VALUES (34, '2026-09-21 16:26:36.956996', '2026-09-21 16:26:36.956996', '', 'UV3q', 'captcha');
INSERT INTO `sys_captcha_log` (`id`, `created_at`, `updated_at`, `account`, `code`, `provider`) VALUES (35, '2026-09-22 11:04:02.314560', '2026-09-22 11:04:02.314560', '', 'UnGB', 'captcha');
INSERT INTO `sys_captcha_log` (`id`, `created_at`, `updated_at`, `account`, `code`, `provider`) VALUES (36, '2026-09-22 11:04:02.471337', '2026-09-22 11:04:02.471337', '', 'MsP8', 'captcha');
INSERT INTO `sys_captcha_log` (`id`, `created_at`, `updated_at`, `account`, `code`, `provider`) VALUES (37, '2026-09-22 11:04:02.583845', '2026-09-22 11:04:02.583845', '', 'qOVS', 'captcha');
INSERT INTO `sys_captcha_log` (`id`, `created_at`, `updated_at`, `account`, `code`, `provider`) VALUES (38, '2026-09-22 14:43:44.126745', '2026-09-22 14:43:44.126745', '', '6fVB', 'captcha');
INSERT INTO `sys_captcha_log` (`id`, `created_at`, `updated_at`, `account`, `code`, `provider`) VALUES (39, '2026-09-22 14:43:44.335447', '2026-09-22 14:43:44.335447', '', 'r3bc', 'captcha');
INSERT INTO `sys_captcha_log` (`id`, `created_at`, `updated_at`, `account`, `code`, `provider`) VALUES (40, '2026-09-22 14:43:44.452536', '2026-09-22 14:43:44.452536', '', 'Xf2T', 'captcha');
INSERT INTO `sys_captcha_log` (`id`, `created_at`, `updated_at`, `account`, `code`, `provider`) VALUES (41, '2026-09-22 15:17:32.641014', '2026-09-22 15:17:32.641014', '', 'KXXx', 'captcha');
INSERT INTO `sys_captcha_log` (`id`, `created_at`, `updated_at`, `account`, `code`, `provider`) VALUES (42, '2026-09-22 15:17:32.813574', '2026-09-22 15:17:32.813574', '', 'sRra', 'captcha');
INSERT INTO `sys_captcha_log` (`id`, `created_at`, `updated_at`, `account`, `code`, `provider`) VALUES (43, '2026-09-22 15:17:32.917987', '2026-09-22 15:17:32.917987', '', 'tsrY', 'captcha');
INSERT INTO `sys_captcha_log` (`id`, `created_at`, `updated_at`, `account`, `code`, `provider`) VALUES (44, '2026-09-22 15:29:17.307887', '2026-09-22 15:29:17.307887', '', 'fnG2', 'captcha');
INSERT INTO `sys_captcha_log` (`id`, `created_at`, `updated_at`, `account`, `code`, `provider`) VALUES (45, '2026-09-22 15:29:17.487093', '2026-09-22 15:29:17.487093', '', 'uwcG', 'captcha');
INSERT INTO `sys_captcha_log` (`id`, `created_at`, `updated_at`, `account`, `code`, `provider`) VALUES (46, '2026-09-22 15:29:17.599763', '2026-09-22 15:29:17.599763', '', 'MsOW', 'captcha');
INSERT INTO `sys_captcha_log` (`id`, `created_at`, `updated_at`, `account`, `code`, `provider`) VALUES (47, '2026-09-22 16:03:08.236959', '2026-09-22 16:03:08.236959', '', 'R67z', 'captcha');
INSERT INTO `sys_captcha_log` (`id`, `created_at`, `updated_at`, `account`, `code`, `provider`) VALUES (48, '2026-09-22 16:03:08.449722', '2026-09-22 16:03:08.449722', '', 'ReA2', 'captcha');
INSERT INTO `sys_captcha_log` (`id`, `created_at`, `updated_at`, `account`, `code`, `provider`) VALUES (49, '2026-09-22 16:03:08.558070', '2026-09-22 16:03:08.558070', '', 'DPZY', 'captcha');
INSERT INTO `sys_captcha_log` (`id`, `created_at`, `updated_at`, `account`, `code`, `provider`) VALUES (50, '2026-09-22 16:26:53.954754', '2026-09-22 16:26:53.954754', '', 'DxhI', 'captcha');
INSERT INTO `sys_captcha_log` (`id`, `created_at`, `updated_at`, `account`, `code`, `provider`) VALUES (51, '2026-09-22 16:26:54.108364', '2026-09-22 16:26:54.108364', '', 'usjx', 'captcha');
INSERT INTO `sys_captcha_log` (`id`, `created_at`, `updated_at`, `account`, `code`, `provider`) VALUES (52, '2026-09-22 16:26:54.214239', '2026-09-22 16:26:54.214239', '', 'IGHz', 'captcha');
INSERT INTO `sys_captcha_log` (`id`, `created_at`, `updated_at`, `account`, `code`, `provider`) VALUES (53, '2026-09-22 16:39:45.485106', '2026-09-22 16:39:45.485106', '', 'xgHr', 'captcha');
INSERT INTO `sys_captcha_log` (`id`, `created_at`, `updated_at`, `account`, `code`, `provider`) VALUES (54, '2026-09-22 16:39:45.482759', '2026-09-22 16:39:45.482759', '', 'Yafp', 'captcha');
INSERT INTO `sys_captcha_log` (`id`, `created_at`, `updated_at`, `account`, `code`, `provider`) VALUES (55, '2026-09-22 17:13:49.639883', '2026-09-22 17:13:49.639883', '', 'ztUp', 'captcha');
INSERT INTO `sys_captcha_log` (`id`, `created_at`, `updated_at`, `account`, `code`, `provider`) VALUES (56, '2026-09-22 17:13:49.858241', '2026-09-22 17:13:49.858241', '', 'exJ6', 'captcha');
INSERT INTO `sys_captcha_log` (`id`, `created_at`, `updated_at`, `account`, `code`, `provider`) VALUES (57, '2026-09-22 17:13:49.990749', '2026-09-22 17:13:49.990749', '', 'bkfh', 'captcha');
INSERT INTO `sys_captcha_log` (`id`, `created_at`, `updated_at`, `account`, `code`, `provider`) VALUES (58, '2026-09-22 17:15:40.358112', '2026-09-22 17:15:40.358112', '', 'r2bc', 'captcha');
INSERT INTO `sys_captcha_log` (`id`, `created_at`, `updated_at`, `account`, `code`, `provider`) VALUES (59, '2026-09-22 17:15:40.618672', '2026-09-22 17:15:40.618672', '', 'FJXG', 'captcha');
INSERT INTO `sys_captcha_log` (`id`, `created_at`, `updated_at`, `account`, `code`, `provider`) VALUES (60, '2026-09-22 17:15:40.768782', '2026-09-22 17:15:40.768782', '', 'ftz4', 'captcha');
INSERT INTO `sys_captcha_log` (`id`, `created_at`, `updated_at`, `account`, `code`, `provider`) VALUES (61, '2026-09-22 17:21:17.501880', '2026-09-22 17:21:17.501880', '', 'fjEz', 'captcha');
INSERT INTO `sys_captcha_log` (`id`, `created_at`, `updated_at`, `account`, `code`, `provider`) VALUES (62, '2026-09-22 17:21:17.912886', '2026-09-22 17:21:17.912886', '', 's8sj', 'captcha');
INSERT INTO `sys_captcha_log` (`id`, `created_at`, `updated_at`, `account`, `code`, `provider`) VALUES (63, '2026-09-22 17:21:18.122271', '2026-09-22 17:21:18.122271', '', 'apUv', 'captcha');
INSERT INTO `sys_captcha_log` (`id`, `created_at`, `updated_at`, `account`, `code`, `provider`) VALUES (64, '2026-09-22 17:21:47.496800', '2026-09-22 17:21:47.496800', '', 'PqXL', 'captcha');
INSERT INTO `sys_captcha_log` (`id`, `created_at`, `updated_at`, `account`, `code`, `provider`) VALUES (65, '2026-09-22 17:21:47.748676', '2026-09-22 17:21:47.748676', '', 'BLvk', 'captcha');
INSERT INTO `sys_captcha_log` (`id`, `created_at`, `updated_at`, `account`, `code`, `provider`) VALUES (66, '2026-09-22 17:23:23.918898', '2026-09-22 17:23:23.918898', '', 'MFer', 'captcha');
INSERT INTO `sys_captcha_log` (`id`, `created_at`, `updated_at`, `account`, `code`, `provider`) VALUES (67, '2026-09-22 17:23:24.086192', '2026-09-22 17:23:24.086192', '', 'RkdW', 'captcha');
INSERT INTO `sys_captcha_log` (`id`, `created_at`, `updated_at`, `account`, `code`, `provider`) VALUES (68, '2026-09-22 17:23:24.211125', '2026-09-22 17:23:24.211125', '', '3RMs', 'captcha');
INSERT INTO `sys_captcha_log` (`id`, `created_at`, `updated_at`, `account`, `code`, `provider`) VALUES (69, '2026-09-22 17:24:50.625528', '2026-09-22 17:24:50.625528', '', 'hrdS', 'captcha');
INSERT INTO `sys_captcha_log` (`id`, `created_at`, `updated_at`, `account`, `code`, `provider`) VALUES (70, '2026-09-22 17:24:50.839329', '2026-09-22 17:24:50.839329', '', 'Ha76', 'captcha');
INSERT INTO `sys_captcha_log` (`id`, `created_at`, `updated_at`, `account`, `code`, `provider`) VALUES (71, '2026-09-22 17:24:50.971492', '2026-09-22 17:24:50.971492', '', 'HHGk', 'captcha');
INSERT INTO `sys_captcha_log` (`id`, `created_at`, `updated_at`, `account`, `code`, `provider`) VALUES (72, '2026-09-22 17:26:12.144594', '2026-09-22 17:26:12.144594', '', 'veDz', 'captcha');
INSERT INTO `sys_captcha_log` (`id`, `created_at`, `updated_at`, `account`, `code`, `provider`) VALUES (73, '2026-09-22 17:26:13.068381', '2026-09-22 17:26:13.068381', '', '5UfK', 'captcha');
INSERT INTO `sys_captcha_log` (`id`, `created_at`, `updated_at`, `account`, `code`, `provider`) VALUES (74, '2026-09-22 17:26:13.605083', '2026-09-22 17:26:13.605083', '', 'qhhC', 'captcha');
INSERT INTO `sys_captcha_log` (`id`, `created_at`, `updated_at`, `account`, `code`, `provider`) VALUES (75, '2026-09-22 17:31:31.618074', '2026-09-22 17:31:31.618074', '', 'dYwg', 'captcha');
INSERT INTO `sys_captcha_log` (`id`, `created_at`, `updated_at`, `account`, `code`, `provider`) VALUES (76, '2026-09-22 17:31:31.832327', '2026-09-22 17:31:31.832327', '', 'xfgJ', 'captcha');
INSERT INTO `sys_captcha_log` (`id`, `created_at`, `updated_at`, `account`, `code`, `provider`) VALUES (77, '2026-09-22 17:31:31.955329', '2026-09-22 17:31:31.955329', '', 'JINA', 'captcha');
INSERT INTO `sys_captcha_log` (`id`, `created_at`, `updated_at`, `account`, `code`, `provider`) VALUES (78, '2026-09-22 18:16:48.790771', '2026-09-22 18:16:48.790771', '', 'w7jH', 'captcha');
INSERT INTO `sys_captcha_log` (`id`, `created_at`, `updated_at`, `account`, `code`, `provider`) VALUES (79, '2026-09-22 18:16:49.290127', '2026-09-22 18:16:49.290127', '', 'a5k5', 'captcha');
INSERT INTO `sys_captcha_log` (`id`, `created_at`, `updated_at`, `account`, `code`, `provider`) VALUES (80, '2026-09-22 18:16:49.663336', '2026-09-22 18:16:49.663336', '', '4ZWy', 'captcha');
INSERT INTO `sys_captcha_log` (`id`, `created_at`, `updated_at`, `account`, `code`, `provider`) VALUES (81, '2026-09-22 18:18:06.159534', '2026-09-22 18:18:06.159534', '', 'b3fs', 'captcha');
INSERT INTO `sys_captcha_log` (`id`, `created_at`, `updated_at`, `account`, `code`, `provider`) VALUES (82, '2026-09-22 18:18:06.416946', '2026-09-22 18:18:06.416946', '', 'snMd', 'captcha');
INSERT INTO `sys_captcha_log` (`id`, `created_at`, `updated_at`, `account`, `code`, `provider`) VALUES (83, '2026-09-22 18:18:06.585942', '2026-09-22 18:18:06.585942', '', 'wsK2', 'captcha');
INSERT INTO `sys_captcha_log` (`id`, `created_at`, `updated_at`, `account`, `code`, `provider`) VALUES (84, '2026-09-22 18:19:11.819520', '2026-09-22 18:19:11.819520', '', 'Kj9G', 'captcha');
INSERT INTO `sys_captcha_log` (`id`, `created_at`, `updated_at`, `account`, `code`, `provider`) VALUES (85, '2026-09-22 18:19:12.063107', '2026-09-22 18:19:12.063107', '', 'InH4', 'captcha');
INSERT INTO `sys_captcha_log` (`id`, `created_at`, `updated_at`, `account`, `code`, `provider`) VALUES (86, '2026-09-22 18:19:12.306403', '2026-09-22 18:19:12.306403', '', 'IJEt', 'captcha');
INSERT INTO `sys_captcha_log` (`id`, `created_at`, `updated_at`, `account`, `code`, `provider`) VALUES (87, '2026-09-22 18:23:06.347436', '2026-09-22 18:23:06.347436', '', 'k5LA', 'captcha');
INSERT INTO `sys_captcha_log` (`id`, `created_at`, `updated_at`, `account`, `code`, `provider`) VALUES (88, '2026-09-22 18:23:06.577768', '2026-09-22 18:23:06.577768', '', 'abhO', 'captcha');
INSERT INTO `sys_captcha_log` (`id`, `created_at`, `updated_at`, `account`, `code`, `provider`) VALUES (89, '2026-09-22 18:23:06.709409', '2026-09-22 18:23:06.709409', '', 'kugS', 'captcha');
INSERT INTO `sys_captcha_log` (`id`, `created_at`, `updated_at`, `account`, `code`, `provider`) VALUES (90, '2026-09-22 18:24:42.063817', '2026-09-22 18:24:42.063817', '', 'CdkL', 'captcha');
INSERT INTO `sys_captcha_log` (`id`, `created_at`, `updated_at`, `account`, `code`, `provider`) VALUES (91, '2026-09-22 18:24:42.263614', '2026-09-22 18:24:42.263614', '', 'rnSC', 'captcha');
INSERT INTO `sys_captcha_log` (`id`, `created_at`, `updated_at`, `account`, `code`, `provider`) VALUES (92, '2026-09-22 18:24:42.405740', '2026-09-22 18:24:42.405740', '', 'Ln5r', 'captcha');
INSERT INTO `sys_captcha_log` (`id`, `created_at`, `updated_at`, `account`, `code`, `provider`) VALUES (93, '2026-09-23 10:22:29.634839', '2026-09-23 10:22:29.634839', '', 'zeDB', 'captcha');
INSERT INTO `sys_captcha_log` (`id`, `created_at`, `updated_at`, `account`, `code`, `provider`) VALUES (94, '2026-09-23 10:22:29.658583', '2026-09-23 10:22:29.658583', '', '3Gf4', 'captcha');
COMMIT;

-- ----------------------------
-- Table structure for sys_dept
-- ----------------------------
DROP TABLE IF EXISTS `sys_dept`;
CREATE TABLE `sys_dept` (
  `id` int NOT NULL AUTO_INCREMENT,
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '部门名称',
  `order` int DEFAULT '0' COMMENT '排序',
  `default` tinyint NOT NULL DEFAULT '0' COMMENT '是否系统默认部门',
  `mpath` varchar(255) DEFAULT '',
  `parentId` int DEFAULT NULL,
  `created_by` int DEFAULT NULL COMMENT '创建人',
  `updated_by` int DEFAULT NULL COMMENT '修改者',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `FK_c75280b01c49779f2323536db67` (`parentId`),
  CONSTRAINT `FK_c75280b01c49779f2323536db67` FOREIGN KEY (`parentId`) REFERENCES `sys_dept` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of sys_dept
-- ----------------------------
BEGIN;
INSERT INTO `sys_dept` (`id`, `created_at`, `updated_at`, `name`, `order`, `default`, `mpath`, `parentId`, `created_by`, `updated_by`) VALUES (1, '2025-04-09 16:37:40.000000', '2025-04-09 16:37:40.000000', '华北', 1, 0, '1.', NULL, 1, 1);
INSERT INTO `sys_dept` (`id`, `created_at`, `updated_at`, `name`, `order`, `default`, `mpath`, `parentId`, `created_by`, `updated_by`) VALUES (2, '2025-04-09 16:37:40.000000', '2025-04-09 16:37:40.000000', '运维', 1, 0, '4.2.', 4, NULL, NULL);
INSERT INTO `sys_dept` (`id`, `created_at`, `updated_at`, `name`, `order`, `default`, `mpath`, `parentId`, `created_by`, `updated_by`) VALUES (3, '2025-04-09 16:37:40.000000', '2025-04-09 16:37:40.000000', '研发部', 1, 0, '1.3.', 1, NULL, 1);
INSERT INTO `sys_dept` (`id`, `created_at`, `updated_at`, `name`, `order`, `default`, `mpath`, `parentId`, `created_by`, `updated_by`) VALUES (4, '2025-04-09 16:37:40.000000', '2025-04-09 16:37:40.000000', '华南', 2, 0, '4.', NULL, NULL, NULL);
INSERT INTO `sys_dept` (`id`, `created_at`, `updated_at`, `name`, `order`, `default`, `mpath`, `parentId`, `created_by`, `updated_by`) VALUES (10, '2025-04-13 11:05:58.621259', '2025-04-13 11:05:58.621259', '外部', 3, 1, '10.', NULL, 1, 1);
COMMIT;

-- ----------------------------
-- Table structure for sys_dict_item
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict_item`;
CREATE TABLE `sys_dict_item` (
  `id` int NOT NULL AUTO_INCREMENT,
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  `label` varchar(50) NOT NULL,
  `value` varchar(50) NOT NULL,
  `order` int DEFAULT NULL COMMENT '字典项排序',
  `status` tinyint NOT NULL DEFAULT '1',
  `remark` varchar(255) DEFAULT NULL,
  `type_id` int DEFAULT NULL,
  `created_by` int DEFAULT NULL COMMENT '创建人',
  `updated_by` int DEFAULT NULL COMMENT '修改者',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of sys_dict_item
-- ----------------------------
BEGIN;
INSERT INTO `sys_dict_item` (`id`, `created_at`, `updated_at`, `label`, `value`, `order`, `status`, `remark`, `type_id`, `created_by`, `updated_by`) VALUES (1, '2025-04-09 16:37:40.000000', '2025-04-09 16:37:40.000000', '启用', '1', 1, 1, '', 1, NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `created_at`, `updated_at`, `label`, `value`, `order`, `status`, `remark`, `type_id`, `created_by`, `updated_by`) VALUES (5, '2025-04-12 12:07:59.379001', '2025-04-12 12:07:59.379001', '禁用', '0', 2, 1, '', 1, NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `created_at`, `updated_at`, `label`, `value`, `order`, `status`, `remark`, `type_id`, `created_by`, `updated_by`) VALUES (6, '2025-04-12 12:09:35.907445', '2025-04-12 12:09:35.907445', '男', '1', 1, 1, '', 2, NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `created_at`, `updated_at`, `label`, `value`, `order`, `status`, `remark`, `type_id`, `created_by`, `updated_by`) VALUES (7, '2025-04-12 12:09:55.402096', '2025-04-12 12:09:55.402096', '女', '0', 2, 1, '', 2, NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `created_at`, `updated_at`, `label`, `value`, `order`, `status`, `remark`, `type_id`, `created_by`, `updated_by`) VALUES (8, '2025-04-13 10:24:22.197686', '2025-04-13 10:24:22.197686', '公告', '1', 1, 1, '', 3, 1, NULL);
INSERT INTO `sys_dict_item` (`id`, `created_at`, `updated_at`, `label`, `value`, `order`, `status`, `remark`, `type_id`, `created_by`, `updated_by`) VALUES (9, '2025-04-13 10:24:29.060138', '2025-04-13 10:24:29.060138', '通知', '2', 2, 1, '', 3, 1, NULL);
COMMIT;

-- ----------------------------
-- Table structure for sys_dict_type
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict_type`;
CREATE TABLE `sys_dict_type` (
  `id` int NOT NULL AUTO_INCREMENT,
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  `name` varchar(50) NOT NULL,
  `code` varchar(50) NOT NULL,
  `status` tinyint NOT NULL DEFAULT '1',
  `remark` varchar(255) DEFAULT NULL,
  `created_by` int DEFAULT NULL COMMENT '创建人',
  `updated_by` int DEFAULT NULL COMMENT '修改者',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `IDX_74d0045ff7fab9f67adc0b1bda` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of sys_dict_type
-- ----------------------------
BEGIN;
INSERT INTO `sys_dict_type` (`id`, `created_at`, `updated_at`, `name`, `code`, `status`, `remark`, `created_by`, `updated_by`) VALUES (1, '2025-04-09 16:37:40.000000', '2025-04-09 16:37:40.000000', '用户状态', 'user_status', 1, '', NULL, 1);
INSERT INTO `sys_dict_type` (`id`, `created_at`, `updated_at`, `name`, `code`, `status`, `remark`, `created_by`, `updated_by`) VALUES (2, '2025-04-12 12:08:15.499276', '2025-04-12 12:08:15.499276', '用户性别', 'user_gender', 1, '', NULL, 1);
INSERT INTO `sys_dict_type` (`id`, `created_at`, `updated_at`, `name`, `code`, `status`, `remark`, `created_by`, `updated_by`) VALUES (3, '2025-04-13 10:24:08.111950', '2025-04-13 10:24:08.111950', '公告类型', 'notice_type', 1, '', 1, NULL);
COMMIT;

-- ----------------------------
-- Table structure for sys_login_log
-- ----------------------------
DROP TABLE IF EXISTS `sys_login_log`;
CREATE TABLE `sys_login_log` (
  `id` int NOT NULL AUTO_INCREMENT,
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  `ip` varchar(255) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `provider` varchar(255) DEFAULT NULL,
  `user_agent` varchar(255) DEFAULT NULL,
  `user_id` int DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `FK_3029712e0df6a28edaee46fd470` (`user_id`),
  CONSTRAINT `FK_3029712e0df6a28edaee46fd470` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=104 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of sys_login_log
-- ----------------------------
BEGIN;
INSERT INTO `sys_login_log` (`id`, `created_at`, `updated_at`, `ip`, `address`, `provider`, `user_agent`, `user_id`) VALUES (21, '2026-09-08 14:14:27.707929', '2026-09-08 14:14:27.707929', '127.0.0.1', '内网IP', NULL, 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 2);
INSERT INTO `sys_login_log` (`id`, `created_at`, `updated_at`, `ip`, `address`, `provider`, `user_agent`, `user_id`) VALUES (22, '2026-09-08 14:16:35.496077', '2026-09-08 14:16:35.496077', '127.0.0.1', '内网IP', NULL, 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 2);
INSERT INTO `sys_login_log` (`id`, `created_at`, `updated_at`, `ip`, `address`, `provider`, `user_agent`, `user_id`) VALUES (24, '2026-09-08 14:24:21.304094', '2026-09-08 14:24:21.304094', '127.0.0.1', '内网IP', NULL, 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 1);
INSERT INTO `sys_login_log` (`id`, `created_at`, `updated_at`, `ip`, `address`, `provider`, `user_agent`, `user_id`) VALUES (27, '2026-09-09 13:58:59.873566', '2026-09-09 13:58:59.873566', '127.0.0.1', '内网IP', NULL, 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 2);
INSERT INTO `sys_login_log` (`id`, `created_at`, `updated_at`, `ip`, `address`, `provider`, `user_agent`, `user_id`) VALUES (28, '2026-09-09 14:13:12.703096', '2026-09-09 14:13:12.703096', '127.0.0.1', '内网IP', NULL, 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 1);
INSERT INTO `sys_login_log` (`id`, `created_at`, `updated_at`, `ip`, `address`, `provider`, `user_agent`, `user_id`) VALUES (29, '2026-09-09 14:35:48.372574', '2026-09-09 14:35:48.372574', '127.0.0.1', '内网IP', NULL, 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 2);
INSERT INTO `sys_login_log` (`id`, `created_at`, `updated_at`, `ip`, `address`, `provider`, `user_agent`, `user_id`) VALUES (30, '2026-09-10 10:46:19.134893', '2026-09-10 10:46:19.134893', '127.0.0.1', '内网IP', NULL, 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 2);
INSERT INTO `sys_login_log` (`id`, `created_at`, `updated_at`, `ip`, `address`, `provider`, `user_agent`, `user_id`) VALUES (31, '2026-09-10 13:43:36.513155', '2026-09-10 13:43:36.513155', '127.0.0.1', '内网IP', NULL, 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 2);
INSERT INTO `sys_login_log` (`id`, `created_at`, `updated_at`, `ip`, `address`, `provider`, `user_agent`, `user_id`) VALUES (32, '2026-09-10 15:36:27.433288', '2026-09-10 15:36:27.433288', '127.0.0.1', '内网IP', NULL, 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/152.0.0.0 Safari/537.36', 2);
INSERT INTO `sys_login_log` (`id`, `created_at`, `updated_at`, `ip`, `address`, `provider`, `user_agent`, `user_id`) VALUES (33, '2026-09-20 09:53:20.116453', '2026-09-20 09:53:20.116453', '127.0.0.1', '内网IP', NULL, 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', 2);
INSERT INTO `sys_login_log` (`id`, `created_at`, `updated_at`, `ip`, `address`, `provider`, `user_agent`, `user_id`) VALUES (36, '2026-09-21 15:50:40.747561', '2026-09-21 15:50:40.747561', '127.0.0.1', '内网IP', NULL, 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 2);
INSERT INTO `sys_login_log` (`id`, `created_at`, `updated_at`, `ip`, `address`, `provider`, `user_agent`, `user_id`) VALUES (37, '2026-09-21 16:01:05.907360', '2026-09-21 16:01:05.907360', '127.0.0.1', '内网IP', NULL, 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', 2);
INSERT INTO `sys_login_log` (`id`, `created_at`, `updated_at`, `ip`, `address`, `provider`, `user_agent`, `user_id`) VALUES (40, '2026-09-21 16:23:38.389069', '2026-09-21 16:23:38.389069', '127.0.0.1', '内网IP', NULL, 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', 2);
INSERT INTO `sys_login_log` (`id`, `created_at`, `updated_at`, `ip`, `address`, `provider`, `user_agent`, `user_id`) VALUES (62, '2026-09-22 16:39:56.666081', '2026-09-22 16:39:56.666081', '127.0.0.1', '内网IP', NULL, 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', 2);
INSERT INTO `sys_login_log` (`id`, `created_at`, `updated_at`, `ip`, `address`, `provider`, `user_agent`, `user_id`) VALUES (63, '2026-09-22 17:13:08.110695', '2026-09-22 17:13:08.110695', '127.0.0.1', '内网IP', NULL, 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', 2);
INSERT INTO `sys_login_log` (`id`, `created_at`, `updated_at`, `ip`, `address`, `provider`, `user_agent`, `user_id`) VALUES (102, '2026-09-23 12:48:20.864795', '2026-09-23 12:48:20.864795', '127.0.0.1', '内网IP', NULL, 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', 2);
INSERT INTO `sys_login_log` (`id`, `created_at`, `updated_at`, `ip`, `address`, `provider`, `user_agent`, `user_id`) VALUES (103, '2026-09-23 13:21:46.873285', '2026-09-23 13:21:46.873285', '127.0.0.1', '内网IP', NULL, 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', 2);
COMMIT;

-- ----------------------------
-- Table structure for sys_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_menu`;
CREATE TABLE `sys_menu` (
  `id` int NOT NULL AUTO_INCREMENT,
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  `parent_id` int DEFAULT NULL COMMENT '菜单父级ID',
  `name` varchar(255) DEFAULT NULL COMMENT '路由名称',
  `path` varchar(255) DEFAULT NULL COMMENT '菜单路径',
  `component` varchar(255) DEFAULT NULL COMMENT '菜单组件',
  `permission` varchar(255) DEFAULT NULL COMMENT '菜单权限',
  `icon` varchar(255) DEFAULT NULL COMMENT '菜单图标',
  `order` int DEFAULT '0' COMMENT '菜单排序',
  `is_ext` tinyint DEFAULT '0' COMMENT '是否外链',
  `ext_open_mode` tinyint DEFAULT '1' COMMENT '外链打开模式 1 项目内打开 2 项目外打开',
  `keep_alive` tinyint DEFAULT '0' COMMENT '是否缓存',
  `active_menu` varchar(255) DEFAULT NULL COMMENT '设置当前路由高亮的菜单项，一般用于详情页',
  `status` int DEFAULT '1' COMMENT '菜单状态 1 启用 0 禁用',
  `title` varchar(255) DEFAULT NULL COMMENT '菜单/权限名称',
  `i18n_key` varchar(255) DEFAULT NULL COMMENT '国际化 key',
  `route_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '路由名称',
  `icon_type` int DEFAULT NULL COMMENT '图标类型',
  `hide_in_menu` tinyint DEFAULT '0' COMMENT '是否隐藏',
  `multi_tab` tinyint DEFAULT '0' COMMENT '是否显示多标签页',
  `href` varchar(255) DEFAULT NULL COMMENT '外链地址',
  `fixed_index_in_tab` int DEFAULT NULL COMMENT '是否显示多标签页',
  `type` int DEFAULT NULL COMMENT '菜单类型',
  `created_by` int DEFAULT NULL COMMENT '创建人',
  `updated_by` int DEFAULT NULL COMMENT '修改者',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=207 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of sys_menu
-- ----------------------------
BEGIN;
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (1, '2025-04-09 16:37:40.000000', '2025-04-09 16:37:40.000000', 53, '', '', '', 'system:role:create', '', 3, 0, 0, 0, NULL, 0, '创建', NULL, NULL, 0, 0, 0, NULL, NULL, 2, NULL, 1);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (2, '2025-04-09 16:37:40.000000', '2025-04-09 16:37:40.000000', 18, '', NULL, NULL, 'system:dict-type:delete', '', 5, 0, 0, 0, NULL, 1, '字典类型删除', NULL, NULL, 0, 0, 0, NULL, NULL, 2, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (3, '2025-04-09 16:37:40.000000', '2025-04-09 16:37:40.000000', 74, '', '', '', 'system:task:delete', '', 5, 0, 0, 0, NULL, 1, '删除', NULL, NULL, 0, 0, 0, NULL, NULL, 2, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (4, '2025-04-09 16:37:40.000000', '2025-04-09 16:37:40.000000', 59, '', '', '', 'upload:upload', '', 2, 0, 0, 0, NULL, 1, '上传', NULL, NULL, 0, 0, 0, NULL, NULL, 2, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (5, '2025-04-09 16:37:40.000000', '2026-09-21 15:43:06.364252', 47, 'tools_storage_local', '/tools/storage/local', 'view.tools_storage_local', '', 'mdi:record-circle-outline', 1, 0, 0, 0, NULL, 1, '文件管理', 'route.tools_storage_local', NULL, 0, 0, 0, NULL, NULL, 1, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (6, '2025-04-09 16:37:40.000000', '2025-04-09 16:37:40.000000', 27, '', '', '', 'system:parameter:delete', '', 5, 0, 0, 0, NULL, 1, '删除', NULL, NULL, 0, 0, 0, NULL, NULL, 1, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (7, '2025-04-09 16:37:40.000000', '2025-04-09 16:37:40.000000', 46, 'system_monitor_captcha-log', '/system/monitor/captcha-log', 'view.system_monitor_captcha-log', '', 'mdi:email-fast-outline', 3, 0, 0, 0, NULL, 1, '验证码日志', 'route.system_monitor_captcha-log', NULL, 0, 0, 0, NULL, NULL, 1, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (8, '2025-04-09 16:37:40.000000', '2025-04-09 16:37:40.000000', 21, '', '', '', 'system:dept:read', '', 2, 0, 0, 0, NULL, 1, '详情', NULL, NULL, 0, 0, 0, NULL, NULL, 2, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (9, '2025-04-09 16:37:40.000000', '2025-04-09 16:37:40.000000', 21, '', '', '', 'system:dept:create', '', 3, 0, 0, 0, NULL, 1, '创建', NULL, NULL, 0, 0, 0, NULL, NULL, 2, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (10, '2025-04-09 16:37:40.000000', '2025-04-09 16:37:40.000000', 0, 'user-center', '/user-center', 'layout.base$view.user-center', '', 'mdi:account-heart-outline', 12, 0, 0, 0, NULL, 1, '个人中心', 'route.user-center', NULL, 0, 0, 0, NULL, NULL, 1, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (11, '2025-04-09 16:37:40.000000', '2025-04-09 16:37:40.000000', 21, '', '', '', 'system:dept:update', '', 4, 0, 0, 0, NULL, 1, '修改', NULL, NULL, 0, 0, 0, NULL, NULL, 2, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (12, '2025-04-09 16:37:40.000000', '2025-04-09 16:37:40.000000', 72, '', '', '', 'system:log:task:list', '', 1, 0, 0, 0, NULL, 1, '列表', NULL, NULL, 0, 0, 0, NULL, NULL, 2, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (13, '2025-04-09 16:37:40.000000', '2025-04-09 16:37:40.000000', 0, 'tools', '/tools', 'layout.base', '', 'mdi:toolbox-outline', 3, 0, 0, 0, NULL, 1, '系统工具', 'route.tools', NULL, 0, 0, 0, NULL, NULL, 0, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (14, '2025-04-09 16:37:40.000000', '2025-04-09 16:37:40.000000', 61, '', '', '', 'system:menu:create', '', 3, 0, 0, 0, NULL, 1, '创建', NULL, NULL, 0, 0, 0, NULL, NULL, 2, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (15, '2025-04-09 16:37:40.000000', '2025-04-09 16:37:40.000000', 5, '', '', '', 'tool:storage:delete', '', 3, 0, 0, 0, NULL, 1, '删除', NULL, NULL, 0, 0, 0, NULL, NULL, 2, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (16, '2025-04-09 16:37:40.000000', '2025-04-09 16:37:40.000000', 36, 'system_schedule', 'system_schedule', '', NULL, 'mdi:calendar-clock-outline', 6, 0, 0, 0, NULL, 1, '任务调度', 'route.system_schedule', NULL, 0, 0, 0, NULL, NULL, 0, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (17, '2025-04-09 16:37:40.000000', '2025-04-09 16:37:40.000000', 32, '', '', '', 'system:online:list', '', 1, 0, 0, 0, NULL, 1, '列表', NULL, NULL, 0, 0, 0, NULL, NULL, 2, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (18, '2025-04-09 16:37:40.000000', '2025-04-09 16:37:40.000000', 36, 'system_dict', '/system/dict', 'view.system_dict', NULL, 'mdi:format-list-numbered', 8, 0, 0, 0, NULL, 1, '字典管理', 'route.system_dict', NULL, 0, 0, 0, NULL, NULL, 1, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (19, '2025-04-09 16:37:40.000000', '2025-04-09 16:37:40.000000', 18, '', NULL, NULL, 'system:dict-type:create', '', 3, 0, 0, 0, NULL, 1, '字典类型创建', NULL, NULL, 0, 0, 0, NULL, NULL, 2, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (20, '2025-04-09 16:37:40.000000', '2025-04-09 16:37:40.000000', 21, '', '', '', 'system:dept:list', '', 1, 0, 0, 0, NULL, 1, '列表', NULL, NULL, 0, 0, 0, NULL, NULL, 2, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (21, '2025-04-09 16:37:40.000000', '2025-04-09 16:37:40.000000', 36, 'system_dept', '/system/dept', 'view.system_dept', '', 'ic:outline-reduce-capacity', 1, 0, 0, 0, NULL, 1, '部门管理', 'route.system_dept', NULL, 0, 0, 0, NULL, NULL, 1, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (22, '2025-04-09 16:37:40.000000', '2025-04-09 16:37:40.000000', 74, '', '', '', 'system:task:start', '', 7, 0, 0, 0, NULL, 1, '启动', NULL, NULL, 0, 0, 0, NULL, NULL, 2, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (23, '2025-04-09 16:37:40.000000', '2025-04-09 16:37:40.000000', 18, '', NULL, NULL, 'system:dict-item:delete', '', 10, 0, 0, 0, NULL, 1, '字典项删除', NULL, NULL, 0, 0, 0, NULL, NULL, 2, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (24, '2025-04-09 16:37:40.000000', '2025-04-09 16:37:40.000000', 74, '', '', '', 'system:task:stop', '', 8, 0, 0, 0, NULL, 1, '停止任务', NULL, NULL, 0, 0, 0, NULL, NULL, 2, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (25, '2025-04-09 16:37:40.000000', '2025-04-09 16:37:40.000000', 61, '', '', '', 'system:menu:update', '', 4, 0, 0, 0, NULL, 1, '修改', NULL, NULL, 0, 0, 0, NULL, NULL, 2, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (26, '2025-04-09 16:37:40.000000', '2025-04-09 16:37:40.000000', 0, 'about', '/about', 'layout.base$view.about', '', 'fluent:book-information-24-regular', 13, 0, 0, 0, NULL, 1, '关于', 'route.about', NULL, 0, 0, 0, NULL, NULL, 1, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (27, '2025-04-09 16:37:40.000000', '2025-04-09 16:37:40.000000', 36, 'system_parameter', '/system/parameter', 'view.system_parameter', '', 'mdi:database-cog-outline', 7, 0, 0, 0, NULL, 1, '参数管理', 'route.system_parameter', NULL, 0, 0, 0, NULL, NULL, 1, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (28, '2025-04-09 16:37:40.000000', '2025-04-09 16:37:40.000000', 18, '', NULL, NULL, 'system:dict-type:update', '', 4, 0, 0, 0, NULL, 1, '字典类型修改', NULL, NULL, 0, 0, 0, NULL, NULL, 2, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (29, '2025-04-09 16:37:40.000000', '2025-04-09 16:37:40.000000', 18, '', NULL, NULL, 'system:dict-type:read', '', 2, 0, 0, 0, NULL, 1, '字典类型详情', NULL, NULL, 0, 0, 0, NULL, NULL, 2, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (30, '2025-04-09 16:37:40.000000', '2025-04-09 16:37:40.000000', 53, '', '', '', 'system:role:read', '', 2, 0, 0, 0, NULL, 1, '详情', NULL, NULL, 0, 0, 0, NULL, NULL, 2, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (31, '2025-04-09 16:37:40.000000', '2025-04-09 16:37:40.000000', 18, '', NULL, NULL, 'system:dict-item:read', '', 7, 0, 0, 0, NULL, 1, '字典项详情', NULL, NULL, 0, 0, 0, NULL, NULL, 2, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (32, '2025-04-09 16:37:40.000000', '2025-04-09 16:37:40.000000', 46, 'system_monitor_online', '/system/monitor/online', 'view.system_monitor_online', '', 'mdi:account-multiple-check-outline', 1, 0, 0, 0, NULL, 1, '在线用户', 'route.system_monitor_online', NULL, 0, 0, 0, NULL, NULL, 1, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (33, '2025-04-09 16:37:40.000000', '2025-04-09 16:37:40.000000', 27, '', '', '', 'system:parameter:create', '', 3, 0, 0, 0, NULL, 1, '创建', NULL, NULL, 0, 0, 0, NULL, NULL, 2, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (34, '2025-04-09 16:37:40.000000', '2025-04-09 16:37:40.000000', 74, '', '', '', 'system:task:update', '', 4, 0, 0, 0, NULL, 1, '修改', NULL, NULL, 0, 0, 0, NULL, NULL, 2, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (35, '2025-04-09 16:37:40.000000', '2025-04-09 16:37:40.000000', 74, '', '', '', 'system:task:read', '', 2, 0, 0, 0, NULL, 1, '详情', NULL, NULL, 0, 0, 0, NULL, NULL, 2, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (36, '2025-04-09 16:37:40.000000', '2026-09-22 14:38:42.000000', 0, 'system', '/system', 'layout.base', '', 'ic:outline-settings', 2, 0, 0, 0, NULL, 1, '系统管理', 'route.system', NULL, 0, 0, 0, NULL, NULL, 0, NULL, 2);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (37, '2025-04-09 16:37:40.000000', '2025-04-09 16:37:40.000000', 13, 'tools_mail', '/tools/mail', 'view.tools_mail', '', 'mdi:email-arrow-right-outline', 3, 0, 0, 0, NULL, 1, '发送邮件', 'route.tools_mail', NULL, 0, 0, 0, NULL, NULL, 1, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (39, '2025-04-09 16:37:40.000000', '2025-04-09 16:37:40.000000', 59, '', '', '', 'tool:oss:list', '', 1, 0, 0, 0, NULL, 1, '列表', NULL, NULL, 0, 0, 0, NULL, NULL, 2, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (40, '2025-04-09 16:37:40.000000', '2025-04-09 16:37:40.000000', 74, '', '', '', 'system:task:list', '', 1, 0, 0, 0, NULL, 1, '列表', NULL, NULL, 0, 0, 0, NULL, NULL, 2, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (41, '2025-04-09 16:37:40.000000', '2025-04-09 16:37:40.000000', 51, '', '', '', 'system:log:login:delete', '', 2, 0, 0, 0, NULL, 1, '删除', NULL, NULL, 0, 0, 0, NULL, NULL, 2, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (42, '2025-04-09 16:37:40.000000', '2025-04-09 16:37:40.000000', 36, 'system_user', '/system/user', 'view.system_user', '', 'mdi:account-cog-outline', 4, 0, 0, 0, NULL, 1, '用户管理', 'route.system_user', NULL, 0, 0, 0, NULL, NULL, 1, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (43, '2025-04-09 16:37:40.000000', '2025-04-09 16:37:40.000000', 27, '', '', '', 'system:parameter:update', '', 4, 0, 0, 0, NULL, 1, '修改', NULL, NULL, 0, 0, 0, NULL, NULL, 2, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (44, '2025-04-09 16:37:40.000000', '2025-04-09 16:37:40.000000', 27, '', '', '', 'system:parameter:list', '', 1, 0, 0, 0, NULL, 1, '列表', NULL, NULL, 0, 0, 0, NULL, NULL, 2, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (45, '2025-04-09 16:37:40.000000', '2025-04-09 16:37:40.000000', 42, '', '', '', 'system:user:read', '', 2, 0, 0, 0, NULL, 1, '详情', NULL, NULL, 0, 0, 0, NULL, NULL, 2, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (46, '2025-04-09 16:37:40.000000', '2025-04-09 16:37:40.000000', 36, 'system_monitor', '/system/monitor', '', '', 'mdi:monitor-eye', 5, 0, 0, 0, NULL, 1, '系统监控', 'route.system_monitor', NULL, 0, 0, 0, NULL, NULL, 0, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (47, '2025-04-09 16:37:40.000000', '2025-04-09 16:37:40.000000', 13, 'tools_storage', '/tools/storage', '', '', 'mdi:folder-cog-outline', 2, 0, 0, 0, NULL, 1, '存储管理', 'route.tools_storage', NULL, 0, 0, 0, NULL, NULL, 0, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (48, '2025-04-09 16:37:40.000000', '2025-04-09 16:37:40.000000', 53, '', '', '', 'system:role:delete', '', 5, 0, 0, 0, NULL, 1, '删除', NULL, NULL, 0, 0, 0, NULL, NULL, 2, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (50, '2025-04-09 16:37:40.000000', '2025-04-09 16:37:40.000000', 21, '', '', '', 'system:dept:delete', '', 5, 0, 0, 0, NULL, 1, '删除', NULL, NULL, 0, 0, 0, NULL, NULL, 2, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (51, '2025-04-09 16:37:40.000000', '2025-04-09 16:37:40.000000', 46, 'system_monitor_login-log', '/system/monitor/login-log', 'view.system_monitor_login-log', '', 'mdi:account-file-text-outline', 2, 0, 0, 0, NULL, 1, '登录日志', 'route.system_monitor_login-log', NULL, 0, 0, 0, NULL, NULL, 1, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (52, '2025-04-09 16:37:40.000000', '2025-04-09 16:37:40.000000', 42, '', '', '', 'system:user:list', '', 1, 0, 0, 0, NULL, 1, '列表', NULL, NULL, 0, 0, 0, NULL, NULL, 2, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (53, '2025-04-09 16:37:40.000000', '2025-04-09 16:37:40.000000', 36, 'system_role', '/system/role', 'view.system_role', '', 'mdi:account-group-outline', 2, 0, 0, 0, NULL, 1, '角色管理', 'route.system_role', NULL, 0, 0, 0, NULL, NULL, 1, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (54, '2025-04-09 16:37:40.000000', '2025-04-09 16:37:40.000000', 46, 'system_monitor_serve', '/system/monitor/serve', 'view.system_monitor_serve', '', 'mdi:server-outline', 4, 0, 0, 0, NULL, 1, '服务监控', 'route.system_monitor_serve', NULL, 0, 0, 0, NULL, NULL, 1, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (55, '2025-04-09 16:37:40.000000', '2025-04-09 16:37:40.000000', 61, '', '', '', 'system:menu:read', '', 2, 0, 0, 0, NULL, 1, '详情', NULL, NULL, 0, 0, 0, NULL, NULL, 2, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (56, '2025-04-09 16:37:40.000000', '2025-04-09 16:37:40.000000', 18, '', NULL, NULL, 'system:dict-item:create', '', 8, 0, 0, 0, NULL, 1, '字典项创建', NULL, NULL, 0, 0, 0, NULL, NULL, 2, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (57, '2025-04-09 16:37:40.000000', '2025-04-09 16:37:40.000000', 5, '', '', '', 'upload:upload', '', 2, 0, 0, 0, NULL, 1, '上传', NULL, NULL, 0, 0, 0, NULL, NULL, 2, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (58, '2025-04-09 16:37:40.000000', '2025-04-09 16:37:40.000000', 61, '', '', '', 'system:menu:list', '', 1, 0, 0, 0, NULL, 1, '列表', NULL, NULL, 0, 0, 0, NULL, NULL, 2, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (59, '2025-04-09 16:37:40.000000', '2025-04-09 16:37:40.000000', 47, 'tools_storage_oss', '/tools/storage/oss', 'view.tools_storage_oss', '', 'mdi:cloud-check-variant-outline', 2, 0, 0, 0, NULL, 1, 'Oss存储', 'route.tools_storage_oss', NULL, 0, 0, 0, NULL, NULL, 1, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (60, '2025-04-09 16:37:40.000000', '2025-04-09 16:37:40.000000', 18, '', NULL, NULL, 'system:dict-item:update', '', 9, 0, 0, 0, NULL, 1, '字典项修改', NULL, NULL, 0, 0, 0, NULL, NULL, 2, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (61, '2025-04-09 16:37:40.000000', '2025-04-09 16:37:40.000000', 36, 'system_menu', '/system/menu', 'view.system_menu', '', 'mdi:list-box-outline', 3, 0, 0, 0, NULL, 1, '菜单管理', 'route.system_menu', NULL, 0, 0, 0, NULL, NULL, 1, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (62, '2025-04-09 16:37:40.000000', '2025-04-09 16:37:40.000000', 42, '', '', '', 'system:user:create', '', 3, 0, 0, 0, NULL, 1, '创建', NULL, NULL, 0, 0, 0, NULL, NULL, 2, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (63, '2025-04-09 16:37:40.000000', '2025-04-09 16:37:40.000000', 5, '', '', '', 'tool:storage:list', '', 1, 0, 0, 0, NULL, 1, '列表', NULL, NULL, 0, 0, 0, NULL, NULL, 2, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (64, '2025-04-09 16:37:40.000000', '2025-04-09 16:37:40.000000', 74, '', '', '', 'system:task:once', '', 6, 0, 0, 0, NULL, 1, '启动一次', NULL, NULL, 0, 0, 0, NULL, NULL, 2, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (65, '2025-04-09 16:37:40.000000', '2025-04-09 16:37:40.000000', 0, 'home', '/home', 'layout.base$view.home', '', 'ic:outline-other-houses', 1, 0, 0, 0, NULL, 1, '首页', 'route.home', NULL, 0, 0, 0, NULL, NULL, 1, NULL, 2);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (66, '2025-04-09 16:37:40.000000', '2025-04-09 16:37:40.000000', 74, '', '', '', 'system:task:create', '', 3, 0, 0, 0, NULL, 1, '创建', NULL, NULL, 0, 0, 0, NULL, NULL, 2, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (67, '2025-04-09 16:37:40.000000', '2025-04-09 16:37:40.000000', 27, '', '', '', 'system:parameter:read', '', 2, 0, 0, 0, NULL, 1, '详情', NULL, NULL, 0, 0, 0, NULL, NULL, 2, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (68, '2025-04-09 16:37:40.000000', '2025-04-09 16:37:40.000000', 42, '', '', '', 'system:user:update', '', 4, 0, 0, 0, NULL, 1, '修改', NULL, NULL, 0, 0, 0, NULL, NULL, 2, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (69, '2025-04-09 16:37:40.000000', '2025-04-09 16:37:40.000000', 61, '', '', '', 'system:menu:delete', '', 5, 0, 0, 0, NULL, 1, '删除', NULL, NULL, 0, 0, 0, NULL, NULL, 2, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (70, '2025-04-09 16:37:40.000000', '2025-04-09 16:37:40.000000', 42, '', '', '', 'system:user:pass:reset', '', 5, 0, 0, 0, NULL, 1, '重置密码', NULL, NULL, 0, 0, 0, NULL, NULL, 2, NULL, 2);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (71, '2025-04-09 16:37:40.000000', '2025-04-09 16:37:40.000000', 53, '', '', '', 'system:role:list', '', 1, 0, 0, 0, NULL, 1, '列表', NULL, NULL, 0, 0, 0, NULL, NULL, 2, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (72, '2025-04-09 16:37:40.000000', '2025-04-09 16:37:40.000000', 16, 'system_schedule_task-log', '/system/schedule/task-log', 'view.system_schedule_task-log', '', 'mdi:invoice-text-clock-outline', 2, 0, 0, 0, NULL, 1, '任务日志', 'route.system_schedule_task-log', NULL, 0, 0, 0, NULL, NULL, 1, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (73, '2025-04-09 16:37:40.000000', '2025-04-09 16:37:40.000000', 51, '', '', '', 'system:log:login:list', '', 1, 0, 0, 0, NULL, 1, '列表', NULL, NULL, 0, 0, 0, NULL, NULL, 2, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (74, '2025-04-09 16:37:40.000000', '2025-04-09 16:37:40.000000', 16, 'system_schedule_task', '/system/schedule/task', 'view.system_schedule_task', '', 'mdi:timer-cog-outline', 1, 0, 0, 0, NULL, 1, '定时任务', 'route.system_schedule_task', NULL, 0, 0, 0, NULL, NULL, 1, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (75, '2025-04-09 16:37:40.000000', '2025-04-09 16:37:40.000000', 53, '', '', '', 'system:role:update', '', 4, 0, 0, 0, NULL, 1, '修改', NULL, NULL, 0, 0, 0, NULL, NULL, 2, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (76, '2025-04-09 16:37:40.000000', '2025-04-09 16:37:40.000000', 7, '', '', '', 'system:log:captcha:delete', '', 2, 0, 0, 0, NULL, 1, '删除', NULL, NULL, 0, 0, 0, NULL, NULL, 2, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (77, '2025-04-09 16:37:40.000000', '2025-04-09 16:37:40.000000', 7, '', '', '', 'system:log:captcha:list', '', 1, 0, 0, 0, NULL, 1, '列表', NULL, NULL, 0, 0, 0, NULL, NULL, 2, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (78, '2025-04-09 16:37:40.000000', '2025-04-09 16:37:40.000000', 18, '', NULL, NULL, 'system:dict-type:list', '', 1, 0, 0, 0, NULL, 1, '字典类型列表', NULL, NULL, 0, 0, 0, NULL, NULL, 2, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (79, '2025-04-09 16:37:40.000000', '2025-04-09 16:37:40.000000', 18, '', NULL, NULL, 'system:dict-item:list', '', 6, 0, 0, 0, NULL, 1, '字典项列表', NULL, NULL, 0, 0, 0, NULL, NULL, 2, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (80, '2025-04-09 16:37:40.000000', '2025-04-09 16:37:40.000000', 37, '', '', '', 'tool:mail:send', '', 1, 0, 0, 0, NULL, 1, '发送', NULL, NULL, 0, 0, 0, NULL, NULL, 2, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (81, '2025-04-09 16:37:40.000000', '2025-04-09 16:37:40.000000', 72, '', '', '', 'system:log:task:delete', '', 2, 0, 0, 0, NULL, 1, '删除', NULL, NULL, 0, 0, 0, NULL, NULL, 2, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (82, '2025-04-09 16:37:40.000000', '2025-04-09 16:37:40.000000', 32, '', '', '', 'system:online:kick', '', 2, 0, 0, 0, NULL, 1, '下线', NULL, NULL, 0, 0, 0, NULL, NULL, 2, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (83, '2025-04-09 16:37:40.000000', '2025-04-09 16:37:40.000000', 0, 'blog', '/blog', 'layout.base', NULL, 'mdi:book-heart-outline', 4, 0, 0, 0, NULL, 1, '博客管理', 'route.blog', 'blog', 0, 0, 0, NULL, NULL, 0, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (84, '2025-04-11 22:43:19.312329', '2025-04-11 22:43:19.312329', 13, 'tools_sql', '/tools/sql', 'view.tools_sql', NULL, 'mdi:database-cog-outline', 1, 0, 0, 0, NULL, 1, '数据库管理', 'route.tools_sql', NULL, 0, 0, 0, NULL, NULL, 1, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (85, '2025-04-11 22:43:46.293927', '2025-04-11 22:43:46.293927', 84, '', NULL, NULL, 'tool:sql:export', '', 1, 0, 0, 0, NULL, 1, '导出', NULL, NULL, 0, 0, 0, NULL, NULL, 2, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (86, '2025-04-11 22:44:00.474854', '2025-04-11 22:44:00.474854', 84, '', NULL, NULL, 'tool:sql:import', '', 2, 0, 0, 0, NULL, 1, '导入', NULL, NULL, 0, 0, 0, NULL, NULL, 2, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (87, '2025-04-11 22:44:47.125958', '2025-04-11 22:44:47.125958', 46, 'system_monitor_cache', '/system/monitor/cache', 'view.system_monitor_cache', NULL, 'ic:outline-cached', 9, 0, 0, 0, NULL, 1, '缓存监控', 'route.system_monitor_cache', NULL, 0, 0, 0, NULL, NULL, 1, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (88, '2025-04-11 22:45:29.369814', '2025-04-11 22:45:29.369814', 87, '', NULL, NULL, 'system:cache:LIST', '', 1, 0, 0, 0, NULL, 1, '列表', NULL, NULL, 0, 0, 0, NULL, NULL, 2, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (89, '2025-04-11 22:45:42.673700', '2025-04-11 22:45:42.673700', 87, '', NULL, NULL, 'system:cache:READ', '', 2, 0, 0, 0, NULL, 1, '详情', NULL, NULL, 0, 0, 0, NULL, NULL, 2, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (90, '2025-04-11 22:45:52.554843', '2025-04-11 22:45:52.554843', 87, '', NULL, NULL, 'system:cache:DELETE', '', 3, 0, 0, 0, NULL, 1, '删除', NULL, NULL, 0, 0, 0, NULL, NULL, 2, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (98, '2025-04-13 16:07:20.427038', '2025-04-13 16:07:20.427038', 36, 'system_notice', '/system/notice', 'view.system_notice', NULL, 'ic:outline-notifications', 9, 0, 0, 0, NULL, 1, '通知公告', 'route.system_notice', NULL, 0, 0, 0, NULL, NULL, 1, 2, 2);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (99, '2025-04-13 16:13:47.289494', '2025-04-13 16:13:47.289494', 98, '', NULL, NULL, 'system:notice:list', NULL, 1, 0, 0, 0, NULL, 1, '列表', NULL, NULL, 0, 0, 0, NULL, NULL, 2, 2, 2);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (100, '2025-04-13 16:14:03.075460', '2025-04-13 16:14:03.075460', 98, '', NULL, NULL, 'system:notice:read', '', 2, 0, 0, 0, NULL, 1, '详情', NULL, NULL, 0, 0, 0, NULL, NULL, 2, 2, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (101, '2025-04-13 16:14:25.829637', '2025-04-13 16:14:25.829637', 98, '', NULL, NULL, 'system:notice:create', '', 3, 0, 0, 0, NULL, 1, '创建', NULL, NULL, 0, 0, 0, NULL, NULL, 2, 2, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (102, '2025-04-13 16:14:36.427214', '2025-04-13 16:14:36.427214', 98, '', NULL, NULL, 'system:notice:update', '', 4, 0, 0, 0, NULL, 1, '修改', NULL, NULL, 0, 0, 0, NULL, NULL, 2, 2, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (103, '2025-04-13 16:14:47.595467', '2025-04-13 16:14:47.595467', 98, '', NULL, NULL, 'system:notice:delete', '', 5, 0, 0, 0, NULL, 1, '删除', NULL, NULL, 0, 0, 0, NULL, NULL, 2, 2, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (104, '2025-04-13 23:56:24.790031', '2025-04-13 23:56:24.790031', 36, 'system_notice_notice-operate', '/system/notice/notice-operate', 'view.system_notice_notice-operate', NULL, 'ic:outline-notifications', 10, 0, 0, 0, 'system_notice', 1, '公告操作', 'route.system_notice_notice-operate', NULL, 0, 1, 0, NULL, NULL, 1, 2, 2);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (105, '2025-04-13 23:57:16.669670', '2025-04-13 23:57:16.669670', 104, '', NULL, NULL, 'system:notice:create', '', 1, 0, 0, 0, NULL, 1, '创建', NULL, NULL, 0, 0, 0, NULL, NULL, 2, 2, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (106, '2025-04-13 23:57:31.841662', '2025-04-13 23:57:31.841662', 104, '', NULL, NULL, 'system:notice:update', '', 2, 0, 0, 0, NULL, 1, '修改', NULL, NULL, 0, 0, 0, NULL, NULL, 2, 2, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (107, '2025-04-20 13:11:40.039536', '2025-04-20 13:11:40.039536', 42, '', NULL, NULL, 'system:user:delete', '', 6, 0, 0, 0, NULL, 1, '删除用户', NULL, NULL, 0, 0, 0, NULL, NULL, 2, 2, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (108, '2025-04-26 09:31:29.961106', '2025-04-26 09:31:29.961106', 13, 'tools_pay', '/tools/pay', 'view.tools_pay', NULL, 'fa-brands:alipay', 1, 0, 0, 0, NULL, 1, '支付宝沙箱', 'route.tools_pay', NULL, 0, 0, 0, NULL, NULL, 1, 1, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (109, '2026-09-08 11:24:08.187820', '2026-09-22 14:34:49.000000', 83, 'blog_site', '/blog/site', 'view.blog_site', NULL, 'ic:outline-other-houses', 1, 0, 1, 0, NULL, 1, '站点管理', 'route.blog_site', 'blog_site', 0, 0, 0, NULL, NULL, 1, NULL, 2);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (110, '2026-09-08 11:24:08.189903', '2026-09-08 11:24:08.189903', 109, 'blog_site_list', NULL, NULL, 'blog:site:list', NULL, 0, 0, 1, 0, NULL, 1, '站点管理-list', NULL, NULL, NULL, 1, 0, NULL, NULL, 2, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (111, '2026-09-08 11:24:08.191693', '2026-09-08 11:24:08.191693', 109, 'blog_site_update', NULL, NULL, 'blog:site:update', NULL, 0, 0, 1, 0, NULL, 1, '站点管理-update', NULL, NULL, NULL, 1, 0, NULL, NULL, 2, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (112, '2026-09-08 11:24:08.193996', '2026-09-22 14:34:32.000000', 83, 'blog_menus', '/blog/menus', 'view.blog_menus', NULL, 'mdi:list-box-outline', 2, 0, 1, 0, NULL, 1, '菜单管理', 'route.blog_menus', 'blog_menus', 0, 0, 0, NULL, NULL, 1, NULL, 2);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (113, '2026-09-08 11:24:08.195496', '2026-09-08 11:24:08.195496', 112, 'blog_menus_list', NULL, NULL, 'blog:menus:list', NULL, 0, 0, 1, 0, NULL, 1, '菜单管理-list', NULL, NULL, NULL, 1, 0, NULL, NULL, 2, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (114, '2026-09-08 11:24:08.196986', '2026-09-08 11:24:08.196986', 112, 'blog_menus_create', NULL, NULL, 'blog:menus:create', NULL, 0, 0, 1, 0, NULL, 1, '菜单管理-create', NULL, NULL, NULL, 1, 0, NULL, NULL, 2, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (115, '2026-09-08 11:24:08.198678', '2026-09-08 11:24:08.198678', 112, 'blog_menus_update', NULL, NULL, 'blog:menus:update', NULL, 0, 0, 1, 0, NULL, 1, '菜单管理-update', NULL, NULL, NULL, 1, 0, NULL, NULL, 2, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (116, '2026-09-08 11:24:08.200014', '2026-09-08 11:24:08.200014', 112, 'blog_menus_delete', NULL, NULL, 'blog:menus:delete', NULL, 0, 0, 1, 0, NULL, 1, '菜单管理-delete', NULL, NULL, NULL, 1, 0, NULL, NULL, 2, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (117, '2026-09-08 11:24:08.202908', '2026-09-22 14:38:56.000000', 83, 'blog_documents', '/blog/documents', 'view.blog_documents', NULL, 'mdi:book-open-variant-outline', 3, 0, 1, 0, NULL, 1, '文档管理', 'route.blog_documents', 'blog_documents', 0, 0, 0, NULL, NULL, 1, NULL, 2);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (118, '2026-09-08 11:24:08.206478', '2026-09-08 11:24:08.206478', 117, 'blog_documents_list', NULL, NULL, 'blog:documents:list', NULL, 0, 0, 1, 0, NULL, 1, '文档管理-list', NULL, NULL, NULL, 1, 0, NULL, NULL, 2, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (119, '2026-09-08 11:24:08.208239', '2026-09-08 11:24:08.208239', 117, 'blog_documents_create', NULL, NULL, 'blog:documents:create', NULL, 0, 0, 1, 0, NULL, 1, '文档管理-create', NULL, NULL, NULL, 1, 0, NULL, NULL, 2, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (120, '2026-09-08 11:24:08.210290', '2026-09-08 11:24:08.210290', 117, 'blog_documents_update', NULL, NULL, 'blog:documents:update', NULL, 0, 0, 1, 0, NULL, 1, '文档管理-update', NULL, NULL, NULL, 1, 0, NULL, NULL, 2, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (121, '2026-09-08 11:24:08.211763', '2026-09-08 11:24:08.211763', 117, 'blog_documents_delete', NULL, NULL, 'blog:documents:delete', NULL, 0, 0, 1, 0, NULL, 1, '文档管理-delete', NULL, NULL, NULL, 1, 0, NULL, NULL, 2, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (122, '2026-09-08 11:24:08.213037', '2026-09-22 14:35:08.000000', 83, 'blog_categories', '/blog/categories', 'view.blog_categories', NULL, 'mdi:format-list-numbered', 4, 0, 1, 0, NULL, 1, '分类管理', 'route.blog_categories', 'blog_categories', 0, 0, 0, NULL, NULL, 1, NULL, 2);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (123, '2026-09-08 11:24:08.214409', '2026-09-08 11:24:08.214409', 122, 'blog_categories_list', NULL, NULL, 'blog:categories:list', NULL, 0, 0, 1, 0, NULL, 1, '分类管理-list', NULL, NULL, NULL, 1, 0, NULL, NULL, 2, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (124, '2026-09-08 11:24:08.215770', '2026-09-08 11:24:08.215770', 122, 'blog_categories_create', NULL, NULL, 'blog:categories:create', NULL, 0, 0, 1, 0, NULL, 1, '分类管理-create', NULL, NULL, NULL, 1, 0, NULL, NULL, 2, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (125, '2026-09-08 11:24:08.217321', '2026-09-08 11:24:08.217321', 122, 'blog_categories_update', NULL, NULL, 'blog:categories:update', NULL, 0, 0, 1, 0, NULL, 1, '分类管理-update', NULL, NULL, NULL, 1, 0, NULL, NULL, 2, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (126, '2026-09-08 11:24:08.219074', '2026-09-08 11:24:08.219074', 122, 'blog_categories_delete', NULL, NULL, 'blog:categories:delete', NULL, 0, 0, 1, 0, NULL, 1, '分类管理-delete', NULL, NULL, NULL, 1, 0, NULL, NULL, 2, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (127, '2026-09-08 11:24:08.220412', '2026-09-22 14:35:32.000000', 83, 'blog_tags', '/blog/tags', 'view.blog_tags', NULL, 'mdi:book-open-page-variant-outline', 5, 0, 1, 0, NULL, 1, '标签管理', 'route.blog_tags', 'blog_tags', 0, 0, 0, NULL, NULL, 1, NULL, 2);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (128, '2026-09-08 11:24:08.221766', '2026-09-08 11:24:08.221766', 127, 'blog_tags_list', NULL, NULL, 'blog:tags:list', NULL, 0, 0, 1, 0, NULL, 1, '标签管理-list', NULL, NULL, NULL, 1, 0, NULL, NULL, 2, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (129, '2026-09-08 11:24:08.223203', '2026-09-08 11:24:08.223203', 127, 'blog_tags_create', NULL, NULL, 'blog:tags:create', NULL, 0, 0, 1, 0, NULL, 1, '标签管理-create', NULL, NULL, NULL, 1, 0, NULL, NULL, 2, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (130, '2026-09-08 11:24:08.224468', '2026-09-08 11:24:08.224468', 127, 'blog_tags_update', NULL, NULL, 'blog:tags:update', NULL, 0, 0, 1, 0, NULL, 1, '标签管理-update', NULL, NULL, NULL, 1, 0, NULL, NULL, 2, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (131, '2026-09-08 11:24:08.226464', '2026-09-08 11:24:08.226464', 127, 'blog_tags_delete', NULL, NULL, 'blog:tags:delete', NULL, 0, 0, 1, 0, NULL, 1, '标签管理-delete', NULL, NULL, NULL, 1, 0, NULL, NULL, 2, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (132, '2026-09-08 11:24:08.228622', '2026-09-22 14:35:50.000000', 83, 'blog_albums', '/blog/albums', 'view.blog_albums', NULL, 'mdi:alpha-f-box-outline', 6, 0, 1, 0, NULL, 1, '相册管理', 'route.blog_albums', 'blog_albums', 0, 0, 0, NULL, NULL, 1, NULL, 2);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (133, '2026-09-08 11:24:08.229935', '2026-09-08 11:24:08.229935', 132, 'blog_albums_list', NULL, NULL, 'blog:albums:list', NULL, 0, 0, 1, 0, NULL, 1, '相册管理-list', NULL, NULL, NULL, 1, 0, NULL, NULL, 2, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (134, '2026-09-08 11:24:08.231315', '2026-09-08 11:24:08.231315', 132, 'blog_albums_create', NULL, NULL, 'blog:albums:create', NULL, 0, 0, 1, 0, NULL, 1, '相册管理-create', NULL, NULL, NULL, 1, 0, NULL, NULL, 2, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (135, '2026-09-08 11:24:08.232736', '2026-09-08 11:24:08.232736', 132, 'blog_albums_update', NULL, NULL, 'blog:albums:update', NULL, 0, 0, 1, 0, NULL, 1, '相册管理-update', NULL, NULL, NULL, 1, 0, NULL, NULL, 2, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (136, '2026-09-08 11:24:08.234287', '2026-09-08 11:24:08.234287', 132, 'blog_albums_delete', NULL, NULL, 'blog:albums:delete', NULL, 0, 0, 1, 0, NULL, 1, '相册管理-delete', NULL, NULL, NULL, 1, 0, NULL, NULL, 2, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (138, '2026-09-08 11:24:08.237171', '2026-09-21 16:25:08.491192', 132, 'blog_photos_list', NULL, NULL, 'blog:photos:list', NULL, 0, 0, 1, 0, NULL, 1, '照片管理-list', NULL, NULL, NULL, 1, 0, NULL, NULL, 2, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (139, '2026-09-08 11:24:08.238544', '2026-09-21 16:25:08.491192', 132, 'blog_photos_create', NULL, NULL, 'blog:photos:create', NULL, 0, 0, 1, 0, NULL, 1, '照片管理-create', NULL, NULL, NULL, 1, 0, NULL, NULL, 2, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (140, '2026-09-08 11:24:08.239895', '2026-09-21 16:25:08.491192', 132, 'blog_photos_update', NULL, NULL, 'blog:photos:update', NULL, 0, 0, 1, 0, NULL, 1, '照片管理-update', NULL, NULL, NULL, 1, 0, NULL, NULL, 2, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (141, '2026-09-08 11:24:08.241292', '2026-09-21 16:25:08.491192', 132, 'blog_photos_delete', NULL, NULL, 'blog:photos:delete', NULL, 0, 0, 1, 0, NULL, 1, '照片管理-delete', NULL, NULL, NULL, 1, 0, NULL, NULL, 2, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (142, '2026-09-08 11:24:08.243059', '2026-09-22 14:37:06.000000', 83, 'blog_bangumis', '/blog/bangumis', 'view.blog_bangumis', NULL, 'mdi:toolbox-outline', 8, 0, 1, 0, NULL, 1, '追番管理', 'route.blog_bangumis', 'blog_bangumis', 0, 0, 0, NULL, NULL, 1, NULL, 2);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (143, '2026-09-08 11:24:08.244469', '2026-09-08 11:24:08.244469', 142, 'blog_bangumis_list', NULL, NULL, 'blog:bangumis:list', NULL, 0, 0, 1, 0, NULL, 1, '追番管理-list', NULL, NULL, NULL, 1, 0, NULL, NULL, 2, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (144, '2026-09-08 11:24:08.245660', '2026-09-08 11:24:08.245660', 142, 'blog_bangumis_create', NULL, NULL, 'blog:bangumis:create', NULL, 0, 0, 1, 0, NULL, 1, '追番管理-create', NULL, NULL, NULL, 1, 0, NULL, NULL, 2, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (145, '2026-09-08 11:24:08.247184', '2026-09-08 11:24:08.247184', 142, 'blog_bangumis_update', NULL, NULL, 'blog:bangumis:update', NULL, 0, 0, 1, 0, NULL, 1, '追番管理-update', NULL, NULL, NULL, 1, 0, NULL, NULL, 2, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (146, '2026-09-08 11:24:08.248707', '2026-09-08 11:24:08.248707', 142, 'blog_bangumis_delete', NULL, NULL, 'blog:bangumis:delete', NULL, 0, 0, 1, 0, NULL, 1, '追番管理-delete', NULL, NULL, NULL, 1, 0, NULL, NULL, 2, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (147, '2026-09-08 11:24:08.250118', '2026-09-22 14:36:01.000000', 83, 'blog_about', '/blog/about', 'view.blog_about', NULL, 'mdi:account-file-text-outline', 9, 0, 1, 0, NULL, 1, '关于本人管理', 'route.blog_about', 'blog_about', 0, 0, 0, NULL, NULL, 1, NULL, 2);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (148, '2026-09-08 11:24:08.251879', '2026-09-08 11:24:08.251879', 147, 'blog_about_list', NULL, NULL, 'blog:about:list', NULL, 0, 0, 1, 0, NULL, 1, '关于本人管理-list', NULL, NULL, NULL, 1, 0, NULL, NULL, 2, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (149, '2026-09-08 11:24:08.253198', '2026-09-08 11:24:08.253198', 147, 'blog_about_create', NULL, NULL, 'blog:about:create', NULL, 0, 0, 1, 0, NULL, 1, '关于本人管理-create', NULL, NULL, NULL, 1, 0, NULL, NULL, 2, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (150, '2026-09-08 11:24:08.254523', '2026-09-08 11:24:08.254523', 147, 'blog_about_update', NULL, NULL, 'blog:about:update', NULL, 0, 0, 1, 0, NULL, 1, '关于本人管理-update', NULL, NULL, NULL, 1, 0, NULL, NULL, 2, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (151, '2026-09-08 11:24:08.255717', '2026-09-08 11:24:08.255717', 147, 'blog_about_delete', NULL, NULL, 'blog:about:delete', NULL, 0, 0, 1, 0, NULL, 1, '关于本人管理-delete', NULL, NULL, NULL, 1, 0, NULL, NULL, 2, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (152, '2026-09-08 11:24:08.256872', '2026-09-22 15:14:34.412476', 83, 'blog_essays', '/blog/essays', 'view.blog_essays', NULL, 'mdi:invoice-text-arrow-left-outline', 10, 0, 1, 0, NULL, 1, '即刻短文', 'route.blog_essays', 'blog_essays', 0, 0, 0, NULL, NULL, 1, NULL, 2);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (153, '2026-09-08 11:24:08.258130', '2026-09-08 11:24:08.258130', 152, 'blog_essays_list', NULL, NULL, 'blog:essays:list', NULL, 0, 0, 1, 0, NULL, 1, '说说管理-list', NULL, NULL, NULL, 1, 0, NULL, NULL, 2, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (154, '2026-09-08 11:24:08.260382', '2026-09-08 11:24:08.260382', 152, 'blog_essays_create', NULL, NULL, 'blog:essays:create', NULL, 0, 0, 1, 0, NULL, 1, '说说管理-create', NULL, NULL, NULL, 1, 0, NULL, NULL, 2, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (155, '2026-09-08 11:24:08.261849', '2026-09-08 11:24:08.261849', 152, 'blog_essays_update', NULL, NULL, 'blog:essays:update', NULL, 0, 0, 1, 0, NULL, 1, '说说管理-update', NULL, NULL, NULL, 1, 0, NULL, NULL, 2, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (156, '2026-09-08 11:24:08.263007', '2026-09-08 11:24:08.263007', 152, 'blog_essays_delete', NULL, NULL, 'blog:essays:delete', NULL, 0, 0, 1, 0, NULL, 1, '说说管理-delete', NULL, NULL, NULL, 1, 0, NULL, NULL, 2, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (157, '2026-09-08 11:24:08.264363', '2026-09-22 14:36:49.000000', 83, 'blog_links', '/blog/links', 'view.blog_links', NULL, 'ic:outline-reduce-capacity', 11, 0, 1, 0, NULL, 1, '友链管理', 'route.blog_links', 'blog_links', 0, 0, 0, NULL, NULL, 1, NULL, 2);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (158, '2026-09-08 11:24:08.265573', '2026-09-08 11:24:08.265573', 157, 'blog_links_list', NULL, NULL, 'blog:links:list', NULL, 0, 0, 1, 0, NULL, 1, '友链管理-list', NULL, NULL, NULL, 1, 0, NULL, NULL, 2, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (159, '2026-09-08 11:24:08.266778', '2026-09-08 11:24:08.266778', 157, 'blog_links_create', NULL, NULL, 'blog:links:create', NULL, 0, 0, 1, 0, NULL, 1, '友链管理-create', NULL, NULL, NULL, 1, 0, NULL, NULL, 2, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (160, '2026-09-08 11:24:08.268759', '2026-09-08 11:24:08.268759', 157, 'blog_links_update', NULL, NULL, 'blog:links:update', NULL, 0, 0, 1, 0, NULL, 1, '友链管理-update', NULL, NULL, NULL, 1, 0, NULL, NULL, 2, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (161, '2026-09-08 11:24:08.270114', '2026-09-08 11:24:08.270114', 157, 'blog_links_delete', NULL, NULL, 'blog:links:delete', NULL, 0, 0, 1, 0, NULL, 1, '友链管理-delete', NULL, NULL, NULL, 1, 0, NULL, NULL, 2, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (162, '2026-09-08 11:24:08.271534', '2026-09-22 15:14:34.421705', 83, 'blog_moments', '/blog/moments', 'view.blog_moments', NULL, 'mdi:book-edit-outline', 12, 0, 1, 0, NULL, 1, '朋友圈管理', 'route.blog_moments', 'blog_moments', 0, 1, 0, NULL, NULL, 1, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (163, '2026-09-08 11:24:08.273045', '2026-09-08 11:24:08.273045', 162, 'blog_moments_list', NULL, NULL, 'blog:moments:list', NULL, 0, 0, 1, 0, NULL, 1, '朋友圈管理-list', NULL, NULL, NULL, 1, 0, NULL, NULL, 2, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (164, '2026-09-08 11:24:08.274434', '2026-09-08 11:24:08.274434', 162, 'blog_moments_create', NULL, NULL, 'blog:moments:create', NULL, 0, 0, 1, 0, NULL, 1, '朋友圈管理-create', NULL, NULL, NULL, 1, 0, NULL, NULL, 2, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (165, '2026-09-08 11:24:08.275593', '2026-09-08 11:24:08.275593', 162, 'blog_moments_update', NULL, NULL, 'blog:moments:update', NULL, 0, 0, 1, 0, NULL, 1, '朋友圈管理-update', NULL, NULL, NULL, 1, 0, NULL, NULL, 2, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (166, '2026-09-08 11:24:08.276963', '2026-09-08 11:24:08.276963', 162, 'blog_moments_delete', NULL, NULL, 'blog:moments:delete', NULL, 0, 0, 1, 0, NULL, 1, '朋友圈管理-delete', NULL, NULL, NULL, 1, 0, NULL, NULL, 2, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (167, '2026-09-08 11:24:08.278344', '2026-09-22 14:37:30.000000', 83, 'blog_comments', '/blog/comments', 'view.blog_comments', NULL, 'mdi:email-fast-outline', 13, 0, 1, 0, NULL, 1, '评论管理', 'route.blog_comments', 'blog_comments', 0, 0, 0, NULL, NULL, 1, NULL, 2);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (168, '2026-09-08 11:24:08.279406', '2026-09-08 11:24:08.279406', 167, 'blog_comments_list', NULL, NULL, 'blog:comments:list', NULL, 0, 0, 1, 0, NULL, 1, '评论管理-list', NULL, NULL, NULL, 1, 0, NULL, NULL, 2, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (169, '2026-09-08 11:24:08.280466', '2026-09-08 11:24:08.280466', 167, 'blog_comments_create', NULL, NULL, 'blog:comments:create', NULL, 0, 0, 1, 0, NULL, 1, '评论管理-create', NULL, NULL, NULL, 1, 0, NULL, NULL, 2, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (170, '2026-09-08 11:24:08.281536', '2026-09-08 11:24:08.281536', 167, 'blog_comments_update', NULL, NULL, 'blog:comments:update', NULL, 0, 0, 1, 0, NULL, 1, '评论管理-update', NULL, NULL, NULL, 1, 0, NULL, NULL, 2, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (171, '2026-09-08 11:24:08.282572', '2026-09-08 11:24:08.282572', 167, 'blog_comments_delete', NULL, NULL, 'blog:comments:delete', NULL, 0, 0, 1, 0, NULL, 1, '评论管理-delete', NULL, NULL, NULL, 1, 0, NULL, NULL, 2, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (172, '2026-09-08 11:24:08.283986', '2026-09-22 14:37:37.000000', 83, 'blog_collections', '/blog/collections', 'view.blog_collections', NULL, 'mdi:book-heart-outline', 14, 0, 1, 0, NULL, 1, '收藏管理', 'route.blog_collections', 'blog_collections', 0, 0, 0, NULL, NULL, 1, NULL, 2);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (173, '2026-09-08 11:24:08.285276', '2026-09-08 11:24:08.285276', 172, 'blog_collections_list', NULL, NULL, 'blog:collections:list', NULL, 0, 0, 1, 0, NULL, 1, '收藏管理-list', NULL, NULL, NULL, 1, 0, NULL, NULL, 2, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (174, '2026-09-08 11:24:08.286306', '2026-09-08 11:24:08.286306', 172, 'blog_collections_create', NULL, NULL, 'blog:collections:create', NULL, 0, 0, 1, 0, NULL, 1, '收藏管理-create', NULL, NULL, NULL, 1, 0, NULL, NULL, 2, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (175, '2026-09-08 11:24:08.287276', '2026-09-08 11:24:08.287276', 172, 'blog_collections_update', NULL, NULL, 'blog:collections:update', NULL, 0, 0, 1, 0, NULL, 1, '收藏管理-update', NULL, NULL, NULL, 1, 0, NULL, NULL, 2, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (176, '2026-09-08 11:24:08.288388', '2026-09-08 11:24:08.288388', 172, 'blog_collections_delete', NULL, NULL, 'blog:collections:delete', NULL, 0, 0, 1, 0, NULL, 1, '收藏管理-delete', NULL, NULL, NULL, 1, 0, NULL, NULL, 2, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (177, '2026-09-08 11:24:08.289435', '2026-09-22 14:37:42.000000', 83, 'blog_music', '/blog/music', 'view.blog_music', NULL, 'mdi:record-circle-outline', 15, 0, 1, 0, NULL, 1, '音乐管理', 'route.blog_music', 'blog_music', 0, 0, 0, NULL, NULL, 1, NULL, 2);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (178, '2026-09-08 11:24:08.290521', '2026-09-08 11:24:08.290521', 177, 'blog_music_list', NULL, NULL, 'blog:music:list', NULL, 0, 0, 1, 0, NULL, 1, '音乐管理-list', NULL, NULL, NULL, 1, 0, NULL, NULL, 2, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (179, '2026-09-08 11:24:08.291726', '2026-09-08 11:24:08.291726', 177, 'blog_music_create', NULL, NULL, 'blog:music:create', NULL, 0, 0, 1, 0, NULL, 1, '音乐管理-create', NULL, NULL, NULL, 1, 0, NULL, NULL, 2, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (180, '2026-09-08 11:24:08.293204', '2026-09-08 11:24:08.293204', 177, 'blog_music_update', NULL, NULL, 'blog:music:update', NULL, 0, 0, 1, 0, NULL, 1, '音乐管理-update', NULL, NULL, NULL, 1, 0, NULL, NULL, 2, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (181, '2026-09-08 11:24:08.294397', '2026-09-08 11:24:08.294397', 177, 'blog_music_delete', NULL, NULL, 'blog:music:delete', NULL, 0, 0, 1, 0, NULL, 1, '音乐管理-delete', NULL, NULL, NULL, 1, 0, NULL, NULL, 2, NULL, NULL);
INSERT INTO `sys_menu` (`id`, `created_at`, `updated_at`, `parent_id`, `name`, `path`, `component`, `permission`, `icon`, `order`, `is_ext`, `ext_open_mode`, `keep_alive`, `active_menu`, `status`, `title`, `i18n_key`, `route_name`, `icon_type`, `hide_in_menu`, `multi_tab`, `href`, `fixed_index_in_tab`, `type`, `created_by`, `updated_by`) VALUES (187, '2026-09-21 15:43:06.368100', '2026-09-21 15:43:06.368100', 5, 'tools_storage_migrate', NULL, NULL, 'tool:storage:migrate', NULL, 0, 0, 1, 0, NULL, 1, '迁移博客媒体', NULL, NULL, NULL, 1, 0, NULL, NULL, 2, NULL, NULL);
COMMIT;

-- ----------------------------
-- Table structure for sys_notice
-- ----------------------------
DROP TABLE IF EXISTS `sys_notice`;
CREATE TABLE `sys_notice` (
  `id` int NOT NULL AUTO_INCREMENT,
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  `created_by` int DEFAULT NULL COMMENT '创建人',
  `updated_by` int DEFAULT NULL COMMENT '修改者',
  `name` varchar(50) DEFAULT NULL COMMENT '公告名称',
  `content` text NOT NULL COMMENT '公告内容',
  `type` tinyint NOT NULL DEFAULT '1' COMMENT '公告类型 1 公告 2 通知',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '公告状态 1 正常 0 停用',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Records of sys_notice
-- ----------------------------
BEGIN;
INSERT INTO `sys_notice` (`id`, `created_at`, `updated_at`, `created_by`, `updated_by`, `name`, `content`, `type`, `status`) VALUES (2, '2025-04-13 16:58:43.921657', '2025-04-13 16:58:43.921657', 2, 1, '项目信息', '<ul>\n<li>前端源码地址 <a href=\"https://gitee.com/mrzym/vue3-naive-admin\" target=\"_blank\" rel=\"noopener\">gitee</a> &nbsp; &nbsp;<a href=\"https://github.com/mrzym99/vue3-naive-admin\" target=\"_blank\" rel=\"noopener\">github</a></li>\n<li>后端源码地址 <a href=\"https://gitee.com/mrzym/nest-admin\" target=\"_blank\" rel=\"noopener\">gitee</a> &nbsp; &nbsp;<a href=\"https://github.com/mrzym99/nest-admin\" target=\"_blank\" rel=\"noopener\">github</a></li>\n<li>在线预览地址 <a href=\"../\" target=\"_blank\" rel=\"noopener\">https://nest.mrzym.top/</a></li>\n<li>使用 express 作为底层web框架在 <a href=\"https://gitee.com/mrzym/nest-admin\" target=\"_blank\" rel=\"noopener\">master</a> 分支&nbsp;</li>\n<li>使用 fastify 作为底层web框架在 <a href=\"https://gitee.com/mrzym/nest-admin/tree/fastify/\" target=\"_blank\" rel=\"noopener\">fastify</a> 分支</li>\n</ul>', 1, 1);
COMMIT;

-- ----------------------------
-- Table structure for sys_parameter
-- ----------------------------
DROP TABLE IF EXISTS `sys_parameter`;
CREATE TABLE `sys_parameter` (
  `id` int NOT NULL AUTO_INCREMENT,
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '参数名称',
  `key` varchar(255) NOT NULL COMMENT '参数键',
  `value` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '参数值',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '备注',
  `created_by` int DEFAULT NULL COMMENT '创建人',
  `updated_by` int DEFAULT NULL COMMENT '修改者',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of sys_parameter
-- ----------------------------
BEGIN;
INSERT INTO `sys_parameter` (`id`, `created_at`, `updated_at`, `name`, `key`, `value`, `remark`, `created_by`, `updated_by`) VALUES (2, '2025-04-11 23:10:23.941686', '2025-04-11 23:10:23.941686', '是否校验验证码', 'login.captcha.enable', 'false', '配置 为 true 才会校验验证码、登录页面才显示验证码', NULL, 1);
INSERT INTO `sys_parameter` (`id`, `created_at`, `updated_at`, `name`, `key`, `value`, `remark`, `created_by`, `updated_by`) VALUES (3, '2025-04-11 23:10:46.253499', '2025-04-11 23:10:46.253499', '是否允许修改数据', 'auth.modify.enable', 'true', '配置为 true 时，用户有权限则可修改数据，否则除了超级管理员之外都不能修改数据，用于演示系统时使用', NULL, 1);
COMMIT;

-- ----------------------------
-- Table structure for sys_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_role`;
CREATE TABLE `sys_role` (
  `id` int NOT NULL AUTO_INCREMENT,
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '角色名称',
  `value` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '角色标识',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '角色描述',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '角色状态 1 启用 0 禁用',
  `default` tinyint DEFAULT NULL COMMENT '是否系统默认角色',
  `created_by` int DEFAULT NULL COMMENT '创建人',
  `updated_by` int DEFAULT NULL COMMENT '修改者',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `IDX_223de54d6badbe43a5490450c3` (`name`),
  UNIQUE KEY `IDX_05edc0a51f41bb16b7d8137da9` (`value`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of sys_role
-- ----------------------------
BEGIN;
INSERT INTO `sys_role` (`id`, `created_at`, `updated_at`, `name`, `value`, `description`, `status`, `default`, `created_by`, `updated_by`) VALUES (1, '2025-04-09 16:37:40.000000', '2025-04-09 16:37:40.000000', '超级管理员', 'superadmin', 'I\'m the most awesome.', 1, 0, NULL, 1);
INSERT INTO `sys_role` (`id`, `created_at`, `updated_at`, `name`, `value`, `description`, `status`, `default`, `created_by`, `updated_by`) VALUES (2, '2025-04-09 16:37:40.000000', '2025-04-13 10:44:36.017308', '管理员', 'admin', '管理员', 1, 0, 1, 1);
INSERT INTO `sys_role` (`id`, `created_at`, `updated_at`, `name`, `value`, `description`, `status`, `default`, `created_by`, `updated_by`) VALUES (3, '2025-04-09 16:37:40.000000', '2025-04-09 16:37:40.000000', '测试', 'test', '测试角色', 1, 1, NULL, 1);
INSERT INTO `sys_role` (`id`, `created_at`, `updated_at`, `name`, `value`, `description`, `status`, `default`, `created_by`, `updated_by`) VALUES (4, '2025-04-09 16:37:40.000000', '2025-04-09 16:37:40.000000', '游客', 'guest', '游客', 1, 0, NULL, 1);
INSERT INTO `sys_role` (`id`, `created_at`, `updated_at`, `name`, `value`, `description`, `status`, `default`, `created_by`, `updated_by`) VALUES (10, '2026-09-09 14:13:51.817125', '2026-09-09 14:13:51.817125', '博客管理员', 'blogadmin', '博客管理员', 1, 0, 1, NULL);
COMMIT;

-- ----------------------------
-- Table structure for sys_role_menus
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_menus`;
CREATE TABLE `sys_role_menus` (
  `role_id` int NOT NULL,
  `menu_id` int NOT NULL,
  PRIMARY KEY (`role_id`,`menu_id`) USING BTREE,
  KEY `IDX_35ce749b04d57e226d059e0f63` (`role_id`),
  KEY `IDX_2b95fdc95b329d66c18f5baed6` (`menu_id`),
  CONSTRAINT `FK_2b95fdc95b329d66c18f5baed6d` FOREIGN KEY (`menu_id`) REFERENCES `sys_menu` (`id`) ON DELETE CASCADE,
  CONSTRAINT `FK_35ce749b04d57e226d059e0f633` FOREIGN KEY (`role_id`) REFERENCES `sys_role` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of sys_role_menus
-- ----------------------------
BEGIN;
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 1);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 2);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 3);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 4);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 5);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 6);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 7);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 8);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 9);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 10);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 11);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 12);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 13);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 14);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 15);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 16);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 17);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 18);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 19);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 20);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 21);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 22);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 23);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 24);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 25);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 26);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 27);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 28);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 29);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 30);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 31);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 32);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 33);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 34);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 35);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 36);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 37);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 39);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 40);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 41);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 42);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 43);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 44);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 45);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 46);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 47);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 48);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 50);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 51);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 52);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 53);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 54);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 55);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 56);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 57);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 58);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 59);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 60);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 61);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 62);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 63);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 64);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 65);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 66);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 67);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 68);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 69);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 70);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 71);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 72);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 73);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 74);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 75);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 76);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 77);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 78);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 79);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 80);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 81);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 82);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 83);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 87);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 88);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 89);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 90);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 109);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 110);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 111);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 112);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 113);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 114);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 115);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 116);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 117);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 118);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 119);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 120);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 121);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 122);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 123);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 124);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 125);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 126);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 127);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 128);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 129);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 130);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 131);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 132);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 133);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 134);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 135);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 136);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 138);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 139);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 140);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 141);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 142);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 143);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 144);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 145);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 146);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 147);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 148);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 149);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 150);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 151);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 152);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 153);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 154);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 155);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 156);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 157);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 158);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 159);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 160);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 161);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 162);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 163);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 164);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 165);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 166);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 167);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 168);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 169);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 170);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 171);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 172);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 173);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 174);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 175);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 176);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 177);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 178);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 179);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 180);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (1, 181);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (2, 2);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (2, 3);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (2, 4);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (2, 5);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (2, 6);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (2, 7);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (2, 8);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (2, 9);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (2, 10);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (2, 11);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (2, 12);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (2, 13);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (2, 14);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (2, 15);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (2, 16);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (2, 17);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (2, 18);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (2, 19);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (2, 20);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (2, 21);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (2, 22);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (2, 23);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (2, 24);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (2, 25);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (2, 26);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (2, 27);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (2, 28);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (2, 29);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (2, 30);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (2, 31);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (2, 32);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (2, 33);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (2, 34);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (2, 35);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (2, 36);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (2, 37);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (2, 39);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (2, 40);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (2, 41);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (2, 42);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (2, 43);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (2, 44);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (2, 45);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (2, 46);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (2, 47);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (2, 48);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (2, 50);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (2, 51);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (2, 52);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (2, 53);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (2, 54);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (2, 55);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (2, 56);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (2, 57);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (2, 58);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (2, 59);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (2, 60);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (2, 61);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (2, 62);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (2, 63);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (2, 64);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (2, 65);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (2, 66);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (2, 67);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (2, 68);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (2, 69);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (2, 70);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (2, 71);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (2, 72);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (2, 73);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (2, 74);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (2, 75);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (2, 76);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (2, 77);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (2, 78);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (2, 79);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (2, 80);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (2, 81);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (2, 82);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (2, 87);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (2, 88);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (2, 89);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (2, 90);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (2, 98);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (2, 99);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (2, 100);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (2, 101);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (2, 102);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (2, 103);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (2, 104);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (2, 105);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (2, 106);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (2, 107);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (2, 108);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (3, 5);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (3, 7);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (3, 8);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (3, 10);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (3, 12);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (3, 13);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (3, 16);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (3, 17);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (3, 18);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (3, 20);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (3, 21);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (3, 26);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (3, 27);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (3, 29);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (3, 30);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (3, 31);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (3, 32);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (3, 35);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (3, 36);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (3, 37);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (3, 39);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (3, 40);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (3, 42);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (3, 44);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (3, 45);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (3, 46);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (3, 47);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (3, 51);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (3, 52);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (3, 53);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (3, 54);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (3, 55);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (3, 58);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (3, 59);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (3, 61);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (3, 63);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (3, 65);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (3, 67);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (3, 71);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (3, 72);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (3, 73);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (3, 74);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (3, 77);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (3, 78);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (3, 79);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (3, 87);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (3, 88);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (3, 89);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (3, 98);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (3, 99);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (3, 100);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (3, 104);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (3, 108);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (4, 10);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (4, 26);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (4, 29);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (4, 31);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (4, 44);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (4, 65);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (4, 67);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (4, 78);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (4, 79);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (4, 99);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (4, 100);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (10, 65);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (10, 83);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (10, 109);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (10, 110);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (10, 111);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (10, 112);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (10, 113);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (10, 114);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (10, 115);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (10, 116);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (10, 117);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (10, 118);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (10, 119);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (10, 120);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (10, 121);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (10, 122);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (10, 123);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (10, 124);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (10, 125);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (10, 126);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (10, 127);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (10, 128);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (10, 129);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (10, 130);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (10, 131);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (10, 132);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (10, 133);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (10, 134);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (10, 135);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (10, 136);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (10, 138);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (10, 139);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (10, 140);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (10, 141);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (10, 142);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (10, 143);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (10, 144);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (10, 145);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (10, 146);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (10, 147);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (10, 148);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (10, 149);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (10, 150);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (10, 151);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (10, 152);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (10, 153);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (10, 154);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (10, 155);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (10, 156);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (10, 157);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (10, 158);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (10, 159);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (10, 160);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (10, 161);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (10, 162);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (10, 163);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (10, 164);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (10, 165);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (10, 166);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (10, 167);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (10, 168);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (10, 169);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (10, 170);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (10, 171);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (10, 172);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (10, 173);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (10, 174);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (10, 175);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (10, 176);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (10, 177);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (10, 178);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (10, 179);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (10, 180);
INSERT INTO `sys_role_menus` (`role_id`, `menu_id`) VALUES (10, 181);
COMMIT;

-- ----------------------------
-- Table structure for sys_task
-- ----------------------------
DROP TABLE IF EXISTS `sys_task`;
CREATE TABLE `sys_task` (
  `id` int NOT NULL AUTO_INCREMENT,
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '任务名称',
  `service` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '任务服务',
  `type` tinyint NOT NULL DEFAULT '1' COMMENT '任务类型 1:cron 2:interval',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '任务状态 1 启用 0 禁用',
  `start_time` datetime DEFAULT NULL COMMENT '开始时间',
  `end_time` datetime DEFAULT NULL COMMENT '结束时间',
  `limit` int DEFAULT '0' COMMENT '限制执行次数，负数则无限制',
  `every` int DEFAULT NULL COMMENT '执行间隔，毫秒单位',
  `data` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '执行数据',
  `jobOpts` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '执行选项配置',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '备注',
  `cron` varchar(255) DEFAULT NULL COMMENT 'Cron表达式',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of sys_task
-- ----------------------------
BEGIN;
INSERT INTO `sys_task` (`id`, `created_at`, `updated_at`, `name`, `service`, `type`, `status`, `start_time`, `end_time`, `limit`, `every`, `data`, `jobOpts`, `remark`, `cron`) VALUES (5, '2025-04-11 23:18:04.075099', '2025-04-11 23:18:04.075099', '清除登录日志', 'LogClearJob.clearLoginLog', 0, 0, NULL, NULL, -1, 60000, '', '{\"count\":1,\"key\":\"__default__:5:::0 0 3 * * 1\",\"cron\":\"0 0 3 * * 1\",\"jobId\":5}', '0 秒：表示第0秒。\n0 分钟：表示在小时的第0分钟。\n3 小时：表示在凌晨3点。\n* 日期：表示每天。\n* 月份：表示每个月。\n1 星期中星期几：1 表示星期一', '0 0 3 * * 1');
INSERT INTO `sys_task` (`id`, `created_at`, `updated_at`, `name`, `service`, `type`, `status`, `start_time`, `end_time`, `limit`, `every`, `data`, `jobOpts`, `remark`, `cron`) VALUES (6, '2025-04-11 23:18:36.212907', '2025-04-11 23:18:36.212907', '清除验证码日志', 'LogClearJob.clearCaptchaLog', 0, 0, NULL, NULL, -1, 60000, '', '{\"count\":1,\"key\":\"__default__:6:::0 0 3 * * 1\",\"cron\":\"0 0 3 * * 1\",\"jobId\":6}', '', '0 0 3 * * 1');
INSERT INTO `sys_task` (`id`, `created_at`, `updated_at`, `name`, `service`, `type`, `status`, `start_time`, `end_time`, `limit`, `every`, `data`, `jobOpts`, `remark`, `cron`) VALUES (7, '2025-04-11 23:18:56.168804', '2025-04-11 23:18:56.168804', '清除任务日志', 'LogClearJob.clearTaskLog', 0, 0, NULL, NULL, -1, 60000, '', '{\"count\":1,\"key\":\"__default__:7:::0 0 3 * * 1\",\"cron\":\"0 0 3 * * 1\",\"jobId\":7}', '', '0 0 3 * * 1');
INSERT INTO `sys_task` (`id`, `created_at`, `updated_at`, `name`, `service`, `type`, `status`, `start_time`, `end_time`, `limit`, `every`, `data`, `jobOpts`, `remark`, `cron`) VALUES (10, '2025-04-13 02:51:33.521935', '2025-04-13 02:51:33.521935', '删除过期的access_token', 'TokenClearJob.clearExpiredAccessToken', 0, 0, NULL, NULL, -1, 60000, '', '{\"count\":1,\"key\":\"__default__:10:::0 0 3 * * ?\",\"cron\":\"0 0 3 * * ?\",\"jobId\":10}', '', '0 0 3 * * ?');
INSERT INTO `sys_task` (`id`, `created_at`, `updated_at`, `name`, `service`, `type`, `status`, `start_time`, `end_time`, `limit`, `every`, `data`, `jobOpts`, `remark`, `cron`) VALUES (11, '2025-04-13 02:55:47.921729', '2025-04-13 02:55:47.921729', '删除过期的RefreshToken', 'TokenClearJob.clearExpiredRefreshToken', 0, 0, NULL, NULL, -1, 60000, '', '{\"count\":1,\"key\":\"__default__:11:::0 0 3 * * 1\",\"cron\":\"0 0 3 * * 1\",\"jobId\":11}', '', '0 0 3 * * 1');
COMMIT;

-- ----------------------------
-- Table structure for sys_task_log
-- ----------------------------
DROP TABLE IF EXISTS `sys_task_log`;
CREATE TABLE `sys_task_log` (
  `id` int NOT NULL AUTO_INCREMENT,
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  `status` tinyint NOT NULL DEFAULT '0' COMMENT '任务状态 1 成功 0 失败',
  `detail` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '任务日志信息',
  `consume_time` int DEFAULT '0' COMMENT '任务耗时',
  `task_id` int DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `FK_f4d9c36052fdb188ff5c089454b` (`task_id`),
  CONSTRAINT `FK_f4d9c36052fdb188ff5c089454b` FOREIGN KEY (`task_id`) REFERENCES `sys_task` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of sys_task_log
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for sys_user_roles
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_roles`;
CREATE TABLE `sys_user_roles` (
  `user_id` int NOT NULL,
  `role_id` int NOT NULL,
  PRIMARY KEY (`user_id`,`role_id`) USING BTREE,
  KEY `IDX_96311d970191a044ec048011f4` (`user_id`),
  KEY `IDX_6d61c5b3f76a3419d93a421669` (`role_id`),
  CONSTRAINT `FK_6d61c5b3f76a3419d93a4216695` FOREIGN KEY (`role_id`) REFERENCES `sys_role` (`id`),
  CONSTRAINT `FK_96311d970191a044ec048011f44` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of sys_user_roles
-- ----------------------------
BEGIN;
INSERT INTO `sys_user_roles` (`user_id`, `role_id`) VALUES (1, 1);
INSERT INTO `sys_user_roles` (`user_id`, `role_id`) VALUES (2, 2);
INSERT INTO `sys_user_roles` (`user_id`, `role_id`) VALUES (2, 10);
INSERT INTO `sys_user_roles` (`user_id`, `role_id`) VALUES (3, 3);
INSERT INTO `sys_user_roles` (`user_id`, `role_id`) VALUES (4, 4);
COMMIT;

-- ----------------------------
-- Table structure for tool_storage
-- ----------------------------
DROP TABLE IF EXISTS `tool_storage`;
CREATE TABLE `tool_storage` (
  `id` int NOT NULL AUTO_INCREMENT,
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  `name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '文件名',
  `fileName` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '真实文件名',
  `ext_name` varchar(255) DEFAULT NULL,
  `path` varchar(255) NOT NULL,
  `type` varchar(255) DEFAULT NULL,
  `size` varchar(255) DEFAULT NULL,
  `user_id` varchar(255) DEFAULT NULL,
  `visibility` varchar(16) NOT NULL DEFAULT 'public',
  `source` varchar(24) NOT NULL DEFAULT 'general',
  `storage_key` varchar(500) DEFAULT NULL,
  `provider` varchar(20) DEFAULT NULL,
  `blog_media_id` int DEFAULT NULL,
  `mime` varchar(100) DEFAULT NULL,
  `storage_profile` text,
  `previous_locations` longtext,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `IDX_be417768130394d6c265cc5783` (`blog_media_id`)
) ENGINE=InnoDB AUTO_INCREMENT=169 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of tool_storage
-- ----------------------------
BEGIN;
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (14, '2025-04-28 00:53:34.475768', '2025-04-28 00:53:34.475768', '1745772814472-u=2978468399,3739141687&fm=253&fmt=auto&app=120&f=JPEG.webp', 'u=2978468399,3739141687&fm=253&fmt=auto&app=120&f=JPEG.webp', 'webp', '/upload/2025-04-28/other/1745772814472-u=2978468399,3739141687&fm=253&fmt=auto&app=120&f=JPEG.webp', 'other', '50.13 KB', '1', 'public', 'general', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (15, '2026-09-10 15:26:09.462164', '2026-09-10 15:26:09.462164', '1789025169455-å®å®æç©º.webp', 'å®å®æç©º.webp', 'webp', '/upload/2026-09-10/other/1789025169455-å®å®æç©º.webp', 'other', '89.33 KB', '2', 'public', 'general', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (16, '2026-09-20 14:44:03.876172', '2026-09-20 14:44:03.876172', 'æ±¤å§é®ç®±ï¼æ¼«ï¼.JPG', 'æ±¤å§é®ç®±ï¼æ¼«ï¼.JPG', 'JPG', '/blog-media/6', 'image', '97330 B', '2', 'private', 'blog', 'legacy-blog-private/bc9a5595-ba01-4921-b571-aba957bd7b00', 'local', 6, 'image/jpeg', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (17, '2026-09-20 14:44:25.262747', '2026-09-20 14:44:25.262747', '1625-1182619662.jpeg', '1625-1182619662.jpeg', 'jpeg', '/blog-media/7', 'image', '62875 B', '2', 'private', 'blog', 'legacy-blog-private/8dbe557d-25dd-449c-9187-0f0c286dbf5d', 'local', 7, 'image/jpeg', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (18, '2026-09-20 14:45:48.088543', '2026-09-20 14:45:48.088543', 'img169.jpg', 'img169.jpg', 'jpg', '/blog-media/8', 'image', '314943 B', '2', 'private', 'blog', 'legacy-blog-private/55c2f484-17ea-4b4a-bab8-0fe9bc5ccf32', 'local', 8, 'image/jpeg', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (19, '2026-09-20 14:45:55.884986', '2026-09-20 14:45:55.884986', 'img6.jpg', 'img6.jpg', 'jpg', '/blog-media/9', 'image', '251313 B', '2', 'private', 'blog', 'legacy-blog-private/bc08987c-db11-4524-a247-72e2b242688a', 'local', 9, 'image/jpeg', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (20, '2026-09-20 14:46:26.066124', '2026-09-20 14:46:26.066124', 'img10.jpg', 'img10.jpg', 'jpg', '/blog-media/10', 'image', '320913 B', '2', 'private', 'blog', 'legacy-blog-private/128be3a0-723d-4791-ac3e-426d1eda8d15', 'local', 10, 'image/jpeg', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (21, '2026-09-20 14:48:44.855018', '2026-09-20 14:48:44.855018', 'img191.jpg', 'img191.jpg', 'jpg', '/blog-media/11', 'image', '238383 B', '2', 'private', 'blog', 'legacy-blog-private/484047ff-e026-4b9e-aa19-47dbcba760d1', 'local', 11, 'image/jpeg', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (22, '2026-09-20 14:49:04.611401', '2026-09-20 14:49:04.611401', 'img2.jpg', 'img2.jpg', 'jpg', '/blog-media/12', 'image', '508048 B', '2', 'private', 'blog', 'legacy-blog-private/e9477864-e3e8-48e1-893c-b80bd4e9c3a8', 'local', 12, 'image/jpeg', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (23, '2026-09-20 14:50:40.485297', '2026-09-20 14:50:40.485297', 'img8.jpg', 'img8.jpg', 'jpg', '/blog-media/13', 'image', '136545 B', '2', 'private', 'blog', 'legacy-blog-private/4ec8a8be-dfe8-47c8-854b-624f11d6dba5', 'local', 13, 'image/jpeg', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (24, '2026-09-20 14:51:00.753969', '2026-09-20 14:51:00.753969', '37550a78bb6abcc036f2125fb8b77a3b.JPG', '37550a78bb6abcc036f2125fb8b77a3b.JPG', 'JPG', '/blog-media/14', 'image', '38745 B', '2', 'private', 'blog', 'legacy-blog-private/b4acd4c6-9d56-4758-9556-d5ab1ec5b6ec', 'local', 14, 'image/jpeg', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (25, '2026-09-20 16:58:48.583289', '2026-09-20 16:58:48.583289', 'img6.jpg', 'img6.jpg', 'jpg', '/blog-media/15', 'image', '251313 B', '2', 'private', 'blog', 'legacy-blog-private/5adb00ff-e2a4-4f83-94a8-df8977cc7756', 'local', 15, 'image/jpeg', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (26, '2026-09-20 16:59:06.039981', '2026-09-20 16:59:06.039981', 'img9.jpg', 'img9.jpg', 'jpg', '/blog-media/16', 'image', '258042 B', '2', 'private', 'blog', 'legacy-blog-private/144e8f71-5b51-4385-ab2a-46aacdfbaec2', 'local', 16, 'image/jpeg', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (27, '2026-09-20 16:59:17.885559', '2026-09-20 16:59:17.885559', 'img14.jpg', 'img14.jpg', 'jpg', '/blog-media/17', 'image', '305695 B', '2', 'private', 'blog', 'legacy-blog-private/6de13faa-f363-4d90-abe8-877aa0d24dba', 'local', 17, 'image/jpeg', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (28, '2026-09-20 16:59:28.042246', '2026-09-20 16:59:28.042246', 'img16.jpg', 'img16.jpg', 'jpg', '/blog-media/18', 'image', '274427 B', '2', 'private', 'blog', 'legacy-blog-private/1a85b333-7365-4653-8b97-51f501742be8', 'local', 18, 'image/jpeg', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (29, '2026-09-20 17:08:04.968915', '2026-09-20 17:08:04.968915', 'ç»ç­-ç­ç±105Â°çä½ (èå).mp4', 'ç»ç­-ç­ç±105Â°çä½ (èå).mp4', 'mp4', '/blog-media/19', 'video', '16332014 B', '2', 'private', 'blog', 'legacy-blog-private/aefa4b19-c84d-4ae7-940c-c6719b6178cd', 'local', 19, 'video/mp4', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (30, '2026-09-20 18:06:55.769810', '2026-09-20 18:06:55.769810', 'img3.jpg', 'img3.jpg', 'jpg', '/blog-media/20', 'image', '510185 B', '2', 'private', 'blog', 'legacy-blog-private/d1a51d02-c6f9-4e1f-9b1d-20fcabecd339', 'local', 20, 'image/jpeg', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (31, '2026-09-21 09:46:05.550132', '2026-09-21 09:46:05.550132', 'æé³å¾å±á¥«á©£.HEIC', 'æé³å¾å±á¥«á©£.HEIC', 'HEIC', '/blog-media/21', 'video', '135938 B', '2', 'private', 'blog', 'legacy-blog-private/d2785c1c-a0a3-4f1c-8e3d-090d1c9dacfb', 'local', 21, 'video/mp4', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (32, '2026-09-21 09:46:33.160001', '2026-09-21 09:46:33.160001', 'img411.jpg', 'img411.jpg', 'jpg', '/blog-media/22', 'image', '276739 B', '2', 'private', 'blog', 'legacy-blog-private/6cbea557-33bb-4a22-af0f-fdda73767031', 'local', 22, 'image/jpeg', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (33, '2026-09-21 09:46:48.424089', '2026-09-21 09:46:48.424089', 'img409.jpg', 'img409.jpg', 'jpg', '/blog-media/23', 'image', '134542 B', '2', 'private', 'blog', 'legacy-blog-private/bd27e539-d187-4a75-9672-367e07a0492a', 'local', 23, 'image/jpeg', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (34, '2026-09-21 09:47:52.216146', '2026-09-21 09:47:52.216146', 'img410.jpg', 'img410.jpg', 'jpg', '/blog-media/24', 'image', '109508 B', '2', 'private', 'blog', 'legacy-blog-private/9c8d5326-3a20-4bb1-a317-00458d36ac0a', 'local', 24, 'image/jpeg', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (35, '2026-09-21 09:47:59.837357', '2026-09-21 09:47:59.837357', 'img407.jpg', 'img407.jpg', 'jpg', '/blog-media/25', 'image', '228676 B', '2', 'private', 'blog', 'legacy-blog-private/054cac9d-48dc-4cb5-a5fc-e0156682be4a', 'local', 25, 'image/jpeg', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (36, '2026-09-21 09:48:09.209989', '2026-09-21 09:48:09.209989', 'img642.jpg', 'img642.jpg', 'jpg', '/blog-media/26', 'image', '243911 B', '2', 'private', 'blog', 'legacy-blog-private/d5be9213-352e-469c-95fa-93fe2dd027b8', 'local', 26, 'image/jpeg', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (37, '2026-09-21 09:48:19.562070', '2026-09-21 09:48:19.562070', 'img414.jpg', 'img414.jpg', 'jpg', '/blog-media/27', 'image', '142762 B', '2', 'private', 'blog', 'legacy-blog-private/9d0dfaaa-299b-4826-95a7-1648fbd526b6', 'local', 27, 'image/jpeg', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (38, '2026-09-21 10:26:31.384290', '2026-09-21 10:26:31.384290', 'img409.jpg', 'img409.jpg', 'jpg', '/blog-media/28', 'image', '134542 B', '2', 'private', 'blog', 'legacy-blog-private/82dc7a05-847a-45d2-8869-6167ee64cfe8', 'local', 28, 'image/jpeg', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (39, '2026-09-21 11:09:40.559792', '2026-09-21 11:09:40.559792', 'img516.jpg', 'img516.jpg', 'jpg', '/blog-media/29', 'image', '134224 B', '2', 'private', 'blog', 'legacy-blog-private/115a64e6-e633-4e5b-b4b4-e1b4f0bf13f8', 'local', 29, 'image/jpeg', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (40, '2026-09-21 14:03:34.131510', '2026-09-21 14:03:34.131510', 'img407.jpg', 'img407.jpg', 'jpg', '/blog-media/30', 'image', '228676 B', '2', 'private', 'blog', 'legacy-blog-private/b0013500-9b26-40bb-8c20-fe73090cfbe3', 'local', 30, 'image/jpeg', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (53, '2026-09-21 16:07:09.885054', '2026-09-21 16:07:09.885054', 'img408.jpg', 'img408.jpg', 'jpg', '/blog-media/35', 'image', '132.83 KB', '2', 'private', 'blog', 'storage/blog-private/270f2c07-9019-4b8c-b992-e68294ef5de0.jpg', 'local', 35, 'image/jpeg', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (54, '2026-09-21 16:08:30.203905', '2026-09-21 16:08:30.203905', 'img409.jpg', 'img409.jpg', 'jpg', '/blog-media/36', 'image', '131.39 KB', '2', 'private', 'blog', 'storage/blog-private/e7b8d566-bf23-4278-9973-523c10e128f3.jpg', 'local', 36, 'image/jpeg', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (55, '2026-09-21 16:08:49.828028', '2026-09-21 16:08:49.828028', 'img414.jpg', 'img414.jpg', 'jpg', '/blog-media/37', 'image', '139.42 KB', '2', 'private', 'blog', 'storage/blog-private/b94e34d3-86a6-441a-be8a-d4f3a6c81400.jpg', 'local', 37, 'image/jpeg', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (56, '2026-09-21 16:24:16.159669', '2026-09-21 16:24:16.159669', '760495b66551e2abf32c7a188085c7af.mp4', '760495b66551e2abf32c7a188085c7af.mp4', 'mp4', '/blog-media/38', 'video', '475.47 KB', '2', 'private', 'blog', 'storage/blog-private/44923a4c-3a3b-4450-8b8b-e4ec6b8da4ae.mp4', 'local', 38, 'video/mp4', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (62, '2026-09-21 16:32:34.508520', '2026-09-21 16:32:34.508520', 'img1.jpg', 'img1.jpg', 'jpg', '/blog-media/43', 'image', '371.72 KB', '2', 'private', 'blog', 'storage/blog-private/33873e83-814e-4db2-81e3-637d33e4b652.jpg', 'local', 43, 'image/jpeg', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (63, '2026-09-21 16:32:34.623118', '2026-09-21 16:32:34.623118', 'img2.jpg', 'img2.jpg', 'jpg', '/blog-media/44', 'image', '496.14 KB', '2', 'private', 'blog', 'storage/blog-private/6b1d0fa0-1d37-4387-a669-37e2d9a9a191.jpg', 'local', 44, 'image/jpeg', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (64, '2026-09-21 16:32:34.710689', '2026-09-21 16:32:34.710689', 'img3.jpg', 'img3.jpg', 'jpg', '/blog-media/45', 'image', '498.23 KB', '2', 'private', 'blog', 'storage/blog-private/61db9017-b035-4a4c-9201-7a95894e8619.jpg', 'local', 45, 'image/jpeg', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (65, '2026-09-21 16:32:34.821397', '2026-09-21 16:32:34.821397', 'img4.jpg', 'img4.jpg', 'jpg', '/blog-media/46', 'image', '465.92 KB', '2', 'private', 'blog', 'storage/blog-private/ffe3bea8-1740-4893-bd3d-69ed3c4dab5c.jpg', 'local', 46, 'image/jpeg', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (66, '2026-09-21 16:32:34.884460', '2026-09-21 16:32:34.884460', 'img5.jpg', 'img5.jpg', 'jpg', '/blog-media/47', 'image', '227.66 KB', '2', 'private', 'blog', 'storage/blog-private/c4325ecd-ebfb-4e9c-b57f-7c3290ae346e.jpg', 'local', 47, 'image/jpeg', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (67, '2026-09-21 16:32:34.963679', '2026-09-21 16:32:34.963679', 'img6.jpg', 'img6.jpg', 'jpg', '/blog-media/48', 'image', '245.42 KB', '2', 'private', 'blog', 'storage/blog-private/bdde9fad-248e-4ef0-9365-f178c59616c7.jpg', 'local', 48, 'image/jpeg', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (68, '2026-09-21 16:32:35.078471', '2026-09-21 16:32:35.078471', 'img7.jpg', 'img7.jpg', 'jpg', '/blog-media/49', 'image', '300.94 KB', '2', 'private', 'blog', 'storage/blog-private/a48d4061-fe06-4cbe-91c2-7a607b069f1a.jpg', 'local', 49, 'image/jpeg', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (69, '2026-09-21 16:32:35.141902', '2026-09-21 16:32:35.141902', 'img8.jpg', 'img8.jpg', 'jpg', '/blog-media/50', 'image', '133.34 KB', '2', 'private', 'blog', 'storage/blog-private/c70999a5-25d3-4569-b2f4-d140f5d39b6b.jpg', 'local', 50, 'image/jpeg', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (70, '2026-09-21 16:32:35.213308', '2026-09-21 16:32:35.213308', 'img9.jpg', 'img9.jpg', 'jpg', '/blog-media/51', 'image', '251.99 KB', '2', 'private', 'blog', 'storage/blog-private/da1dc14d-c033-4c18-88cc-29ed4c80c635.jpg', 'local', 51, 'image/jpeg', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (71, '2026-09-21 16:32:35.266875', '2026-09-21 16:32:35.266875', 'img10.jpg', 'img10.jpg', 'jpg', '/blog-media/52', 'image', '313.39 KB', '2', 'private', 'blog', 'storage/blog-private/86fe1cd9-3161-459c-9d98-793508da198e.jpg', 'local', 52, 'image/jpeg', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (72, '2026-09-21 16:32:35.415190', '2026-09-21 16:32:35.415190', 'img11.jpg', 'img11.jpg', 'jpg', '/blog-media/53', 'image', '590.34 KB', '2', 'private', 'blog', 'storage/blog-private/a35d0731-ce71-4575-9fec-9a82893f91c2.jpg', 'local', 53, 'image/jpeg', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (73, '2026-09-21 16:33:22.649285', '2026-09-21 16:33:22.649285', 'img1.jpg', 'img1.jpg', 'jpg', '/blog-media/54', 'image', '371.72 KB', '2', 'private', 'blog', 'storage/blog-private/7e59e10e-23c7-4b5a-9cfc-bb9f78ff91cd.jpg', 'local', 54, 'image/jpeg', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (74, '2026-09-21 16:33:22.876504', '2026-09-21 16:33:22.876504', 'img2.jpg', 'img2.jpg', 'jpg', '/blog-media/55', 'image', '496.14 KB', '2', 'private', 'blog', 'storage/blog-private/b937d8db-9e11-4d17-ad8b-4561d11f6e46.jpg', 'local', 55, 'image/jpeg', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (75, '2026-09-21 16:33:23.521251', '2026-09-21 16:33:23.521251', 'img3.jpg', 'img3.jpg', 'jpg', '/blog-media/56', 'image', '498.23 KB', '2', 'private', 'blog', 'storage/blog-private/d9b82dbd-c0cf-4e90-bd7a-cfd169a03dd5.jpg', 'local', 56, 'image/jpeg', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (76, '2026-09-21 16:33:23.791488', '2026-09-21 16:33:23.791488', 'img4.jpg', 'img4.jpg', 'jpg', '/blog-media/57', 'image', '465.92 KB', '2', 'private', 'blog', 'storage/blog-private/7d932fbf-9437-410d-9d52-de4b55dcb35e.jpg', 'local', 57, 'image/jpeg', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (77, '2026-09-21 16:33:24.039994', '2026-09-21 16:33:24.039994', 'img5.jpg', 'img5.jpg', 'jpg', '/blog-media/58', 'image', '227.66 KB', '2', 'private', 'blog', 'storage/blog-private/df1aa508-06c8-401a-b494-c524b3b97afd.jpg', 'local', 58, 'image/jpeg', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (78, '2026-09-21 16:33:26.133463', '2026-09-21 16:33:26.133463', 'img6.jpg', 'img6.jpg', 'jpg', '/blog-media/59', 'image', '245.42 KB', '2', 'private', 'blog', 'storage/blog-private/9b37ee9b-8fee-48a3-acfd-59cc4a278577.jpg', 'local', 59, 'image/jpeg', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (79, '2026-09-21 16:33:26.328585', '2026-09-21 16:33:26.328585', 'img7.jpg', 'img7.jpg', 'jpg', '/blog-media/60', 'image', '300.94 KB', '2', 'private', 'blog', 'storage/blog-private/167c88e2-6110-41b4-a34e-89cc8a496b3e.jpg', 'local', 60, 'image/jpeg', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (80, '2026-09-21 16:33:26.400312', '2026-09-21 16:33:26.400312', 'img8.jpg', 'img8.jpg', 'jpg', '/blog-media/61', 'image', '133.34 KB', '2', 'private', 'blog', 'storage/blog-private/42b59779-13b9-4fbf-a769-b69e7c5ed950.jpg', 'local', 61, 'image/jpeg', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (81, '2026-09-21 16:33:26.982579', '2026-09-21 16:33:26.982579', 'img9.jpg', 'img9.jpg', 'jpg', '/blog-media/62', 'image', '251.99 KB', '2', 'private', 'blog', 'storage/blog-private/f79151e8-650f-4920-98ed-d6ec2198be0d.jpg', 'local', 62, 'image/jpeg', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (82, '2026-09-21 16:33:27.090623', '2026-09-21 16:33:27.090623', 'img10.jpg', 'img10.jpg', 'jpg', '/blog-media/63', 'image', '313.39 KB', '2', 'private', 'blog', 'storage/blog-private/4a3bd025-805a-4c66-9c03-11f6682029d3.jpg', 'local', 63, 'image/jpeg', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (83, '2026-09-21 16:33:27.384395', '2026-09-21 16:33:27.384395', 'img11.jpg', 'img11.jpg', 'jpg', '/blog-media/64', 'image', '590.34 KB', '2', 'private', 'blog', 'storage/blog-private/99676ba1-182d-482b-bcf3-382b59a7662e.jpg', 'local', 64, 'image/jpeg', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (84, '2026-09-21 16:33:27.565317', '2026-09-21 16:33:27.565317', 'img12.jpg', 'img12.jpg', 'jpg', '/blog-media/65', 'image', '371.98 KB', '2', 'private', 'blog', 'storage/blog-private/493546a7-637d-4c8e-bcf5-aaa43054687e.jpg', 'local', 65, 'image/jpeg', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (85, '2026-09-21 16:33:27.698264', '2026-09-21 16:33:27.698264', 'img13.jpg', 'img13.jpg', 'jpg', '/blog-media/66', 'image', '294 KB', '2', 'private', 'blog', 'storage/blog-private/bc2e9058-5956-4df1-a8d0-598f1d84a17b.jpg', 'local', 66, 'image/jpeg', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (86, '2026-09-21 16:34:30.802619', '2026-09-21 16:34:30.802619', 'img1.jpg', 'img1.jpg', 'jpg', '/blog-media/67', 'image', '371.72 KB', '2', 'private', 'blog', 'storage/blog-private/3921621b-193a-4371-8f04-1792a98972ad.jpg', 'local', 67, 'image/jpeg', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (87, '2026-09-21 16:34:31.005809', '2026-09-21 16:34:31.005809', 'img2.jpg', 'img2.jpg', 'jpg', '/blog-media/68', 'image', '496.14 KB', '2', 'private', 'blog', 'storage/blog-private/b2a06898-ffd7-4de7-b407-0c11f2ec9199.jpg', 'local', 68, 'image/jpeg', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (88, '2026-09-21 16:34:31.065742', '2026-09-21 16:34:31.065742', 'img3.jpg', 'img3.jpg', 'jpg', '/blog-media/69', 'image', '498.23 KB', '2', 'private', 'blog', 'storage/blog-private/5d2fa71f-72e3-44aa-a04f-8cd8a9771fb5.jpg', 'local', 69, 'image/jpeg', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (89, '2026-09-21 16:34:31.129279', '2026-09-21 16:34:31.129279', 'img4.jpg', 'img4.jpg', 'jpg', '/blog-media/70', 'image', '465.92 KB', '2', 'private', 'blog', 'storage/blog-private/15a44ce6-cd6f-4c72-a8ce-d92a1aecc383.jpg', 'local', 70, 'image/jpeg', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (90, '2026-09-21 16:34:31.257547', '2026-09-21 16:34:31.257547', 'img5.jpg', 'img5.jpg', 'jpg', '/blog-media/71', 'image', '227.66 KB', '2', 'private', 'blog', 'storage/blog-private/bf24ab50-df14-4110-b6aa-eb5fa27928f5.jpg', 'local', 71, 'image/jpeg', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (91, '2026-09-21 16:34:31.321856', '2026-09-21 16:34:31.321856', 'img6.jpg', 'img6.jpg', 'jpg', '/blog-media/72', 'image', '245.42 KB', '2', 'private', 'blog', 'storage/blog-private/d17a81f7-8a27-468e-92d7-4d24c772a5b6.jpg', 'local', 72, 'image/jpeg', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (92, '2026-09-21 16:34:31.409061', '2026-09-21 16:34:31.409061', 'img7.jpg', 'img7.jpg', 'jpg', '/blog-media/73', 'image', '300.94 KB', '2', 'private', 'blog', 'storage/blog-private/6750b989-a60e-4f4f-9b13-ffc8f4a6c4dc.jpg', 'local', 73, 'image/jpeg', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (93, '2026-09-21 16:34:32.116665', '2026-09-21 16:34:32.116665', 'img8.jpg', 'img8.jpg', 'jpg', '/blog-media/74', 'image', '133.34 KB', '2', 'private', 'blog', 'storage/blog-private/aa527934-d979-4ceb-a69e-9e7ca4dc65e6.jpg', 'local', 74, 'image/jpeg', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (94, '2026-09-21 16:34:32.173384', '2026-09-21 16:34:32.173384', 'img9.jpg', 'img9.jpg', 'jpg', '/blog-media/75', 'image', '251.99 KB', '2', 'private', 'blog', 'storage/blog-private/9c60d100-28c3-4f08-aa87-41fa8fcbe9c0.jpg', 'local', 75, 'image/jpeg', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (95, '2026-09-21 16:34:32.229627', '2026-09-21 16:34:32.229627', 'img10.jpg', 'img10.jpg', 'jpg', '/blog-media/76', 'image', '313.39 KB', '2', 'private', 'blog', 'storage/blog-private/4b386dbe-6f7a-4eb2-87e2-699970998b28.jpg', 'local', 76, 'image/jpeg', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (96, '2026-09-21 16:34:32.290237', '2026-09-21 16:34:32.290237', 'img11.jpg', 'img11.jpg', 'jpg', '/blog-media/77', 'image', '590.34 KB', '2', 'private', 'blog', 'storage/blog-private/aba69545-ac44-48ea-a0cd-3844d2812575.jpg', 'local', 77, 'image/jpeg', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (97, '2026-09-21 16:34:32.345417', '2026-09-21 16:34:32.345417', 'img12.jpg', 'img12.jpg', 'jpg', '/blog-media/78', 'image', '371.98 KB', '2', 'private', 'blog', 'storage/blog-private/f15b6e3a-f426-4944-bd12-edeae083ef06.jpg', 'local', 78, 'image/jpeg', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (98, '2026-09-21 16:34:32.434340', '2026-09-21 16:34:32.434340', 'img13.jpg', 'img13.jpg', 'jpg', '/blog-media/79', 'image', '294 KB', '2', 'private', 'blog', 'storage/blog-private/8583fe46-889a-4398-b8b0-92a12b2be929.jpg', 'local', 79, 'image/jpeg', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (99, '2026-09-21 17:27:05.284233', '2026-09-21 17:27:05.284233', 'çå¿§ä¼¤ï¼æ¼«ï¼.jpg', 'çå¿§ä¼¤ï¼æ¼«ï¼.jpg', 'jpg', '/blog-media/80', 'image', '176.81 KB', '2', 'private', 'blog', 'storage/blog-private/20a1cc54-aede-4626-ac4d-a4d1b9a60fbb.jpg', 'local', 80, 'image/jpeg', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (100, '2026-09-21 17:27:05.999561', '2026-09-21 17:27:05.999561', 'ç»ç­-ç­ç±105Â°çä½ (èå).mp4', 'ç»ç­-ç­ç±105Â°çä½ (èå).mp4', 'mp4', '/blog-media/81', 'video', '15.58 MB', '2', 'private', 'blog', 'storage/blog-private/ba45a44a-4031-439a-b840-d7bd441b6b8e.mp4', 'local', 81, 'video/mp4', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (101, '2026-09-21 17:27:06.081257', '2026-09-21 17:27:06.081257', 'æ°çå¿§ä¼¤ï¼æ¼«ï¼.jpg', 'æ°çå¿§ä¼¤ï¼æ¼«ï¼.jpg', 'jpg', '/blog-media/82', 'image', '450.8 KB', '2', 'private', 'blog', 'storage/blog-private/efb77ef6-0090-4a4e-9170-6dcfe1306a56.jpg', 'local', 82, 'image/jpeg', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (102, '2026-09-21 17:27:06.131928', '2026-09-21 17:27:06.131928', 'æ°çå¿§ä¼¤ï¼äººï¼.jpg', 'æ°çå¿§ä¼¤ï¼äººï¼.jpg', 'jpg', '/blog-media/83', 'image', '281.71 KB', '2', 'private', 'blog', 'storage/blog-private/6584f6bb-57a6-447e-b57c-b4d0c8bce5cf.jpg', 'local', 83, 'image/jpeg', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (103, '2026-09-21 17:27:06.187583', '2026-09-21 17:27:06.187583', 'å¾®ä¿¡å¾ç_20201112103431.jpg', 'å¾®ä¿¡å¾ç_20201112103431.jpg', 'jpg', '/blog-media/84', 'image', '45.61 KB', '2', 'private', 'blog', 'storage/blog-private/40bc7cc6-f94d-4d32-a270-117df315d1ea.jpg', 'local', 84, 'image/jpeg', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (104, '2026-09-21 17:27:06.231529', '2026-09-21 17:27:06.231529', 'å¾®ä¿¡å¾ç_20201125084331.jpg', 'å¾®ä¿¡å¾ç_20201125084331.jpg', 'jpg', '/blog-media/85', 'image', '57.68 KB', '2', 'private', 'blog', 'storage/blog-private/50d4770f-49d9-4885-8a8b-97f953ab59c5.jpg', 'local', 85, 'image/jpeg', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (105, '2026-09-21 17:27:06.497401', '2026-09-21 17:27:06.497401', 'å¾®ä¿¡å¾ç_20201201145036.jpg', 'å¾®ä¿¡å¾ç_20201201145036.jpg', 'jpg', '/blog-media/86', 'image', '41.62 KB', '2', 'private', 'blog', 'storage/blog-private/db201ee6-b447-46ea-b138-df775f6da79c.jpg', 'local', 86, 'image/jpeg', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (106, '2026-09-21 17:27:06.568855', '2026-09-21 17:27:06.568855', 'å¾®ä¿¡å¾ç_20201214130342.jpg', 'å¾®ä¿¡å¾ç_20201214130342.jpg', 'jpg', '/blog-media/87', 'image', '152.88 KB', '2', 'private', 'blog', 'storage/blog-private/0fcab820-b9ec-4559-873a-bd4dbb06e8c5.jpg', 'local', 87, 'image/jpeg', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (107, '2026-09-21 17:27:06.760582', '2026-09-21 17:27:06.760582', 'å¾®ä¿¡å¾ç_20211115193158.png', 'å¾®ä¿¡å¾ç_20211115193158.png', 'png', '/blog-media/88', 'image', '470.36 KB', '2', 'private', 'blog', 'storage/blog-private/a0f20ba4-34aa-4a1c-8b1d-a45224b9dde6.png', 'local', 88, 'image/png', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (108, '2026-09-21 17:27:06.878174', '2026-09-21 17:27:06.878174', 'ä¸è½½.png', 'ä¸è½½.png', 'png', '/blog-media/89', 'image', '73.58 KB', '2', 'private', 'blog', 'storage/blog-private/1d0f5078-3020-42b4-a64f-a85c20ab490f.png', 'local', 89, 'image/png', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (109, '2026-09-21 17:27:06.955126', '2026-09-21 17:27:06.955126', 'å®å®æç©º.jpg', 'å®å®æç©º.jpg', 'jpg', '/blog-media/90', 'image', '132.96 KB', '2', 'private', 'blog', 'storage/blog-private/7a7384eb-93cd-4c99-8b1c-94200641d2e1.jpg', 'local', 90, 'image/jpeg', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (110, '2026-09-21 17:27:07.814228', '2026-09-21 17:27:07.814228', 'c8c1bd59f552b149202800e354041535.mp4', 'c8c1bd59f552b149202800e354041535.mp4', 'mp4', '/blog-media/91', 'video', '3.58 MB', '2', 'private', 'blog', 'storage/blog-private/573141f8-4542-4d10-9e16-0865b1ed4d96.mp4', 'local', 91, 'video/mp4', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (111, '2026-09-21 17:27:07.920376', '2026-09-21 17:27:07.920376', 'cy.png', 'cy.png', 'png', '/blog-media/92', 'image', '85.61 KB', '2', 'private', 'blog', 'storage/blog-private/5b3a227c-6857-42f6-ac64-2658643034d3.png', 'local', 92, 'image/png', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (112, '2026-09-21 17:27:07.981713', '2026-09-21 17:27:07.981713', 'IMG_0006.JPG', 'IMG_0006.JPG', 'JPG', '/blog-media/93', 'image', '59.04 KB', '2', 'private', 'blog', 'storage/blog-private/9a20f09c-fe79-4ed4-8039-f3441370ec47.jpg', 'local', 93, 'image/jpeg', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (113, '2026-09-21 17:27:08.067562', '2026-09-21 17:27:08.067562', 'IMG_0007.JPG', 'IMG_0007.JPG', 'JPG', '/blog-media/94', 'image', '49.72 KB', '2', 'private', 'blog', 'storage/blog-private/7a4167a5-5d0a-45ea-bacf-4df362542b72.jpg', 'local', 94, 'image/jpeg', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (114, '2026-09-21 17:27:08.342718', '2026-09-21 17:27:08.342718', 'IMG_0008.JPG', 'IMG_0008.JPG', 'JPG', '/blog-media/95', 'image', '63.68 KB', '2', 'private', 'blog', 'storage/blog-private/5be97272-511e-47d4-896d-b82883cae9dd.jpg', 'local', 95, 'image/jpeg', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (115, '2026-09-21 17:27:08.426489', '2026-09-21 17:27:08.426489', 'IMG_0058.JPG', 'IMG_0058.JPG', 'JPG', '/blog-media/96', 'image', '38.56 KB', '2', 'private', 'blog', 'storage/blog-private/a4fd4b2d-3125-45a0-ba20-860acbb68c35.jpg', 'local', 96, 'image/jpeg', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (116, '2026-09-21 17:27:08.494620', '2026-09-21 17:27:08.494620', 'IMG_0289.JPG', 'IMG_0289.JPG', 'JPG', '/blog-media/97', 'image', '156.83 KB', '2', 'private', 'blog', 'storage/blog-private/e0103db8-6570-4743-8c52-ed7516c79eb3.jpg', 'local', 97, 'image/jpeg', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (117, '2026-09-21 17:27:08.809831', '2026-09-21 17:27:08.809831', 'IMG_0430.JPG', 'IMG_0430.JPG', 'JPG', '/blog-media/98', 'image', '109.58 KB', '2', 'private', 'blog', 'storage/blog-private/4a6de7fb-b0ed-474f-9661-ff4747f0515d.jpg', 'local', 98, 'image/jpeg', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (118, '2026-09-21 17:27:08.870569', '2026-09-21 17:27:08.870569', 'IMG_1598.JPG', 'IMG_1598.JPG', 'JPG', '/blog-media/99', 'image', '53.06 KB', '2', 'private', 'blog', 'storage/blog-private/ca5f05a2-25d5-45ce-96c5-4fdeb64cbc7e.jpg', 'local', 99, 'image/jpeg', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (119, '2026-09-21 17:27:08.976834', '2026-09-21 17:27:08.976834', 'IMG_1765.PNG', 'IMG_1765.PNG', 'PNG', '/blog-media/100', 'image', '3.4 MB', '2', 'private', 'blog', 'storage/blog-private/29980290-b04b-4260-a919-31d3b2b7ef31.png', 'local', 100, 'image/png', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (120, '2026-09-21 17:27:09.062721', '2026-09-21 17:27:09.062721', 'psc11.jpg', 'psc11.jpg', 'jpg', '/blog-media/101', 'image', '3.76 MB', '2', 'private', 'blog', 'storage/blog-private/75a753aa-f217-4e18-bd63-11d379533399.jpg', 'local', 101, 'image/jpeg', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (121, '2026-09-21 18:10:23.410608', '2026-09-21 18:10:23.410608', '1625-1182619662.jpeg', '1625-1182619662.jpeg', 'jpeg', '/blog-media/102', 'image', '61.4 KB', '2', 'private', 'blog', 'storage/blog-private/e7743b72-159d-41bd-a5da-6b86fa2a31d2.jpeg', 'local', 102, 'image/jpeg', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (122, '2026-09-21 22:56:11.673443', '2026-09-21 22:56:11.673443', 'img49.jpg', 'img49.jpg', 'jpg', '/blog-media/103', 'image', '193.68 KB', '2', 'private', 'blog', 'storage/blog-private/2026-09-21/image/316127a1-860d-4de4-921e-932411bd7f8d.jpg', 'local', 103, 'image/jpeg', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (123, '2026-09-22 09:11:14.424337', '2026-09-22 09:11:14.424337', 'å¾å¾å¾.mp3', 'å¾å¾å¾.mp3', 'mp3', '/blog-media/104', 'video', '20.05 MB', '2', 'private', 'blog', 'storage/blog-private/2026-09-22/music/bb13d94e-e65a-4af6-923f-bce6ac2a14b1.mp3', 'local', 104, 'video/mp4', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (124, '2026-09-22 09:11:21.955632', '2026-09-22 09:11:21.955632', '1625-1182619662.jpeg', '1625-1182619662.jpeg', 'jpeg', '/blog-media/105', 'image', '61.4 KB', '2', 'private', 'blog', 'storage/blog-private/2026-09-22/image/7c14c3a1-ff02-43f4-acf9-818674458757.jpeg', 'local', 105, 'image/jpeg', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (125, '2026-09-22 11:04:03.221932', '2026-09-22 11:04:03.221932', 'test.png', 'test.png', 'png', '/blog-media/106', 'image', '70 B', '33', 'private', 'blog', 'storage/blog-private/2026-09-22/image/e79435e3-eb4b-4662-bc5e-8f1e9f9477cc.png', 'local', 106, 'image/png', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (126, '2026-09-22 11:07:32.767038', '2026-09-22 11:07:32.767038', 'çå¿§ä¼¤ï¼æ¼«ï¼.jpg', 'çå¿§ä¼¤ï¼æ¼«ï¼.jpg', 'jpg', '/blog-media/107', 'image', '176.81 KB', '2', 'private', 'blog', 'storage/blog-private/2026-09-22/image/ae9e286a-36b4-4569-ba2b-e057c13076fd.jpg', 'local', 107, 'image/jpeg', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (127, '2026-09-22 11:08:36.366212', '2026-09-22 11:08:36.366212', 'æ°çå¿§ä¼¤ï¼äººï¼.jpg', 'æ°çå¿§ä¼¤ï¼äººï¼.jpg', 'jpg', '/blog-media/108', 'image', '281.71 KB', '2', 'private', 'blog', 'storage/blog-private/2026-09-22/image/fa4a4f1c-bd72-41d1-a960-58fd38bf3b40.jpg', 'local', 108, 'image/jpeg', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (128, '2026-09-22 11:09:57.868345', '2026-09-22 11:09:57.868345', 'img7.jpg', 'img7.jpg', 'jpg', '/blog-media/109', 'image', '300.94 KB', '2', 'private', 'blog', 'storage/blog-private/2026-09-22/image/a158cdca-213b-4881-9561-550f8a4e4ae6.jpg', 'local', 109, 'image/jpeg', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (129, '2026-09-22 11:10:03.540175', '2026-09-22 11:10:03.540175', 'img13.jpg', 'img13.jpg', 'jpg', '/blog-media/110', 'image', '294 KB', '2', 'private', 'blog', 'storage/blog-private/2026-09-22/image/05c8d023-e6ee-465a-8b8d-2276b9d8f7b7.jpg', 'local', 110, 'image/jpeg', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (130, '2026-09-22 11:10:08.876541', '2026-09-22 11:10:08.876541', 'img12.jpg', 'img12.jpg', 'jpg', '/blog-media/111', 'image', '371.98 KB', '2', 'private', 'blog', 'storage/blog-private/2026-09-22/image/e208e5c5-175e-4ab2-9112-079041dbcf26.jpg', 'local', 111, 'image/jpeg', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (131, '2026-09-22 11:10:12.793183', '2026-09-22 11:10:12.793183', 'img14.jpg', 'img14.jpg', 'jpg', '/blog-media/112', 'image', '298.53 KB', '2', 'private', 'blog', 'storage/blog-private/2026-09-22/image/2dfee616-70d1-44f9-a79f-e3fa8cc89e4e.jpg', 'local', 112, 'image/jpeg', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (132, '2026-09-22 11:10:17.765497', '2026-09-22 11:10:17.765497', 'img4.jpg', 'img4.jpg', 'jpg', '/blog-media/113', 'image', '465.92 KB', '2', 'private', 'blog', 'storage/blog-private/2026-09-22/image/252cb868-3987-4b16-b4af-4184b86532e7.jpg', 'local', 113, 'image/jpeg', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (133, '2026-09-22 12:11:29.458531', '2026-09-22 12:11:29.458531', 'img47.jpg', 'img47.jpg', 'jpg', '/blog-media/114', 'image', '345.84 KB', '2', 'private', 'blog', 'storage/blog-private/2026-09-22/image/f8799218-bec3-45e0-b1a9-104d46260842.jpg', 'local', 114, 'image/jpeg', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (134, '2026-09-22 12:11:39.236271', '2026-09-22 12:11:39.236271', 'img11.jpg', 'img11.jpg', 'jpg', '/blog-media/115', 'image', '590.34 KB', '2', 'private', 'blog', 'storage/blog-private/2026-09-22/image/0e4c1b06-0cbb-4f2f-bdb1-816ae86adec6.jpg', 'local', 115, 'image/jpeg', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (135, '2026-09-22 12:11:58.355444', '2026-09-22 12:11:58.355444', 'img7.jpg', 'img7.jpg', 'jpg', '/blog-media/116', 'image', '300.94 KB', '2', 'private', 'blog', 'storage/blog-private/2026-09-22/image/e4b77afa-3f89-467f-8cad-a3d62a1bfacb.jpg', 'local', 116, 'image/jpeg', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (136, '2026-09-22 12:12:35.028574', '2026-09-22 12:12:35.028574', 'img12.jpg', 'img12.jpg', 'jpg', '/blog-media/117', 'image', '371.98 KB', '2', 'private', 'blog', 'storage/blog-private/2026-09-22/image/cc3b4f78-3ac0-4ca6-a21d-80acad18a5bb.jpg', 'local', 117, 'image/jpeg', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (137, '2026-09-22 14:01:08.027674', '2026-09-22 14:01:08.027674', 'img13.jpg', 'img13.jpg', 'jpg', '/blog-media/118', 'image', '294 KB', '2', 'private', 'blog', 'storage/blog-private/2026-09-22/image/85de950e-4cd3-4ded-a669-dd3aafcb3601.jpg', 'local', 118, 'image/jpeg', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (138, '2026-09-22 14:01:13.236367', '2026-09-22 14:01:13.236367', 'img26.jpg', 'img26.jpg', 'jpg', '/blog-media/119', 'image', '272.3 KB', '2', 'private', 'blog', 'storage/blog-private/2026-09-22/image/547365d3-81ca-43d8-ad58-c6f17333918a.jpg', 'local', 119, 'image/jpeg', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (139, '2026-09-22 14:01:30.826098', '2026-09-22 14:01:30.826098', 'img11.jpg', 'img11.jpg', 'jpg', '/blog-media/120', 'image', '590.34 KB', '2', 'private', 'blog', 'storage/blog-private/2026-09-22/image/8649bac1-f32e-46c6-81d3-1098a070a43d.jpg', 'local', 120, 'image/jpeg', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (140, '2026-09-22 14:01:47.264437', '2026-09-22 14:01:47.264437', 'img147.jpg', 'img147.jpg', 'jpg', '/blog-media/121', 'image', '300.92 KB', '2', 'private', 'blog', 'storage/blog-private/2026-09-22/image/159ff600-160d-4742-857a-061949debfec.jpg', 'local', 121, 'image/jpeg', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (141, '2026-09-22 14:22:08.829221', '2026-09-22 14:22:08.829221', 'img9.jpg', 'img9.jpg', 'jpg', '/blog-media/122', 'image', '251.99 KB', '2', 'private', 'blog', 'storage/blog-private/2026-09-22/image/43dacd43-d376-4f5f-a4ba-b2945462ca01.jpg', 'local', 122, 'image/jpeg', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (142, '2026-09-22 14:22:12.995244', '2026-09-22 14:22:12.995244', 'img8.jpg', 'img8.jpg', 'jpg', '/blog-media/123', 'image', '133.34 KB', '2', 'private', 'blog', 'storage/blog-private/2026-09-22/image/e9fa2380-b350-4175-b135-b3bd1e31af2c.jpg', 'local', 123, 'image/jpeg', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (143, '2026-09-22 14:22:31.004376', '2026-09-22 14:22:31.004376', 'img1.jpg', 'img1.jpg', 'jpg', '/blog-media/124', 'image', '371.72 KB', '2', 'private', 'blog', 'storage/blog-private/2026-09-22/image/3d004345-d20a-4576-bce5-c4d53b7e0853.jpg', 'local', 124, 'image/jpeg', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (144, '2026-09-22 14:43:45.250524', '2026-09-22 14:43:45.250524', 'test.png', 'test.png', 'png', '/blog-media/125', 'image', '70 B', '36', 'private', 'blog', 'storage/blog-private/2026-09-22/image/dcf7dd19-21c3-4059-94e1-131a690480b9.png', 'local', 125, 'image/png', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (145, '2026-09-22 15:17:33.644865', '2026-09-22 15:17:33.644865', 'test.png', 'test.png', 'png', '/blog-media/126', 'image', '70 B', '39', 'private', 'blog', 'storage/blog-private/2026-09-22/image/029083d2-dc98-4806-98e5-2fce77720994.png', 'local', 126, 'image/png', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (146, '2026-09-22 15:29:18.258544', '2026-09-22 15:29:18.258544', 'test.png', 'test.png', 'png', '/blog-media/127', 'image', '70 B', '42', 'private', 'blog', 'storage/blog-private/2026-09-22/image/713d838e-0b76-46a2-b7c4-10a4bf2d11d7.png', 'local', 127, 'image/png', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (147, '2026-09-22 15:51:45.546421', '2026-09-22 15:51:45.546421', 'ç»ç­-ç­ç±105Â°çä½ (èå).mp4', 'ç»ç­-ç­ç±105Â°çä½ (èå).mp4', 'mp4', '/blog-media/128', 'video', '15.58 MB', '2', 'private', 'blog', 'storage/blog-private/2026-09-22/video/78a5f187-9b07-451c-a4d8-bdc97d482244.mp4', 'local', 128, 'video/mp4', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (148, '2026-09-22 16:03:09.115134', '2026-09-22 16:03:09.115134', 'test.png', 'test.png', 'png', '/blog-media/129', 'image', '70 B', '45', 'private', 'blog', 'storage/blog-private/2026-09-22/image/84371363-2f46-4d49-87bf-dcef614b7486.png', 'local', 129, 'image/png', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (149, '2026-09-22 16:07:51.928426', '2026-09-22 16:07:51.928426', '1625-1182619662.jpeg', '1625-1182619662.jpeg', 'jpeg', '/blog-media/130', 'image', '61.4 KB', '2', 'private', 'blog', 'storage/blog-private/2026-09-22/image/42b5792c-6972-4545-bf97-34c1bacc2462.jpeg', 'local', 130, 'image/jpeg', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (150, '2026-09-22 16:08:05.248474', '2026-09-22 16:08:05.248474', 'å¾å¾å¾.mp3', 'å¾å¾å¾.mp3', 'mp3', '/blog-media/131', 'video', '20.05 MB', '2', 'private', 'blog', 'storage/blog-private/2026-09-22/music/02b6a833-97c3-43c8-aadb-179729d7fcab.mp3', 'local', 131, 'video/mp4', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (151, '2026-09-22 16:08:39.584920', '2026-09-22 16:08:39.584920', 'img8.jpg', 'img8.jpg', 'jpg', '/blog-media/132', 'image', '133.34 KB', '2', 'private', 'blog', 'storage/blog-private/2026-09-22/image/8526a671-d3b6-4474-b5a7-e04360bfd1e7.jpg', 'local', 132, 'image/jpeg', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (152, '2026-09-22 16:08:47.318674', '2026-09-22 16:08:47.318674', 'å¾å¾å¾.mp3', 'å¾å¾å¾.mp3', 'mp3', '/blog-media/133', 'video', '20.05 MB', '2', 'private', 'blog', 'storage/blog-private/2026-09-22/music/8752a779-7216-43a0-908e-525c12f21819.mp3', 'local', 133, 'video/mp4', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (153, '2026-09-22 16:08:56.294023', '2026-09-22 16:08:56.294023', 'çµèèææºé®é¢.png', 'çµèèææºé®é¢.png', 'png', '/blog-media/134', 'image', '26.61 KB', '2', 'private', 'blog', 'storage/blog-private/2026-09-22/image/0c785408-95c0-4b31-884f-9857470a8909.png', 'local', 134, 'image/png', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (154, '2026-09-22 16:09:29.426464', '2026-09-22 16:09:29.426464', 'img7.jpg', 'img7.jpg', 'jpg', '/blog-media/135', 'image', '300.94 KB', '2', 'private', 'blog', 'storage/blog-private/2026-09-22/image/68abd90d-e585-4b1a-ba3b-73748de5c540.jpg', 'local', 135, 'image/jpeg', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (155, '2026-09-22 16:26:54.756148', '2026-09-22 16:26:54.756148', 'test.png', 'test.png', 'png', '/blog-media/136', 'image', '70 B', '48', 'private', 'blog', 'storage/blog-private/2026-09-22/image/014857e4-e555-4073-9c51-c45a76778722.png', 'local', 136, 'image/png', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (156, '2026-09-22 17:13:50.729690', '2026-09-22 17:13:50.729690', 'test.png', 'test.png', 'png', '/blog-media/137', 'image', '70 B', '51', 'private', 'blog', 'storage/blog-private/2026-09-22/image/3149f534-9818-46a7-bff8-5d3e7a741f57.png', 'local', 137, 'image/png', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (157, '2026-09-22 17:15:41.623494', '2026-09-22 17:15:41.623494', 'test.png', 'test.png', 'png', '/blog-media/138', 'image', '70 B', '54', 'private', 'blog', 'storage/blog-private/2026-09-22/image/25906bfd-cfed-46f1-8d9a-4077e3e15f99.png', 'local', 138, 'image/png', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (158, '2026-09-22 17:21:19.188079', '2026-09-22 17:21:19.188079', 'test.png', 'test.png', 'png', '/blog-media/139', 'image', '70 B', '57', 'private', 'blog', 'storage/blog-private/2026-09-22/image/40a3de7f-fc95-4e10-8c18-6f0355d6304f.png', 'local', 139, 'image/png', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (159, '2026-09-22 17:23:25.021042', '2026-09-22 17:23:25.021042', 'test.png', 'test.png', 'png', '/blog-media/140', 'image', '70 B', '63', 'private', 'blog', 'storage/blog-private/2026-09-22/image/f56a7e25-1ea0-44ad-a40c-bafebe1d261f.png', 'local', 140, 'image/png', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (160, '2026-09-22 17:24:52.049964', '2026-09-22 17:24:52.049964', 'test.png', 'test.png', 'png', '/blog-media/141', 'image', '70 B', '66', 'private', 'blog', 'storage/blog-private/2026-09-22/image/c0eaf400-6bb4-4c9e-bff9-d440adaeb32d.png', 'local', 141, 'image/png', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (161, '2026-09-22 17:26:19.332596', '2026-09-22 17:26:19.332596', 'test.png', 'test.png', 'png', '/blog-media/142', 'image', '70 B', '69', 'private', 'blog', 'storage/blog-private/2026-09-22/image/a932dd39-f119-4fd9-9ac9-2c34dad723f9.png', 'local', 142, 'image/png', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (162, '2026-09-22 17:31:32.739873', '2026-09-22 17:31:32.739873', 'test.png', 'test.png', 'png', '/blog-media/143', 'image', '70 B', '72', 'private', 'blog', 'storage/blog-private/2026-09-22/image/24ae5dcd-0cf7-4ae7-8574-11165b299824.png', 'local', 143, 'image/png', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (163, '2026-09-22 18:16:51.202311', '2026-09-22 18:16:51.202311', 'test.png', 'test.png', 'png', '/blog-media/144', 'image', '70 B', '75', 'private', 'blog', 'storage/blog-private/2026-09-22/image/4a401e6d-4503-4745-8f95-116c128e2e0d.png', 'local', 144, 'image/png', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (164, '2026-09-22 18:18:07.619763', '2026-09-22 18:18:07.619763', 'test.png', 'test.png', 'png', '/blog-media/145', 'image', '70 B', '78', 'private', 'blog', 'storage/blog-private/2026-09-22/image/d11f00aa-7cc3-4902-b066-2523d5539bc6.png', 'local', 145, 'image/png', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (165, '2026-09-22 18:19:13.295835', '2026-09-22 18:19:13.295835', 'test.png', 'test.png', 'png', '/blog-media/146', 'image', '70 B', '81', 'private', 'blog', 'storage/blog-private/2026-09-22/image/7a412774-4307-49f5-9dc5-1d7b5959639e.png', 'local', 146, 'image/png', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (166, '2026-09-22 18:23:07.466290', '2026-09-22 18:23:07.466290', 'test.png', 'test.png', 'png', '/blog-media/147', 'image', '70 B', '84', 'private', 'blog', 'storage/blog-private/2026-09-22/image/5f68e17c-0041-4171-bd33-7a41bb150bae.png', 'local', 147, 'image/png', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (167, '2026-09-22 18:24:43.542339', '2026-09-22 18:24:43.542339', 'test.png', 'test.png', 'png', '/blog-media/148', 'image', '70 B', '87', 'private', 'blog', 'storage/blog-private/2026-09-22/image/12265bd2-89a4-4c97-992d-08cef5a28137.png', 'local', 148, 'image/png', NULL, NULL);
INSERT INTO `tool_storage` (`id`, `created_at`, `updated_at`, `name`, `fileName`, `ext_name`, `path`, `type`, `size`, `user_id`, `visibility`, `source`, `storage_key`, `provider`, `blog_media_id`, `mime`, `storage_profile`, `previous_locations`) VALUES (168, '2026-09-23 12:29:05.102002', '2026-09-23 12:29:05.102002', 'img10.jpg', 'img10.jpg', 'jpg', '/blog-media/149', 'image', '313.39 KB', '2', 'private', 'blog', 'storage/blog-private/2026-09-23/image/68b8e572-7d6a-4434-ad15-ae8d2ad7cf77.jpg', 'local', 149, 'image/jpeg', NULL, NULL);
COMMIT;

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
  `id` int NOT NULL AUTO_INCREMENT,
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用户名',
  `password` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '密码',
  `status` tinyint DEFAULT '1' COMMENT '状态 1 启用 0 禁用',
  `profile_id` int DEFAULT NULL,
  `dept_id` int DEFAULT NULL,
  `from` varchar(255) DEFAULT NULL COMMENT '记录是从哪里来的用户',
  `unique_id` int DEFAULT NULL COMMENT '唯一的id',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `IDX_78a916df40e02a9deb1c4b75ed` (`username`),
  UNIQUE KEY `REL_f44d0cd18cfd80b0fed7806c3b` (`profile_id`),
  KEY `FK_c330c4acd2740fac489be6d2889` (`dept_id`),
  CONSTRAINT `FK_c330c4acd2740fac489be6d2889` FOREIGN KEY (`dept_id`) REFERENCES `sys_dept` (`id`),
  CONSTRAINT `FK_f44d0cd18cfd80b0fed7806c3b7` FOREIGN KEY (`profile_id`) REFERENCES `user_profile` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=90 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of user
-- ----------------------------
BEGIN;
INSERT INTO `user` (`id`, `created_at`, `updated_at`, `username`, `password`, `status`, `profile_id`, `dept_id`, `from`, `unique_id`) VALUES (1, '2025-04-09 16:37:40.000000', '2025-04-09 16:37:40.000000', 'superadmin', '$argon2id$v=19$m=65536,t=3,p=4$t6lmMgT5M6REVn+9V7X6xg$fxgxtZYiGN03kSA5ltcMOWxMoZNNJMOG760iim/9YF8', 1, 1, 3, NULL, NULL);
INSERT INTO `user` (`id`, `created_at`, `updated_at`, `username`, `password`, `status`, `profile_id`, `dept_id`, `from`, `unique_id`) VALUES (2, '2025-04-09 16:37:40.000000', '2025-04-09 16:37:40.000000', 'admin', '$argon2id$v=19$m=65536,t=3,p=4$/Ir79I0IEI37cuBbJZ7KPQ$M+GkjjFdZeOJ+M4TCPiU3bqxgGQyVFBaG1257t3mnUg', 1, 2, 3, NULL, NULL);
INSERT INTO `user` (`id`, `created_at`, `updated_at`, `username`, `password`, `status`, `profile_id`, `dept_id`, `from`, `unique_id`) VALUES (3, '2025-04-09 16:37:40.000000', '2025-04-09 16:37:40.000000', 'test', '$argon2id$v=19$m=65536,t=3,p=4$PXghOAgpytsWpqWZG9ycDA$jEWuDUP7GHf44dxkodAYB+9GySzOU4Y2CHXY+pWKxeM', 1, 3, 2, NULL, NULL);
INSERT INTO `user` (`id`, `created_at`, `updated_at`, `username`, `password`, `status`, `profile_id`, `dept_id`, `from`, `unique_id`) VALUES (4, '2025-04-28 00:53:59.035815', '2025-04-28 00:53:59.035815', 'guest', '$argon2id$v=19$m=65536,t=3,p=4$uB3RC47BNbisVRnmgH7QZg$r+L4/pdc53EMh2PGntVBePHxfuIPCO2QQNckjWpwZu0', 1, 4, 10, NULL, NULL);
COMMIT;

-- ----------------------------
-- Table structure for user_access_token
-- ----------------------------
DROP TABLE IF EXISTS `user_access_token`;
CREATE TABLE `user_access_token` (
  `value` varchar(255) NOT NULL,
  `expired_at` datetime NOT NULL,
  `created_at` datetime NOT NULL,
  `userId` int DEFAULT NULL,
  `id` int NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`),
  KEY `FK_c9c6ac4970ddbe5a8c4887e1e7e` (`userId`),
  CONSTRAINT `FK_c9c6ac4970ddbe5a8c4887e1e7e` FOREIGN KEY (`userId`) REFERENCES `user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=114 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Records of user_access_token
-- ----------------------------
BEGIN;
INSERT INTO `user_access_token` (`value`, `expired_at`, `created_at`, `userId`, `id`) VALUES ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1aWQiOjIsInJvbGVzIjpbImFkbWluIl0sImlhdCI6MTc0ODI3NzQ4MywiZXhwIjoxNzQ4MzYzODgzfQ.F6iFZSLlOpGOZ-USK6BqSxv6UsqGUMgGDAafOJ7xwqc', '2025-05-28 00:38:04', '2025-05-27 00:38:04', 2, 8);
INSERT INTO `user_access_token` (`value`, `expired_at`, `created_at`, `userId`, `id`) VALUES ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1aWQiOjIsInJvbGVzIjpbImFkbWluIl0sImlhdCI6MTc4ODg0ODA2NywiZXhwIjoxNzg4OTM0NDY3fQ.2IJSrKyVzOYyY-MnQkJM4tz7IMVvGQ8jG3ffeawfhzQ', '2026-09-09 14:14:28', '2026-09-08 14:14:28', 2, 29);
INSERT INTO `user_access_token` (`value`, `expired_at`, `created_at`, `userId`, `id`) VALUES ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1aWQiOjIsInJvbGVzIjpbImFkbWluIl0sImlhdCI6MTc4ODg0ODE5NSwiZXhwIjoxNzg4OTM0NTk1fQ.5uuFMmpMVd9zEv_qtI6F_yhwo7xEePlOmqD84uT9I7I', '2026-09-09 14:16:35', '2026-09-08 14:16:35', 2, 30);
INSERT INTO `user_access_token` (`value`, `expired_at`, `created_at`, `userId`, `id`) VALUES ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1aWQiOjIsInJvbGVzIjpbImFkbWluIl0sImlhdCI6MTc4ODkzMzUzOSwiZXhwIjoxNzg5MDE5OTM5fQ.PLr1DOvODQBvULn56kli7YO11PdJ7ISi3hPYKfeekAA', '2026-09-10 13:59:00', '2026-09-09 13:59:00', 2, 35);
INSERT INTO `user_access_token` (`value`, `expired_at`, `created_at`, `userId`, `id`) VALUES ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1aWQiOjEsInJvbGVzIjpbInN1cGVyYWRtaW4iXSwiaWF0IjoxNzg4OTM0MzkyLCJleHAiOjE3ODkwMjA3OTJ9.ClIberR02kVIKolhGjeFGFWQ4nV7p46nW_TrYckFm7Q', '2026-09-10 14:13:13', '2026-09-09 14:13:13', 1, 36);
INSERT INTO `user_access_token` (`value`, `expired_at`, `created_at`, `userId`, `id`) VALUES ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1aWQiOjIsInJvbGVzIjpbImFkbWluIiwiYmxvZ2FkbWluIl0sImlhdCI6MTc4ODkzNTc0OCwiZXhwIjoxNzg5MDIyMTQ4fQ.BWKml--okw5qtJjf6EsAj9TKfTACS0w34HYW5EEdjTQ', '2026-09-10 14:35:48', '2026-09-09 14:35:48', 2, 37);
INSERT INTO `user_access_token` (`value`, `expired_at`, `created_at`, `userId`, `id`) VALUES ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1aWQiOjIsInJvbGVzIjpbImFkbWluIiwiYmxvZ2FkbWluIl0sImlhdCI6MTc4OTAwODM3OSwiZXhwIjoxNzg5MDk0Nzc5fQ.REI_XVcVxhYdMqUUbYWA-OiTzaPPTlXf87Y73Wzs1i8', '2026-09-11 10:46:19', '2026-09-10 10:46:19', 2, 38);
INSERT INTO `user_access_token` (`value`, `expired_at`, `created_at`, `userId`, `id`) VALUES ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1aWQiOjIsInJvbGVzIjpbImFkbWluIiwiYmxvZ2FkbWluIl0sImlhdCI6MTc4OTAyNTc4NywiZXhwIjoxNzg5MTEyMTg3fQ.qaoV1_H0XEf9A5Eyz4hbpxlvqGI-3-9WGeyM5-Dkit0', '2026-09-11 15:36:27', '2026-09-10 15:36:27', 2, 40);
INSERT INTO `user_access_token` (`value`, `expired_at`, `created_at`, `userId`, `id`) VALUES ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1aWQiOjIsInJvbGVzIjpbImFkbWluIiwiYmxvZ2FkbWluIl0sImlhdCI6MTc4OTk1NzU4NCwiZXhwIjoxNzkwMDQzOTg0fQ.a7Cni5GHHgnDHGYICKo4qh9tJb21vPd6KHGyKUCkj7k', '2026-09-22 10:26:25', '2026-09-21 10:26:25', 2, 42);
INSERT INTO `user_access_token` (`value`, `expired_at`, `created_at`, `userId`, `id`) VALUES ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1aWQiOjIsInJvbGVzIjpbImFkbWluIiwiYmxvZ2FkbWluIl0sImlhdCI6MTc4OTk3NzA0MCwiZXhwIjoxNzkwMDYzNDQwfQ.1DxqJ2y8NyPouh00h9C4WETahuWY9-ONOl_ClajG_9E', '2026-09-22 15:50:41', '2026-09-21 15:50:41', 2, 45);
INSERT INTO `user_access_token` (`value`, `expired_at`, `created_at`, `userId`, `id`) VALUES ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1aWQiOjIsInJvbGVzIjpbImFkbWluIiwiYmxvZ2FkbWluIl0sImlhdCI6MTc4OTk3NzY2NSwiZXhwIjoxNzkwMDY0MDY1fQ.r5o5P1a5OfMQe_tMw_4mzkmkL-CK5PHdhaIuweYo3CA', '2026-09-22 16:01:06', '2026-09-21 16:01:06', 2, 46);
INSERT INTO `user_access_token` (`value`, `expired_at`, `created_at`, `userId`, `id`) VALUES ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1aWQiOjIsInJvbGVzIjpbImFkbWluIiwiYmxvZ2FkbWluIl0sImlhdCI6MTc5MDA2NjE2NywiZXhwIjoxNzkwMTUyNTY3fQ.Hf4V9VEjWfI3P98XuufXkRgpzmXdaVtD2imbnmkSRfk', '2026-09-23 16:36:08', '2026-09-22 16:36:08', 2, 71);
INSERT INTO `user_access_token` (`value`, `expired_at`, `created_at`, `userId`, `id`) VALUES ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1aWQiOjIsInJvbGVzIjpbImFkbWluIiwiYmxvZ2FkbWluIl0sImlhdCI6MTc5MDA2ODM4OCwiZXhwIjoxNzkwMTU0Nzg4fQ.K7_vJkBTMU1UebLc6C_mtqLercGTsC9695TBJMVperU', '2026-09-23 17:13:08', '2026-09-22 17:13:08', 2, 73);
INSERT INTO `user_access_token` (`value`, `expired_at`, `created_at`, `userId`, `id`) VALUES ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1aWQiOjIsInJvbGVzIjpbImFkbWluIiwiYmxvZ2FkbWluIl0sImlhdCI6MTc5MDEzODkwMCwiZXhwIjoxNzkwMjI1MzAwfQ.kUiel_Q46SCsSLBORe6vBtPJKX4tpFCTGHd8nF-p3dQ', '2026-09-24 12:48:21', '2026-09-23 12:48:21', 2, 112);
INSERT INTO `user_access_token` (`value`, `expired_at`, `created_at`, `userId`, `id`) VALUES ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1aWQiOjIsInJvbGVzIjpbImFkbWluIiwiYmxvZ2FkbWluIl0sImlhdCI6MTc5MDE0MDkwNiwiZXhwIjoxNzkwMjI3MzA2fQ.1ZjJNm5DgUK4QNwXFOAaQY0pWKo7OAVtHexWPGybIbQ', '2026-09-24 13:21:47', '2026-09-23 13:21:47', 2, 113);
COMMIT;

-- ----------------------------
-- Table structure for user_profile
-- ----------------------------
DROP TABLE IF EXISTS `user_profile`;
CREATE TABLE `user_profile` (
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  `nick_name` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '昵称',
  `email` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT 'email',
  `phone` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '手机号',
  `avatar` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '头像',
  `signature` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '个人签名',
  `address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '地址',
  `birth_date` datetime DEFAULT NULL COMMENT '出生日期',
  `introduction` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '简介',
  `id` int NOT NULL AUTO_INCREMENT,
  `gender` tinyint NOT NULL DEFAULT '1' COMMENT '性别 1 男 0 女',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of user_profile
-- ----------------------------
BEGIN;
INSERT INTO `user_profile` (`created_at`, `updated_at`, `nick_name`, `email`, `phone`, `avatar`, `signature`, `address`, `birth_date`, `introduction`, `id`, `gender`) VALUES ('2025-02-21 17:15:27.107185', '2025-02-21 17:15:27.107185', '超级管理员', 'superadmin@qq.com', '19983467897', '/upload/2025-04-16/image/bg.webp', '哼…这具躯壳终究无法承载吾『终焉之暗·灭世魔神』的万亿分之一力量吗…', '中国 成都', '2005-05-06 00:00:00', '(◣_◢) 您的中二能量已突破事件视界——', 1, 1);
INSERT INTO `user_profile` (`created_at`, `updated_at`, `nick_name`, `email`, `phone`, `avatar`, `signature`, `address`, `birth_date`, `introduction`, `id`, `gender`) VALUES ('2025-02-24 17:27:35.418875', '2026-09-10 15:26:14.000000', '管理员', 'admin@qq.com', NULL, '/upload/2026-09-10/other/1789025169455-å®å®æç©º.webp', '\"风停在窗边，嘱咐你要热爱这个世界。\"', NULL, NULL, NULL, 2, 1);
INSERT INTO `user_profile` (`created_at`, `updated_at`, `nick_name`, `email`, `phone`, `avatar`, `signature`, `address`, `birth_date`, `introduction`, `id`, `gender`) VALUES ('2025-02-26 14:52:05.341684', '2025-02-26 14:52:05.341684', '测试', 'test@qq.com', NULL, 'http://myblogimgbucket.oss-cn-beijing.aliyuncs.com/1741512170833-WechatIMG432.jpg', '\"在平凡的日子里，做自己的光。\"', NULL, NULL, NULL, 3, 1);
INSERT INTO `user_profile` (`created_at`, `updated_at`, `nick_name`, `email`, `phone`, `avatar`, `signature`, `address`, `birth_date`, `introduction`, `id`, `gender`) VALUES ('2025-04-28 00:53:59.028953', '2025-04-28 00:53:59.028953', '游客', 'guest@qq.com', '', '/upload/2025-04-28/other/1745772814472-u=2978468399,3739141687&fm=253&fmt=auto&app=120&f=JPEG.webp', '', '', NULL, '', 4, 1);
COMMIT;

-- ----------------------------
-- Table structure for user_refresh_token
-- ----------------------------
DROP TABLE IF EXISTS `user_refresh_token`;
CREATE TABLE `user_refresh_token` (
  `value` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `expired_at` datetime NOT NULL,
  `created_at` datetime NOT NULL,
  `accessTokenId` int DEFAULT NULL,
  `id` int NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`),
  UNIQUE KEY `REL_0fb9e76570bb35fd7dd7f78f73` (`accessTokenId`),
  CONSTRAINT `FK_0fb9e76570bb35fd7dd7f78f73c` FOREIGN KEY (`accessTokenId`) REFERENCES `user_access_token` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=114 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of user_refresh_token
-- ----------------------------
BEGIN;
INSERT INTO `user_refresh_token` (`value`, `expired_at`, `created_at`, `accessTokenId`, `id`) VALUES ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1dWlkIjoiN2YzMzVlZjgtMjBhYy00NDljLWEyMmYtNDZjZGE2NjRhOWY5IiwiaWF0IjoxNzQ4Mjc3NDgzLCJleHAiOjE3NDgzNjM4ODN9.eHVxRUY0DCjf21xVCVfSTmNGYPR_g5JArXVZbTrRBJo', '2025-06-03 00:38:04', '2025-05-27 00:38:04', 8, 8);
INSERT INTO `user_refresh_token` (`value`, `expired_at`, `created_at`, `accessTokenId`, `id`) VALUES ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1dWlkIjoiNDU3ZDRhMTMtYjU3Ni00YTIyLWFkYTctMzA4MjljNzdlYTNhIiwiaWF0IjoxNzg4ODQ4MDY3LCJleHAiOjE3ODg5MzQ0Njd9.Z6iaVCjDo9784QcWEnk9IuZZs9kd_o2f2p4XCUhHqnY', '2026-09-15 14:14:28', '2026-09-08 14:14:28', 29, 29);
INSERT INTO `user_refresh_token` (`value`, `expired_at`, `created_at`, `accessTokenId`, `id`) VALUES ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1dWlkIjoiOGY2NzkwY2MtZjVjMC00MjA1LWJmNmUtZGQ3ODQ4OGU0YzM2IiwiaWF0IjoxNzg4ODQ4MTk1LCJleHAiOjE3ODg5MzQ1OTV9.86vUfeIHVOYsuoEN3aIyJhX8yLAvawEWHTU6fRAwzWU', '2026-09-15 14:16:35', '2026-09-08 14:16:35', 30, 30);
INSERT INTO `user_refresh_token` (`value`, `expired_at`, `created_at`, `accessTokenId`, `id`) VALUES ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1dWlkIjoiNWFhNjczMGYtMWFkNS00ZDBmLWE4ZTktOTMxOTNlZGVhYTI3IiwiaWF0IjoxNzg4OTMzNTM5LCJleHAiOjE3ODkwMTk5Mzl9.dwIOMZ_AlCSPrDHsPDGnUbMB6wliPdw6X-vW3JQhmyU', '2026-09-16 13:59:00', '2026-09-09 13:59:00', 35, 35);
INSERT INTO `user_refresh_token` (`value`, `expired_at`, `created_at`, `accessTokenId`, `id`) VALUES ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1dWlkIjoiMDAxN2E5MzgtYTdjNy00ZDU1LWE2ZGItOTBhNGMyMjRlZmE3IiwiaWF0IjoxNzg4OTM0MzkyLCJleHAiOjE3ODkwMjA3OTJ9.4iVVnHdK84k-Uq_ab_-5_ge7DDr8xyZljnRhR76jAAY', '2026-09-16 14:13:13', '2026-09-09 14:13:13', 36, 36);
INSERT INTO `user_refresh_token` (`value`, `expired_at`, `created_at`, `accessTokenId`, `id`) VALUES ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1dWlkIjoiYmJmMGFiNDEtMzQ0OS00NDQzLTg4MWQtM2ViMTliYjdkMjU1IiwiaWF0IjoxNzg4OTM1NzQ4LCJleHAiOjE3ODkwMjIxNDh9.ZH2PbfQtOaUtdZi0Bpnx5sKr3viqPpmZyL5Jn5JvTv8', '2026-09-16 14:35:48', '2026-09-09 14:35:48', 37, 37);
INSERT INTO `user_refresh_token` (`value`, `expired_at`, `created_at`, `accessTokenId`, `id`) VALUES ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1dWlkIjoiMmJiZjcyM2YtODRjYy00NmY2LTg0YWQtOTA3MTk0ZThkYjk0IiwiaWF0IjoxNzg5MDA4Mzc5LCJleHAiOjE3ODkwOTQ3Nzl9.FQ2pw0xF2g17hVHHNl3oa-p9pgkLLG4OGj6gZ2qw_do', '2026-09-17 10:46:19', '2026-09-10 10:46:19', 38, 38);
INSERT INTO `user_refresh_token` (`value`, `expired_at`, `created_at`, `accessTokenId`, `id`) VALUES ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1dWlkIjoiODQ3ZGU3ODMtNDhjZi00OTk0LWEwYTItMjUxZDkzOWJiMTVkIiwiaWF0IjoxNzg5MDI1Nzg3LCJleHAiOjE3ODkxMTIxODd9.0HyjH-QbmwpNgcXyZ5Anl3yhBfibUj7R9eD_4VpMMCg', '2026-09-17 15:36:27', '2026-09-10 15:36:27', 40, 40);
INSERT INTO `user_refresh_token` (`value`, `expired_at`, `created_at`, `accessTokenId`, `id`) VALUES ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1dWlkIjoiNjBiYTk2NzMtZjgxYi00N2Y0LWE1ZmUtZTk1YzY1MTE4OWM1IiwiaWF0IjoxNzg5OTU3NTg0LCJleHAiOjE3OTAwNDM5ODR9.26a4Af0QzXBzXr9obR_zGV6Bvxoo0RFd__AV7Ysc4KQ', '2026-09-28 10:26:25', '2026-09-21 10:26:25', 42, 42);
INSERT INTO `user_refresh_token` (`value`, `expired_at`, `created_at`, `accessTokenId`, `id`) VALUES ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1dWlkIjoiZjQyOGExY2EtNWVlMi00MTQ2LTkwOTMtNGRkOGYwYTNjODAzIiwiaWF0IjoxNzg5OTc3MDQwLCJleHAiOjE3OTAwNjM0NDB9.2z64jO1zBG4kGb5eF0UDVeaLvf7wHjwJU8QuZtAzwPU', '2026-09-28 15:50:41', '2026-09-21 15:50:41', 45, 45);
INSERT INTO `user_refresh_token` (`value`, `expired_at`, `created_at`, `accessTokenId`, `id`) VALUES ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1dWlkIjoiNDMyZjVlNTEtNjJkZS00YzY0LWE2Y2EtYzdhMmZlZGFmMWMzIiwiaWF0IjoxNzg5OTc3NjY1LCJleHAiOjE3OTAwNjQwNjV9.ARA4RQFL7WZQzgkptPZOLC3FE252QFA8Jh1WxnhJtUA', '2026-09-28 16:01:06', '2026-09-21 16:01:06', 46, 46);
INSERT INTO `user_refresh_token` (`value`, `expired_at`, `created_at`, `accessTokenId`, `id`) VALUES ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1dWlkIjoiYzE2Mzk1MmMtNTUwNC00NGQ1LWE4YjktMjljNGJkMzgyN2MwIiwiaWF0IjoxNzkwMDY2MTY3LCJleHAiOjE3OTAxNTI1Njd9.OMXmCN_nvO3fRYYoOOuoScu9CwuOrJngTi2kMG4zqK4', '2026-09-29 16:36:08', '2026-09-22 16:36:08', 71, 71);
INSERT INTO `user_refresh_token` (`value`, `expired_at`, `created_at`, `accessTokenId`, `id`) VALUES ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1dWlkIjoiOGVlMDA1YWYtOGQ2Yi00YjVhLTkxMzEtNjUxZDdmZjY5MDVkIiwiaWF0IjoxNzkwMDY4Mzg4LCJleHAiOjE3OTAxNTQ3ODh9.SdIWWDEISEUqDh4P7dn_6rnHsl-VCzWESIO7wntUbnQ', '2026-09-29 17:13:08', '2026-09-22 17:13:08', 73, 73);
INSERT INTO `user_refresh_token` (`value`, `expired_at`, `created_at`, `accessTokenId`, `id`) VALUES ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1dWlkIjoiZjllYTBlY2YtOWFjYS00MjczLWI3MTctOTBiZGM3MDg2MjY5IiwiaWF0IjoxNzkwMTM4OTAwLCJleHAiOjE3OTAyMjUzMDB9.brO4_yytTg2tsp38kfH2_qSVmS75AOn18any01HwN_0', '2026-09-30 12:48:21', '2026-09-23 12:48:21', 112, 112);
INSERT INTO `user_refresh_token` (`value`, `expired_at`, `created_at`, `accessTokenId`, `id`) VALUES ('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1dWlkIjoiY2RkZTZiYzgtODdlNy00MzAxLWIyNjEtOWRiMTM0Y2Q4MGJiIiwiaWF0IjoxNzkwMTQwOTA2LCJleHAiOjE3OTAyMjczMDZ9.XNxZktrQ02CEGbFlUxxZ4Cd3O1Z0AHP3M2zZTiiMyx4', '2026-09-30 13:21:47', '2026-09-23 13:21:47', 113, 113);
COMMIT;

SET FOREIGN_KEY_CHECKS = 1;
