/*
Navicat MySQL Data Transfer

Source Server         : localhost_3306
Source Server Version : 50527
Source Host           : localhost:3306
Source Database       : gw_erp

Target Server Type    : MYSQL
Target Server Version : 50527
File Encoding         : 65001

Date: 2021-03-11 14:54:35
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for `gw_account`
-- ----------------------------
DROP TABLE IF EXISTS `gw_account`;
CREATE TABLE `gw_account` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(50) DEFAULT NULL COMMENT '名称',
  `serial_no` varchar(50) DEFAULT NULL COMMENT '编号',
  `initial_amount` decimal(24,6) DEFAULT NULL COMMENT '期初金额',
  `current_amount` decimal(24,6) DEFAULT NULL COMMENT '当前余额',
  `remark` varchar(100) DEFAULT NULL COMMENT '备注',
  `is_default` bit(1) DEFAULT NULL COMMENT '是否默认',
  `tenant_id` bigint(20) DEFAULT NULL COMMENT '租户id',
  `delete_flag` varchar(1) DEFAULT '0' COMMENT '删除标记，0未删除，1删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8 COMMENT='账户信息';

-- ----------------------------
-- Records of gw_account
-- ----------------------------
INSERT INTO `gw_account` VALUES ('19', '账户000', 'acount000', '20000.000000', null, '', '', '63', '0');

-- ----------------------------
-- Table structure for `gw_account_head`
-- ----------------------------
DROP TABLE IF EXISTS `gw_account_head`;
CREATE TABLE `gw_account_head` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `type` varchar(50) DEFAULT NULL COMMENT '类型(支出/收入/收款/付款/转账)',
  `organ_id` bigint(20) DEFAULT NULL COMMENT '单位Id(收款/付款单位)',
  `hands_person_id` bigint(20) DEFAULT NULL COMMENT '经手人id',
  `creator` bigint(20) DEFAULT NULL COMMENT '操作员',
  `change_amount` decimal(24,6) DEFAULT NULL COMMENT '变动金额(优惠/收款/付款/实付)',
  `total_price` decimal(24,6) DEFAULT NULL COMMENT '合计金额',
  `account_id` bigint(20) DEFAULT NULL COMMENT '账户(收款/付款)',
  `bill_no` varchar(50) DEFAULT NULL COMMENT '单据编号',
  `bill_time` datetime DEFAULT NULL COMMENT '单据日期',
  `remark` varchar(100) DEFAULT NULL COMMENT '备注',
  `tenant_id` bigint(20) DEFAULT NULL COMMENT '租户id',
  `delete_flag` varchar(1) DEFAULT '0' COMMENT '删除标记，0未删除，1删除',
  PRIMARY KEY (`id`),
  KEY `FK9F4C0D8DB610FC06` (`organ_id`),
  KEY `FK9F4C0D8DAAE50527` (`account_id`),
  KEY `FK9F4C0D8DC4170B37` (`hands_person_id`)
) ENGINE=InnoDB AUTO_INCREMENT=107 DEFAULT CHARSET=utf8 COMMENT='财务主表';

-- ----------------------------
-- Records of gw_account_head
-- ----------------------------

-- ----------------------------
-- Table structure for `gw_account_item`
-- ----------------------------
DROP TABLE IF EXISTS `gw_account_item`;
CREATE TABLE `gw_account_item` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `header_id` bigint(20) NOT NULL COMMENT '表头Id',
  `account_id` bigint(20) DEFAULT NULL COMMENT '账户Id',
  `in_out_item_id` bigint(20) DEFAULT NULL COMMENT '收支项目Id',
  `each_amount` decimal(24,6) DEFAULT NULL COMMENT '单项金额',
  `remark` varchar(100) DEFAULT NULL COMMENT '单据备注',
  `tenant_id` bigint(20) DEFAULT NULL COMMENT '租户id',
  `delete_flag` varchar(1) DEFAULT '0' COMMENT '删除标记，0未删除，1删除',
  PRIMARY KEY (`id`),
  KEY `FK9F4CBAC0AAE50527` (`account_id`),
  KEY `FK9F4CBAC0C5FE6007` (`header_id`),
  KEY `FK9F4CBAC0D203EDC5` (`in_out_item_id`)
) ENGINE=InnoDB AUTO_INCREMENT=108 DEFAULT CHARSET=utf8 COMMENT='财务子表';

-- ----------------------------
-- Records of gw_account_item
-- ----------------------------

-- ----------------------------
-- Table structure for `gw_depot`
-- ----------------------------
DROP TABLE IF EXISTS `gw_depot`;
CREATE TABLE `gw_depot` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(20) DEFAULT NULL COMMENT '仓库名称',
  `address` varchar(50) DEFAULT NULL COMMENT '仓库地址',
  `warehousing` decimal(24,6) DEFAULT NULL COMMENT '仓储费',
  `truckage` decimal(24,6) DEFAULT NULL COMMENT '搬运费',
  `type` int(10) DEFAULT NULL COMMENT '类型',
  `sort` varchar(10) DEFAULT NULL COMMENT '排序',
  `remark` varchar(100) DEFAULT NULL COMMENT '描述',
  `principal` bigint(20) DEFAULT NULL COMMENT '负责人',
  `tenant_id` bigint(20) DEFAULT NULL COMMENT '租户id',
  `delete_Flag` varchar(1) DEFAULT '0' COMMENT '删除标记，0未删除，1删除',
  `is_default` bit(1) DEFAULT NULL COMMENT '是否默认',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8 COMMENT='仓库表';

-- ----------------------------
-- Records of gw_depot
-- ----------------------------
INSERT INTO `gw_depot` VALUES ('18', '仓库000', '梧桐街', null, null, '0', '', '', null, '63', '0', '');

-- ----------------------------
-- Table structure for `gw_depot_head`
-- ----------------------------
DROP TABLE IF EXISTS `gw_depot_head`;
CREATE TABLE `gw_depot_head` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `type` varchar(50) DEFAULT NULL COMMENT '类型(出库/入库)',
  `sub_type` varchar(50) DEFAULT NULL COMMENT '出入库分类',
  `default_number` varchar(50) DEFAULT NULL COMMENT '初始票据号',
  `number` varchar(50) DEFAULT NULL COMMENT '票据号',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `oper_time` datetime DEFAULT NULL COMMENT '出入库时间',
  `organ_id` bigint(20) DEFAULT NULL COMMENT '供应商id',
  `hands_person_id` bigint(20) DEFAULT NULL COMMENT '采购/领料-经手人id',
  `creator` bigint(20) DEFAULT NULL COMMENT '操作员',
  `account_id` bigint(20) DEFAULT NULL COMMENT '账户id',
  `change_amount` decimal(24,6) DEFAULT NULL COMMENT '变动金额(收款/付款)',
  `total_price` decimal(24,6) DEFAULT NULL COMMENT '合计金额',
  `pay_type` varchar(50) DEFAULT NULL COMMENT '付款类型(现金、记账等)',
  `bill_type` varchar(50) DEFAULT NULL COMMENT '单据类型',
  `remark` varchar(1000) DEFAULT NULL COMMENT '备注',
  `sales_man` varchar(50) DEFAULT NULL COMMENT '业务员（可以多个）',
  `account_id_list` varchar(50) DEFAULT NULL COMMENT '多账户ID列表',
  `account_money_list` varchar(200) DEFAULT NULL COMMENT '多账户金额列表',
  `discount` decimal(24,6) DEFAULT NULL COMMENT '优惠率',
  `discount_money` decimal(24,6) DEFAULT NULL COMMENT '优惠金额',
  `discount_last_money` decimal(24,6) DEFAULT NULL COMMENT '优惠后金额',
  `other_money` decimal(24,6) DEFAULT NULL COMMENT '销售或采购费用合计',
  `other_money_list` varchar(200) DEFAULT NULL COMMENT '销售或采购费用涉及项目Id数组（包括快递、招待等）',
  `other_money_item` varchar(200) DEFAULT NULL COMMENT '销售或采购费用涉及项目（包括快递、招待等）',
  `account_day` int(10) DEFAULT NULL COMMENT '结算天数',
  `status` varchar(1) DEFAULT NULL COMMENT '状态，0未审核、1已审核、2已转采购|销售',
  `link_number` varchar(50) DEFAULT NULL COMMENT '关联订单号',
  `tenant_id` bigint(20) DEFAULT NULL COMMENT '租户id',
  `delete_flag` varchar(1) DEFAULT '0' COMMENT '删除标记，0未删除，1删除',
  PRIMARY KEY (`id`),
  KEY `FK2A80F214C4170B37` (`hands_person_id`),
  KEY `FK2A80F214B610FC06` (`organ_id`),
  KEY `FK2A80F214AAE50527` (`account_id`)
) ENGINE=InnoDB AUTO_INCREMENT=270 DEFAULT CHARSET=utf8 COMMENT='单据主表';

-- ----------------------------
-- Records of gw_depot_head
-- ----------------------------

-- ----------------------------
-- Table structure for `gw_depot_item`
-- ----------------------------
DROP TABLE IF EXISTS `gw_depot_item`;
CREATE TABLE `gw_depot_item` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `header_id` bigint(20) NOT NULL COMMENT '表头Id',
  `material_id` bigint(20) NOT NULL COMMENT '商品Id',
  `material_extend_id` bigint(20) DEFAULT NULL COMMENT '商品扩展id',
  `material_unit` varchar(20) DEFAULT NULL COMMENT '商品计量单位',
  `oper_number` decimal(24,6) DEFAULT NULL COMMENT '数量',
  `basic_number` decimal(24,6) DEFAULT NULL COMMENT '基础数量，如kg、瓶',
  `unit_price` decimal(24,6) DEFAULT NULL COMMENT '单价',
  `tax_unit_price` decimal(24,6) DEFAULT NULL COMMENT '含税单价',
  `all_price` decimal(24,6) DEFAULT NULL COMMENT '金额',
  `remark` varchar(200) DEFAULT NULL COMMENT '备注',
  `img` varchar(50) DEFAULT NULL COMMENT '图片',
  `incidentals` decimal(24,6) DEFAULT NULL COMMENT '运杂费',
  `depot_id` bigint(20) DEFAULT NULL COMMENT '仓库ID',
  `another_depot_id` bigint(20) DEFAULT NULL COMMENT '调拨时，对方仓库Id',
  `tax_rate` decimal(24,6) DEFAULT NULL COMMENT '税率',
  `tax_money` decimal(24,6) DEFAULT NULL COMMENT '税额',
  `tax_last_money` decimal(24,6) DEFAULT NULL COMMENT '价税合计',
  `other_field1` varchar(50) DEFAULT NULL COMMENT '自定义字段1-名称',
  `other_field2` varchar(50) DEFAULT NULL COMMENT '自定义字段2-型号',
  `other_field3` varchar(50) DEFAULT NULL COMMENT '自定义字段3-制造商',
  `other_field4` varchar(50) DEFAULT NULL COMMENT '自定义字段4-名称',
  `other_field5` varchar(50) DEFAULT NULL COMMENT '自定义字段5-名称',
  `material_type` varchar(20) DEFAULT NULL COMMENT '商品类型',
  `tenant_id` bigint(20) DEFAULT NULL COMMENT '租户id',
  `delete_flag` varchar(1) DEFAULT '0' COMMENT '删除标记，0未删除，1删除',
  PRIMARY KEY (`id`),
  KEY `FK2A819F475D61CCF7` (`material_id`),
  KEY `FK2A819F474BB6190E` (`header_id`),
  KEY `FK2A819F479485B3F5` (`depot_id`),
  KEY `FK2A819F47729F5392` (`another_depot_id`)
) ENGINE=InnoDB AUTO_INCREMENT=288 DEFAULT CHARSET=utf8 COMMENT='单据子表';

-- ----------------------------
-- Records of gw_depot_item
-- ----------------------------

-- ----------------------------
-- Table structure for `gw_function`
-- ----------------------------
DROP TABLE IF EXISTS `gw_function`;
CREATE TABLE `gw_function` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `number` varchar(50) DEFAULT NULL COMMENT '编号',
  `name` varchar(50) DEFAULT NULL COMMENT '名称',
  `parent_number` varchar(50) DEFAULT NULL COMMENT '上级编号',
  `url` varchar(100) DEFAULT NULL COMMENT '链接',
  `state` bit(1) DEFAULT NULL COMMENT '收缩',
  `sort` varchar(50) DEFAULT NULL COMMENT '排序',
  `enabled` bit(1) DEFAULT NULL COMMENT '启用',
  `type` varchar(50) DEFAULT NULL COMMENT '类型',
  `push_btn` varchar(50) DEFAULT NULL COMMENT '功能按钮',
  `icon` varchar(50) DEFAULT NULL COMMENT '图标',
  `delete_flag` varchar(1) DEFAULT '0' COMMENT '删除标记，0未删除，1删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=246 DEFAULT CHARSET=utf8 COMMENT='功能模块表';

-- ----------------------------
-- Records of gw_function
-- ----------------------------
INSERT INTO `gw_function` VALUES ('1', '0001', '系统管理', '0', '', '', '0910', '', '电脑版', '', 'icon-settings', '0');
INSERT INTO `gw_function` VALUES ('13', '000102', '角色管理', '0001', '/pages/manage/role.html', '', '0130', '', '电脑版', '1', 'icon-notebook', '0');
INSERT INTO `gw_function` VALUES ('14', '000103', '用户管理', '0001', '/pages/manage/user.html', '', '0140', '', '电脑版', '1', 'icon-notebook', '0');
INSERT INTO `gw_function` VALUES ('15', '000104', '日志管理', '0001', '/pages/manage/log.html', '', '0160', '', '电脑版', '', 'icon-notebook', '0');
INSERT INTO `gw_function` VALUES ('16', '000105', '功能管理', '0001', '/pages/manage/functions.html', '', '0166', '', '电脑版', '1', 'icon-notebook', '0');
INSERT INTO `gw_function` VALUES ('21', '0101', '商品管理', '0', '', '', '0620', '', '电脑版', null, 'icon-social-dropbox', '0');
INSERT INTO `gw_function` VALUES ('22', '010101', '商品类别', '0101', '/pages/materials/materialcategory.html', '', '0230', '', '电脑版', '1', 'icon-notebook', '0');
INSERT INTO `gw_function` VALUES ('23', '010102', '商品信息', '0101', '/pages/materials/material.html', '', '0240', '', '电脑版', '1', 'icon-notebook', '0');
INSERT INTO `gw_function` VALUES ('24', '0102', '基本资料', '0', '', '', '0750', '', '电脑版', null, 'icon-grid', '0');
INSERT INTO `gw_function` VALUES ('25', '01020101', '供应商信息', '0102', '/pages/manage/vendor.html', '', '0260', '', '电脑版', '1', 'icon-notebook', '0');
INSERT INTO `gw_function` VALUES ('26', '010202', '仓库信息', '0102', '/pages/manage/depot.html', '', '0270', '', '电脑版', '1', 'icon-notebook', '0');
INSERT INTO `gw_function` VALUES ('31', '010206', '经手人管理', '0102', '/pages/manage/person.html', '', '0284', '', '电脑版', '1', 'icon-notebook', '0');
INSERT INTO `gw_function` VALUES ('32', '0502', '采购管理', '0', '', '', '0330', '', '电脑版', '', 'icon-loop', '0');
INSERT INTO `gw_function` VALUES ('33', '050201', '采购入库', '0502', '/pages/bill/purchase_in_list.html', '', '0340', '', '电脑版', '1,2', 'icon-notebook', '0');
INSERT INTO `gw_function` VALUES ('38', '0603', '销售管理', '0', '', '', '0390', '', '电脑版', '', 'icon-briefcase', '0');
INSERT INTO `gw_function` VALUES ('40', '080107', '调拨出库', '0801', '/pages/bill/allocation_out_list.html', '', '0807', '', '电脑版', '1,2', 'icon-notebook', '0');
INSERT INTO `gw_function` VALUES ('41', '060303', '销售出库', '0603', '/pages/bill/sale_out_list.html', '', '0394', '', '电脑版', '1,2', 'icon-notebook', '0');
INSERT INTO `gw_function` VALUES ('44', '0704', '财务管理', '0', '', '', '0450', '', '电脑版', '', 'icon-map', '0');
INSERT INTO `gw_function` VALUES ('59', '030101', '库存状况', '0301', '/pages/reports/in_out_stock_report.html', '', '0600', '', '电脑版', '', 'icon-notebook', '0');
INSERT INTO `gw_function` VALUES ('194', '010204', '收支项目', '0102', '/pages/manage/inOutItem.html', '', '0282', '', '电脑版', '1', 'icon-notebook', '0');
INSERT INTO `gw_function` VALUES ('195', '010205', '结算账户', '0102', '/pages/manage/account.html', '', '0283', '', '电脑版', '1', 'icon-notebook', '0');
INSERT INTO `gw_function` VALUES ('197', '070402', '收入单', '0704', '/pages/financial/item_in.html', '', '0465', '', '电脑版', '1', 'icon-notebook', '0');
INSERT INTO `gw_function` VALUES ('198', '0301', '报表查询', '0', '', '', '0570', '', '电脑版', null, 'icon-pie-chart', '0');
INSERT INTO `gw_function` VALUES ('199', '050204', '采购退货', '0502', '/pages/bill/purchase_back_list.html', '', '0345', '', '电脑版', '1,2', 'icon-notebook', '0');
INSERT INTO `gw_function` VALUES ('200', '060305', '销售退货', '0603', '/pages/bill/sale_back_list.html', '', '0396', '', '电脑版', '1,2', 'icon-notebook', '0');
INSERT INTO `gw_function` VALUES ('201', '080103', '整机入库', '0801', '/pages/bill/other_in_list.html', '', '0803', '', '电脑版', '1,2', 'icon-notebook', '0');
INSERT INTO `gw_function` VALUES ('202', '080105', '领料出库', '0801', '/pages/bill/other_out_list.html', '', '0805', '', '电脑版', '1,2', 'icon-notebook', '0');
INSERT INTO `gw_function` VALUES ('203', '070403', '支出单', '0704', '/pages/financial/item_out.html', '', '0470', '', '电脑版', '1', 'icon-notebook', '0');
INSERT INTO `gw_function` VALUES ('204', '070404', '收款单', '0704', '/pages/financial/money_in.html', '', '0475', '', '电脑版', '1', 'icon-notebook', '0');
INSERT INTO `gw_function` VALUES ('205', '070405', '付款单', '0704', '/pages/financial/money_out.html', '', '0480', '', '电脑版', '1', 'icon-notebook', '0');
INSERT INTO `gw_function` VALUES ('206', '070406', '转账单', '0704', '/pages/financial/giro.html', '', '0490', '', '电脑版', '1', 'icon-notebook', '0');
INSERT INTO `gw_function` VALUES ('207', '030102', '账户统计', '0301', '/pages/reports/account_report.html', '', '0610', '', '电脑版', '', 'icon-notebook', '0');
INSERT INTO `gw_function` VALUES ('208', '030103', '进货统计', '0301', '/pages/reports/buy_in_report.html', '', '0620', '', '电脑版', '', 'icon-notebook', '0');
INSERT INTO `gw_function` VALUES ('209', '030104', '销售统计', '0301', '/pages/reports/sale_out_report.html', '', '0630', '', '电脑版', '', 'icon-notebook', '0');
INSERT INTO `gw_function` VALUES ('210', '040102', '零售出库', '0401', '/pages/bill/retail_out_list.html', '', '0405', '', '电脑版', '1,2', 'icon-notebook', '0');
INSERT INTO `gw_function` VALUES ('211', '040104', '零售退货', '0401', '/pages/bill/retail_back_list.html', '', '0407', '', '电脑版', '1,2', 'icon-notebook', '0');
INSERT INTO `gw_function` VALUES ('212', '070407', '收预付款', '0704', '/pages/financial/advance_in.html', '', '0495', '', '电脑版', '1', 'icon-notebook', '0');
INSERT INTO `gw_function` VALUES ('217', '01020102', '客户信息', '0102', '/pages/manage/customer.html', '', '0262', '', '电脑版', '1', 'icon-notebook', '0');
INSERT INTO `gw_function` VALUES ('218', '01020103', '会员信息', '0102', '/pages/manage/member.html', '', '0263', '', '电脑版', '1', 'icon-notebook', '0');
INSERT INTO `gw_function` VALUES ('220', '010103', '计量单位', '0101', '/pages/manage/unit.html', '', '0245', '', '电脑版', '1', 'icon-notebook', '0');
INSERT INTO `gw_function` VALUES ('225', '0401', '零售管理', '0', '', '', '0101', '', '电脑版', '', 'icon-present', '0');
INSERT INTO `gw_function` VALUES ('226', '030106', '入库明细', '0301', '/pages/reports/in_detail.html', '', '0640', '', '电脑版', '', 'icon-notebook', '0');
INSERT INTO `gw_function` VALUES ('227', '030107', '出库明细', '0301', '/pages/reports/out_detail.html', '', '0645', '', '电脑版', '', 'icon-notebook', '0');
INSERT INTO `gw_function` VALUES ('228', '030108', '入库汇总', '0301', '/pages/reports/in_material_count.html', '', '0650', '', '电脑版', '', 'icon-notebook', '0');
INSERT INTO `gw_function` VALUES ('229', '030109', '出库汇总', '0301', '/pages/reports/out_material_count.html', '', '0655', '', '电脑版', '', 'icon-notebook', '0');
INSERT INTO `gw_function` VALUES ('232', '080109', '组装单', '0801', '/pages/bill/assemble_list.html', '', '0809', '', '电脑版', '1,2', 'icon-notebook', '0');
INSERT INTO `gw_function` VALUES ('233', '080111', '拆卸单', '0801', '/pages/bill/disassemble_list.html', '', '0811', '', '电脑版', '1,2', 'icon-notebook', '0');
INSERT INTO `gw_function` VALUES ('234', '000105', '系统配置', '0001', '/pages/manage/systemConfig.html', '', '0165', '', '电脑版', '1', 'icon-notebook', '0');
INSERT INTO `gw_function` VALUES ('235', '030110', '客户对账', '0301', '/pages/reports/customer_account.html', '', '0660', '', '电脑版', '', 'icon-notebook', '0');
INSERT INTO `gw_function` VALUES ('236', '000106', '商品属性', '0001', '/pages/materials/materialProperty.html', '', '0168', '', '电脑版', '1', 'icon-notebook', '0');
INSERT INTO `gw_function` VALUES ('237', '030111', '供应商对账', '0301', '/pages/reports/vendor_account.html', '', '0665', '', '电脑版', '', 'icon-notebook', '0');
INSERT INTO `gw_function` VALUES ('239', '0801', '仓库管理', '0', '', '', '0420', '', '电脑版', '', 'icon-layers', '0');
INSERT INTO `gw_function` VALUES ('240', '010104', '序列号', '0101', '/pages/manage/serialNumber.html', '', '0246', '', '电脑版', '1', 'icon-notebook', '0');
INSERT INTO `gw_function` VALUES ('241', '050202', '采购订单', '0502', '/pages/bill/purchase_orders_list.html', '', '0335', '', '电脑版', '1,2', 'icon-notebook', '0');
INSERT INTO `gw_function` VALUES ('242', '060301', '销售订单', '0603', '/pages/bill/sale_orders_list.html', '', '0392', '', '电脑版', '1,2', 'icon-notebook', '0');
INSERT INTO `gw_function` VALUES ('243', '000108', '机构管理', '0001', '/pages/manage/organization.html', '', '0150', '', '电脑版', '1', 'icon-notebook', '0');
INSERT INTO `gw_function` VALUES ('244', '030112', '库存预警', '0301', '/pages/reports/stock_warning_report.html', '', '0670', '', '电脑版', '', 'icon-notebook', '0');
INSERT INTO `gw_function` VALUES ('245', '000107', '插件管理', '0001', '/pages/manage/plugin.html', '', '0170', '', '电脑版', '1', 'icon-notebook', '0');

-- ----------------------------
-- Table structure for `gw_in_out_item`
-- ----------------------------
DROP TABLE IF EXISTS `gw_in_out_item`;
CREATE TABLE `gw_in_out_item` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(50) DEFAULT NULL COMMENT '名称',
  `type` varchar(20) DEFAULT NULL COMMENT '类型',
  `remark` varchar(100) DEFAULT NULL COMMENT '备注',
  `tenant_id` bigint(20) DEFAULT NULL COMMENT '租户id',
  `delete_flag` varchar(1) DEFAULT '0' COMMENT '删除标记，0未删除，1删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8 COMMENT='收支项目';

-- ----------------------------
-- Records of gw_in_out_item
-- ----------------------------
INSERT INTO `gw_in_out_item` VALUES ('21', '快递费', '支出', '', '63', '0');
INSERT INTO `gw_in_out_item` VALUES ('22', '房租收入', '收入', '', '63', '0');
INSERT INTO `gw_in_out_item` VALUES ('23', '利息收入', '收入', '收入', '63', '0');

-- ----------------------------
-- Table structure for `gw_log`
-- ----------------------------
DROP TABLE IF EXISTS `gw_log`;
CREATE TABLE `gw_log` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` bigint(20) DEFAULT NULL COMMENT '用户id',
  `operation` varchar(500) DEFAULT NULL COMMENT '操作模块名称',
  `client_ip` varchar(50) DEFAULT NULL COMMENT '客户端IP',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `status` tinyint(4) DEFAULT NULL COMMENT '操作状态 0==成功，1==失败',
  `content` varchar(1000) DEFAULT NULL COMMENT '详情',
  `tenant_id` bigint(20) DEFAULT NULL COMMENT '租户id',
  PRIMARY KEY (`id`),
  KEY `FKF2696AA13E226853` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=333 DEFAULT CHARSET=utf8 COMMENT='操作日志';

-- ----------------------------
-- Records of gw_log
-- ----------------------------

-- ----------------------------
-- Table structure for `gw_material`
-- ----------------------------
DROP TABLE IF EXISTS `gw_material`;
CREATE TABLE `gw_material` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `category_id` bigint(20) DEFAULT NULL COMMENT '产品类型id',
  `name` varchar(50) DEFAULT NULL COMMENT '名称',
  `mfrs` varchar(50) DEFAULT NULL COMMENT '制造商',
  `safety_stock` decimal(24,6) DEFAULT NULL COMMENT '安全存量（KG）',
  `model` varchar(50) DEFAULT NULL COMMENT '型号',
  `standard` varchar(50) DEFAULT NULL COMMENT '规格',
  `color` varchar(50) DEFAULT NULL COMMENT '颜色',
  `unit` varchar(50) DEFAULT NULL COMMENT '单位-单个',
  `remark` varchar(100) DEFAULT NULL COMMENT '备注',
  `unit_id` bigint(20) DEFAULT NULL COMMENT '计量单位Id',
  `enabled` bit(1) DEFAULT NULL COMMENT '启用 0-禁用  1-启用',
  `other_field1` varchar(50) DEFAULT NULL COMMENT '自定义1',
  `other_field2` varchar(50) DEFAULT NULL COMMENT '自定义2',
  `other_field3` varchar(50) DEFAULT NULL COMMENT '自定义3',
  `enable_serial_number` varchar(1) DEFAULT '0' COMMENT '是否开启序列号，0否，1是',
  `tenant_id` bigint(20) DEFAULT NULL COMMENT '租户id',
  `delete_flag` varchar(1) DEFAULT '0' COMMENT '删除标记，0未删除，1删除',
  PRIMARY KEY (`id`),
  KEY `FK675951272AB6672C` (`category_id`),
  KEY `UnitId` (`unit_id`)
) ENGINE=InnoDB AUTO_INCREMENT=594 DEFAULT CHARSET=utf8 COMMENT='产品表';

-- ----------------------------
-- Records of gw_material
-- ----------------------------
INSERT INTO `gw_material` VALUES ('589', '21', '世恒F712', '', '100.000000', '飞腾2000', '', '黑色', '个', '', null, '', '', '', '', '0', '63', '0');
INSERT INTO `gw_material` VALUES ('590', '21', '世恒F718', '', '100.000000', '飞腾2200', '', '白色', '个', '', null, '', '', '', '', '0', '63', '0');
INSERT INTO `gw_material` VALUES ('591', '21', '热敏打印机', '', '200.000000', '', '', '白色', '个', '', null, '', '', '', '', '1', '63', '0');
INSERT INTO `gw_material` VALUES ('592', null, '纸箱', '', '1000.000000', '', '', '', '个', '原材料采购', null, '', '', '', '', '0', '63', '0');
INSERT INTO `gw_material` VALUES ('593', '21', '服务器', '', '50.000000', '擎天530', '', '黑色', '个', '', null, '', '', '', '', '0', '63', '0');

-- ----------------------------
-- Table structure for `gw_material_category`
-- ----------------------------
DROP TABLE IF EXISTS `gw_material_category`;
CREATE TABLE `gw_material_category` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(50) DEFAULT NULL COMMENT '名称',
  `category_level` smallint(6) DEFAULT NULL COMMENT '等级',
  `parent_id` bigint(20) DEFAULT NULL COMMENT '上级id',
  `sort` varchar(10) DEFAULT NULL COMMENT '显示顺序',
  `status` varchar(1) DEFAULT '0' COMMENT '状态，0系统默认，1启用，2删除',
  `serial_no` varchar(100) DEFAULT NULL COMMENT '编号',
  `remark` varchar(1024) DEFAULT NULL COMMENT '备注',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `creator` bigint(20) DEFAULT NULL COMMENT '创建人',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `updater` bigint(20) DEFAULT NULL COMMENT '更新人',
  `tenant_id` bigint(20) DEFAULT NULL COMMENT '租户id',
  PRIMARY KEY (`id`),
  KEY `FK3EE7F725237A77D8` (`parent_id`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8 COMMENT='产品类型表';

-- ----------------------------
-- Records of gw_material_category
-- ----------------------------
INSERT INTO `gw_material_category` VALUES ('17', '目录1', null, '-1', '', '1', '', '', '2019-04-10 22:18:12', '63', '2019-04-10 22:18:12', '63', '63');
INSERT INTO `gw_material_category` VALUES ('21', '目录2', null, '17', '', '1', '', '', '2020-07-20 23:08:44', '63', '2020-07-20 23:08:44', '63', '63');

-- ----------------------------
-- Table structure for `gw_material_current_stock`
-- ----------------------------
DROP TABLE IF EXISTS `gw_material_current_stock`;
CREATE TABLE `gw_material_current_stock` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `material_id` bigint(20) DEFAULT NULL COMMENT '产品id',
  `depot_id` bigint(20) DEFAULT NULL COMMENT '仓库id',
  `current_number` decimal(24,6) DEFAULT NULL COMMENT '当前库存数量',
  `tenant_id` bigint(20) DEFAULT NULL COMMENT '租户id',
  `delete_flag` varchar(1) DEFAULT '0' COMMENT '删除标记，0未删除，1删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='产品当前库存';

-- ----------------------------
-- Records of gw_material_current_stock
-- ----------------------------
INSERT INTO `gw_material_current_stock` VALUES ('7', '589', '18', '212.000000', '63', '0');
INSERT INTO `gw_material_current_stock` VALUES ('8', '590', '18', '298.000000', '63', '0');
INSERT INTO `gw_material_current_stock` VALUES ('9', '591', '18', '396.000000', '63', '0');
INSERT INTO `gw_material_current_stock` VALUES ('11', '592', '18', '0.000000', '63', '0');

-- ----------------------------
-- Table structure for `gw_material_extend`
-- ----------------------------
DROP TABLE IF EXISTS `gw_material_extend`;
CREATE TABLE `gw_material_extend` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `material_id` bigint(20) DEFAULT NULL COMMENT '商品id',
  `bar_code` varchar(50) DEFAULT NULL COMMENT '商品条码',
  `commodity_unit` varchar(50) DEFAULT NULL COMMENT '商品单位',
  `purchase_decimal` decimal(24,6) DEFAULT NULL COMMENT '采购价格',
  `commodity_decimal` decimal(24,6) DEFAULT NULL COMMENT '零售价格',
  `wholesale_decimal` decimal(24,6) DEFAULT NULL COMMENT '销售价格',
  `low_decimal` decimal(24,6) DEFAULT NULL COMMENT '最低售价',
  `default_flag` varchar(1) DEFAULT '1' COMMENT '是否为默认单位，1是，0否',
  `create_time` datetime DEFAULT NULL COMMENT '创建日期',
  `create_serial` varchar(50) DEFAULT NULL COMMENT '创建人编码',
  `update_serial` varchar(50) DEFAULT NULL COMMENT '更新人编码',
  `update_time` bigint(20) DEFAULT NULL COMMENT '更新时间戳',
  `tenant_id` bigint(20) DEFAULT NULL COMMENT '租户id',
  `delete_Flag` varchar(1) DEFAULT '0' COMMENT '删除标记，0未删除，1删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='产品价格扩展';

-- ----------------------------
-- Records of gw_material_extend
-- ----------------------------
INSERT INTO `gw_material_extend` VALUES ('11', '589', '100200300', '个', '3000.000000', '4000.000000', '4300.000000', '4000.000000', '1', '2021-02-23 16:15:35', 'wdy', 'wdy', '1614068319649', '63', '0');
INSERT INTO `gw_material_extend` VALUES ('12', '590', '200300400', '个', '3500.000000', '4500.000000', '5000.000000', '4500.000000', '1', '2021-02-23 16:17:04', 'wdy', 'wdy', '1614135518424', '63', '0');
INSERT INTO `gw_material_extend` VALUES ('13', '591', '123123123', '个', '800.000000', '1000.000000', '1100.000000', '1000.000000', '1', '2021-02-23 16:18:04', 'wdy', 'wdy', '1614068284037', '63', '0');
INSERT INTO `gw_material_extend` VALUES ('14', '592', '200300401', '个', null, null, null, null, '1', '2021-02-24 14:21:50', 'yy', 'yy', '1614147710488', '63', '0');
INSERT INTO `gw_material_extend` VALUES ('15', '593', '2003004042222', '个', '5000.000000', '7000.000000', '6500.000000', '6300.000000', '1', '2021-03-11 11:25:52', 'wdy', 'wdy', '1615433152377', '63', '0');

-- ----------------------------
-- Table structure for `gw_material_initial_stock`
-- ----------------------------
DROP TABLE IF EXISTS `gw_material_initial_stock`;
CREATE TABLE `gw_material_initial_stock` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `material_id` bigint(20) DEFAULT NULL COMMENT '产品id',
  `depot_id` bigint(20) DEFAULT NULL COMMENT '仓库id',
  `number` decimal(24,6) DEFAULT NULL COMMENT '初始库存数量',
  `tenant_id` bigint(20) DEFAULT NULL COMMENT '租户id',
  `delete_flag` varchar(1) DEFAULT '0' COMMENT '删除标记，0未删除，1删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=125 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='产品初始库存';

-- ----------------------------
-- Records of gw_material_initial_stock
-- ----------------------------
INSERT INTO `gw_material_initial_stock` VALUES ('124', '593', '18', '50.000000', '63', '0');

-- ----------------------------
-- Table structure for `gw_material_property`
-- ----------------------------
DROP TABLE IF EXISTS `gw_material_property`;
CREATE TABLE `gw_material_property` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `native_name` varchar(50) DEFAULT NULL COMMENT '原始名称',
  `enabled` bit(1) DEFAULT NULL COMMENT '是否启用',
  `sort` varchar(10) DEFAULT NULL COMMENT '排序',
  `another_name` varchar(50) DEFAULT NULL COMMENT '别名',
  `delete_flag` varchar(1) DEFAULT '0' COMMENT '删除标记，0未删除，1删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COMMENT='产品扩展字段表';

-- ----------------------------
-- Records of gw_material_property
-- ----------------------------
INSERT INTO `gw_material_property` VALUES ('1', '制造商', '', '01', '制造商', '0');
INSERT INTO `gw_material_property` VALUES ('2', '自定义1', '', '02', '自定义1', '0');
INSERT INTO `gw_material_property` VALUES ('3', '自定义2', '', '03', '自定义2', '0');
INSERT INTO `gw_material_property` VALUES ('4', '自定义3', '', '04', '自定义3', '0');

-- ----------------------------
-- Table structure for `gw_msg`
-- ----------------------------
DROP TABLE IF EXISTS `gw_msg`;
CREATE TABLE `gw_msg` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `msg_title` varchar(100) DEFAULT NULL COMMENT '消息标题',
  `msg_content` varchar(500) DEFAULT NULL COMMENT '消息内容',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `type` varchar(20) DEFAULT NULL COMMENT '消息类型',
  `status` varchar(1) DEFAULT NULL COMMENT '状态，1未读 2已读',
  `tenant_id` bigint(20) DEFAULT NULL COMMENT '租户id',
  `delete_Flag` varchar(1) DEFAULT '0' COMMENT '删除标记，0未删除，1删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='消息表';

-- ----------------------------
-- Records of gw_msg
-- ----------------------------

-- ----------------------------
-- Table structure for `gw_organization`
-- ----------------------------
DROP TABLE IF EXISTS `gw_organization`;
CREATE TABLE `gw_organization` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `org_no` varchar(20) DEFAULT NULL COMMENT '机构编号',
  `org_full_name` varchar(500) DEFAULT NULL COMMENT '机构全称',
  `org_abr` varchar(20) DEFAULT NULL COMMENT '机构简称',
  `org_tpcd` varchar(9) DEFAULT NULL COMMENT '机构类型',
  `org_stcd` char(1) DEFAULT NULL COMMENT '机构状态,1未营业、2正常营业、3暂停营业、4终止营业、5已除名',
  `org_parent_no` varchar(20) DEFAULT NULL COMMENT '机构父节点编号',
  `sort` varchar(20) DEFAULT NULL COMMENT '机构显示顺序',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `creator` bigint(20) DEFAULT NULL COMMENT '创建人',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `updater` bigint(20) DEFAULT NULL COMMENT '更新人',
  `org_create_time` datetime DEFAULT NULL COMMENT '机构创建时间',
  `org_stop_time` datetime DEFAULT NULL COMMENT '机构停运时间',
  `tenant_id` bigint(20) DEFAULT NULL COMMENT '租户id',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8 COMMENT='机构表';

-- ----------------------------
-- Records of gw_organization
-- ----------------------------
INSERT INTO `gw_organization` VALUES ('15', '001', '研发中心', '研发中心', null, '', '-1', '01', '', '2021-02-23 15:57:03', '63', '2021-02-23 15:57:03', '63', null, null, '63');
INSERT INTO `gw_organization` VALUES ('16', '002', '产品开发部', '产品开发', null, '', '001', '02', '', '2021-02-23 15:58:12', '63', '2021-02-23 15:58:22', '63', null, null, '63');

-- ----------------------------
-- Table structure for `gw_orga_user_rel`
-- ----------------------------
DROP TABLE IF EXISTS `gw_orga_user_rel`;
CREATE TABLE `gw_orga_user_rel` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `orga_id` bigint(20) NOT NULL COMMENT '机构id',
  `user_id` bigint(20) NOT NULL COMMENT '用户id',
  `user_blng_orga_dspl_seq` varchar(20) DEFAULT NULL COMMENT '用户在所属机构中显示顺序',
  `delete_flag` char(1) DEFAULT '0' COMMENT '删除标记，0未删除，1删除',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `creator` bigint(20) DEFAULT NULL COMMENT '创建人',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `updater` bigint(20) DEFAULT NULL COMMENT '更新人',
  `tenant_id` bigint(20) DEFAULT NULL COMMENT '租户id',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8 COMMENT='机构用户关系表';

-- ----------------------------
-- Records of gw_orga_user_rel
-- ----------------------------
INSERT INTO `gw_orga_user_rel` VALUES ('11', '16', '63', '', '0', '2020-09-13 18:42:45', '63', '2021-02-23 15:58:38', '63', '63');

-- ----------------------------
-- Table structure for `gw_person`
-- ----------------------------
DROP TABLE IF EXISTS `gw_person`;
CREATE TABLE `gw_person` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `type` varchar(20) DEFAULT NULL COMMENT '类型',
  `name` varchar(50) DEFAULT NULL COMMENT '姓名',
  `tenant_id` bigint(20) DEFAULT NULL COMMENT '租户id',
  `delete_flag` varchar(1) DEFAULT '0' COMMENT '删除标记，0未删除，1删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8 COMMENT='经手人表';

-- ----------------------------
-- Records of gw_person
-- ----------------------------
INSERT INTO `gw_person` VALUES ('14', '业务员', '小李', '63', '0');
INSERT INTO `gw_person` VALUES ('15', '仓管员', '小军', '63', '0');
INSERT INTO `gw_person` VALUES ('16', '财务员', '小夏', '63', '0');

-- ----------------------------
-- Table structure for `gw_platform_config`
-- ----------------------------
DROP TABLE IF EXISTS `gw_platform_config`;
CREATE TABLE `gw_platform_config` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `platform_key` varchar(100) DEFAULT NULL COMMENT '关键词',
  `platform_key_info` varchar(100) DEFAULT NULL COMMENT '关键词名称',
  `platform_value` varchar(200) DEFAULT NULL COMMENT '值',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COMMENT='平台参数';

-- ----------------------------
-- Records of gw_platform_config
-- ----------------------------
INSERT INTO `gw_platform_config` VALUES ('1', 'platform_name', '平台名称', '长城ERP');
INSERT INTO `gw_platform_config` VALUES ('2', 'activation_code', '激活码', null);

-- ----------------------------
-- Table structure for `gw_role`
-- ----------------------------
DROP TABLE IF EXISTS `gw_role`;
CREATE TABLE `gw_role` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(50) DEFAULT NULL COMMENT '名称',
  `type` varchar(50) DEFAULT NULL COMMENT '类型',
  `value` varchar(200) DEFAULT NULL COMMENT '值',
  `description` varchar(100) DEFAULT NULL COMMENT '描述',
  `tenant_id` bigint(20) DEFAULT NULL COMMENT '租户id',
  `delete_flag` varchar(1) DEFAULT '0' COMMENT '删除标记，0未删除，1删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8 COMMENT='角色表';

-- ----------------------------
-- Records of gw_role
-- ----------------------------
INSERT INTO `gw_role` VALUES ('4', '管理员', '全部数据', null, null, null, '0');
INSERT INTO `gw_role` VALUES ('10', '租户', '全部数据', null, '', null, '0');
INSERT INTO `gw_role` VALUES ('16', '销售经理', '全部数据', null, 'sales manager', '63', '0');
INSERT INTO `gw_role` VALUES ('20', '运营', '全部数据', null, '', '63', '0');
INSERT INTO `gw_role` VALUES ('21', 'PMC', '全部数据', null, '', '63', '0');
INSERT INTO `gw_role` VALUES ('22', '财务', '全部数据', null, '', '63', '0');

-- ----------------------------
-- Table structure for `gw_sequence`
-- ----------------------------
DROP TABLE IF EXISTS `gw_sequence`;
CREATE TABLE `gw_sequence` (
  `seq_name` varchar(50) NOT NULL COMMENT '序列名称',
  `min_value` bigint(20) NOT NULL COMMENT '最小值',
  `max_value` bigint(20) NOT NULL COMMENT '最大值',
  `current_val` bigint(20) NOT NULL COMMENT '当前值',
  `increment_val` int(11) NOT NULL DEFAULT '1' COMMENT '增长步数',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`seq_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='单据编号表';

-- ----------------------------
-- Records of gw_sequence
-- ----------------------------
INSERT INTO `gw_sequence` VALUES ('depot_number_seq', '1', '999999999999999999', '445', '1', '单据编号sequence');

-- ----------------------------
-- Table structure for `gw_serial_number`
-- ----------------------------
DROP TABLE IF EXISTS `gw_serial_number`;
CREATE TABLE `gw_serial_number` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `material_id` bigint(20) DEFAULT NULL COMMENT '产品表id',
  `serial_number` varchar(64) DEFAULT NULL COMMENT '序列号',
  `is_sell` varchar(1) DEFAULT '0' COMMENT '是否卖出，0未卖出，1卖出',
  `remark` varchar(1024) DEFAULT NULL COMMENT '备注',
  `delete_flag` varchar(1) DEFAULT '0' COMMENT '删除标记，0未删除，1删除',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `creator` bigint(20) DEFAULT NULL COMMENT '创建人',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `updater` bigint(20) DEFAULT NULL COMMENT '更新人',
  `depot_head_id` bigint(20) DEFAULT NULL COMMENT '单据主表id，用于跟踪序列号流向',
  `tenant_id` bigint(20) DEFAULT NULL COMMENT '租户id',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=132 DEFAULT CHARSET=utf8 COMMENT='序列号表';

-- ----------------------------
-- Records of gw_serial_number
-- ----------------------------

-- ----------------------------
-- Table structure for `gw_supplier`
-- ----------------------------
DROP TABLE IF EXISTS `gw_supplier`;
CREATE TABLE `gw_supplier` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `supplier` varchar(255) NOT NULL COMMENT '供应商名称',
  `contacts` varchar(100) DEFAULT NULL COMMENT '联系人',
  `phone_num` varchar(30) DEFAULT NULL COMMENT '联系电话',
  `email` varchar(50) DEFAULT NULL COMMENT '电子邮箱',
  `description` varchar(500) DEFAULT NULL COMMENT '备注',
  `isystem` tinyint(4) DEFAULT NULL COMMENT '是否系统自带 0==系统 1==非系统',
  `type` varchar(20) DEFAULT NULL COMMENT '类型',
  `enabled` bit(1) DEFAULT NULL COMMENT '启用',
  `advance_in` decimal(24,6) DEFAULT '0.000000' COMMENT '预收款',
  `begin_need_get` decimal(24,6) DEFAULT NULL COMMENT '期初应收',
  `begin_need_pay` decimal(24,6) DEFAULT NULL COMMENT '期初应付',
  `all_need_get` decimal(24,6) DEFAULT NULL COMMENT '累计应收',
  `all_need_pay` decimal(24,6) DEFAULT NULL COMMENT '累计应付',
  `fax` varchar(30) DEFAULT NULL COMMENT '传真',
  `telephone` varchar(30) DEFAULT NULL COMMENT '手机',
  `address` varchar(50) DEFAULT NULL COMMENT '地址',
  `tax_num` varchar(50) DEFAULT NULL COMMENT '纳税人识别号',
  `bank_name` varchar(50) DEFAULT NULL COMMENT '开户行',
  `account_number` varchar(50) DEFAULT NULL COMMENT '账号',
  `tax_rate` decimal(24,6) DEFAULT NULL COMMENT '税率',
  `tenant_id` bigint(20) DEFAULT NULL COMMENT '租户id',
  `delete_flag` varchar(1) DEFAULT '0' COMMENT '删除标记，0未删除，1删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=78 DEFAULT CHARSET=utf8 COMMENT='供应商/客户信息表';

-- ----------------------------
-- Records of gw_supplier
-- ----------------------------
INSERT INTO `gw_supplier` VALUES ('60', '12312666', '小曹', '', '', '', null, '会员', '', '1000.000000', '0.000000', '0.000000', null, null, '', '13000000000', '', '', '', '', null, '63', '0');
INSERT INTO `gw_supplier` VALUES ('75', '供应商000', '光电', '', '', '', null, '供应商', '', '0.000000', '0.000000', '0.000000', null, null, '', '', '', '', '', '', null, '63', '0');
INSERT INTO `gw_supplier` VALUES ('76', '客户000', '小李', '', '', '', null, '客户', '', '0.000000', null, null, null, null, '', '', '', '', '', '', null, '63', '0');

-- ----------------------------
-- Table structure for `gw_system_config`
-- ----------------------------
DROP TABLE IF EXISTS `gw_system_config`;
CREATE TABLE `gw_system_config` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `company_name` varchar(50) DEFAULT NULL COMMENT '公司名称',
  `company_contacts` varchar(20) DEFAULT NULL COMMENT '公司联系人',
  `company_address` varchar(50) DEFAULT NULL COMMENT '公司地址',
  `company_tel` varchar(20) DEFAULT NULL COMMENT '公司电话',
  `company_fax` varchar(20) DEFAULT NULL COMMENT '公司传真',
  `company_post_code` varchar(20) DEFAULT NULL COMMENT '公司邮编',
  `depot_flag` varchar(1) DEFAULT '0' COMMENT '仓库启用标记，0未启用，1启用',
  `customer_flag` varchar(1) DEFAULT '0' COMMENT '客户启用标记，0未启用，1启用',
  `minus_stock_flag` varchar(1) DEFAULT '0' COMMENT '负库存启用标记，0未启用，1启用',
  `tenant_id` bigint(20) DEFAULT NULL COMMENT '租户id',
  `delete_flag` varchar(1) DEFAULT '0' COMMENT '删除标记，0未删除，1删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='系统参数';

-- ----------------------------
-- Records of gw_system_config
-- ----------------------------
INSERT INTO `gw_system_config` VALUES ('9', '河南长城计算机', '小刘', '梧桐街', '88888888', '', '', '0', '0', '0', '63', '0');

-- ----------------------------
-- Table structure for `gw_tenant`
-- ----------------------------
DROP TABLE IF EXISTS `gw_tenant`;
CREATE TABLE `gw_tenant` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `tenant_id` bigint(20) DEFAULT NULL COMMENT '用户id',
  `login_name` varchar(255) DEFAULT NULL COMMENT '登录名',
  `user_num_limit` int(11) DEFAULT NULL COMMENT '用户数量限制',
  `bills_num_limit` int(11) DEFAULT NULL COMMENT '单据数量限制',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8 COMMENT='租户';

-- ----------------------------
-- Records of gw_tenant
-- ----------------------------
INSERT INTO `gw_tenant` VALUES ('13', '63', 'wdy', '20', '2000', null);

-- ----------------------------
-- Table structure for `gw_unit`
-- ----------------------------
DROP TABLE IF EXISTS `gw_unit`;
CREATE TABLE `gw_unit` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(50) DEFAULT NULL COMMENT '名称，支持多单位',
  `basic_unit` varchar(50) DEFAULT NULL COMMENT '基础单位',
  `other_unit` varchar(50) DEFAULT NULL COMMENT '副单位',
  `ratio` int(11) DEFAULT NULL COMMENT '比例',
  `tenant_id` bigint(20) DEFAULT NULL COMMENT '租户id',
  `delete_flag` varchar(1) DEFAULT '0' COMMENT '删除标记，0未删除，1删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8 COMMENT='多单位表';

-- ----------------------------
-- Records of gw_unit
-- ----------------------------
INSERT INTO `gw_unit` VALUES ('15', '个,箱(1:12)', '个', '箱', '12', '63', '0');
INSERT INTO `gw_unit` VALUES ('16', '个,台(1:10)', '个', '台', '10', '63', '1');
INSERT INTO `gw_unit` VALUES ('17', '个,只(1:12)', '个', '只', '12', '63', '1');

-- ----------------------------
-- Table structure for `gw_user`
-- ----------------------------
DROP TABLE IF EXISTS `gw_user`;
CREATE TABLE `gw_user` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `username` varchar(255) NOT NULL COMMENT '用户姓名--例如张三',
  `login_name` varchar(255) NOT NULL COMMENT '登录用户名',
  `password` varchar(50) DEFAULT NULL COMMENT '登陆密码',
  `position` varchar(200) DEFAULT NULL COMMENT '职位',
  `department` varchar(255) DEFAULT NULL COMMENT '所属部门',
  `email` varchar(100) DEFAULT NULL COMMENT '电子邮箱',
  `phonenum` varchar(100) DEFAULT NULL COMMENT '手机号码',
  `ismanager` tinyint(4) NOT NULL DEFAULT '1' COMMENT '是否为管理者 0==管理者 1==员工',
  `isystem` tinyint(4) NOT NULL DEFAULT '0' COMMENT '是否系统自带数据 ',
  `Status` tinyint(4) DEFAULT '0' COMMENT '状态，0：正常，1：删除，2封禁',
  `description` varchar(500) DEFAULT NULL COMMENT '用户描述信息',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  `tenant_id` bigint(20) DEFAULT NULL COMMENT '租户id',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=137 DEFAULT CHARSET=utf8 COMMENT='用户表';

-- ----------------------------
-- Records of gw_user
-- ----------------------------
INSERT INTO `gw_user` VALUES ('63', '汪东洋', 'wdy', 'e10adc3949ba59abbe56e057f20f883e', '', null, '', '', '1', '1', '0', '', null, '63');
INSERT INTO `gw_user` VALUES ('120', '管理员', 'admin', 'e10adc3949ba59abbe56e057f20f883e', null, null, null, null, '1', '0', '0', null, null, null);
INSERT INTO `gw_user` VALUES ('132', '销售经理', 'xsjl', 'e10adc3949ba59abbe56e057f20f883e', '', null, '', '', '1', '0', '0', '', null, '63');
INSERT INTO `gw_user` VALUES ('133', '运营', 'yy', 'e10adc3949ba59abbe56e057f20f883e', '', null, '', '', '1', '0', '0', '', null, '63');
INSERT INTO `gw_user` VALUES ('134', '财务', 'cw', 'e10adc3949ba59abbe56e057f20f883e', '', null, '', '', '1', '0', '0', '', null, '63');
INSERT INTO `gw_user` VALUES ('135', 'PMC', 'pmc', 'e10adc3949ba59abbe56e057f20f883e', '', null, '', '', '1', '0', '0', '', null, '63');

-- ----------------------------
-- Table structure for `gw_user_business`
-- ----------------------------
DROP TABLE IF EXISTS `gw_user_business`;
CREATE TABLE `gw_user_business` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `type` varchar(50) DEFAULT NULL COMMENT '类别',
  `key_id` varchar(50) DEFAULT NULL COMMENT '主id',
  `value` varchar(10000) DEFAULT NULL COMMENT '值',
  `btn_str` varchar(2000) DEFAULT NULL COMMENT '按钮权限',
  `delete_flag` varchar(1) DEFAULT '0' COMMENT '删除标记，0未删除，1删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=80 DEFAULT CHARSET=utf8 COMMENT='用户/角色/模块关系表';

-- ----------------------------
-- Records of gw_user_business
-- ----------------------------
INSERT INTO `gw_user_business` VALUES ('5', 'RoleFunctions', '4', '[210][211][241][33][199][242][41][200][201][202][40][232][233][197][203][204][205][206][212][59][207][208][209][226][227][228][229][235][237][244][246][22][23][220][240][25][217][218][26][194][195][31][13][16][243][14][15][234][236][245]', '[{\"funId\":\"13\",\"btnStr\":\"1\"},{\"funId\":\"16\",\"btnStr\":\"1\"},{\"funId\":\"243\",\"btnStr\":\"1\"},{\"funId\":\"14\",\"btnStr\":\"1\"},{\"funId\":\"234\",\"btnStr\":\"1\"},{\"funId\":\"236\",\"btnStr\":\"1\"},{\"funId\":\"245\",\"btnStr\":\"1\"},{\"funId\":\"22\",\"btnStr\":\"1\"},{\"funId\":\"23\",\"btnStr\":\"1\"},{\"funId\":\"220\",\"btnStr\":\"1\"},{\"funId\":\"240\",\"btnStr\":\"1\"},{\"funId\":\"25\",\"btnStr\":\"1\"},{\"funId\":\"217\",\"btnStr\":\"1\"},{\"funId\":\"218\",\"btnStr\":\"1\"},{\"funId\":\"26\",\"btnStr\":\"1\"},{\"funId\":\"194\",\"btnStr\":\"1\"},{\"funId\":\"195\",\"btnStr\":\"1\"},{\"funId\":\"31\",\"btnStr\":\"1\"},{\"funId\":\"241\",\"btnStr\":\"1,2\"},{\"funId\":\"33\",\"btnStr\":\"1,2\"},{\"funId\":\"199\",\"btnStr\":\"1,2\"},{\"funId\":\"242\",\"btnStr\":\"1,2\"},{\"funId\":\"41\",\"btnStr\":\"1,2\"},{\"funId\":\"200\",\"btnStr\":\"1,2\"},{\"funId\":\"210\",\"btnStr\":\"1,2\"},{\"funId\":\"211\",\"btnStr\":\"1,2\"},{\"funId\":\"197\",\"btnStr\":\"1\"},{\"funId\":\"203\",\"btnStr\":\"1\"},{\"funId\":\"204\",\"btnStr\":\"1\"},{\"funId\":\"205\",\"btnStr\":\"1\"},{\"funId\":\"206\",\"btnStr\":\"1\"},{\"funId\":\"212\",\"btnStr\":\"1\"},{\"funId\":\"201\",\"btnStr\":\"1,2\"},{\"funId\":\"202\",\"btnStr\":\"1,2\"},{\"funId\":\"40\",\"btnStr\":\"1,2\"},{\"funId\":\"232\",\"btnStr\":\"1,2\"},{\"funId\":\"233\",\"btnStr\":\"1,2\"}]', '0');
INSERT INTO `gw_user_business` VALUES ('16', 'UserRole', '63', '[10]', null, '0');
INSERT INTO `gw_user_business` VALUES ('18', 'UserDepot', '63', '[14][15]', null, '0');
INSERT INTO `gw_user_business` VALUES ('27', 'UserCustomer', '63', '[58]', null, '0');
INSERT INTO `gw_user_business` VALUES ('32', 'RoleFunctions', '10', '[210][211][241][33][199][242][41][200][201][202][40][232][233][197][203][204][205][206][212][59][207][208][209][226][227][228][229][235][237][244][246][22][23][220][240][25][217][218][26][194][195][31][13][243][14][15][234]', '[{\"funId\":\"13\",\"btnStr\":\"1\"},{\"funId\":\"243\",\"btnStr\":\"1\"},{\"funId\":\"14\",\"btnStr\":\"1\"},{\"funId\":\"234\",\"btnStr\":\"1\"},{\"funId\":\"22\",\"btnStr\":\"1\"},{\"funId\":\"23\",\"btnStr\":\"1\"},{\"funId\":\"220\",\"btnStr\":\"1\"},{\"funId\":\"240\",\"btnStr\":\"1\"},{\"funId\":\"25\",\"btnStr\":\"1\"},{\"funId\":\"217\",\"btnStr\":\"1\"},{\"funId\":\"218\",\"btnStr\":\"1\"},{\"funId\":\"26\",\"btnStr\":\"1\"},{\"funId\":\"194\",\"btnStr\":\"1\"},{\"funId\":\"195\",\"btnStr\":\"1\"},{\"funId\":\"31\",\"btnStr\":\"1\"},{\"funId\":\"241\",\"btnStr\":\"1,2\"},{\"funId\":\"33\",\"btnStr\":\"1,2\"},{\"funId\":\"199\",\"btnStr\":\"1,2\"},{\"funId\":\"242\",\"btnStr\":\"1,2\"},{\"funId\":\"41\",\"btnStr\":\"1,2\"},{\"funId\":\"200\",\"btnStr\":\"1,2\"},{\"funId\":\"210\",\"btnStr\":\"1,2\"},{\"funId\":\"211\",\"btnStr\":\"1,2\"},{\"funId\":\"197\",\"btnStr\":\"1\"},{\"funId\":\"203\",\"btnStr\":\"1\"},{\"funId\":\"204\",\"btnStr\":\"1\"},{\"funId\":\"205\",\"btnStr\":\"1\"},{\"funId\":\"206\",\"btnStr\":\"1\"},{\"funId\":\"212\",\"btnStr\":\"1\"},{\"funId\":\"201\",\"btnStr\":\"1,2\"},{\"funId\":\"202\",\"btnStr\":\"1,2\"},{\"funId\":\"40\",\"btnStr\":\"1,2\"},{\"funId\":\"232\",\"btnStr\":\"1,2\"},{\"funId\":\"233\",\"btnStr\":\"1,2\"}]', '0');
INSERT INTO `gw_user_business` VALUES ('38', 'UserRole', '120', '[4]', null, '0');
INSERT INTO `gw_user_business` VALUES ('39', 'UserDepot', '120', '[7][8][9][10][11][12][2][1][3]', null, '0');
INSERT INTO `gw_user_business` VALUES ('40', 'UserCustomer', '120', '[52][48][6][5][2]', null, '0');
INSERT INTO `gw_user_business` VALUES ('68', 'RoleFunctions', '16', '[241][242][41][200][59][209][23][217][218]', '[{\"funId\":\"217\",\"btnStr\":\"1\"},{\"funId\":\"218\",\"btnStr\":\"1\"},{\"funId\":\"241\",\"btnStr\":\"1\"},{\"funId\":\"242\",\"btnStr\":\"1\"},{\"funId\":\"200\",\"btnStr\":\"1,2\"}]', '0');
INSERT INTO `gw_user_business` VALUES ('70', 'RoleFunctions', '20', '[241][33][199][242][41][200][201][202][40][232][233][59][208][209][226][227][228][229][244][23][25][217][218][26][194]', '[{\"funId\":\"25\",\"btnStr\":\"1\"},{\"funId\":\"217\",\"btnStr\":\"1\"},{\"funId\":\"218\",\"btnStr\":\"1\"},{\"funId\":\"194\",\"btnStr\":\"1\"},{\"funId\":\"241\",\"btnStr\":\"1,2\"},{\"funId\":\"242\",\"btnStr\":\"1,2\"}]', '0');
INSERT INTO `gw_user_business` VALUES ('71', 'RoleFunctions', '21', '[33][41][201][202][40][232][233][59][226][227][228][229][244][22][23][220][240][25][217][218][26]', '[{\"funId\":\"22\",\"btnStr\":\"1\"},{\"funId\":\"23\",\"btnStr\":\"1\"},{\"funId\":\"220\",\"btnStr\":\"1\"},{\"funId\":\"240\",\"btnStr\":\"1\"},{\"funId\":\"26\",\"btnStr\":\"1\"},{\"funId\":\"33\",\"btnStr\":\"1,2\"},{\"funId\":\"41\",\"btnStr\":\"1,2\"},{\"funId\":\"201\",\"btnStr\":\"1,2\"},{\"funId\":\"202\",\"btnStr\":\"1,2\"},{\"funId\":\"40\",\"btnStr\":\"1,2\"},{\"funId\":\"232\",\"btnStr\":\"1,2\"},{\"funId\":\"233\",\"btnStr\":\"1,2\"}]', '0');
INSERT INTO `gw_user_business` VALUES ('72', 'RoleFunctions', '22', '[197][203][204][205][206][212][207][235][237][194][195]', '[{\"funId\":\"194\",\"btnStr\":\"1\"},{\"funId\":\"195\",\"btnStr\":\"1\"},{\"funId\":\"197\",\"btnStr\":\"1\"},{\"funId\":\"203\",\"btnStr\":\"1\"},{\"funId\":\"204\",\"btnStr\":\"1\"},{\"funId\":\"205\",\"btnStr\":\"1\"},{\"funId\":\"206\",\"btnStr\":\"1\"},{\"funId\":\"212\",\"btnStr\":\"1\"}]', '0');
INSERT INTO `gw_user_business` VALUES ('73', 'UserRole', '132', '[16]', null, '0');
INSERT INTO `gw_user_business` VALUES ('74', 'UserRole', '133', '[20]', null, '0');
INSERT INTO `gw_user_business` VALUES ('75', 'UserRole', '134', '[22]', null, '0');
INSERT INTO `gw_user_business` VALUES ('76', 'UserRole', '135', '[21]', null, '0');
