-- V1__init_iot_tables.sql
-- 数据库：iot_v1 （请先创建数据库：CREATE DATABASE IF NOT EXISTS iot_v1 DEFAULT CHARACTER SET utf8mb4;）
-- 表：传感器扩展、联系人、通知额度、报警/通知/状态/配置日志、导入日志、模板、角色区域、阈值日志

SET NAMES utf8mb4;

CREATE TABLE IF NOT EXISTS sensor_extend (
  sensor_id              VARCHAR(32)  NOT NULL COMMENT '传感器唯一标识（IMEI）主键',
  material_code          VARCHAR(64)  DEFAULT NULL COMMENT '物料编码（JTY-GD-TCN2010）',
  installation_location  VARCHAR(255) DEFAULT NULL COMMENT '安装位置',
  area_id                BIGINT       DEFAULT NULL COMMENT '所属区域ID',
  area_name              VARCHAR(64)  DEFAULT NULL COMMENT '所属区域名称',
  iccid                  VARCHAR(32)  DEFAULT NULL COMMENT 'SIM卡ID（Tag0x70）',
  module_version         VARCHAR(64)  DEFAULT NULL COMMENT '通信模组版本（Tag0x67）',
  module_vendor          VARCHAR(32)  DEFAULT NULL COMMENT '模组厂商（Tag0x68）',
  terminal_type          TINYINT      DEFAULT NULL COMMENT '终端类型（Tag0x03）',
  normal_work_interval   INT          DEFAULT NULL COMMENT '正常上报间隔（秒，Tag0x06）',
  emergency_alarm_interval INT        DEFAULT NULL COMMENT '紧急报警间隔（秒，Tag0x08）',
  smoke_threshold        INT          DEFAULT NULL COMMENT '烟雾阈值（%，Tag0x14）',
  temp_upper_limit       TINYINT      DEFAULT NULL COMMENT '温度上限（℃，Tag0x0B）',
  temp_lower_limit       TINYINT      DEFAULT NULL COMMENT '温度下限（℃，Tag0x21）',
  battery_life           VARCHAR(16)  DEFAULT NULL COMMENT '电池寿命',
  protection_level       VARCHAR(8)   DEFAULT NULL COMMENT '防护等级',
  create_time            DATETIME     DEFAULT CURRENT_TIMESTAMP,
  update_time            DATETIME     DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (sensor_id),
  KEY idx_area_id (area_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='传感器扩展信息';

CREATE TABLE IF NOT EXISTS sensor_contact (
  id          BIGINT      NOT NULL AUTO_INCREMENT COMMENT '主键',
  sensor_id   VARCHAR(32) NOT NULL COMMENT '传感器IMEI',
  user_id     BIGINT      DEFAULT NULL COMMENT '联系人用户ID',
  phone       VARCHAR(20) DEFAULT NULL COMMENT '联系电话',
  notify_type TINYINT     DEFAULT NULL COMMENT '通知类型（1语音 2短信）',
  priority    TINYINT     DEFAULT 1 COMMENT '通知优先级（1最高）',
  create_time DATETIME    DEFAULT CURRENT_TIMESTAMP,
  update_time DATETIME    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY idx_sensor_id (sensor_id),
  KEY idx_sensor_priority (sensor_id, priority)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='传感器联系人';

CREATE TABLE IF NOT EXISTS notification_quota (
  id               BIGINT       NOT NULL AUTO_INCREMENT COMMENT '主键',
  sensor_id        VARCHAR(32)  NOT NULL COMMENT '传感器IMEI',
  free_voice_count INT          DEFAULT 10 COMMENT '剩余免费语音条数',
  free_sms_count   INT          DEFAULT 20 COMMENT '剩余免费短信条数',
  balance          DECIMAL(10,2) DEFAULT 0 COMMENT '余额',
  create_time      DATETIME     DEFAULT CURRENT_TIMESTAMP,
  update_time      DATETIME     DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uk_sensor (sensor_id),
  KEY idx_voice (free_voice_count),
  KEY idx_sms (free_sms_count)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='通知额度';

CREATE TABLE IF NOT EXISTS sensor_alarm_log (
  id            BIGINT       NOT NULL AUTO_INCREMENT COMMENT '主键',
  sensor_id     VARCHAR(32)  NOT NULL COMMENT '传感器IMEI',
  alarm_type    TINYINT      NOT NULL COMMENT '报警类型（1火灾 2温度 3低电 4防拆）',
  trigger_tag   TINYINT      DEFAULT NULL COMMENT '触发Tag（0x01/0x02）',
  trigger_value VARCHAR(32)  DEFAULT NULL COMMENT '触发值（如烟雾浓度）',
  alarm_time    DATETIME     NOT NULL COMMENT '报警时间',
  handle_status TINYINT      DEFAULT 0 COMMENT '处理状态（0未处理 1已处理）',
  handle_time   DATETIME     DEFAULT NULL COMMENT '处理时间',
  handle_user   VARCHAR(32)  DEFAULT NULL COMMENT '处理人',
  create_time   DATETIME     DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY idx_sensor (sensor_id),
  KEY idx_alarm_time (alarm_time),
  KEY idx_alarm_type (alarm_type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='传感器报警日志';

CREATE TABLE IF NOT EXISTS notification_log (
  id             BIGINT       NOT NULL AUTO_INCREMENT COMMENT '主键',
  sensor_id      VARCHAR(32)  NOT NULL COMMENT '传感器IMEI',
  notify_type    TINYINT      NOT NULL COMMENT '1语音 2短信',
  receiver       VARCHAR(32)  NOT NULL COMMENT '接收号码',
  send_result    TINYINT      DEFAULT 0 COMMENT '发送结果：0失败 1成功',
  quota_type     VARCHAR(8)   DEFAULT NULL COMMENT 'VOICE/SMS',
  free_used      TINYINT      DEFAULT 0 COMMENT '0免费 1付费',
  quota_used     INT          DEFAULT 1 COMMENT '消耗额度条数',
  send_time      DATETIME     DEFAULT CURRENT_TIMESTAMP COMMENT '发送时间',
  create_time    DATETIME     DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY idx_sensor (sensor_id),
  KEY idx_send_time (send_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='通知日志';

CREATE TABLE IF NOT EXISTS status_log (
  id                  BIGINT       NOT NULL AUTO_INCREMENT COMMENT '主键',
  sensor_id           VARCHAR(32)  NOT NULL COMMENT '传感器IMEI',
  status              VARCHAR(16)  DEFAULT NULL COMMENT '在线/离线/待维护',
  smoke_concentration INT          DEFAULT NULL COMMENT '烟雾浓度',
  temperature         INT          DEFAULT NULL COMMENT '温度值',
  battery             INT          DEFAULT NULL COMMENT '电池电量',
  rsrp                INT          DEFAULT NULL COMMENT 'RSRP',
  send_fail_count     INT          DEFAULT NULL COMMENT '发送失败计数',
  update_time         DATETIME     DEFAULT CURRENT_TIMESTAMP COMMENT '状态变更时间',
  create_time         DATETIME     DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY idx_sensor (sensor_id),
  KEY idx_update_time (update_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='状态变更日志';

CREATE TABLE IF NOT EXISTS config_log (
  id             BIGINT       NOT NULL AUTO_INCREMENT COMMENT '主键',
  sensor_id      VARCHAR(32)  NOT NULL COMMENT '传感器IMEI',
  config_tag     VARCHAR(8)   NOT NULL COMMENT '配置Tag（如0x06/0x14）',
  old_value      VARCHAR(64)  DEFAULT NULL COMMENT '旧值',
  new_value      VARCHAR(64)  DEFAULT NULL COMMENT '新值',
  config_time    DATETIME     DEFAULT CURRENT_TIMESTAMP COMMENT '配置时间',
  confirm_status VARCHAR(16)  DEFAULT 'pending' COMMENT '确认状态（pending/success/failed）',
  create_time    DATETIME     DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY idx_sensor (sensor_id),
  KEY idx_config_time (config_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='配置操作日志';

CREATE TABLE IF NOT EXISTS iot_import_log (
  id            BIGINT       NOT NULL AUTO_INCREMENT COMMENT '主键',
  import_user   VARCHAR(64)  DEFAULT NULL COMMENT '导入人',
  import_time   DATETIME     DEFAULT CURRENT_TIMESTAMP COMMENT '导入时间',
  success_count INT          DEFAULT 0 COMMENT '成功数量',
  fail_count    INT          DEFAULT 0 COMMENT '失败数量',
  fail_reason   TEXT         COMMENT '失败原因',
  file_name     VARCHAR(255) DEFAULT NULL COMMENT '导入文件名',
  create_time   DATETIME     DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY idx_import_time (import_time),
  KEY idx_import_user (import_user)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='导入日志';

CREATE TABLE IF NOT EXISTS sys_notification_template (
  id            BIGINT       NOT NULL AUTO_INCREMENT COMMENT '主键',
  product_id    BIGINT       DEFAULT NULL COMMENT '关联产品ID',
  sign_name     VARCHAR(255) DEFAULT NULL COMMENT '短信签名',
  template_code VARCHAR(255) DEFAULT NULL COMMENT '短信模板CODE',
  template_id   VARCHAR(255) DEFAULT NULL COMMENT '语音模板ID',
  create_time   DATETIME     DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='通知模板';

CREATE TABLE IF NOT EXISTS sys_role_area (
  id       BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键',
  role_id  BIGINT NOT NULL COMMENT '角色ID',
  area_id  BIGINT NOT NULL COMMENT '区域ID',
  PRIMARY KEY (id),
  KEY idx_role_area (role_id, area_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='角色区域关联';

CREATE TABLE IF NOT EXISTS iot_threshold_log (
  id             BIGINT       NOT NULL AUTO_INCREMENT COMMENT '主键',
  sensor_id      VARCHAR(32)  NOT NULL COMMENT '传感器IMEI',
  threshold_type VARCHAR(32)  DEFAULT NULL COMMENT '阈值类型（battery等）',
  old_value      VARCHAR(64)  DEFAULT NULL COMMENT '旧值',
  new_value      VARCHAR(64)  DEFAULT NULL COMMENT '新值',
  operate_user   VARCHAR(64)  DEFAULT NULL COMMENT '操作人',
  operate_time   DATETIME     DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY idx_sensor (sensor_id),
  KEY idx_operate_time (operate_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='阈值调整日志';


