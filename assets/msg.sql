/*
 Navicat Premium Data Transfer

 Source Server         : 本地
 Source Server Type    : MySQL
 Source Server Version : 80013
 Source Host           : localhost:3306
 Source Schema         : api_msg3

 Target Server Type    : MySQL
 Target Server Version : 80013
 File Encoding         : 65001

 Date: 19/03/2021 10:57:46
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for sms_adminconfig
-- ----------------------------
DROP TABLE IF EXISTS `sms_adminconfig`;
CREATE TABLE `sms_adminconfig` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(25) NOT NULL,
  `caption` varchar(50) NOT NULL,
  `config` text,
  `cache` text,
  `disable` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `remark` varchar(500) DEFAULT NULL,
  `time` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for sms_admingroup
-- ----------------------------
DROP TABLE IF EXISTS `sms_admingroup`;
CREATE TABLE `sms_admingroup` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(35) NOT NULL,
  `sequence` smallint(5) unsigned DEFAULT '0',
  `disable` tinyint(1) unsigned DEFAULT '0',
  `remark` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for sms_administrator
-- ----------------------------
DROP TABLE IF EXISTS `sms_administrator`;
CREATE TABLE `sms_administrator` (
  `admid` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `password` char(32) DEFAULT NULL,
  `salt` char(6) DEFAULT NULL,
  `realname` varchar(35) DEFAULT NULL,
  `groupid` varchar(255) DEFAULT NULL COMMENT '多个用,分开',
  `tel` varchar(35) DEFAULT NULL,
  `mobile` varchar(35) DEFAULT NULL,
  `email` varchar(50) DEFAULT NULL,
  `remark` varchar(500) DEFAULT NULL,
  `disable` tinyint(1) unsigned DEFAULT '0',
  `logintime` int(10) unsigned NOT NULL DEFAULT '0',
  `logincount` int(10) unsigned NOT NULL DEFAULT '0',
  `loginip` char(15) DEFAULT NULL,
  `time` int(10) unsigned DEFAULT '0',
  PRIMARY KEY (`admid`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8 COMMENT='管理员';

-- ----------------------------
-- Table structure for sms_adminloginlogs
-- ----------------------------
DROP TABLE IF EXISTS `sms_adminloginlogs`;
CREATE TABLE `sms_adminloginlogs` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `admid` int(10) unsigned NOT NULL DEFAULT '0',
  `time` int(10) unsigned NOT NULL DEFAULT '0',
  `ip` char(15) DEFAULT NULL,
  `data` text,
  `status` varchar(15) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=221 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for sms_adminmenu
-- ----------------------------
DROP TABLE IF EXISTS `sms_adminmenu`;
CREATE TABLE `sms_adminmenu` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `url` varchar(300) DEFAULT NULL,
  `module` varchar(50) DEFAULT NULL,
  `action` varchar(50) DEFAULT NULL,
  `params` varchar(255) DEFAULT NULL,
  `parentid` int(10) unsigned DEFAULT '0',
  `sequence` smallint(5) unsigned DEFAULT '0',
  `depth` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `child` text,
  `target` varchar(35) DEFAULT NULL,
  `disable` tinyint(1) unsigned DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=52 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for sms_adminmodule
-- ----------------------------
DROP TABLE IF EXISTS `sms_adminmodule`;
CREATE TABLE `sms_adminmodule` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(35) NOT NULL,
  `caption` varchar(50) NOT NULL,
  `sequence` smallint(5) unsigned DEFAULT '0',
  `sys` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `disable` tinyint(1) unsigned DEFAULT '0',
  `action` text,
  `remark` varchar(500) DEFAULT NULL,
  `time` int(10) unsigned DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for sms_adminprivilege
-- ----------------------------
DROP TABLE IF EXISTS `sms_adminprivilege`;
CREATE TABLE `sms_adminprivilege` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `types` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `keyid` int(10) unsigned NOT NULL DEFAULT '0',
  `utypes` varchar(35) NOT NULL,
  `contextid` int(10) unsigned NOT NULL DEFAULT '0',
  `flag` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '0不允许列表,1允许列表',
  `action` varchar(300) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=459 DEFAULT CHARSET=utf8 COMMENT='管理员权限表';

-- ----------------------------
-- Table structure for sms_audit
-- ----------------------------
DROP TABLE IF EXISTS `sms_audit`;
CREATE TABLE `sms_audit` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '编号ID',
  `model` varchar(35) DEFAULT NULL COMMENT '模块名',
  `context_id` int(10) unsigned DEFAULT '0' COMMENT '待审核表单ID',
  `user_id` int(10) unsigned DEFAULT '0' COMMENT '申请人ID',
  `check_userid` int(10) unsigned DEFAULT '0' COMMENT '审核人ID',
  `status` tinyint(3) unsigned DEFAULT '0' COMMENT '审核状态',
  `reason` varchar(500) DEFAULT NULL COMMENT '申请说明',
  `feedback` varchar(300) DEFAULT NULL COMMENT '审核反馈',
  `create_time` int(10) unsigned DEFAULT '0' COMMENT '创建申请时间',
  `view_time` int(10) unsigned DEFAULT '0' COMMENT '查看时间',
  `check_time` int(10) unsigned DEFAULT '0' COMMENT '审核操作时间',
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `model` (`model`,`context_id`)
) ENGINE=InnoDB AUTO_INCREMENT=99 DEFAULT CHARSET=utf8 COMMENT='审核表';

-- ----------------------------
-- Table structure for sms_eventlogs
-- ----------------------------
DROP TABLE IF EXISTS `sms_eventlogs`;
CREATE TABLE `sms_eventlogs` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `admid` int(10) unsigned DEFAULT '0',
  `ip` char(15) DEFAULT NULL,
  `sttime` int(10) unsigned DEFAULT '0',
  `time` int(10) unsigned DEFAULT '0',
  `module` varchar(35) DEFAULT NULL,
  `action` varchar(40) DEFAULT NULL,
  `msg` varchar(255) DEFAULT NULL,
  `url` varchar(300) DEFAULT NULL,
  `data` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1111 DEFAULT CHARSET=utf8 COMMENT='管理员日志';

-- ----------------------------
-- Table structure for sms_phonetable_1
-- ----------------------------
DROP TABLE IF EXISTS `sms_phonetable_1`;
CREATE TABLE `sms_phonetable_1` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `phone` varchar(20) DEFAULT NULL,
  `status` tinyint(1) DEFAULT '1',
  `msg` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `phone` (`phone`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for sms_phonetable_2
-- ----------------------------
DROP TABLE IF EXISTS `sms_phonetable_2`;
CREATE TABLE `sms_phonetable_2` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `phone` varchar(20) DEFAULT NULL,
  `status` tinyint(1) DEFAULT '1',
  `msg` varchar(100) DEFAULT NULL,
  `cipher` varchar(64) DEFAULT NULL,
  `search_key` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `phone` (`phone`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1198 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for sms_phonetable_3
-- ----------------------------
DROP TABLE IF EXISTS `sms_phonetable_3`;
CREATE TABLE `sms_phonetable_3` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `phone` varchar(20) DEFAULT NULL,
  `status` tinyint(1) DEFAULT '1',
  `msg` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `phone` (`phone`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2729 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for sms_smsapplist
-- ----------------------------
DROP TABLE IF EXISTS `sms_smsapplist`;
CREATE TABLE `sms_smsapplist` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '编号ID',
  `user_id` int(10) unsigned DEFAULT '0' COMMENT '创建人ID',
  `name` varchar(35) DEFAULT NULL COMMENT '名称',
  `account` varchar(35) DEFAULT NULL COMMENT '接口账号',
  `type` int(11) DEFAULT '0' COMMENT '产品线类型，0为测试账号',
  `token` varchar(40) DEFAULT NULL COMMENT '效验码',
  `url` varchar(150) DEFAULT NULL COMMENT '域名地址',
  `send_mode` tinyint(3) unsigned DEFAULT '0' COMMENT '发送模式',
  `send_count` bigint(20) unsigned DEFAULT '0' COMMENT '短信发送条数',
  `gateway` varchar(35) DEFAULT NULL COMMENT '默认网关',
  `disip` tinyint(1) unsigned DEFAULT '0' COMMENT '关闭IP名称. 0启用,1关闭',
  `iplist` text COMMENT 'IP名单',
  `mobile_type` tinyint(3) unsigned DEFAULT '0' COMMENT '关闭手机黑白名单',
  `whitelist` text COMMENT '手机白名单',
  `blacklist` text COMMENT '手机黑名称',
  `status` tinyint(3) unsigned DEFAULT '0' COMMENT '状态',
  `disable` tinyint(1) unsigned DEFAULT '0' COMMENT '禁用. 0正常,1禁用',
  `remark` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '备注说明',
  `create_time` int(10) unsigned DEFAULT '0' COMMENT '创建时间',
  `update_time` int(10) unsigned DEFAULT '0' COMMENT '修改时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8 COMMENT='用记API账号列表';

-- ----------------------------
-- Table structure for sms_smsapplisttype
-- ----------------------------
DROP TABLE IF EXISTS `sms_smsapplisttype`;
CREATE TABLE `sms_smsapplisttype` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  `code` varchar(50) DEFAULT NULL,
  `pid` int(11) DEFAULT '0' COMMENT '父ID',
  `disabled` tinyint(1) DEFAULT '1' COMMENT '是否可用，1可用0禁用',
  `isdel` tinyint(1) DEFAULT '1' COMMENT '用于软删除，1删除，0存在',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for sms_smsapplisturl
-- ----------------------------
DROP TABLE IF EXISTS `sms_smsapplisturl`;
CREATE TABLE `sms_smsapplisturl` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '编号ID',
  `acc_id` int(10) unsigned DEFAULT '0' COMMENT 'Api帐号ID',
  `code` varchar(20) DEFAULT NULL COMMENT '编号',
  `url` varchar(255) DEFAULT NULL COMMENT '地址',
  `disable` tinyint(1) unsigned DEFAULT '0' COMMENT '禁用. 0启用,1禁用',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8 COMMENT='接口账号回调地址';

-- ----------------------------
-- Table structure for sms_smsautosendjob
-- ----------------------------
DROP TABLE IF EXISTS `sms_smsautosendjob`;
CREATE TABLE `sms_smsautosendjob` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `gateway` int(11) DEFAULT NULL,
  `sms_type` int(11) DEFAULT NULL,
  `sms_tmp` int(11) DEFAULT NULL COMMENT '模板id',
  `sms_sign` int(11) DEFAULT NULL,
  `sms_account` varchar(50) DEFAULT NULL,
  `sms_txt` varchar(1000) DEFAULT NULL,
  `ukey` char(32) DEFAULT NULL COMMENT 'md5(网关id+...+短信内容+日期)',
  `phone_table` varchar(50) DEFAULT NULL,
  `status` tinyint(1) DEFAULT '0',
  `created_at` int(10) DEFAULT NULL,
  `finished_at` int(10) DEFAULT '0' COMMENT '结束时间',
  `userid` int(11) DEFAULT NULL,
  `phone_id` int(10) unsigned DEFAULT '0' COMMENT '当前手机号码最大ID',
  `last_max_phone_id` int(10) unsigned DEFAULT '0' COMMENT '上次最大手机号码记录ID',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `ukey` (`ukey`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='存放自动群发任务表';

-- ----------------------------
-- Table structure for sms_smscontent
-- ----------------------------
DROP TABLE IF EXISTS `sms_smscontent`;
CREATE TABLE `sms_smscontent` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '编号ID',
  `user_id` int(10) unsigned DEFAULT '0' COMMENT '用户ID',
  `account` varchar(35) DEFAULT NULL COMMENT '发送账号',
  `reqid` bigint(20) unsigned DEFAULT '0' COMMENT '请求ID',
  `type` tinyint(3) unsigned DEFAULT '0' COMMENT '短信媒体类型',
  `content` varchar(1000) DEFAULT NULL COMMENT '参数内容',
  `smstxt` varchar(1000) DEFAULT NULL COMMENT '短信文本内容',
  `tplid` varchar(35) DEFAULT NULL COMMENT '模板ID',
  `sms_type` tinyint(3) unsigned DEFAULT '0' COMMENT '短信类型',
  `sign` varchar(25) DEFAULT NULL COMMENT '签名',
  `extend` varchar(50) DEFAULT NULL COMMENT '扩展号',
  `idxkey` int(10) unsigned DEFAULT '0' COMMENT '索引Key',
  `create_time` int(10) unsigned DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `reqid` (`reqid`),
  KEY `user_id` (`user_id`),
  KEY `account` (`account`)
) ENGINE=InnoDB AUTO_INCREMENT=4388554 DEFAULT CHARSET=utf8 COMMENT='短信内容';

-- ----------------------------
-- Table structure for sms_smscountacc
-- ----------------------------
DROP TABLE IF EXISTS `sms_smscountacc`;
CREATE TABLE `sms_smscountacc` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `idate` int(11) DEFAULT NULL COMMENT '日期',
  `num` int(11) DEFAULT NULL COMMENT '条数',
  `account` varchar(50) DEFAULT NULL COMMENT '业务名称',
  `idxkey` int(11) DEFAULT NULL COMMENT '分区值',
  `created_key` char(20) DEFAULT NULL COMMENT '插入时key',
  PRIMARY KEY (`id`),
  KEY `idate` (`idate`,`account`(15)),
  KEY `created_key` (`created_key`)
) ENGINE=InnoDB AUTO_INCREMENT=1262 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for sms_smscountall
-- ----------------------------
DROP TABLE IF EXISTS `sms_smscountall`;
CREATE TABLE `sms_smscountall` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `gateway` varchar(50) DEFAULT NULL COMMENT '网关',
  `gateway_id` int(11) DEFAULT NULL COMMENT '网关ID',
  `num` int(11) DEFAULT NULL COMMENT '发送总数',
  `isabled` tinyint(1) DEFAULT '1' COMMENT '是否可用',
  `idate` int(11) DEFAULT NULL COMMENT 'key',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for sms_smscounttpl
-- ----------------------------
DROP TABLE IF EXISTS `sms_smscounttpl`;
CREATE TABLE `sms_smscounttpl` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tpl_id` int(11) DEFAULT NULL COMMENT '模板ID',
  `tpl` varchar(35) DEFAULT NULL COMMENT '模板编号',
  `num` int(11) DEFAULT '0' COMMENT '条数',
  `idate` int(11) DEFAULT NULL COMMENT '统计日期',
  `idxkey` int(11) DEFAULT NULL COMMENT '预留分区值',
  `created_key` char(20) DEFAULT NULL COMMENT '插入key',
  PRIMARY KEY (`id`),
  KEY `tplid` (`tpl_id`,`idate`),
  KEY `create_key` (`created_key`)
) ENGINE=InnoDB AUTO_INCREMENT=2209 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for sms_smsgateway
-- ----------------------------
DROP TABLE IF EXISTS `sms_smsgateway`;
CREATE TABLE `sms_smsgateway` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(35) NOT NULL,
  `name` varchar(50) NOT NULL,
  `sequence` smallint(5) unsigned DEFAULT '0',
  `remark` varchar(500) DEFAULT NULL,
  `disable` tinyint(1) unsigned DEFAULT '0',
  `update_time` int(10) unsigned DEFAULT '0',
  `create_time` int(10) unsigned DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for sms_smsgatewayconfig
-- ----------------------------
DROP TABLE IF EXISTS `sms_smsgatewayconfig`;
CREATE TABLE `sms_smsgatewayconfig` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '编号ID',
  `api_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '接口ID',
  `name` varchar(35) NOT NULL COMMENT '名称',
  `diff` tinyint(1) unsigned DEFAULT '0' COMMENT '默认. 0否,1是',
  `config` text COMMENT '配置',
  `link_count` int(10) unsigned DEFAULT '0' COMMENT '引用数',
  `disable` tinyint(1) unsigned DEFAULT '0' COMMENT '禁用. 0正常,1禁用',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for sms_smslicense
-- ----------------------------
DROP TABLE IF EXISTS `sms_smslicense`;
CREATE TABLE `sms_smslicense` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '自动编号',
  `name` varchar(50) DEFAULT NULL COMMENT '名称',
  `link_count` int(10) unsigned DEFAULT '0' COMMENT '引用数',
  `file_name` varchar(100) DEFAULT NULL COMMENT '文件名',
  `file_path` varchar(255) DEFAULT NULL COMMENT '存放路径',
  `file_size` int(10) unsigned DEFAULT '0' COMMENT '文件大小',
  `file_type` varchar(50) DEFAULT NULL COMMENT '文件类型',
  `file_md5` char(32) DEFAULT NULL COMMENT '文件Md5',
  `user_id` int(10) unsigned DEFAULT '0' COMMENT '上传用户',
  `remark` varchar(300) DEFAULT NULL COMMENT '备注说明',
  `disable` tinyint(1) unsigned DEFAULT '0' COMMENT '禁用. 0正常,1禁用',
  `create_time` int(10) unsigned DEFAULT '0' COMMENT '创建时间',
  `update_time` int(10) unsigned DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='短信相关证书';

-- ----------------------------
-- Table structure for sms_smslist
-- ----------------------------
DROP TABLE IF EXISTS `sms_smslist`;
CREATE TABLE `sms_smslist` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '编号ID',
  `user_id` int(10) unsigned DEFAULT '0' COMMENT '所属用户',
  `account` varchar(35) DEFAULT NULL COMMENT '发送账号',
  `content_id` bigint(20) unsigned DEFAULT '0' COMMENT '内容ID',
  `mobile` varchar(15) DEFAULT NULL COMMENT '手机号',
  `cipher` varchar(64) DEFAULT NULL COMMENT '手机密文',
  `search_key` char(64) DEFAULT NULL COMMENT '手机查询key',
  `status` tinyint(3) unsigned DEFAULT '0' COMMENT '状态',
  `api_name` varchar(35) DEFAULT NULL COMMENT '发送接口',
  `reqtime` decimal(7,3) unsigned DEFAULT '0.000' COMMENT '接口请求时间',
  `send_time` int(10) unsigned DEFAULT '0' COMMENT '发送时间',
  `send_status` tinyint(3) unsigned DEFAULT '0' COMMENT '发送状态',
  `send_count` smallint(5) unsigned DEFAULT '0' COMMENT '发送次数',
  `reqid` varchar(40) DEFAULT NULL COMMENT '返回短信ID',
  `receive_time` int(10) unsigned DEFAULT '0' COMMENT '接收时间',
  `receive_status` tinyint(3) unsigned DEFAULT '0' COMMENT '接收状态',
  `receive_code` varchar(25) DEFAULT NULL COMMENT '接收状态码',
  `receive_detail` varchar(80) DEFAULT NULL COMMENT '接收详细说明',
  `intr` varchar(100) DEFAULT NULL COMMENT '备注说明',
  `idxkey` int(10) unsigned DEFAULT '0' COMMENT '索引Key',
  `create_time` int(10) unsigned DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `content_id` (`content_id`),
  KEY `mobile` (`mobile`),
  KEY `reqid` (`reqid`),
  KEY `send_status` (`send_status`),
  KEY `api_name` (`api_name`),
  KEY `account` (`account`),
  KEY `user_id` (`user_id`,`account`,`send_time`) USING BTREE,
  KEY `search_key` (`search_key`) USING BTREE,
  KEY `create_time` (`create_time`)
) ENGINE=InnoDB AUTO_INCREMENT=4930487 DEFAULT CHARSET=utf8 COMMENT='短信列表';

-- ----------------------------
-- Table structure for sms_smslogs
-- ----------------------------
DROP TABLE IF EXISTS `sms_smslogs`;
CREATE TABLE `sms_smslogs` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '编号ID',
  `smsid` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '短信ID',
  `api_name` varchar(35) DEFAULT NULL COMMENT '网关接口',
  `route_type` varchar(15) DEFAULT NULL COMMENT '路由方式',
  `mobile` varchar(15) DEFAULT NULL COMMENT '手机号',
  `cipher` varchar(64) DEFAULT NULL COMMENT '手机密文',
  `search_key` char(64) DEFAULT NULL,
  `status` tinyint(3) unsigned DEFAULT '0' COMMENT '短信状态',
  `reqtime` decimal(7,3) unsigned DEFAULT '0.000' COMMENT '网关请求时间',
  `send_time` int(10) unsigned DEFAULT '0' COMMENT '发送时间',
  `send_status` tinyint(3) unsigned DEFAULT '0' COMMENT '发送状态',
  `reqid` varchar(40) DEFAULT NULL COMMENT '返回短信ID',
  `receive_time` int(10) unsigned DEFAULT '0' COMMENT '接收时间',
  `receive_status` tinyint(3) unsigned DEFAULT '0' COMMENT '接收状态',
  `receive_code` varchar(25) DEFAULT NULL COMMENT '接收状态码',
  `receive_detail` varchar(100) DEFAULT NULL COMMENT '接收详细信息',
  `intr` varchar(100) DEFAULT NULL COMMENT '备注说明',
  `count` smallint(5) unsigned DEFAULT '0' COMMENT '短信条数',
  `fee` decimal(6,4) unsigned DEFAULT '0.0000' COMMENT '费用',
  `idxkey` int(10) unsigned DEFAULT '0' COMMENT '索引Key',
  `create_time` int(10) unsigned DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `smsid` (`smsid`),
  KEY `api_name` (`api_name`),
  KEY `reqid` (`reqid`),
  KEY `status` (`status`),
  KEY `sendtime` (`send_time`),
  KEY `search_key` (`search_key`) USING BTREE,
  KEY `create_time` (`create_time`)
) ENGINE=InnoDB AUTO_INCREMENT=5300027 DEFAULT CHARSET=utf8 COMMENT='短信发送日志';

-- ----------------------------
-- Table structure for sms_smspost
-- ----------------------------
DROP TABLE IF EXISTS `sms_smspost`;
CREATE TABLE `sms_smspost` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT ' 编号ID',
  `account` varchar(35) DEFAULT NULL COMMENT '发送账号',
  `smsid` bigint(20) unsigned DEFAULT '0' COMMENT '短信ID',
  `post_status` tinyint(3) unsigned DEFAULT '0' COMMENT '推送状态',
  `post_count` smallint(5) unsigned DEFAULT '0' COMMENT '推送次数',
  `post_time` int(10) unsigned DEFAULT '0' COMMENT '推送时间',
  `idxkey` int(10) unsigned DEFAULT '0' COMMENT '索引',
  `create_time` int(10) unsigned DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `smsid` (`smsid`),
  KEY `post_status` (`post_status`),
  KEY `post_count` (`post_count`),
  KEY `create_time` (`create_time`)
) ENGINE=InnoDB AUTO_INCREMENT=4825928 DEFAULT CHARSET=utf8 COMMENT='短信推送';

-- ----------------------------
-- Table structure for sms_smsreply
-- ----------------------------
DROP TABLE IF EXISTS `sms_smsreply`;
CREATE TABLE `sms_smsreply` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `apiname` varchar(35) NOT NULL,
  `appid` int(10) unsigned NOT NULL DEFAULT '0',
  `mobile` varchar(15) NOT NULL,
  `content` varchar(300) DEFAULT NULL,
  `replytime` int(10) unsigned NOT NULL DEFAULT '0',
  `extend` varchar(36) DEFAULT NULL,
  `baseextend` varchar(30) DEFAULT NULL,
  `time` int(10) unsigned NOT NULL DEFAULT '0',
  `sendcnt` smallint(10) unsigned NOT NULL DEFAULT '0',
  `sendtime` int(10) unsigned NOT NULL DEFAULT '0',
  `sendstatus` tinyint(1) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for sms_smsreplyconf
-- ----------------------------
DROP TABLE IF EXISTS `sms_smsreplyconf`;
CREATE TABLE `sms_smsreplyconf` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `appid` int(10) unsigned NOT NULL DEFAULT '0',
  `replyurl` varchar(255) DEFAULT NULL,
  `disable` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `distime` int(10) unsigned NOT NULL DEFAULT '0',
  `time` int(10) unsigned NOT NULL DEFAULT '0',
  `extyp` varchar(36) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `extyp` (`extyp`),
  KEY `appid` (`appid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for sms_smsrequest
-- ----------------------------
DROP TABLE IF EXISTS `sms_smsrequest`;
CREATE TABLE `sms_smsrequest` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '编号ID',
  `user_id` int(10) unsigned DEFAULT '0' COMMENT '用户ID',
  `account` varchar(35) DEFAULT NULL COMMENT 'API账号',
  `reqtime` decimal(7,3) unsigned DEFAULT '0.000' COMMENT '请求时间',
  `apitime` decimal(7,3) unsigned DEFAULT '0.000' COMMENT 'API请求时间',
  `ip` varchar(40) DEFAULT NULL COMMENT '请求IP',
  `path` varchar(50) DEFAULT NULL COMMENT '请求路径',
  `intr` varchar(255) DEFAULT NULL COMMENT '备注信息',
  `idxkey` int(10) unsigned DEFAULT '0' COMMENT '索引',
  `create_time` int(10) unsigned DEFAULT '0' COMMENT '请求时间',
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `account` (`account`)
) ENGINE=InnoDB AUTO_INCREMENT=3247103 DEFAULT CHARSET=utf8 COMMENT='请求日志';

-- ----------------------------
-- Table structure for sms_smsroute
-- ----------------------------
DROP TABLE IF EXISTS `sms_smsroute`;
CREATE TABLE `sms_smsroute` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '编号ID',
  `name` varchar(35) DEFAULT NULL COMMENT '名称',
  `sms_type` tinyint(3) unsigned DEFAULT '0' COMMENT '短信类型',
  `gateway` varchar(35) DEFAULT NULL COMMENT '网关接口',
  `gateway_conf` varchar(500) DEFAULT NULL COMMENT '网关配置',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注说明',
  `disable` tinyint(1) unsigned DEFAULT '0' COMMENT '禁用. 0正常,1禁用',
  `create_time` int(10) unsigned DEFAULT '0' COMMENT '创建时间',
  `update_time` int(10) unsigned DEFAULT '0' COMMENT '修改时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8 COMMENT='短信路由配置';

-- ----------------------------
-- Table structure for sms_smsrouteconfig
-- ----------------------------
DROP TABLE IF EXISTS `sms_smsrouteconfig`;
CREATE TABLE `sms_smsrouteconfig` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '编号',
  `route_id` int(10) unsigned DEFAULT '0' COMMENT '路由ID',
  `code` varchar(20) DEFAULT NULL COMMENT '规则编号',
  `cond` text COMMENT '条件',
  `config` text COMMENT '配置',
  `disable` tinyint(1) unsigned DEFAULT '0' COMMENT '禁用. 0正常,1禁用',
  PRIMARY KEY (`id`),
  KEY `route_id` (`route_id`)
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for sms_smssendexception
-- ----------------------------
DROP TABLE IF EXISTS `sms_smssendexception`;
CREATE TABLE `sms_smssendexception` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `logid` int(10) unsigned NOT NULL DEFAULT '0',
  `mobile` varchar(15) NOT NULL,
  `recode` varchar(25) NOT NULL,
  `resend` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `time` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `logid` (`logid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for sms_smssendlog
-- ----------------------------
DROP TABLE IF EXISTS `sms_smssendlog`;
CREATE TABLE `sms_smssendlog` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `appid` int(10) unsigned DEFAULT '0',
  `userid` int(10) DEFAULT '0',
  `apiname` varchar(35) NOT NULL,
  `smstype` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `content` varchar(300) DEFAULT NULL,
  `mobile` text,
  `nocnt` int(10) unsigned NOT NULL DEFAULT '0',
  `ip` varchar(16) DEFAULT NULL,
  `time` int(10) unsigned DEFAULT '0',
  `sid` bigint(20) unsigned DEFAULT '0',
  `vsid` varchar(32) NOT NULL DEFAULT '',
  `ssid` bigint(20) unsigned NOT NULL DEFAULT '0',
  `result` mediumtext,
  `reqtime` decimal(8,4) unsigned DEFAULT '0.0000',
  `resultcode` int(11) DEFAULT NULL,
  `status` tinyint(1) unsigned DEFAULT '0',
  `info` varchar(255) DEFAULT NULL,
  `remark` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `appid` (`appid`),
  KEY `time` (`time`),
  KEY `content` (`content`(255)),
  KEY `sid` (`sid`),
  KEY `ssid` (`ssid`),
  KEY `vsid` (`vsid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for sms_smssign
-- ----------------------------
DROP TABLE IF EXISTS `sms_smssign`;
CREATE TABLE `sms_smssign` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '编号',
  `user_id` int(10) unsigned DEFAULT '0' COMMENT '申请人ID',
  `sign` varchar(35) DEFAULT NULL COMMENT '签名',
  `code` varchar(35) DEFAULT NULL COMMENT '编号',
  `isglb` tinyint(1) DEFAULT NULL COMMENT '国际短信. 0否,1是',
  `channel` tinyint(1) DEFAULT NULL COMMENT '专用通道. 0否,1是',
  `industry` varchar(50) DEFAULT NULL COMMENT '行业',
  `status` tinyint(3) unsigned DEFAULT '0' COMMENT '状态',
  `remark` varchar(300) DEFAULT NULL COMMENT '备注说明',
  `disable` tinyint(1) unsigned DEFAULT '0' COMMENT '禁用. 0正常,1禁用',
  `create_time` int(10) unsigned DEFAULT '0' COMMENT '创建时间',
  `update_time` int(10) unsigned DEFAULT '0' COMMENT '修改时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COMMENT='短信签名';

-- ----------------------------
-- Table structure for sms_smssignlicense
-- ----------------------------
DROP TABLE IF EXISTS `sms_smssignlicense`;
CREATE TABLE `sms_smssignlicense` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '编号',
  `sign_id` int(10) unsigned DEFAULT '0' COMMENT '签名ID',
  `license_id` int(10) unsigned DEFAULT '0' COMMENT '证书ID',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='短信签名证书';

-- ----------------------------
-- Table structure for sms_smstemplate
-- ----------------------------
DROP TABLE IF EXISTS `sms_smstemplate`;
CREATE TABLE `sms_smstemplate` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '编号ID',
  `user_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '创建人ID',
  `name` varchar(50) NOT NULL COMMENT '模板名称',
  `type` tinyint(3) unsigned DEFAULT '0' COMMENT '类型',
  `code` varchar(35) DEFAULT NULL COMMENT '模板编码',
  `content` varchar(500) DEFAULT NULL COMMENT '模板内容',
  `sms_type` tinyint(3) unsigned DEFAULT '0' COMMENT '短信类型',
  `param_count` smallint(5) unsigned DEFAULT '0' COMMENT '模板参数个数',
  `status` tinyint(3) unsigned DEFAULT '0' COMMENT '状态',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注说明',
  `disable` tinyint(1) unsigned DEFAULT '0' COMMENT '禁用. 0正常,1禁用',
  `create_time` int(10) unsigned DEFAULT '0' COMMENT '创建时间',
  `update_time` int(10) unsigned DEFAULT '0' COMMENT '修改时间',
  PRIMARY KEY (`id`),
  KEY `name` (`name`),
  KEY `code` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=80 DEFAULT CHARSET=utf8 COMMENT='短信模板';

-- ----------------------------
-- Table structure for sms_smstplconfig
-- ----------------------------
DROP TABLE IF EXISTS `sms_smstplconfig`;
CREATE TABLE `sms_smstplconfig` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '编号ID',
  `tpl_id` int(10) unsigned DEFAULT '0' COMMENT '短信模板ID',
  `api_id` int(10) unsigned DEFAULT '0' COMMENT '短信网关ID',
  `api_keyid` int(10) unsigned DEFAULT '0' COMMENT '短信接口账号',
  `api_tplid` varchar(50) DEFAULT NULL COMMENT '模板ID',
  `status` tinyint(3) unsigned DEFAULT '0' COMMENT '状态',
  `remark` varchar(100) DEFAULT NULL COMMENT '备注说明',
  `disable` tinyint(1) unsigned DEFAULT '0' COMMENT '禁用. 0正常,1禁用',
  `check_time` int(10) unsigned DEFAULT '0' COMMENT '审核通过时间',
  `create_time` int(10) unsigned DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `api_id` (`api_id`),
  KEY `tpl_id` (`tpl_id`),
  KEY `api_keyid` (`api_keyid`)
) ENGINE=InnoDB AUTO_INCREMENT=212 DEFAULT CHARSET=utf8 COMMENT='短信模板配置';

-- ----------------------------
-- Table structure for sms_smstplgroup
-- ----------------------------
DROP TABLE IF EXISTS `sms_smstplgroup`;
CREATE TABLE `sms_smstplgroup` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(35) NOT NULL COMMENT '分组名',
  `sequence` smallint(5) unsigned DEFAULT '0' COMMENT '顺序',
  `disable` tinyint(1) unsigned DEFAULT '0' COMMENT '状态. 0正常,1禁用',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='短信模板分组';

-- ----------------------------
-- Table structure for sms_sum_receive
-- ----------------------------
DROP TABLE IF EXISTS `sms_sum_receive`;
CREATE TABLE `sms_sum_receive` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `supplier` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `sms_type` int(11) DEFAULT NULL,
  `total` int(11) DEFAULT NULL,
  `bad_time_num` int(11) DEFAULT NULL,
  `right_time_num` int(11) DEFAULT NULL,
  `scale` float(4,2) DEFAULT NULL,
  `stime` int(11) DEFAULT NULL,
  `etime` int(11) DEFAULT NULL,
  `score_time` int(11) DEFAULT NULL COMMENT '合格时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=97 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for sms_sum_scale_time
-- ----------------------------
DROP TABLE IF EXISTS `sms_sum_scale_time`;
CREATE TABLE `sms_sum_scale_time` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sms_type` int(11) DEFAULT NULL COMMENT '短信类型',
  `supplier` varchar(255) DEFAULT NULL COMMENT '供应商',
  `scale_time` varchar(255) DEFAULT NULL COMMENT '合格时间',
  `num` int(11) DEFAULT NULL COMMENT '达标数量',
  `total` int(11) DEFAULT NULL COMMENT '总数量',
  `stime` int(11) DEFAULT NULL COMMENT '统计时间',
  `etime` int(11) DEFAULT NULL COMMENT '统计时间',
  PRIMARY KEY (`id`),
  KEY `sms_type` (`sms_type`,`stime`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=483 DEFAULT CHARSET=utf8 COMMENT='统计到达时间表';

-- ----------------------------
-- Table structure for sms_sum_success_rate
-- ----------------------------
DROP TABLE IF EXISTS `sms_sum_success_rate`;
CREATE TABLE `sms_sum_success_rate` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tpl_id` varchar(64) DEFAULT NULL,
  `sms_type` int(11) DEFAULT NULL,
  `supplier` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `total` int(11) DEFAULT NULL,
  `success_num` int(11) DEFAULT NULL,
  `failure_num` int(11) DEFAULT NULL,
  `stime` int(11) DEFAULT NULL COMMENT '统计时间',
  `etime` int(11) DEFAULT NULL,
  `nosure_num` int(11) DEFAULT NULL,
  `scale` float(4,2) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=341 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- View structure for sms_tj
-- ----------------------------
DROP VIEW IF EXISTS `sms_tj`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `sms_tj` AS select (`sl`.`receive_time` - `sl`.`send_time`) AS `dt`,`sl`.`api_name` AS `api_name`,`sc`.`sms_type` AS `sms_type` from (`sms_smslist` `sl` left join `sms_smscontent` `sc` on((`sl`.`content_id` = `sc`.`id`))) where ((`sl`.`receive_status` = 1) and (`sl`.`send_time` >= 1562032800) and (`sl`.`send_time` <= 1562637600)) order by (`sl`.`receive_time` - `sl`.`send_time`);

SET FOREIGN_KEY_CHECKS = 1;
