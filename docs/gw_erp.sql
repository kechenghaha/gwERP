/*
Navicat MySQL Data Transfer

Source Server         : localhost_3306
Source Server Version : 50527
Source Host           : localhost:3306
Source Database       : gw_erp

Target Server Type    : MYSQL
Target Server Version : 50527
File Encoding         : 65001

Date: 2021-04-02 16:33:49
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
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8 COMMENT='账户信息';

-- ----------------------------
-- Records of gw_account
-- ----------------------------
INSERT INTO `gw_account` VALUES ('20', '账户001', '01', '0.000000', null, '', '', '63', '0');
INSERT INTO `gw_account` VALUES ('21', '账户002', '02', '0.000000', null, '', '', '63', '0');

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='财务主表';

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='财务子表';

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
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8 COMMENT='仓库表';

-- ----------------------------
-- Records of gw_depot
-- ----------------------------
INSERT INTO `gw_depot` VALUES ('19', '整机库', '梧桐街36号', null, null, '0', '', '', null, '63', '0', '');
INSERT INTO `gw_depot` VALUES ('20', '样机库', '梧桐街36号', null, null, '0', '', '', null, '63', '0', '');
INSERT INTO `gw_depot` VALUES ('21', '物料库', '梧桐街36号', null, null, '0', '', '', null, '63', '0', '');

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
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8 COMMENT='单据主表';

-- ----------------------------
-- Records of gw_depot_head
-- ----------------------------
INSERT INTO `gw_depot_head` VALUES ('1', '入库', '整机', 'ZJRK00000000447', 'ZJRK00000000447', '2021-04-02 10:34:58', '2021-04-02 10:31:11', null, null, '63', null, '0.000000', '0.000000', '现付', null, '', '', null, '', null, null, null, null, null, null, null, '0', '', '63', '0');
INSERT INTO `gw_depot_head` VALUES ('2', '入库', '整机', 'ZJRK00000000448', 'ZJRK00000000448', '2021-04-02 10:41:40', '2021-04-02 10:41:09', null, null, '63', null, '0.000000', '0.000000', '现付', null, '', '', null, '', null, null, null, null, null, null, null, '0', '', '63', '0');
INSERT INTO `gw_depot_head` VALUES ('3', '入库', '整机', 'ZJRK00000000449', 'ZJRK00000000449', '2021-04-02 11:26:57', '2021-04-02 11:26:42', null, null, '63', null, '0.000000', '0.000000', '现付', null, '', '', null, '', null, null, null, null, null, null, null, '0', '', '63', '0');
INSERT INTO `gw_depot_head` VALUES ('4', '入库', '整机', 'ZJRK00000000450', 'ZJRK00000000450', '2021-04-02 11:39:06', '2021-04-02 11:38:39', null, null, '63', null, '0.000000', '0.000000', '现付', null, '', '', null, '', null, null, null, null, null, null, null, '0', '', '63', '0');
INSERT INTO `gw_depot_head` VALUES ('5', '入库', '整机', 'ZJRK00000000451', 'ZJRK00000000451', '2021-04-02 11:39:49', '2021-04-02 11:39:10', null, null, '63', null, '0.000000', '0.000000', '现付', null, '', '', null, '', null, null, null, null, null, null, null, '0', '', '63', '0');
INSERT INTO `gw_depot_head` VALUES ('6', '入库', '整机', 'ZJRK00000000452', 'ZJRK00000000452', '2021-04-02 11:40:57', '2021-04-02 11:40:03', null, null, '63', null, '0.000000', '0.000000', '现付', null, '', '', null, '', null, null, null, null, null, null, null, '0', '', '63', '0');
INSERT INTO `gw_depot_head` VALUES ('7', '入库', '整机', 'ZJRK00000000453', 'ZJRK00000000453', '2021-04-02 11:41:15', '2021-04-02 11:41:02', null, null, '63', null, '0.000000', '0.000000', '现付', null, '', '', null, '', null, null, null, null, null, null, null, '0', '', '63', '0');
INSERT INTO `gw_depot_head` VALUES ('8', '入库', '整机', 'ZJRK00000000454', 'ZJRK00000000454', '2021-04-02 11:41:34', '2021-04-02 11:41:17', null, null, '63', null, '0.000000', '0.000000', '现付', null, '', '', null, '', null, null, null, null, null, null, null, '0', '', '63', '0');
INSERT INTO `gw_depot_head` VALUES ('9', '出库', '领料', 'LLCK00000000457', 'LLCK00000000457', '2021-04-02 11:48:44', '2021-04-02 11:47:31', '77', null, '63', null, '0.000000', '0.000000', '现付', null, '', '', null, '', null, null, null, null, null, null, null, '0', '', '63', '0');
INSERT INTO `gw_depot_head` VALUES ('10', '出库', '调拨', 'DBCK00000000458', 'DBCK00000000458', '2021-04-02 11:49:27', '2021-04-02 11:49:00', null, null, '63', null, '0.000000', '0.000000', '现付', null, '', '', null, '', null, null, null, null, null, null, null, '0', '', '63', '0');
INSERT INTO `gw_depot_head` VALUES ('11', '其它', '组装单', 'ZZD00000000459', 'ZZD00000000459', '2021-04-02 11:50:22', '2021-04-02 11:49:38', null, null, '63', null, '0.000000', '0.000000', '现付', null, '', '', null, '', null, null, null, null, null, null, null, '0', '', '63', '0');
INSERT INTO `gw_depot_head` VALUES ('12', '其它', '拆卸单', 'CXD00000000460', 'CXD00000000460', '2021-04-02 11:50:50', '2021-04-02 11:50:27', null, null, '63', null, '0.000000', '0.000000', '现付', null, '', '', null, '', null, null, null, null, null, null, null, '0', '', '63', '0');
INSERT INTO `gw_depot_head` VALUES ('13', '其它', '销售订单', 'XSDD00000000461', 'XSDD00000000461', '2021-04-02 13:17:18', '2021-04-02 12:00:07', '78', null, '137', null, '0.000000', '50000.000000', '现付', null, '', '<wdy>', null, '', null, null, null, null, null, null, null, '2', '', '63', '0');
INSERT INTO `gw_depot_head` VALUES ('14', '出库', '销售', 'XSCK00000000465', 'XSCK00000000465', '2021-04-02 13:41:05', '2021-04-02 13:40:43', '78', null, '135', '20', '50000.000000', '50000.000000', '现付', null, '物流单号：sf00000000', '<wdy>', null, '', '0.000000', '0.000000', '50000.000000', null, null, null, null, '0', 'XSDD00000000461', '63', '0');
INSERT INTO `gw_depot_head` VALUES ('15', '其它', '销售订单', 'XSDD00000000466', 'XSDD00000000466', '2021-04-02 13:57:20', '2021-04-02 13:56:59', '78', null, '137', null, '0.000000', '0.000000', '现付', null, '', '<haha>', null, '', null, null, null, null, null, null, null, '0', '', '63', '1');
INSERT INTO `gw_depot_head` VALUES ('16', '其它', '采购订单', 'CGDD00000000471', 'CGDD00000000471', '2021-04-02 14:13:27', '2021-04-02 14:12:38', '80', null, '133', null, '0.000000', '-13980.000000', '现付', null, '', '', null, '', null, null, null, null, null, null, null, '2', '', '63', '0');
INSERT INTO `gw_depot_head` VALUES ('17', '其它', '采购订单', 'CGDD00000000472', 'CGDD00000000472', '2021-04-02 14:15:23', '2021-04-02 14:15:08', '80', null, '137', null, '0.000000', '-300.000000', '现付', null, '', '', null, '', null, null, null, null, null, null, null, '0', '', '63', '0');
INSERT INTO `gw_depot_head` VALUES ('18', '入库', '采购', 'CGRK00000000473', 'CGRK00000000473', '2021-04-02 14:16:23', '2021-04-02 14:16:10', '80', null, '135', '20', '-13980.000000', '-13980.000000', '现付', null, '', '', null, '', '0.000000', '0.000000', '13980.000000', null, null, null, null, '0', 'CGDD00000000471', '63', '0');
INSERT INTO `gw_depot_head` VALUES ('19', '入库', '销售退货', 'XSTH00000000474', 'XSTH00000000474', '2021-04-02 14:26:31', '2021-04-02 14:24:08', '78', null, '137', '20', '0.000000', '0.000000', '现付', null, '', '', null, '', '0.000000', '0.000000', '0.000000', null, null, null, null, '0', '', '63', '0');
INSERT INTO `gw_depot_head` VALUES ('20', '出库', '采购退货', 'CGTH00000000475', 'CGTH00000000475', '2021-04-02 14:37:00', '2021-04-02 14:35:55', '80', null, '133', '20', '3495.000000', '3495.000000', '现付', null, '', '', null, '', '0.000000', '0.000000', '3495.000000', null, null, null, null, '0', '', '63', '0');

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
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8 COMMENT='单据子表';

-- ----------------------------
-- Records of gw_depot_item
-- ----------------------------
INSERT INTO `gw_depot_item` VALUES ('1', '1', '594', '17', '台', '50.000000', '50.000000', '0.000000', null, '0.000000', null, null, null, '19', null, null, null, null, null, null, null, null, null, null, '63', '0');
INSERT INTO `gw_depot_item` VALUES ('2', '2', '595', '19', '台', '50.000000', '50.000000', '0.000000', null, '0.000000', null, null, null, '19', null, null, null, null, null, null, null, null, null, null, '63', '0');
INSERT INTO `gw_depot_item` VALUES ('3', '3', '596', '20', '台', '30.000000', '30.000000', '0.000000', null, '0.000000', null, null, null, '19', null, null, null, null, null, null, null, null, null, null, '63', '0');
INSERT INTO `gw_depot_item` VALUES ('4', '4', '597', '21', '台', '5.000000', '5.000000', '0.000000', null, '0.000000', null, null, null, '19', null, null, null, null, null, null, null, null, null, null, '63', '0');
INSERT INTO `gw_depot_item` VALUES ('5', '5', '598', '22', '台', '50.000000', '50.000000', '0.000000', null, '0.000000', null, null, null, '19', null, null, null, null, null, null, null, null, null, null, '63', '0');
INSERT INTO `gw_depot_item` VALUES ('6', '6', '599', '23', '台', '20.000000', '20.000000', '0.000000', null, '0.000000', null, null, null, '19', null, null, null, null, null, null, null, null, null, null, '63', '0');
INSERT INTO `gw_depot_item` VALUES ('7', '7', '600', '24', '台', '50.000000', '50.000000', '0.000000', null, '0.000000', null, null, null, '19', null, null, null, null, null, null, null, null, null, null, '63', '0');
INSERT INTO `gw_depot_item` VALUES ('8', '8', '601', '25', '台', '10.000000', '10.000000', '0.000000', null, '0.000000', null, null, null, '19', null, null, null, null, null, null, null, null, null, null, '63', '0');
INSERT INTO `gw_depot_item` VALUES ('9', '9', '601', '25', '台', '1.000000', '1.000000', '0.000000', null, '0.000000', null, null, null, '19', null, null, null, null, null, null, null, null, null, null, '63', '0');
INSERT INTO `gw_depot_item` VALUES ('10', '10', '599', '23', '台', '1.000000', '1.000000', '0.000000', null, '0.000000', null, null, null, '19', '20', null, null, null, null, null, null, null, null, null, '63', '0');
INSERT INTO `gw_depot_item` VALUES ('11', '11', '594', '17', '台', '2.000000', '2.000000', '0.000000', null, '0.000000', null, null, null, '20', null, null, null, null, null, null, null, null, null, '组合件', '63', '0');
INSERT INTO `gw_depot_item` VALUES ('12', '12', '594', '17', '台', '3.000000', '3.000000', '0.000000', null, '0.000000', null, null, null, '20', null, null, null, null, null, null, null, null, null, '组合件', '63', '0');
INSERT INTO `gw_depot_item` VALUES ('13', '13', '600', '24', '台', '10.000000', '10.000000', '5000.000000', '5000.000000', '50000.000000', null, null, null, '19', null, '0.000000', '0.000000', '50000.000000', null, null, null, null, null, null, '63', '0');
INSERT INTO `gw_depot_item` VALUES ('15', '14', '600', '24', '台', '10.000000', '10.000000', '5000.000000', '5000.000000', '50000.000000', null, null, null, '19', null, '0.000000', '0.000000', '50000.000000', null, null, null, null, null, null, '63', '0');
INSERT INTO `gw_depot_item` VALUES ('16', '15', '597', '21', '台', '1.000000', '1.000000', '0.000000', '0.000000', '0.000000', null, null, null, '19', null, '0.000000', '0.000000', '0.000000', null, null, null, null, null, null, '63', '1');
INSERT INTO `gw_depot_item` VALUES ('17', '16', '602', '26', '个', '20.000000', '20.000000', '699.000000', '699.000000', '13980.000000', null, null, null, '21', null, '0.000000', '0.000000', '13980.000000', null, null, null, null, null, null, '63', '0');
INSERT INTO `gw_depot_item` VALUES ('18', '17', '604', '28', '个', '30.000000', '30.000000', '10.000000', '10.000000', '300.000000', null, null, null, '21', null, '0.000000', '0.000000', '300.000000', null, null, null, null, null, null, '63', '0');
INSERT INTO `gw_depot_item` VALUES ('19', '18', '602', '26', '个', '20.000000', '20.000000', '699.000000', '699.000000', '13980.000000', null, null, null, '21', null, '0.000000', '0.000000', '13980.000000', null, null, null, null, null, null, '63', '0');
INSERT INTO `gw_depot_item` VALUES ('20', '19', '600', '24', '台', '1.000000', '1.000000', '0.000000', '0.000000', '0.000000', null, null, null, '19', null, '0.000000', '0.000000', '0.000000', null, null, null, null, null, null, '63', '0');
INSERT INTO `gw_depot_item` VALUES ('21', '20', '602', '26', '个', '5.000000', '5.000000', '699.000000', '699.000000', '3495.000000', null, null, null, '21', null, '0.000000', '0.000000', '3495.000000', null, null, null, null, null, null, '63', '0');

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
INSERT INTO `gw_function` VALUES ('1', '0001', '系统管理', '0', '', '', '0910', '', '电脑版', '', 'icon-settings', '0');
INSERT INTO `gw_function` VALUES ('13', '000102', '角色管理', '0001', '/pages/manage/role.html', '', '0130', '', '电脑版', '1', 'icon-notebook', '0');
INSERT INTO `gw_function` VALUES ('14', '000103', '用户管理', '0001', '/pages/manage/user.html', '', '0140', '', '电脑版', '1', 'icon-notebook', '0');
INSERT INTO `gw_function` VALUES ('15', '000104', '日志管理', '0001', '/pages/manage/log.html', '', '0160', '', '电脑版', '', 'icon-notebook', '0');
INSERT INTO `gw_function` VALUES ('16', '000105', '功能管理', '0001', '/pages/manage/functions.html', '', '0166', '', '电脑版', '1', 'icon-notebook', '0');
INSERT INTO `gw_function` VALUES ('21', '0101', '商品管理', '0', '', '', '0620', '', '电脑版', '', 'icon-social-dropbox', '0');
INSERT INTO `gw_function` VALUES ('22', '010101', '商品类别', '0101', '/pages/materials/materialcategory.html', '', '0230', '', '电脑版', '1', 'icon-notebook', '0');
INSERT INTO `gw_function` VALUES ('23', '010102', '商品信息', '0101', '/pages/materials/material.html', '', '0240', '', '电脑版', '1', 'icon-notebook', '0');
INSERT INTO `gw_function` VALUES ('24', '0102', '基本资料', '0', '', '', '0750', '', '电脑版', null, 'icon-grid', '0');
INSERT INTO `gw_function` VALUES ('25', '01020101', '供应商信息', '0102', '/pages/manage/vendor.html', '', '0260', '', '电脑版', '1', 'icon-notebook', '0');
INSERT INTO `gw_function` VALUES ('26', '010202', '仓库信息', '0102', '/pages/manage/depot.html', '', '0270', '', '电脑版', '1', 'icon-notebook', '0');
INSERT INTO `gw_function` VALUES ('31', '010206', '经手人管理', '0102', '/pages/manage/person.html', '', '0284', '', '电脑版', '1', 'icon-notebook', '0');
INSERT INTO `gw_function` VALUES ('32', '0502', '采购管理', '0', '', '', '0330', '', '电脑版', '', 'icon-loop', '0');
INSERT INTO `gw_function` VALUES ('33', '050201', '采购入库', '0502', '/pages/bill/purchase_in_list.html', '', '0340', '', '电脑版', '1,2', 'icon-notebook', '0');
INSERT INTO `gw_function` VALUES ('38', '0603', '销售管理', '0', '', '', '0390', '', '电脑版', '', 'icon-briefcase', '0');
INSERT INTO `gw_function` VALUES ('40', '080107', '调拨出库', '0801', '/pages/bill/allocation_out_list.html', '', '0807', '', '电脑版', '1,2', 'icon-notebook', '0');
INSERT INTO `gw_function` VALUES ('41', '060303', '销售出库', '0603', '/pages/bill/sale_out_list.html', '', '0394', '', '电脑版', '1,2', 'icon-notebook', '0');
INSERT INTO `gw_function` VALUES ('44', '0704', '财务管理', '0', '', '', '0450', '', '电脑版', '', 'icon-map', '0');
INSERT INTO `gw_function` VALUES ('59', '030101', '库存状况', '0301', '/pages/reports/in_out_stock_report.html', '', '0600', '', '电脑版', '', 'icon-notebook', '0');
INSERT INTO `gw_function` VALUES ('194', '010204', '收支项目', '0102', '/pages/manage/inOutItem.html', '', '0282', '', '电脑版', '1', 'icon-notebook', '0');
INSERT INTO `gw_function` VALUES ('195', '010205', '结算账户', '0102', '/pages/manage/account.html', '', '0283', '', '电脑版', '1', 'icon-notebook', '0');
INSERT INTO `gw_function` VALUES ('197', '070402', '收入单', '0704', '/pages/financial/item_in.html', '', '0465', '', '电脑版', '1', 'icon-notebook', '0');
INSERT INTO `gw_function` VALUES ('198', '0301', '报表查询', '0', '', '', '0570', '', '电脑版', null, 'icon-pie-chart', '0');
INSERT INTO `gw_function` VALUES ('199', '050204', '采购退货', '0502', '/pages/bill/purchase_back_list.html', '', '0345', '', '电脑版', '1,2', 'icon-notebook', '0');
INSERT INTO `gw_function` VALUES ('200', '060305', '销售退货', '0603', '/pages/bill/sale_back_list.html', '', '0396', '', '电脑版', '1,2', 'icon-notebook', '0');
INSERT INTO `gw_function` VALUES ('201', '080103', '整机入库', '0801', '/pages/bill/other_in_list.html', '', '0803', '', '电脑版', '1,2', 'icon-notebook', '0');
INSERT INTO `gw_function` VALUES ('202', '080105', '领料出库', '0801', '/pages/bill/other_out_list.html', '', '0805', '', '电脑版', '1,2', 'icon-notebook', '0');
INSERT INTO `gw_function` VALUES ('203', '070403', '支出单', '0704', '/pages/financial/item_out.html', '', '0470', '', '电脑版', '1', 'icon-notebook', '0');
INSERT INTO `gw_function` VALUES ('204', '070404', '收款单', '0704', '/pages/financial/money_in.html', '', '0475', '', '电脑版', '1', 'icon-notebook', '0');
INSERT INTO `gw_function` VALUES ('205', '070405', '付款单', '0704', '/pages/financial/money_out.html', '', '0480', '', '电脑版', '1', 'icon-notebook', '0');
INSERT INTO `gw_function` VALUES ('206', '070406', '转账单', '0704', '/pages/financial/giro.html', '', '0490', '', '电脑版', '1', 'icon-notebook', '0');
INSERT INTO `gw_function` VALUES ('207', '030102', '账户统计', '0301', '/pages/reports/account_report.html', '', '0610', '', '电脑版', '', 'icon-notebook', '0');
INSERT INTO `gw_function` VALUES ('208', '030103', '进货统计', '0301', '/pages/reports/buy_in_report.html', '', '0620', '', '电脑版', '', 'icon-notebook', '0');
INSERT INTO `gw_function` VALUES ('209', '030104', '销售统计', '0301', '/pages/reports/sale_out_report.html', '', '0630', '', '电脑版', '', 'icon-notebook', '0');
INSERT INTO `gw_function` VALUES ('210', '040102', '零售出库', '0401', '/pages/bill/retail_out_list.html', '', '0405', '', '电脑版', '1,2', 'icon-notebook', '0');
INSERT INTO `gw_function` VALUES ('211', '040104', '零售退货', '0401', '/pages/bill/retail_back_list.html', '', '0407', '', '电脑版', '1,2', 'icon-notebook', '0');
INSERT INTO `gw_function` VALUES ('212', '070407', '收预付款', '0704', '/pages/financial/advance_in.html', '', '0495', '', '电脑版', '1', 'icon-notebook', '0');
INSERT INTO `gw_function` VALUES ('217', '01020102', '客户信息', '0102', '/pages/manage/customer.html', '', '0262', '', '电脑版', '1', 'icon-notebook', '0');
INSERT INTO `gw_function` VALUES ('218', '01020103', '会员信息', '0102', '/pages/manage/member.html', '', '0263', '', '电脑版', '1', 'icon-notebook', '0');
INSERT INTO `gw_function` VALUES ('220', '010103', '计量单位', '0101', '/pages/manage/unit.html', '', '0245', '', '电脑版', '1', 'icon-notebook', '0');
INSERT INTO `gw_function` VALUES ('225', '0401', '零售管理', '0', '', '', '0101', '', '电脑版', '', 'icon-present', '0');
INSERT INTO `gw_function` VALUES ('226', '030106', '入库明细', '0301', '/pages/reports/in_detail.html', '', '0640', '', '电脑版', '', 'icon-notebook', '0');
INSERT INTO `gw_function` VALUES ('227', '030107', '出库明细', '0301', '/pages/reports/out_detail.html', '', '0645', '', '电脑版', '', 'icon-notebook', '0');
INSERT INTO `gw_function` VALUES ('228', '030108', '入库汇总', '0301', '/pages/reports/in_material_count.html', '', '0650', '', '电脑版', '', 'icon-notebook', '0');
INSERT INTO `gw_function` VALUES ('229', '030109', '出库汇总', '0301', '/pages/reports/out_material_count.html', '', '0655', '', '电脑版', '', 'icon-notebook', '0');
INSERT INTO `gw_function` VALUES ('232', '080109', '组装单', '0801', '/pages/bill/assemble_list.html', '', '0809', '', '电脑版', '1,2', 'icon-notebook', '0');
INSERT INTO `gw_function` VALUES ('233', '080111', '拆卸单', '0801', '/pages/bill/disassemble_list.html', '', '0811', '', '电脑版', '1,2', 'icon-notebook', '0');
INSERT INTO `gw_function` VALUES ('234', '000105', '系统配置', '0001', '/pages/manage/systemConfig.html', '', '0165', '', '电脑版', '1', 'icon-notebook', '0');
INSERT INTO `gw_function` VALUES ('235', '030110', '客户对账', '0301', '/pages/reports/customer_account.html', '', '0660', '', '电脑版', '', 'icon-notebook', '0');
INSERT INTO `gw_function` VALUES ('236', '000106', '商品属性', '0001', '/pages/materials/materialProperty.html', '', '0168', '', '电脑版', '1', 'icon-notebook', '0');
INSERT INTO `gw_function` VALUES ('237', '030111', '供应商对账', '0301', '/pages/reports/vendor_account.html', '', '0665', '', '电脑版', '', 'icon-notebook', '0');
INSERT INTO `gw_function` VALUES ('239', '0801', '仓库管理', '0', '', '', '0420', '', '电脑版', '', 'icon-layers', '0');
INSERT INTO `gw_function` VALUES ('240', '010104', '序列号', '0101', '/pages/manage/serialNumber.html', '', '0246', '', '电脑版', '1', 'icon-notebook', '0');
INSERT INTO `gw_function` VALUES ('241', '050202', '采购订单', '0502', '/pages/bill/purchase_orders_list.html', '', '0335', '', '电脑版', '1,2', 'icon-notebook', '0');
INSERT INTO `gw_function` VALUES ('242', '060301', '销售订单', '0603', '/pages/bill/sale_orders_list.html', '', '0392', '', '电脑版', '1,2', 'icon-notebook', '0');
INSERT INTO `gw_function` VALUES ('243', '000108', '机构管理', '0001', '/pages/manage/organization.html', '', '0150', '', '电脑版', '1', 'icon-notebook', '0');
INSERT INTO `gw_function` VALUES ('244', '030112', '库存预警', '0301', '/pages/reports/stock_warning_report.html', '', '0670', '', '电脑版', '', 'icon-notebook', '0');
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
) ENGINE=InnoDB AUTO_INCREMENT=603 DEFAULT CHARSET=utf8 COMMENT='操作日志';

-- ----------------------------
-- Records of gw_log
-- ----------------------------
INSERT INTO `gw_log` VALUES ('395', '63', '用户', '0:0:0:0:0:0:0:1', '2021-04-02 10:10:07', '0', '登录wdy', '63');
INSERT INTO `gw_log` VALUES ('396', '63', '商品类型', '0:0:0:0:0:0:0:1', '2021-04-02 10:12:50', '0', '新增目录1', '63');
INSERT INTO `gw_log` VALUES ('397', '63', '商品类型', '0:0:0:0:0:0:0:1', '2021-04-02 10:12:58', '0', '新增目录2', '63');
INSERT INTO `gw_log` VALUES ('398', '63', '商品类型', '0:0:0:0:0:0:0:1', '2021-04-02 10:13:11', '0', '修改目录2', '63');
INSERT INTO `gw_log` VALUES ('399', '63', '商品类型', '0:0:0:0:0:0:0:1', '2021-04-02 10:13:36', '0', '删除[目录2]', '63');
INSERT INTO `gw_log` VALUES ('400', '63', '商品类型', '0:0:0:0:0:0:0:1', '2021-04-02 10:13:57', '0', '修改台式机', '63');
INSERT INTO `gw_log` VALUES ('401', '63', '商品类型', '0:0:0:0:0:0:0:1', '2021-04-02 10:14:03', '0', '新增服务器', '63');
INSERT INTO `gw_log` VALUES ('402', '63', '商品类型', '0:0:0:0:0:0:0:1', '2021-04-02 10:14:09', '0', '新增显示器', '63');
INSERT INTO `gw_log` VALUES ('403', '63', '商品类型', '0:0:0:0:0:0:0:1', '2021-04-02 10:14:28', '0', '新增打印机', '63');
INSERT INTO `gw_log` VALUES ('404', '63', '商品类型', '0:0:0:0:0:0:0:1', '2021-04-02 10:14:41', '0', '新增信创', '63');
INSERT INTO `gw_log` VALUES ('405', '63', '商品类型', '0:0:0:0:0:0:0:1', '2021-04-02 10:14:50', '0', '修改台式机', '63');
INSERT INTO `gw_log` VALUES ('406', '63', '商品类型', '0:0:0:0:0:0:0:1', '2021-04-02 10:15:02', '0', '修改服务器', '63');
INSERT INTO `gw_log` VALUES ('407', '63', '商品类型', '0:0:0:0:0:0:0:1', '2021-04-02 10:15:07', '0', '修改显示器', '63');
INSERT INTO `gw_log` VALUES ('408', '63', '商品类型', '0:0:0:0:0:0:0:1', '2021-04-02 10:15:37', '0', '删除[显示器]', '63');
INSERT INTO `gw_log` VALUES ('409', '63', '商品类型', '0:0:0:0:0:0:0:1', '2021-04-02 10:15:42', '0', '新增显示器', '63');
INSERT INTO `gw_log` VALUES ('410', '63', '商品类型', '0:0:0:0:0:0:0:1', '2021-04-02 10:15:55', '0', '新增x86', '63');
INSERT INTO `gw_log` VALUES ('411', '63', '商品类型', '0:0:0:0:0:0:0:1', '2021-04-02 10:16:10', '0', '修改x86机型', '63');
INSERT INTO `gw_log` VALUES ('412', '63', '商品类型', '0:0:0:0:0:0:0:1', '2021-04-02 10:16:27', '0', '新增台式机', '63');
INSERT INTO `gw_log` VALUES ('413', '63', '商品类型', '0:0:0:0:0:0:0:1', '2021-04-02 10:17:03', '0', '新增服务器', '63');
INSERT INTO `gw_log` VALUES ('414', '63', '商品类型', '0:0:0:0:0:0:0:1', '2021-04-02 10:17:10', '0', '修改显示器', '63');
INSERT INTO `gw_log` VALUES ('415', '63', '商品类型', '0:0:0:0:0:0:0:1', '2021-04-02 10:17:15', '0', '修改打印机', '63');
INSERT INTO `gw_log` VALUES ('416', '63', '商品类型', '0:0:0:0:0:0:0:1', '2021-04-02 10:17:30', '0', '新增打印机', '63');
INSERT INTO `gw_log` VALUES ('417', '63', '商品类型', '0:0:0:0:0:0:0:1', '2021-04-02 10:17:40', '0', '新增显示器', '63');
INSERT INTO `gw_log` VALUES ('418', '63', '商品类型', '0:0:0:0:0:0:0:1', '2021-04-02 10:18:20', '0', '新增一体机', '63');
INSERT INTO `gw_log` VALUES ('419', '63', '商品类型', '0:0:0:0:0:0:0:1', '2021-04-02 10:18:26', '0', '修改会议一体机', '63');
INSERT INTO `gw_log` VALUES ('420', '63', '商品类型', '0:0:0:0:0:0:0:1', '2021-04-02 10:18:43', '0', '新增运维管理一体机', '63');
INSERT INTO `gw_log` VALUES ('421', '63', '商品类型', '0:0:0:0:0:0:0:1', '2021-04-02 10:19:22', '0', '新增台式一体机', '63');
INSERT INTO `gw_log` VALUES ('422', '63', '商品类型', '0:0:0:0:0:0:0:1', '2021-04-02 10:19:41', '0', '新增普通台式机', '63');
INSERT INTO `gw_log` VALUES ('423', '63', '商品类型', '0:0:0:0:0:0:0:1', '2021-04-02 10:19:59', '0', '新增笔记本', '63');
INSERT INTO `gw_log` VALUES ('424', '63', '计量单位', '0:0:0:0:0:0:0:1', '2021-04-02 10:20:54', '0', '新增台,箱(1:5)', '63');
INSERT INTO `gw_log` VALUES ('425', '63', '计量单位', '0:0:0:0:0:0:0:1', '2021-04-02 10:21:05', '0', '删除[台,箱(1:5)]', '63');
INSERT INTO `gw_log` VALUES ('426', '63', '商品', '0:0:0:0:0:0:0:1', '2021-04-02 10:28:34', '0', '新增台式机', '63');
INSERT INTO `gw_log` VALUES ('427', '63', '仓库', '0:0:0:0:0:0:0:1', '2021-04-02 10:31:59', '0', '新增整机库', '63');
INSERT INTO `gw_log` VALUES ('428', '63', '仓库', '0:0:0:0:0:0:0:1', '2021-04-02 10:32:13', '0', '新增样机库', '63');
INSERT INTO `gw_log` VALUES ('429', '63', '仓库', '0:0:0:0:0:0:0:1', '2021-04-02 10:32:27', '0', '新增物料库', '63');
INSERT INTO `gw_log` VALUES ('430', '63', '仓库', '0:0:0:0:0:0:0:1', '2021-04-02 10:32:35', '0', '修改19', '63');
INSERT INTO `gw_log` VALUES ('431', '63', '仓库', '0:0:0:0:0:0:0:1', '2021-04-02 10:32:35', '0', '修改20', '63');
INSERT INTO `gw_log` VALUES ('432', '63', '仓库', '0:0:0:0:0:0:0:1', '2021-04-02 10:32:35', '0', '修改21', '63');
INSERT INTO `gw_log` VALUES ('433', '63', '商品', '0:0:0:0:0:0:0:1', '2021-04-02 10:34:21', '0', '修改台式机', '63');
INSERT INTO `gw_log` VALUES ('434', '63', '单据', '0:0:0:0:0:0:0:1', '2021-04-02 10:34:58', '0', '新增ZJRK00000000447', '63');
INSERT INTO `gw_log` VALUES ('435', '63', '商品', '0:0:0:0:0:0:0:1', '2021-04-02 10:40:46', '0', '新增台式一体机', '63');
INSERT INTO `gw_log` VALUES ('436', '63', '单据', '0:0:0:0:0:0:0:1', '2021-04-02 10:41:40', '0', '新增ZJRK00000000448', '63');
INSERT INTO `gw_log` VALUES ('437', '63', '机构', '0:0:0:0:0:0:0:1', '2021-04-02 10:48:30', '0', '删除[研发中心][产品开发部]', '63');
INSERT INTO `gw_log` VALUES ('438', '63', '机构', '0:0:0:0:0:0:0:1', '2021-04-02 10:49:47', '0', '新增河南长城计算机系统有限公司', '63');
INSERT INTO `gw_log` VALUES ('439', '63', '机构', '0:0:0:0:0:0:0:1', '2021-04-02 10:50:18', '0', '新增营销中心', '63');
INSERT INTO `gw_log` VALUES ('440', '63', '机构', '0:0:0:0:0:0:0:1', '2021-04-02 10:50:46', '0', '新增财务部', '63');
INSERT INTO `gw_log` VALUES ('441', '63', '机构', '0:0:0:0:0:0:0:1', '2021-04-02 10:51:06', '0', '新增制造中心', '63');
INSERT INTO `gw_log` VALUES ('442', '63', '机构', '0:0:0:0:0:0:0:1', '2021-04-02 10:51:22', '0', '新增研发中心', '63');
INSERT INTO `gw_log` VALUES ('443', '63', '机构', '0:0:0:0:0:0:0:1', '2021-04-02 10:51:45', '0', '新增行政中心', '63');
INSERT INTO `gw_log` VALUES ('445', '63', '机构', '0:0:0:0:0:0:0:1', '2021-04-02 10:52:22', '0', '新增销售部', '63');
INSERT INTO `gw_log` VALUES ('446', '63', '机构', '0:0:0:0:0:0:0:1', '2021-04-02 10:52:51', '0', '修改销售部', '63');
INSERT INTO `gw_log` VALUES ('447', '63', '机构', '0:0:0:0:0:0:0:1', '2021-04-02 10:53:32', '0', '新增生产部', '63');
INSERT INTO `gw_log` VALUES ('448', '63', '机构', '0:0:0:0:0:0:0:1', '2021-04-02 10:53:54', '0', '新增工程技术部', '63');
INSERT INTO `gw_log` VALUES ('449', '63', '机构', '0:0:0:0:0:0:0:1', '2021-04-02 10:54:16', '0', '新增质量部', '63');
INSERT INTO `gw_log` VALUES ('450', '63', '机构', '0:0:0:0:0:0:0:1', '2021-04-02 10:54:45', '0', '新增适配中心', '63');
INSERT INTO `gw_log` VALUES ('451', '63', '机构', '0:0:0:0:0:0:0:1', '2021-04-02 10:55:11', '0', '新增软件开发部', '63');
INSERT INTO `gw_log` VALUES ('452', '63', '机构', '0:0:0:0:0:0:0:1', '2021-04-02 10:55:34', '0', '新增市场部', '63');
INSERT INTO `gw_log` VALUES ('453', '63', '机构', '0:0:0:0:0:0:0:1', '2021-04-02 10:56:40', '0', '新增战略部', '63');
INSERT INTO `gw_log` VALUES ('454', '63', '机构', '0:0:0:0:0:0:0:1', '2021-04-02 10:57:00', '0', '新增综合部', '63');
INSERT INTO `gw_log` VALUES ('455', '63', '机构', '0:0:0:0:0:0:0:1', '2021-04-02 10:57:20', '0', '新增基建部', '63');
INSERT INTO `gw_log` VALUES ('456', '63', '机构', '0:0:0:0:0:0:0:1', '2021-04-02 10:57:23', '0', '修改综合部', '63');
INSERT INTO `gw_log` VALUES ('457', '63', '机构', '0:0:0:0:0:0:0:1', '2021-04-02 10:57:48', '0', '新增运营部', '63');
INSERT INTO `gw_log` VALUES ('458', '63', '关联关系', '0:0:0:0:0:0:0:1', '2021-04-02 11:01:54', '0', '修改', '63');
INSERT INTO `gw_log` VALUES ('459', '63', '关联关系', '0:0:0:0:0:0:0:1', '2021-04-02 11:02:43', '0', '修改70', '63');
INSERT INTO `gw_log` VALUES ('460', '63', '关联关系', '0:0:0:0:0:0:0:1', '2021-04-02 11:03:13', '0', '修改', '63');
INSERT INTO `gw_log` VALUES ('461', '63', '关联关系', '0:0:0:0:0:0:0:1', '2021-04-02 11:04:18', '0', '修改71', '63');
INSERT INTO `gw_log` VALUES ('462', '63', '角色', '0:0:0:0:0:0:0:1', '2021-04-02 11:04:26', '0', '修改财务', '63');
INSERT INTO `gw_log` VALUES ('463', '63', '关联关系', '0:0:0:0:0:0:0:1', '2021-04-02 11:06:12', '0', '修改', '63');
INSERT INTO `gw_log` VALUES ('464', '63', '关联关系', '0:0:0:0:0:0:0:1', '2021-04-02 11:06:32', '0', '修改72', '63');
INSERT INTO `gw_log` VALUES ('465', '63', '关联关系', '0:0:0:0:0:0:0:1', '2021-04-02 11:07:15', '0', '修改', '63');
INSERT INTO `gw_log` VALUES ('466', '63', '关联关系', '0:0:0:0:0:0:0:1', '2021-04-02 11:07:36', '0', '修改78', '63');
INSERT INTO `gw_log` VALUES ('467', '63', '用户', '0:0:0:0:0:0:0:1', '2021-04-02 11:08:34', '0', '修改63', '63');
INSERT INTO `gw_log` VALUES ('468', '63', '用户', '0:0:0:0:0:0:0:1', '2021-04-02 11:08:53', '0', '修改133', '63');
INSERT INTO `gw_log` VALUES ('469', '63', '用户', '0:0:0:0:0:0:0:1', '2021-04-02 11:09:02', '0', '修改135', '63');
INSERT INTO `gw_log` VALUES ('470', '63', '用户', '0:0:0:0:0:0:0:1', '2021-04-02 11:09:13', '0', '修改134', '63');
INSERT INTO `gw_log` VALUES ('471', '63', '用户', '0:0:0:0:0:0:0:1', '2021-04-02 11:09:24', '0', '修改137', '63');
INSERT INTO `gw_log` VALUES ('472', '63', '商品', '0:0:0:0:0:0:0:1', '2021-04-02 11:26:12', '0', '新增信创服务器', '63');
INSERT INTO `gw_log` VALUES ('473', '63', '商品', '0:0:0:0:0:0:0:1', '2021-04-02 11:26:23', '0', '修改信创服务器', '63');
INSERT INTO `gw_log` VALUES ('474', '63', '商品', '0:0:0:0:0:0:0:1', '2021-04-02 11:26:32', '0', '修改信创服务器', '63');
INSERT INTO `gw_log` VALUES ('475', '63', '单据', '0:0:0:0:0:0:0:1', '2021-04-02 11:26:57', '0', '新增ZJRK00000000449', '63');
INSERT INTO `gw_log` VALUES ('476', '63', '商品', '0:0:0:0:0:0:0:1', '2021-04-02 11:32:21', '0', '新增运维管理一体机', '63');
INSERT INTO `gw_log` VALUES ('477', '63', '商品', '0:0:0:0:0:0:0:1', '2021-04-02 11:32:34', '0', '修改运维管理一体机', '63');
INSERT INTO `gw_log` VALUES ('478', '63', '商品', '0:0:0:0:0:0:0:1', '2021-04-02 11:33:41', '0', '新增信创笔记本', '63');
INSERT INTO `gw_log` VALUES ('479', '63', '商品', '0:0:0:0:0:0:0:1', '2021-04-02 11:33:50', '0', '修改信创笔记本', '63');
INSERT INTO `gw_log` VALUES ('480', '63', '商品', '0:0:0:0:0:0:0:1', '2021-04-02 11:35:08', '0', '新增会议一体机', '63');
INSERT INTO `gw_log` VALUES ('481', '63', '商品', '0:0:0:0:0:0:0:1', '2021-04-02 11:35:17', '0', '修改会议一体机', '63');
INSERT INTO `gw_log` VALUES ('482', '63', '商品', '0:0:0:0:0:0:0:1', '2021-04-02 11:37:04', '0', '新增x86台式机', '63');
INSERT INTO `gw_log` VALUES ('483', '63', '商品', '0:0:0:0:0:0:0:1', '2021-04-02 11:37:57', '0', '新增会议一体机', '63');
INSERT INTO `gw_log` VALUES ('484', '63', '商品', '0:0:0:0:0:0:0:1', '2021-04-02 11:38:08', '0', '修改会议一体机', '63');
INSERT INTO `gw_log` VALUES ('485', '63', '商品', '0:0:0:0:0:0:0:1', '2021-04-02 11:38:15', '0', '修改会议一体机', '63');
INSERT INTO `gw_log` VALUES ('486', '63', '商品', '0:0:0:0:0:0:0:1', '2021-04-02 11:38:30', '0', '修改会议一体机', '63');
INSERT INTO `gw_log` VALUES ('487', '63', '单据', '0:0:0:0:0:0:0:1', '2021-04-02 11:39:06', '0', '新增ZJRK00000000450', '63');
INSERT INTO `gw_log` VALUES ('488', '63', '单据', '0:0:0:0:0:0:0:1', '2021-04-02 11:39:49', '0', '新增ZJRK00000000451', '63');
INSERT INTO `gw_log` VALUES ('489', '63', '单据', '0:0:0:0:0:0:0:1', '2021-04-02 11:40:57', '0', '新增ZJRK00000000452', '63');
INSERT INTO `gw_log` VALUES ('490', '63', '单据', '0:0:0:0:0:0:0:1', '2021-04-02 11:41:15', '0', '新增ZJRK00000000453', '63');
INSERT INTO `gw_log` VALUES ('491', '63', '单据', '0:0:0:0:0:0:0:1', '2021-04-02 11:41:34', '0', '新增ZJRK00000000454', '63');
INSERT INTO `gw_log` VALUES ('492', '63', '商家', '0:0:0:0:0:0:0:1', '2021-04-02 11:45:37', '0', '新增客户01', '63');
INSERT INTO `gw_log` VALUES ('493', '63', '商家', '0:0:0:0:0:0:0:1', '2021-04-02 11:46:24', '0', '新增客户02', '63');
INSERT INTO `gw_log` VALUES ('494', '63', '商家', '0:0:0:0:0:0:0:1', '2021-04-02 11:47:09', '0', '新增客户03', '63');
INSERT INTO `gw_log` VALUES ('495', '63', '单据', '0:0:0:0:0:0:0:1', '2021-04-02 11:48:44', '0', '新增LLCK00000000457', '63');
INSERT INTO `gw_log` VALUES ('496', '63', '单据', '0:0:0:0:0:0:0:1', '2021-04-02 11:49:28', '0', '新增DBCK00000000458', '63');
INSERT INTO `gw_log` VALUES ('497', '63', '单据', '0:0:0:0:0:0:0:1', '2021-04-02 11:50:22', '0', '新增ZZD00000000459', '63');
INSERT INTO `gw_log` VALUES ('498', '63', '单据', '0:0:0:0:0:0:0:1', '2021-04-02 11:50:50', '0', '新增CXD00000000460', '63');
INSERT INTO `gw_log` VALUES ('499', '137', '用户', '0:0:0:0:0:0:0:1', '2021-04-02 11:59:40', '0', '登录xs', '63');
INSERT INTO `gw_log` VALUES ('500', '137', '单据', '0:0:0:0:0:0:0:1', '2021-04-02 13:17:18', '0', '新增XSDD00000000461', '63');
INSERT INTO `gw_log` VALUES ('501', '63', '用户', '0:0:0:0:0:0:0:1', '2021-04-02 13:17:52', '0', '登录wdy', '63');
INSERT INTO `gw_log` VALUES ('502', '63', '关联关系', '0:0:0:0:0:0:0:1', '2021-04-02 13:18:12', '0', '修改78', '63');
INSERT INTO `gw_log` VALUES ('503', '137', '用户', '0:0:0:0:0:0:0:1', '2021-04-02 13:18:23', '0', '登录xs', '63');
INSERT INTO `gw_log` VALUES ('504', '133', '用户', '0:0:0:0:0:0:0:1', '2021-04-02 13:18:42', '0', '登录yy', '63');
INSERT INTO `gw_log` VALUES ('505', '135', '用户', '0:0:0:0:0:0:0:1', '2021-04-02 13:19:53', '0', '登录pmc', '63');
INSERT INTO `gw_log` VALUES ('506', '137', '用户', '0:0:0:0:0:0:0:1', '2021-04-02 13:20:31', '0', '登录xs', '63');
INSERT INTO `gw_log` VALUES ('507', '63', '用户', '0:0:0:0:0:0:0:1', '2021-04-02 13:20:42', '0', '登录wdy', '63');
INSERT INTO `gw_log` VALUES ('508', '63', '关联关系', '0:0:0:0:0:0:0:1', '2021-04-02 13:21:00', '0', '修改78', '63');
INSERT INTO `gw_log` VALUES ('509', '63', '关联关系', '0:0:0:0:0:0:0:1', '2021-04-02 13:26:50', '0', '修改', '63');
INSERT INTO `gw_log` VALUES ('510', '63', '关联关系', '0:0:0:0:0:0:0:1', '2021-04-02 13:35:21', '0', '修改', '63');
INSERT INTO `gw_log` VALUES ('511', '137', '用户', '0:0:0:0:0:0:0:1', '2021-04-02 13:35:57', '0', '登录xs', '63');
INSERT INTO `gw_log` VALUES ('512', '133', '用户', '0:0:0:0:0:0:0:1', '2021-04-02 13:36:18', '0', '登录yy', '63');
INSERT INTO `gw_log` VALUES ('513', '135', '用户', '0:0:0:0:0:0:0:1', '2021-04-02 13:37:16', '0', '登录pmc', '63');
INSERT INTO `gw_log` VALUES ('514', '133', '用户', '0:0:0:0:0:0:0:1', '2021-04-02 13:37:49', '0', '登录yy', '63');
INSERT INTO `gw_log` VALUES ('515', '135', '用户', '0:0:0:0:0:0:0:1', '2021-04-02 13:38:16', '0', '登录pmc', '63');
INSERT INTO `gw_log` VALUES ('516', '63', '用户', '0:0:0:0:0:0:0:1', '2021-04-02 13:39:14', '0', '登录wdy', '63');
INSERT INTO `gw_log` VALUES ('517', '134', '用户', '0:0:0:0:0:0:0:1', '2021-04-02 13:39:26', '0', '登录cw', '63');
INSERT INTO `gw_log` VALUES ('518', '134', '账户', '0:0:0:0:0:0:0:1', '2021-04-02 13:39:59', '0', '新增账户001', '63');
INSERT INTO `gw_log` VALUES ('519', '134', '账户', '0:0:0:0:0:0:0:1', '2021-04-02 13:40:15', '0', '修改20', '63');
INSERT INTO `gw_log` VALUES ('520', '134', '账户', '0:0:0:0:0:0:0:1', '2021-04-02 13:40:26', '0', '新增账户002', '63');
INSERT INTO `gw_log` VALUES ('521', '135', '用户', '0:0:0:0:0:0:0:1', '2021-04-02 13:40:38', '0', '登录pmc', '63');
INSERT INTO `gw_log` VALUES ('522', '135', '单据', '0:0:0:0:0:0:0:1', '2021-04-02 13:41:05', '0', '新增XSCK00000000465', '63');
INSERT INTO `gw_log` VALUES ('523', '133', '用户', '0:0:0:0:0:0:0:1', '2021-04-02 13:41:17', '0', '登录yy', '63');
INSERT INTO `gw_log` VALUES ('524', '137', '用户', '0:0:0:0:0:0:0:1', '2021-04-02 13:42:48', '0', '登录xs', '63');
INSERT INTO `gw_log` VALUES ('525', '135', '用户', '0:0:0:0:0:0:0:1', '2021-04-02 13:43:30', '0', '登录pmc', '63');
INSERT INTO `gw_log` VALUES ('526', '135', '单据', '0:0:0:0:0:0:0:1', '2021-04-02 13:44:24', '0', '修改XSCK00000000465', '63');
INSERT INTO `gw_log` VALUES ('527', '137', '用户', '0:0:0:0:0:0:0:1', '2021-04-02 13:44:46', '0', '登录xs', '63');
INSERT INTO `gw_log` VALUES ('528', '134', '用户', '0:0:0:0:0:0:0:1', '2021-04-02 13:45:16', '0', '登录cw', '63');
INSERT INTO `gw_log` VALUES ('529', '133', '用户', '0:0:0:0:0:0:0:1', '2021-04-02 13:49:15', '0', '登录yy', '63');
INSERT INTO `gw_log` VALUES ('530', '63', '用户', '0:0:0:0:0:0:0:1', '2021-04-02 13:51:23', '0', '登录wdy', '63');
INSERT INTO `gw_log` VALUES ('531', '63', '关联关系', '0:0:0:0:0:0:0:1', '2021-04-02 13:53:12', '0', '修改70', '63');
INSERT INTO `gw_log` VALUES ('532', '63', '关联关系', '0:0:0:0:0:0:0:1', '2021-04-02 13:54:06', '0', '修改71', '63');
INSERT INTO `gw_log` VALUES ('533', '63', '关联关系', '0:0:0:0:0:0:0:1', '2021-04-02 13:54:33', '0', '修改72', '63');
INSERT INTO `gw_log` VALUES ('534', '137', '用户', '0:0:0:0:0:0:0:1', '2021-04-02 13:54:40', '0', '登录xs', '63');
INSERT INTO `gw_log` VALUES ('535', '133', '用户', '0:0:0:0:0:0:0:1', '2021-04-02 13:55:05', '0', '登录yy', '63');
INSERT INTO `gw_log` VALUES ('536', '135', '用户', '0:0:0:0:0:0:0:1', '2021-04-02 13:56:10', '0', '登录pmc', '63');
INSERT INTO `gw_log` VALUES ('537', '137', '用户', '0:0:0:0:0:0:0:1', '2021-04-02 13:56:54', '0', '登录xs', '63');
INSERT INTO `gw_log` VALUES ('538', '137', '单据', '0:0:0:0:0:0:0:1', '2021-04-02 13:57:20', '0', '新增XSDD00000000466', '63');
INSERT INTO `gw_log` VALUES ('539', '133', '用户', '0:0:0:0:0:0:0:1', '2021-04-02 13:57:41', '0', '登录yy', '63');
INSERT INTO `gw_log` VALUES ('540', '63', '用户', '0:0:0:0:0:0:0:1', '2021-04-02 13:58:48', '0', '登录wdy', '63');
INSERT INTO `gw_log` VALUES ('541', '63', '关联关系', '0:0:0:0:0:0:0:1', '2021-04-02 13:59:08', '0', '修改70', '63');
INSERT INTO `gw_log` VALUES ('542', '133', '用户', '0:0:0:0:0:0:0:1', '2021-04-02 13:59:18', '0', '登录yy', '63');
INSERT INTO `gw_log` VALUES ('543', '133', '单据', '0:0:0:0:0:0:0:1', '2021-04-02 13:59:36', '0', '删除XSDD00000000466', '63');
INSERT INTO `gw_log` VALUES ('544', '137', '用户', '0:0:0:0:0:0:0:1', '2021-04-02 13:59:46', '0', '登录xs', '63');
INSERT INTO `gw_log` VALUES ('545', '133', '用户', '0:0:0:0:0:0:0:1', '2021-04-02 14:00:25', '0', '登录yy', '63');
INSERT INTO `gw_log` VALUES ('546', '135', '用户', '0:0:0:0:0:0:0:1', '2021-04-02 14:01:45', '0', '登录pmc', '63');
INSERT INTO `gw_log` VALUES ('547', '133', '用户', '0:0:0:0:0:0:0:1', '2021-04-02 14:03:05', '0', '登录yy', '63');
INSERT INTO `gw_log` VALUES ('548', '133', '商家', '0:0:0:0:0:0:0:1', '2021-04-02 14:04:33', '0', '新增供应商001', '63');
INSERT INTO `gw_log` VALUES ('549', '133', '商品类型', '0:0:0:0:0:0:0:1', '2021-04-02 14:06:29', '0', '新增物料', '63');
INSERT INTO `gw_log` VALUES ('550', '133', '商品类型', '0:0:0:0:0:0:0:1', '2021-04-02 14:07:23', '0', '新增硬盘', '63');
INSERT INTO `gw_log` VALUES ('551', '133', '商品类型', '0:0:0:0:0:0:0:1', '2021-04-02 14:07:34', '0', '新增纸箱', '63');
INSERT INTO `gw_log` VALUES ('552', '133', '商品类型', '0:0:0:0:0:0:0:1', '2021-04-02 14:07:50', '0', '新增内存条', '63');
INSERT INTO `gw_log` VALUES ('553', '133', '商品', '0:0:0:0:0:0:0:1', '2021-04-02 14:09:33', '0', '新增硬盘', '63');
INSERT INTO `gw_log` VALUES ('554', '133', '商品', '0:0:0:0:0:0:0:1', '2021-04-02 14:10:11', '0', '新增内存条', '63');
INSERT INTO `gw_log` VALUES ('555', '133', '商品', '0:0:0:0:0:0:0:1', '2021-04-02 14:11:31', '0', '新增纸箱', '63');
INSERT INTO `gw_log` VALUES ('556', '133', '单据', '0:0:0:0:0:0:0:1', '2021-04-02 14:13:27', '0', '新增CGDD00000000471', '63');
INSERT INTO `gw_log` VALUES ('557', '137', '用户', '0:0:0:0:0:0:0:1', '2021-04-02 14:13:54', '0', '登录xs', '63');
INSERT INTO `gw_log` VALUES ('558', '63', '用户', '0:0:0:0:0:0:0:1', '2021-04-02 14:14:04', '0', '登录wdy', '63');
INSERT INTO `gw_log` VALUES ('559', '63', '关联关系', '0:0:0:0:0:0:0:1', '2021-04-02 14:14:23', '0', '修改', '63');
INSERT INTO `gw_log` VALUES ('560', '63', '关联关系', '0:0:0:0:0:0:0:1', '2021-04-02 14:14:30', '0', '修改78', '63');
INSERT INTO `gw_log` VALUES ('561', '137', '用户', '0:0:0:0:0:0:0:1', '2021-04-02 14:14:38', '0', '登录xs', '63');
INSERT INTO `gw_log` VALUES ('562', '137', '单据', '0:0:0:0:0:0:0:1', '2021-04-02 14:15:23', '0', '新增CGDD00000000472', '63');
INSERT INTO `gw_log` VALUES ('563', '133', '用户', '0:0:0:0:0:0:0:1', '2021-04-02 14:15:46', '0', '登录yy', '63');
INSERT INTO `gw_log` VALUES ('564', '135', '用户', '0:0:0:0:0:0:0:1', '2021-04-02 14:16:05', '0', '登录pmc', '63');
INSERT INTO `gw_log` VALUES ('565', '135', '单据', '0:0:0:0:0:0:0:1', '2021-04-02 14:16:23', '0', '新增CGRK00000000473', '63');
INSERT INTO `gw_log` VALUES ('566', '135', '用户', '0:0:0:0:0:0:0:1', '2021-04-02 14:16:36', '0', '登录pmc', '63');
INSERT INTO `gw_log` VALUES ('567', '133', '用户', '0:0:0:0:0:0:0:1', '2021-04-02 14:16:45', '0', '登录yy', '63');
INSERT INTO `gw_log` VALUES ('568', '63', '用户', '0:0:0:0:0:0:0:1', '2021-04-02 14:18:27', '0', '登录wdy', '63');
INSERT INTO `gw_log` VALUES ('569', '63', '关联关系', '0:0:0:0:0:0:0:1', '2021-04-02 14:18:57', '0', '修改', '63');
INSERT INTO `gw_log` VALUES ('570', '63', '关联关系', '0:0:0:0:0:0:0:1', '2021-04-02 14:21:09', '0', '修改78', '63');
INSERT INTO `gw_log` VALUES ('571', '63', '关联关系', '0:0:0:0:0:0:0:1', '2021-04-02 14:22:15', '0', '修改70', '63');
INSERT INTO `gw_log` VALUES ('572', '63', '关联关系', '0:0:0:0:0:0:0:1', '2021-04-02 14:22:54', '0', '修改', '63');
INSERT INTO `gw_log` VALUES ('573', '63', '关联关系', '0:0:0:0:0:0:0:1', '2021-04-02 14:23:52', '0', '修改71', '63');
INSERT INTO `gw_log` VALUES ('574', '137', '用户', '0:0:0:0:0:0:0:1', '2021-04-02 14:24:03', '0', '登录xs', '63');
INSERT INTO `gw_log` VALUES ('575', '137', '单据', '0:0:0:0:0:0:0:1', '2021-04-02 14:26:31', '0', '新增XSTH00000000474', '63');
INSERT INTO `gw_log` VALUES ('576', '133', '用户', '0:0:0:0:0:0:0:1', '2021-04-02 14:26:52', '0', '登录yy', '63');
INSERT INTO `gw_log` VALUES ('577', '63', '用户', '0:0:0:0:0:0:0:1', '2021-04-02 14:27:11', '0', '登录wdy', '63');
INSERT INTO `gw_log` VALUES ('578', '63', '关联关系', '0:0:0:0:0:0:0:1', '2021-04-02 14:27:33', '0', '修改70', '63');
INSERT INTO `gw_log` VALUES ('579', '133', '用户', '0:0:0:0:0:0:0:1', '2021-04-02 14:27:43', '0', '登录yy', '63');
INSERT INTO `gw_log` VALUES ('580', '63', '用户', '0:0:0:0:0:0:0:1', '2021-04-02 14:28:13', '0', '登录wdy', '63');
INSERT INTO `gw_log` VALUES ('581', '63', '关联关系', '0:0:0:0:0:0:0:1', '2021-04-02 14:28:31', '0', '修改70', '63');
INSERT INTO `gw_log` VALUES ('582', '133', '用户', '0:0:0:0:0:0:0:1', '2021-04-02 14:28:38', '0', '登录yy', '63');
INSERT INTO `gw_log` VALUES ('583', '135', '用户', '0:0:0:0:0:0:0:1', '2021-04-02 14:28:56', '0', '登录pmc', '63');
INSERT INTO `gw_log` VALUES ('584', '63', '用户', '0:0:0:0:0:0:0:1', '2021-04-02 14:31:38', '0', '登录wdy', '63');
INSERT INTO `gw_log` VALUES ('585', '63', '关联关系', '0:0:0:0:0:0:0:1', '2021-04-02 14:32:42', '0', '修改71', '63');
INSERT INTO `gw_log` VALUES ('586', '63', '用户', '0:0:0:0:0:0:0:1', '2021-04-02 14:33:49', '0', '登录wdy', '63');
INSERT INTO `gw_log` VALUES ('587', '63', '关联关系', '0:0:0:0:0:0:0:1', '2021-04-02 14:34:34', '0', '修改', '63');
INSERT INTO `gw_log` VALUES ('588', '63', '关联关系', '0:0:0:0:0:0:0:1', '2021-04-02 14:34:39', '0', '修改78', '63');
INSERT INTO `gw_log` VALUES ('589', '137', '用户', '0:0:0:0:0:0:0:1', '2021-04-02 14:35:02', '0', '登录xs', '63');
INSERT INTO `gw_log` VALUES ('590', '63', '用户', '0:0:0:0:0:0:0:1', '2021-04-02 14:35:28', '0', '登录wdy', '63');
INSERT INTO `gw_log` VALUES ('591', '133', '用户', '0:0:0:0:0:0:0:1', '2021-04-02 14:35:46', '0', '登录yy', '63');
INSERT INTO `gw_log` VALUES ('592', '133', '单据', '0:0:0:0:0:0:0:1', '2021-04-02 14:37:00', '0', '新增CGTH00000000475', '63');
INSERT INTO `gw_log` VALUES ('593', '63', '用户', '0:0:0:0:0:0:0:1', '2021-04-02 14:40:31', '0', '登录wdy', '63');
INSERT INTO `gw_log` VALUES ('594', '133', '用户', '0:0:0:0:0:0:0:1', '2021-04-02 14:43:18', '0', '登录yy', '63');
INSERT INTO `gw_log` VALUES ('595', '133', '用户', '192.168.110.197', '2021-04-02 15:18:01', '0', '登录yy', '63');
INSERT INTO `gw_log` VALUES ('596', '120', '用户', '192.168.110.197', '2021-04-02 15:18:32', '0', '登录admin', null);
INSERT INTO `gw_log` VALUES ('597', '120', '关联关系', '192.168.110.197', '2021-04-02 15:46:51', '0', '修改70', null);
INSERT INTO `gw_log` VALUES ('598', '137', '用户', '0:0:0:0:0:0:0:1', '2021-04-02 16:09:02', '0', '登录xs', '63');
INSERT INTO `gw_log` VALUES ('599', '135', '用户', '0:0:0:0:0:0:0:1', '2021-04-02 16:10:01', '0', '登录pmc', '63');
INSERT INTO `gw_log` VALUES ('600', '120', '用户', '0:0:0:0:0:0:0:1', '2021-04-02 16:15:05', '0', '登录admin', null);
INSERT INTO `gw_log` VALUES ('601', '137', '用户', '0:0:0:0:0:0:0:1', '2021-04-02 16:28:16', '0', '登录xs', '63');
INSERT INTO `gw_log` VALUES ('602', '133', '用户', '0:0:0:0:0:0:0:1', '2021-04-02 16:31:16', '0', '登录yy', '63');

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
) ENGINE=InnoDB AUTO_INCREMENT=605 DEFAULT CHARSET=utf8 COMMENT='产品表';

-- ----------------------------
-- Records of gw_material
-- ----------------------------
INSERT INTO `gw_material` VALUES ('594', '44', '台式机', '', '50.000000', 'ts01', '15.6', '黑色', '台', '', null, '', '', '', '', '0', '63', '0');
INSERT INTO `gw_material` VALUES ('595', '43', '台式一体机', '', '50.000000', 'tsyt01', '15.6', '黑色', '台', '', null, '', '', '', '', '0', '63', '0');
INSERT INTO `gw_material` VALUES ('596', '31', '信创服务器', '', '100.000000', 'fwq01', '', '黑色', '台', '', null, '', '', '', '', '0', '63', '0');
INSERT INTO `gw_material` VALUES ('597', '42', '运维管理一体机', '', null, 'yw01', '15.6', '黑色', '台', '', null, '', '', '', '', '0', '63', '0');
INSERT INTO `gw_material` VALUES ('598', '45', '信创笔记本', '', '1000.000000', 'notebook01', '15.6', '银色', '台', '', null, '', '', '', '', '0', '63', '0');
INSERT INTO `gw_material` VALUES ('599', '41', '会议一体机', '', '50.000000', 'hy01', '75', '黑色', '台', '', null, '', '', '', '', '0', '63', '0');
INSERT INTO `gw_material` VALUES ('600', '37', 'x86台式机', '', '100.000000', '8601', '15.6', '黑色', '台', '', null, '', '', '', '', '0', '63', '0');
INSERT INTO `gw_material` VALUES ('601', '41', '会议一体机', '', '30.000000', 'hy02', '86', '黑色', '台', '', null, '', '', '', '', '0', '63', '0');
INSERT INTO `gw_material` VALUES ('602', '47', '硬盘', '', '100.000000', 'sdd', '500G', '', '个', '', null, '', '', '', '', '0', '63', '0');
INSERT INTO `gw_material` VALUES ('603', '49', '内存条', '', '100.000000', '', '16G', '黑色', '个', '', null, '', '', '', '', '0', '63', '0');
INSERT INTO `gw_material` VALUES ('604', '48', '纸箱', '', '1000.000000', '', '80*70cm', '', '个', '', null, '', '', '', '', '0', '63', '0');

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
) ENGINE=InnoDB AUTO_INCREMENT=50 DEFAULT CHARSET=utf8 COMMENT='产品类型表';

-- ----------------------------
-- Records of gw_material_category
-- ----------------------------
INSERT INTO `gw_material_category` VALUES ('29', '台式机', null, '34', '', '1', '', '', '2021-04-02 10:12:50', '63', '2021-04-02 10:14:50', '63', '63');
INSERT INTO `gw_material_category` VALUES ('30', '目录2', null, '29', '', '2', '', '', '2021-04-02 10:12:58', '63', '2021-04-02 10:13:36', '63', '63');
INSERT INTO `gw_material_category` VALUES ('31', '服务器', null, '34', '', '1', '', '', '2021-04-02 10:14:03', '63', '2021-04-02 10:15:02', '63', '63');
INSERT INTO `gw_material_category` VALUES ('32', '显示器', null, '34', '', '2', '', '', '2021-04-02 10:14:09', '63', '2021-04-02 10:15:37', '63', '63');
INSERT INTO `gw_material_category` VALUES ('33', '打印机', null, '36', '', '1', '', '', '2021-04-02 10:14:28', '63', '2021-04-02 10:17:15', '63', '63');
INSERT INTO `gw_material_category` VALUES ('34', '信创', null, '-1', '', '1', '', '', '2021-04-02 10:14:41', '63', '2021-04-02 10:14:41', '63', '63');
INSERT INTO `gw_material_category` VALUES ('35', '显示器', null, '36', '', '1', '', '', '2021-04-02 10:15:42', '63', '2021-04-02 10:17:10', '63', '63');
INSERT INTO `gw_material_category` VALUES ('36', 'x86机型', null, '-1', '', '1', '', '', '2021-04-02 10:15:55', '63', '2021-04-02 10:16:10', '63', '63');
INSERT INTO `gw_material_category` VALUES ('37', '台式机', null, '36', '', '1', '', '', '2021-04-02 10:16:27', '63', '2021-04-02 10:16:27', '63', '63');
INSERT INTO `gw_material_category` VALUES ('38', '服务器', null, '36', '', '1', '', '', '2021-04-02 10:17:03', '63', '2021-04-02 10:17:03', '63', '63');
INSERT INTO `gw_material_category` VALUES ('39', '打印机', null, '34', '', '1', '', '', '2021-04-02 10:17:30', '63', '2021-04-02 10:17:30', '63', '63');
INSERT INTO `gw_material_category` VALUES ('40', '显示器', null, '34', '', '1', '', '', '2021-04-02 10:17:40', '63', '2021-04-02 10:17:40', '63', '63');
INSERT INTO `gw_material_category` VALUES ('41', '会议一体机', null, '36', '', '1', '', '', '2021-04-02 10:18:20', '63', '2021-04-02 10:18:26', '63', '63');
INSERT INTO `gw_material_category` VALUES ('42', '运维管理一体机', null, '34', '', '1', '', '', '2021-04-02 10:18:43', '63', '2021-04-02 10:18:43', '63', '63');
INSERT INTO `gw_material_category` VALUES ('43', '台式一体机', null, '29', '', '1', '', '', '2021-04-02 10:19:22', '63', '2021-04-02 10:19:22', '63', '63');
INSERT INTO `gw_material_category` VALUES ('44', '普通台式机', null, '29', '', '1', '', '', '2021-04-02 10:19:41', '63', '2021-04-02 10:19:41', '63', '63');
INSERT INTO `gw_material_category` VALUES ('45', '笔记本', null, '34', '', '1', '', '', '2021-04-02 10:19:59', '63', '2021-04-02 10:19:59', '63', '63');
INSERT INTO `gw_material_category` VALUES ('46', '物料', null, '-1', '', '1', '', '', '2021-04-02 14:06:29', '133', '2021-04-02 14:06:29', '133', '63');
INSERT INTO `gw_material_category` VALUES ('47', '硬盘', null, '46', '', '1', '', '', '2021-04-02 14:07:23', '133', '2021-04-02 14:07:23', '133', '63');
INSERT INTO `gw_material_category` VALUES ('48', '纸箱', null, '46', '', '1', '', '', '2021-04-02 14:07:34', '133', '2021-04-02 14:07:34', '133', '63');
INSERT INTO `gw_material_category` VALUES ('49', '内存条', null, '46', '', '1', '', '', '2021-04-02 14:07:50', '133', '2021-04-02 14:07:50', '133', '63');

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
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='产品当前库存';

-- ----------------------------
-- Records of gw_material_current_stock
-- ----------------------------
INSERT INTO `gw_material_current_stock` VALUES ('12', '594', '19', '50.000000', '63', '0');
INSERT INTO `gw_material_current_stock` VALUES ('13', '595', '19', '60.000000', '63', '0');
INSERT INTO `gw_material_current_stock` VALUES ('14', '596', '19', '80.000000', '63', '0');
INSERT INTO `gw_material_current_stock` VALUES ('15', '597', '19', '10.000000', '63', '0');
INSERT INTO `gw_material_current_stock` VALUES ('16', '598', '19', '550.000000', '63', '0');
INSERT INTO `gw_material_current_stock` VALUES ('17', '599', '19', '29.000000', '63', '0');
INSERT INTO `gw_material_current_stock` VALUES ('18', '600', '19', '141.000000', '63', '0');
INSERT INTO `gw_material_current_stock` VALUES ('19', '601', '19', '9.000000', '63', '0');
INSERT INTO `gw_material_current_stock` VALUES ('20', '599', '20', '1.000000', '63', '0');
INSERT INTO `gw_material_current_stock` VALUES ('21', '594', '20', '-1.000000', '63', '0');
INSERT INTO `gw_material_current_stock` VALUES ('22', '602', '21', '115.000000', '63', '0');
INSERT INTO `gw_material_current_stock` VALUES ('23', '604', '21', '0.000000', '63', '0');

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
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='产品价格扩展';

-- ----------------------------
-- Records of gw_material_extend
-- ----------------------------
INSERT INTO `gw_material_extend` VALUES ('16', '594', '1000', '台', '2500.000000', '4700.000000', '4500.000000', null, '1', '2021-04-02 10:28:34', 'wdy', 'wdy', '1617330514873', '63', '1');
INSERT INTO `gw_material_extend` VALUES ('17', '594', '1001', '台', '2500.000000', '4700.000000', '4500.000000', null, '1', '2021-04-02 10:28:34', 'wdy', 'wdy', '1617330861759', '63', '0');
INSERT INTO `gw_material_extend` VALUES ('18', '594', '1003', '台', '2500.000000', '4700.000000', '4500.000000', null, '0', '2021-04-02 10:28:34', 'wdy', 'wdy', '1617330514879', '63', '1');
INSERT INTO `gw_material_extend` VALUES ('19', '595', '1006', '台', '3500.000000', '5600.000000', '5500.000000', null, '1', '2021-04-02 10:40:46', 'wdy', 'wdy', '1617331246660', '63', '0');
INSERT INTO `gw_material_extend` VALUES ('20', '596', '1007', '台', '15000.000000', null, '16000.000000', null, '1', '2021-04-02 11:26:12', 'wdy', 'wdy', '1617333992147', '63', '0');
INSERT INTO `gw_material_extend` VALUES ('21', '597', '1008', '台', null, null, null, null, '1', '2021-04-02 11:32:21', 'wdy', 'wdy', '1617334354132', '63', '0');
INSERT INTO `gw_material_extend` VALUES ('22', '598', '1009', '台', null, null, null, null, '1', '2021-04-02 11:33:41', 'wdy', 'wdy', '1617334430672', '63', '0');
INSERT INTO `gw_material_extend` VALUES ('23', '599', '1010', '台', '9000.000000', null, '15000.000000', null, '1', '2021-04-02 11:35:08', 'wdy', 'wdy', '1617334517704', '63', '0');
INSERT INTO `gw_material_extend` VALUES ('24', '600', '1011', '台', null, null, null, null, '1', '2021-04-02 11:37:04', 'wdy', 'wdy', '1617334624099', '63', '0');
INSERT INTO `gw_material_extend` VALUES ('25', '601', '1012', '台', '12000.000000', null, '20000.000000', null, '1', '2021-04-02 11:37:57', 'wdy', 'wdy', '1617334710477', '63', '0');
INSERT INTO `gw_material_extend` VALUES ('26', '602', '1013', '个', null, null, null, null, '1', '2021-04-02 14:09:33', 'yy', 'yy', '1617343773931', '63', '0');
INSERT INTO `gw_material_extend` VALUES ('27', '603', '1014', '个', null, null, null, null, '1', '2021-04-02 14:10:11', 'yy', 'yy', '1617343811167', '63', '0');
INSERT INTO `gw_material_extend` VALUES ('28', '604', '1015', '个', null, null, null, null, '1', '2021-04-02 14:11:31', 'yy', 'yy', '1617343891138', '63', '0');

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
) ENGINE=InnoDB AUTO_INCREMENT=134 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='产品初始库存';

-- ----------------------------
-- Records of gw_material_initial_stock
-- ----------------------------
INSERT INTO `gw_material_initial_stock` VALUES ('125', '595', '19', '10.000000', '63', '0');
INSERT INTO `gw_material_initial_stock` VALUES ('127', '596', '19', '50.000000', '63', '0');
INSERT INTO `gw_material_initial_stock` VALUES ('128', '597', '19', '5.000000', '63', '0');
INSERT INTO `gw_material_initial_stock` VALUES ('129', '598', '19', '500.000000', '63', '0');
INSERT INTO `gw_material_initial_stock` VALUES ('130', '599', '19', '10.000000', '63', '0');
INSERT INTO `gw_material_initial_stock` VALUES ('131', '600', '19', '100.000000', '63', '0');
INSERT INTO `gw_material_initial_stock` VALUES ('133', '602', '21', '100.000000', '63', '0');

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='消息表';

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
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8 COMMENT='机构表';

-- ----------------------------
-- Records of gw_organization
-- ----------------------------
INSERT INTO `gw_organization` VALUES ('15', '001', '研发中心', '研发中心', null, '5', '-1', '01', '', '2021-02-23 15:57:03', '63', '2021-04-02 10:48:30', '63', null, null, '63');
INSERT INTO `gw_organization` VALUES ('16', '002', '产品开发部', '产品开发', null, '5', '001', '02', '', '2021-02-23 15:58:12', '63', '2021-04-02 10:48:30', '63', null, null, '63');
INSERT INTO `gw_organization` VALUES ('17', '01', '河南长城计算机系统有限公司', '长城计算机', null, '2', '-1', '01', '', '2021-04-02 10:49:47', '63', '2021-04-02 10:49:47', '63', null, null, '63');
INSERT INTO `gw_organization` VALUES ('18', '001', '营销中心', '营销中心', null, '', '01', '001', '', '2021-04-02 10:50:18', '63', '2021-04-02 10:50:18', '63', null, null, '63');
INSERT INTO `gw_organization` VALUES ('19', '002', '财务部', '财务部', null, '', '01', '002', '', '2021-04-02 10:50:46', '63', '2021-04-02 10:50:46', '63', null, null, '63');
INSERT INTO `gw_organization` VALUES ('20', '003', '制造中心', '制造中心', null, '', '01', '003', '', '2021-04-02 10:51:06', '63', '2021-04-02 10:51:06', '63', null, null, '63');
INSERT INTO `gw_organization` VALUES ('21', '004', '研发中心', '研发中心', null, '', '01', '004', '', '2021-04-02 10:51:22', '63', '2021-04-02 10:51:22', '63', null, null, '63');
INSERT INTO `gw_organization` VALUES ('22', '005', '行政中心', '行政中心', null, '', '01', '005', '', '2021-04-02 10:51:45', '63', '2021-04-02 10:51:45', '63', null, null, '63');
INSERT INTO `gw_organization` VALUES ('23', '0001', '销售部', '销售部', null, '', '001', '0001', '', '2021-04-02 10:52:22', '63', '2021-04-02 10:52:51', '63', null, null, '63');
INSERT INTO `gw_organization` VALUES ('24', '0002', '生产部', '生产部', null, '', '003', '0002', '', '2021-04-02 10:53:32', '63', '2021-04-02 10:53:32', '63', null, null, '63');
INSERT INTO `gw_organization` VALUES ('25', '0003', '工程技术部', '工程技术部', null, '', '003', '0003', '', '2021-04-02 10:53:54', '63', '2021-04-02 10:53:54', '63', null, null, '63');
INSERT INTO `gw_organization` VALUES ('26', '0004', '质量部', '质量部', null, '', '003', '0004', '', '2021-04-02 10:54:16', '63', '2021-04-02 10:54:16', '63', null, null, '63');
INSERT INTO `gw_organization` VALUES ('27', '0005', '适配中心', '适配中心', null, '', '004', '0005', '', '2021-04-02 10:54:45', '63', '2021-04-02 10:54:45', '63', null, null, '63');
INSERT INTO `gw_organization` VALUES ('28', '0006', '软件开发部', '软件开发部', null, '', '004', '0006', '', '2021-04-02 10:55:11', '63', '2021-04-02 10:55:11', '63', null, null, '63');
INSERT INTO `gw_organization` VALUES ('29', '0007', '市场部', '市场部', null, '', '004', '0007', '', '2021-04-02 10:55:34', '63', '2021-04-02 10:55:34', '63', null, null, '63');
INSERT INTO `gw_organization` VALUES ('30', '0008', '战略部', '战略部', null, '', '005', '0008', '', '2021-04-02 10:56:40', '63', '2021-04-02 10:56:40', '63', null, null, '63');
INSERT INTO `gw_organization` VALUES ('31', '0009', '综合部', '综合部', null, '', '005', '0009', '', '2021-04-02 10:57:00', '63', '2021-04-02 10:57:23', '63', null, null, '63');
INSERT INTO `gw_organization` VALUES ('32', '0010', '基建部', '基建部', null, '', '005', '0010', '', '2021-04-02 10:57:20', '63', '2021-04-02 10:57:20', '63', null, null, '63');
INSERT INTO `gw_organization` VALUES ('33', '0011', '运营部', '运营部', null, '', '005', '0011', '', '2021-04-02 10:57:48', '63', '2021-04-02 10:57:48', '63', null, null, '63');

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
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8 COMMENT='机构用户关系表';

-- ----------------------------
-- Records of gw_orga_user_rel
-- ----------------------------
INSERT INTO `gw_orga_user_rel` VALUES ('11', '28', '63', '', '0', '2020-09-13 18:42:45', '63', '2021-04-02 11:08:34', '63', '63');
INSERT INTO `gw_orga_user_rel` VALUES ('12', '33', '133', '', '0', '2021-04-02 11:08:53', '63', '2021-04-02 11:08:53', '63', '63');
INSERT INTO `gw_orga_user_rel` VALUES ('13', '33', '135', '', '0', '2021-04-02 11:09:02', '63', '2021-04-02 11:09:02', '63', '63');
INSERT INTO `gw_orga_user_rel` VALUES ('14', '19', '134', '', '0', '2021-04-02 11:09:13', '63', '2021-04-02 11:09:13', '63', '63');
INSERT INTO `gw_orga_user_rel` VALUES ('15', '23', '137', '', '0', '2021-04-02 11:09:24', '63', '2021-04-02 11:09:24', '63', '63');

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
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8 COMMENT='角色表';

-- ----------------------------
-- Records of gw_role
-- ----------------------------
INSERT INTO `gw_role` VALUES ('4', '管理员', '全部数据', null, null, null, '0');
INSERT INTO `gw_role` VALUES ('10', '租户', '全部数据', null, '', null, '0');
INSERT INTO `gw_role` VALUES ('20', '运营', '全部数据', null, '', '63', '0');
INSERT INTO `gw_role` VALUES ('21', 'PMC', '全部数据', null, '', '63', '0');
INSERT INTO `gw_role` VALUES ('22', '财务', '全部数据', null, '', '63', '0');
INSERT INTO `gw_role` VALUES ('23', '销售', '全部数据', null, '', '63', '0');

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
INSERT INTO `gw_sequence` VALUES ('depot_number_seq', '1', '999999999999999999', '476', '1', '单据编号sequence');

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='序列号表';

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
) ENGINE=InnoDB AUTO_INCREMENT=81 DEFAULT CHARSET=utf8 COMMENT='供应商/客户信息表';

-- ----------------------------
-- Records of gw_supplier
-- ----------------------------
INSERT INTO `gw_supplier` VALUES ('77', '客户01', '刘邦', '', '', '', null, '客户', '', '0.000000', null, null, null, null, '', '18888888888', '西安市未央区', '', '', '', null, '63', '0');
INSERT INTO `gw_supplier` VALUES ('78', '客户02', '朱元璋', '', '', '', null, '客户', '', '0.000000', null, null, null, null, '', '19999999999', '北京市海淀区', '', '', '', null, '63', '0');
INSERT INTO `gw_supplier` VALUES ('79', '客户03', '赵匡胤', '', '', '', null, '客户', '', '0.000000', null, null, null, null, '', '16666666666', '河南省开封市', '', '', '', null, '63', '0');
INSERT INTO `gw_supplier` VALUES ('80', '供应商001', '', '', '', '', null, '供应商', '', '0.000000', null, null, null, null, '', '666666', '上海市', '', '', '', null, '63', '0');

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
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8 COMMENT='租户';

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
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8 COMMENT='多单位表';

-- ----------------------------
-- Records of gw_unit
-- ----------------------------
INSERT INTO `gw_unit` VALUES ('18', '台,箱(1:5)', '台', '箱', '5', '63', '1');

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
) ENGINE=InnoDB AUTO_INCREMENT=138 DEFAULT CHARSET=utf8 COMMENT='用户表';

-- ----------------------------
-- Records of gw_user
-- ----------------------------
INSERT INTO `gw_user` VALUES ('63', '汪东洋', 'wdy', 'e10adc3949ba59abbe56e057f20f883e', '', null, '', '', '1', '1', '0', '', null, '63');
INSERT INTO `gw_user` VALUES ('120', '管理员', 'admin', 'e10adc3949ba59abbe56e057f20f883e', null, null, null, null, '1', '0', '0', null, null, null);
INSERT INTO `gw_user` VALUES ('133', '运营', 'yy', 'e10adc3949ba59abbe56e057f20f883e', '', null, '', '', '1', '0', '0', '', null, '63');
INSERT INTO `gw_user` VALUES ('134', '财务', 'cw', 'e10adc3949ba59abbe56e057f20f883e', '', null, '', '', '1', '0', '0', '', null, '63');
INSERT INTO `gw_user` VALUES ('135', 'PMC', 'pmc', 'e10adc3949ba59abbe56e057f20f883e', '', null, '', '', '1', '0', '0', '', null, '63');
INSERT INTO `gw_user` VALUES ('137', '销售', 'xs', 'e10adc3949ba59abbe56e057f20f883e', '', null, '', '', '1', '0', '0', '', null, '63');

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
INSERT INTO `gw_user_business` VALUES ('5', 'RoleFunctions', '4', '[210][211][241][33][199][242][41][200][201][202][40][232][233][197][203][204][205][206][212][59][207][208][209][226][227][228][229][235][237][244][22][23][220][240][25][217][218][26][194][195][31][13][14][243][15][234][16][245]', '[{\"funId\":\"13\",\"btnStr\":\"1\"},{\"funId\":\"14\",\"btnStr\":\"1\"},{\"funId\":\"243\",\"btnStr\":\"1\"},{\"funId\":\"234\",\"btnStr\":\"1\"},{\"funId\":\"16\",\"btnStr\":\"1\"},{\"funId\":\"245\",\"btnStr\":\"1\"},{\"funId\":\"22\",\"btnStr\":\"1\"},{\"funId\":\"23\",\"btnStr\":\"1\"},{\"funId\":\"220\",\"btnStr\":\"1\"},{\"funId\":\"240\",\"btnStr\":\"1\"},{\"funId\":\"25\",\"btnStr\":\"1\"},{\"funId\":\"217\",\"btnStr\":\"1\"},{\"funId\":\"218\",\"btnStr\":\"1\"},{\"funId\":\"26\",\"btnStr\":\"1\"},{\"funId\":\"194\",\"btnStr\":\"1\"},{\"funId\":\"195\",\"btnStr\":\"1\"},{\"funId\":\"31\",\"btnStr\":\"1\"},{\"funId\":\"241\",\"btnStr\":\"1,2\"},{\"funId\":\"33\",\"btnStr\":\"1,2\"},{\"funId\":\"199\",\"btnStr\":\"1,2\"},{\"funId\":\"242\",\"btnStr\":\"1,2\"},{\"funId\":\"41\",\"btnStr\":\"1,2\"},{\"funId\":\"200\",\"btnStr\":\"1,2\"},{\"funId\":\"210\",\"btnStr\":\"1,2\"},{\"funId\":\"211\",\"btnStr\":\"1,2\"},{\"funId\":\"197\",\"btnStr\":\"1\"},{\"funId\":\"203\",\"btnStr\":\"1\"},{\"funId\":\"204\",\"btnStr\":\"1\"},{\"funId\":\"205\",\"btnStr\":\"1\"},{\"funId\":\"206\",\"btnStr\":\"1\"},{\"funId\":\"212\",\"btnStr\":\"1\"},{\"funId\":\"201\",\"btnStr\":\"1,2\"},{\"funId\":\"202\",\"btnStr\":\"1,2\"},{\"funId\":\"40\",\"btnStr\":\"1,2\"},{\"funId\":\"232\",\"btnStr\":\"1,2\"},{\"funId\":\"233\",\"btnStr\":\"1,2\"}]', '0');
INSERT INTO `gw_user_business` VALUES ('16', 'UserRole', '63', '[10]', null, '0');
INSERT INTO `gw_user_business` VALUES ('18', 'UserDepot', '63', '[14][15]', null, '0');
INSERT INTO `gw_user_business` VALUES ('27', 'UserCustomer', '63', '[58]', null, '0');
INSERT INTO `gw_user_business` VALUES ('32', 'RoleFunctions', '10', '[210][211][241][33][199][242][41][200][201][202][40][232][233][197][203][204][205][206][212][59][207][208][209][226][227][228][229][235][237][244][246][22][23][220][240][25][217][218][26][194][195][31][13][243][14][15][234]', '[{\"funId\":\"13\",\"btnStr\":\"1\"},{\"funId\":\"243\",\"btnStr\":\"1\"},{\"funId\":\"14\",\"btnStr\":\"1\"},{\"funId\":\"234\",\"btnStr\":\"1\"},{\"funId\":\"22\",\"btnStr\":\"1\"},{\"funId\":\"23\",\"btnStr\":\"1\"},{\"funId\":\"220\",\"btnStr\":\"1\"},{\"funId\":\"240\",\"btnStr\":\"1\"},{\"funId\":\"25\",\"btnStr\":\"1\"},{\"funId\":\"217\",\"btnStr\":\"1\"},{\"funId\":\"218\",\"btnStr\":\"1\"},{\"funId\":\"26\",\"btnStr\":\"1\"},{\"funId\":\"194\",\"btnStr\":\"1\"},{\"funId\":\"195\",\"btnStr\":\"1\"},{\"funId\":\"31\",\"btnStr\":\"1\"},{\"funId\":\"241\",\"btnStr\":\"1,2\"},{\"funId\":\"33\",\"btnStr\":\"1,2\"},{\"funId\":\"199\",\"btnStr\":\"1,2\"},{\"funId\":\"242\",\"btnStr\":\"1,2\"},{\"funId\":\"41\",\"btnStr\":\"1,2\"},{\"funId\":\"200\",\"btnStr\":\"1,2\"},{\"funId\":\"210\",\"btnStr\":\"1,2\"},{\"funId\":\"211\",\"btnStr\":\"1,2\"},{\"funId\":\"197\",\"btnStr\":\"1\"},{\"funId\":\"203\",\"btnStr\":\"1\"},{\"funId\":\"204\",\"btnStr\":\"1\"},{\"funId\":\"205\",\"btnStr\":\"1\"},{\"funId\":\"206\",\"btnStr\":\"1\"},{\"funId\":\"212\",\"btnStr\":\"1\"},{\"funId\":\"201\",\"btnStr\":\"1,2\"},{\"funId\":\"202\",\"btnStr\":\"1,2\"},{\"funId\":\"40\",\"btnStr\":\"1,2\"},{\"funId\":\"232\",\"btnStr\":\"1,2\"},{\"funId\":\"233\",\"btnStr\":\"1,2\"}]', '0');
INSERT INTO `gw_user_business` VALUES ('38', 'UserRole', '120', '[4]', null, '0');
INSERT INTO `gw_user_business` VALUES ('39', 'UserDepot', '120', '[7][8][9][10][11][12][2][1][3]', null, '0');
INSERT INTO `gw_user_business` VALUES ('40', 'UserCustomer', '120', '[52][48][6][5][2]', null, '0');
INSERT INTO `gw_user_business` VALUES ('68', 'RoleFunctions', '16', '[241][242][41][200][59][209][23][217][218]', '[{\"funId\":\"217\",\"btnStr\":\"1\"},{\"funId\":\"218\",\"btnStr\":\"1\"},{\"funId\":\"241\",\"btnStr\":\"1\"},{\"funId\":\"242\",\"btnStr\":\"1\"},{\"funId\":\"200\",\"btnStr\":\"1,2\"}]', '0');
INSERT INTO `gw_user_business` VALUES ('70', 'RoleFunctions', '20', '[241][33][199][242][41][200][201][202][40][232][233][59][208][209][226][227][228][229][244][22][23][220][240][25][217][218][26][194]', '[{\"funId\":\"22\",\"btnStr\":\"1\"},{\"funId\":\"23\",\"btnStr\":\"1\"},{\"funId\":\"220\",\"btnStr\":\"1\"},{\"funId\":\"240\",\"btnStr\":\"1\"},{\"funId\":\"25\",\"btnStr\":\"1\"},{\"funId\":\"217\",\"btnStr\":\"1\"},{\"funId\":\"218\",\"btnStr\":\"1\"},{\"funId\":\"26\",\"btnStr\":\"1\"},{\"funId\":\"194\",\"btnStr\":\"1\"},{\"funId\":\"241\",\"btnStr\":\"1,2\"},{\"funId\":\"199\",\"btnStr\":\"1,2\"},{\"funId\":\"242\",\"btnStr\":\"2\"}]', '0');
INSERT INTO `gw_user_business` VALUES ('71', 'RoleFunctions', '21', '[33][199][41][200][201][202][40][232][233][59][226][227][228][229][244][22][23][220][240][25][217][218][26]', '[{\"funId\":\"22\",\"btnStr\":\"1\"},{\"funId\":\"23\",\"btnStr\":\"1\"},{\"funId\":\"220\",\"btnStr\":\"1\"},{\"funId\":\"240\",\"btnStr\":\"1\"},{\"funId\":\"26\",\"btnStr\":\"1\"},{\"funId\":\"33\",\"btnStr\":\"1,2\"},{\"funId\":\"199\",\"btnStr\":\"1\"},{\"funId\":\"41\",\"btnStr\":\"1,2\"},{\"funId\":\"201\",\"btnStr\":\"1,2\"},{\"funId\":\"202\",\"btnStr\":\"1,2\"},{\"funId\":\"40\",\"btnStr\":\"1,2\"},{\"funId\":\"232\",\"btnStr\":\"1,2\"},{\"funId\":\"233\",\"btnStr\":\"1,2\"}]', '0');
INSERT INTO `gw_user_business` VALUES ('72', 'RoleFunctions', '22', '[197][203][204][205][206][212][59][207][208][209][226][227][228][229][235][237][244][25][217][218][194][195]', '[{\"funId\":\"194\",\"btnStr\":\"1\"},{\"funId\":\"195\",\"btnStr\":\"1\"},{\"funId\":\"197\",\"btnStr\":\"1\"},{\"funId\":\"203\",\"btnStr\":\"1\"},{\"funId\":\"204\",\"btnStr\":\"1\"},{\"funId\":\"205\",\"btnStr\":\"1\"},{\"funId\":\"206\",\"btnStr\":\"1\"},{\"funId\":\"212\",\"btnStr\":\"1\"}]', '0');
INSERT INTO `gw_user_business` VALUES ('73', 'UserRole', '132', '[16]', null, '0');
INSERT INTO `gw_user_business` VALUES ('74', 'UserRole', '133', '[20]', null, '0');
INSERT INTO `gw_user_business` VALUES ('75', 'UserRole', '134', '[22]', null, '0');
INSERT INTO `gw_user_business` VALUES ('76', 'UserRole', '135', '[21]', null, '0');
INSERT INTO `gw_user_business` VALUES ('77', 'UserRole', '136', '[10]', null, '0');
INSERT INTO `gw_user_business` VALUES ('78', 'RoleFunctions', '23', '[241][242][41][200][59][209][25][217][218]', '[{\"funId\":\"241\",\"btnStr\":\"1\"},{\"funId\":\"242\",\"btnStr\":\"1\"},{\"funId\":\"200\",\"btnStr\":\"1\"}]', '0');
INSERT INTO `gw_user_business` VALUES ('79', 'UserRole', '137', '[23]', null, '0');
