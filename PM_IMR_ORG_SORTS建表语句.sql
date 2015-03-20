PROMPT PL/SQL DEVELOPER IMPORT FILE
PROMPT CREATED ON 2012年5月3日 BY SIGLUD
SET FEEDBACK OFF
SET DEFINE OFF
PROMPT CREATING PM_IMR_ORG_SORTS...
CREATE TABLE PM_IMR_ORG_SORTS
(
  SORT_ID    VARCHAR2(32) NOT NULL,
  ORG_NO     VARCHAR2(32) NOT NULL,
  SORT_ORDER NUMBER DEFAULT 0 NOT NULL,
  SORT_NAME  VARCHAR2(50) NOT NULL,
  ORG_ORDER  NUMBER DEFAULT 0 NOT NULL,
  ORG_NAME   VARCHAR2(50) NOT NULL
)
TABLESPACE USR_IRS_TBS
  PCTFREE 10
  INITRANS 1
  MAXTRANS 255
  STORAGE
  (
    INITIAL 64K
    MINEXTENTS 1
    MAXEXTENTS UNLIMITED
  );
COMMENT ON TABLE PM_IMR_ORG_SORTS
  IS '单位分地区排序表';
COMMENT ON COLUMN PM_IMR_ORG_SORTS.SORT_ID
  IS '主键';
COMMENT ON COLUMN PM_IMR_ORG_SORTS.ORG_NO
  IS '单位ID';
COMMENT ON COLUMN PM_IMR_ORG_SORTS.SORT_ORDER
  IS '分类排序字段';
COMMENT ON COLUMN PM_IMR_ORG_SORTS.SORT_NAME
  IS '分类名';
COMMENT ON COLUMN PM_IMR_ORG_SORTS.ORG_ORDER
  IS '单位排序字段';
COMMENT ON COLUMN PM_IMR_ORG_SORTS.ORG_NAME
  IS '单位名称';
CREATE UNIQUE INDEX ORG_NO ON PM_IMR_ORG_SORTS (ORG_NO)
  TABLESPACE USR_IRS_TBS
  PCTFREE 10
  INITRANS 2
  MAXTRANS 255
  STORAGE
  (
    INITIAL 64K
    MINEXTENTS 1
    MAXEXTENTS UNLIMITED
  );
CREATE INDEX ORG_ORDER ON PM_IMR_ORG_SORTS (ORG_ORDER)
  TABLESPACE USR_IRS_TBS
  PCTFREE 10
  INITRANS 2
  MAXTRANS 255
  STORAGE
  (
    INITIAL 64K
    MINEXTENTS 1
    MAXEXTENTS UNLIMITED
  );
CREATE INDEX SORT_ORDER ON PM_IMR_ORG_SORTS (SORT_ORDER)
  TABLESPACE USR_IRS_TBS
  PCTFREE 10
  INITRANS 2
  MAXTRANS 255
  STORAGE
  (
    INITIAL 64K
    MINEXTENTS 1
    MAXEXTENTS UNLIMITED
  );
ALTER TABLE PM_IMR_ORG_SORTS
  ADD CONSTRAINT SORT_ID PRIMARY KEY (SORT_ID)
  USING INDEX 
  TABLESPACE USR_IRS_TBS
  PCTFREE 10
  INITRANS 2
  MAXTRANS 255
  STORAGE
  (
    INITIAL 64K
    MINEXTENTS 1
    MAXEXTENTS UNLIMITED
  );

PROMPT DISABLING TRIGGERS FOR PM_IMR_ORG_SORTS...
ALTER TABLE PM_IMR_ORG_SORTS DISABLE ALL TRIGGERS;
PROMPT TRUNCATING PM_IMR_ORG_SORTS...
TRUNCATE TABLE PM_IMR_ORG_SORTS;
PROMPT LOADING PM_IMR_ORG_SORTS...
INSERT INTO PM_IMR_ORG_SORTS (SORT_ID, ORG_NO, SORT_ORDER, SORT_NAME, ORG_ORDER, ORG_NAME)
VALUES ('100100', '100100', 10, '公司总部', 1, '国家电网公司总部');
INSERT INTO PM_IMR_ORG_SORTS (SORT_ID, ORG_NO, SORT_ORDER, SORT_NAME, ORG_ORDER, ORG_NAME)
VALUES ('110000', '110000', 20, '华北电网', 20, '北京市电力公司');
INSERT INTO PM_IMR_ORG_SORTS (SORT_ID, ORG_NO, SORT_ORDER, SORT_NAME, ORG_ORDER, ORG_NAME)
VALUES ('103200', '103200', 70, '直属单位', 200, '英大期货有限公司');
INSERT INTO PM_IMR_ORG_SORTS (SORT_ID, ORG_NO, SORT_ORDER, SORT_NAME, ORG_ORDER, ORG_NAME)
VALUES ('102300', '102300', 70, '直属单位', 1, '国网运行分公司');
INSERT INTO PM_IMR_ORG_SORTS (SORT_ID, ORG_NO, SORT_ORDER, SORT_NAME, ORG_ORDER, ORG_NAME)
VALUES ('102400', '102400', 70, '直属单位', 170, '长安保险经纪有限公司');
INSERT INTO PM_IMR_ORG_SORTS (SORT_ID, ORG_NO, SORT_ORDER, SORT_NAME, ORG_ORDER, ORG_NAME)
VALUES ('102500', '102500', 70, '直属单位', 120, '国网能源研究院');
INSERT INTO PM_IMR_ORG_SORTS (SORT_ID, ORG_NO, SORT_ORDER, SORT_NAME, ORG_ORDER, ORG_NAME)
VALUES ('102600', '102600', 70, '直属单位', 180, '英大国际信托有限责任公司');
INSERT INTO PM_IMR_ORG_SORTS (SORT_ID, ORG_NO, SORT_ORDER, SORT_NAME, ORG_ORDER, ORG_NAME)
VALUES ('102700', '102700', 70, '直属单位', 150, '英大泰和财产保险股份有限公司');
INSERT INTO PM_IMR_ORG_SORTS (SORT_ID, ORG_NO, SORT_ORDER, SORT_NAME, ORG_ORDER, ORG_NAME)
VALUES ('100500', '100500', 40, '华中电网', 10, '华中电网有限公司');
INSERT INTO PM_IMR_ORG_SORTS (SORT_ID, ORG_NO, SORT_ORDER, SORT_NAME, ORG_ORDER, ORG_NAME)
VALUES ('101400', '101400', 70, '直属单位', 60, '国网能源开发有限公司');
INSERT INTO PM_IMR_ORG_SORTS (SORT_ID, ORG_NO, SORT_ORDER, SORT_NAME, ORG_ORDER, ORG_NAME)
VALUES ('101500', '101500', 70, '直属单位', 70, '国网信息通信有限公司');
INSERT INTO PM_IMR_ORG_SORTS (SORT_ID, ORG_NO, SORT_ORDER, SORT_NAME, ORG_ORDER, ORG_NAME)
VALUES ('210000', '210000', 50, '东北电网', 20, '辽宁省电力有限公司');
INSERT INTO PM_IMR_ORG_SORTS (SORT_ID, ORG_NO, SORT_ORDER, SORT_NAME, ORG_ORDER, ORG_NAME)
VALUES ('310000', '310000', 30, '华东电网', 20, '上海市电力公司');
INSERT INTO PM_IMR_ORG_SORTS (SORT_ID, ORG_NO, SORT_ORDER, SORT_NAME, ORG_ORDER, ORG_NAME)
VALUES ('510000', '510000', 40, '华中电网', 50, '四川省电力公司');
INSERT INTO PM_IMR_ORG_SORTS (SORT_ID, ORG_NO, SORT_ORDER, SORT_NAME, ORG_ORDER, ORG_NAME)
VALUES ('102200', '102200', 70, '直属单位', 30, '国网直流建设分公司');
INSERT INTO PM_IMR_ORG_SORTS (SORT_ID, ORG_NO, SORT_ORDER, SORT_NAME, ORG_ORDER, ORG_NAME)
VALUES ('101800', '101800', 70, '直属单位', 110, '国网北京经济技术研究院');
INSERT INTO PM_IMR_ORG_SORTS (SORT_ID, ORG_NO, SORT_ORDER, SORT_NAME, ORG_ORDER, ORG_NAME)
VALUES ('610000', '610000', 60, '西北电网', 20, '陕西省电力公司');
INSERT INTO PM_IMR_ORG_SORTS (SORT_ID, ORG_NO, SORT_ORDER, SORT_NAME, ORG_ORDER, ORG_NAME)
VALUES ('102000', '102000', 70, '直属单位', 210, '英大传媒投资集团有限公司');
INSERT INTO PM_IMR_ORG_SORTS (SORT_ID, ORG_NO, SORT_ORDER, SORT_NAME, ORG_ORDER, ORG_NAME)
VALUES ('100700', '100700', 60, '西北电网', 10, '西北电网有限公司');
INSERT INTO PM_IMR_ORG_SORTS (SORT_ID, ORG_NO, SORT_ORDER, SORT_NAME, ORG_ORDER, ORG_NAME)
VALUES ('500000', '500000', 40, '华中电网', 60, '重庆市电力公司');
INSERT INTO PM_IMR_ORG_SORTS (SORT_ID, ORG_NO, SORT_ORDER, SORT_NAME, ORG_ORDER, ORG_NAME)
VALUES ('101900', '101900', 70, '直属单位', 100, '国网电力科学研究院');
INSERT INTO PM_IMR_ORG_SORTS (SORT_ID, ORG_NO, SORT_ORDER, SORT_NAME, ORG_ORDER, ORG_NAME)
VALUES ('150000', '150000', 50, '东北电网', 50, '内蒙古东部电力有限公司');
INSERT INTO PM_IMR_ORG_SORTS (SORT_ID, ORG_NO, SORT_ORDER, SORT_NAME, ORG_ORDER, ORG_NAME)
VALUES ('102900', '102900', 70, '直属单位', 10, '山东鲁能集团有限公司');
INSERT INTO PM_IMR_ORG_SORTS (SORT_ID, ORG_NO, SORT_ORDER, SORT_NAME, ORG_ORDER, ORG_NAME)
VALUES ('103000', '103000', 70, '直属单位', 80, '中国电力技术装备有限公司');
INSERT INTO PM_IMR_ORG_SORTS (SORT_ID, ORG_NO, SORT_ORDER, SORT_NAME, ORG_ORDER, ORG_NAME)
VALUES ('103100', '103100', 70, '直属单位', 160, '英大泰和人寿保险股份有限公司');
INSERT INTO PM_IMR_ORG_SORTS (SORT_ID, ORG_NO, SORT_ORDER, SORT_NAME, ORG_ORDER, ORG_NAME)
VALUES ('340000', '340000', 30, '华东电网', 50, '安徽省电力公司');
INSERT INTO PM_IMR_ORG_SORTS (SORT_ID, ORG_NO, SORT_ORDER, SORT_NAME, ORG_ORDER, ORG_NAME)
VALUES ('102100', '102100', 70, '直属单位', 40, '国网公司交流建设分公司');
INSERT INTO PM_IMR_ORG_SORTS (SORT_ID, ORG_NO, SORT_ORDER, SORT_NAME, ORG_ORDER, ORG_NAME)
VALUES ('230000', '230000', 50, '东北电网', 40, '黑龙江省电力公司');
INSERT INTO PM_IMR_ORG_SORTS (SORT_ID, ORG_NO, SORT_ORDER, SORT_NAME, ORG_ORDER, ORG_NAME)
VALUES ('320000', '320000', 30, '华东电网', 30, '江苏省电力公司');
INSERT INTO PM_IMR_ORG_SORTS (SORT_ID, ORG_NO, SORT_ORDER, SORT_NAME, ORG_ORDER, ORG_NAME)
VALUES ('101300', '101300', 70, '直属单位', 220, '中兴电力实业发展有限公司');
INSERT INTO PM_IMR_ORG_SORTS (SORT_ID, ORG_NO, SORT_ORDER, SORT_NAME, ORG_ORDER, ORG_NAME)
VALUES ('360000', '360000', 40, '华中电网', 40, '江西省电力公司');
INSERT INTO PM_IMR_ORG_SORTS (SORT_ID, ORG_NO, SORT_ORDER, SORT_NAME, ORG_ORDER, ORG_NAME)
VALUES ('100800', '100800', 70, '直属单位', 130, '英大国际控股集团有限公司');
INSERT INTO PM_IMR_ORG_SORTS (SORT_ID, ORG_NO, SORT_ORDER, SORT_NAME, ORG_ORDER, ORG_NAME)
VALUES ('130000', '130000', 20, '华北电网', 40, '河北省电力公司');
INSERT INTO PM_IMR_ORG_SORTS (SORT_ID, ORG_NO, SORT_ORDER, SORT_NAME, ORG_ORDER, ORG_NAME)
VALUES ('420000', '420000', 40, '华中电网', 20, '湖北省电力公司');
INSERT INTO PM_IMR_ORG_SORTS (SORT_ID, ORG_NO, SORT_ORDER, SORT_NAME, ORG_ORDER, ORG_NAME)
VALUES ('350000', '350000', 30, '华东电网', 60, '福建省电力公司');
INSERT INTO PM_IMR_ORG_SORTS (SORT_ID, ORG_NO, SORT_ORDER, SORT_NAME, ORG_ORDER, ORG_NAME)
VALUES ('640000', '640000', 60, '西北电网', 50, '宁夏电力公司');
INSERT INTO PM_IMR_ORG_SORTS (SORT_ID, ORG_NO, SORT_ORDER, SORT_NAME, ORG_ORDER, ORG_NAME)
VALUES ('220000', '220000', 50, '东北电网', 30, '吉林省电力有限公司');
INSERT INTO PM_IMR_ORG_SORTS (SORT_ID, ORG_NO, SORT_ORDER, SORT_NAME, ORG_ORDER, ORG_NAME)
VALUES ('102800', '102800', 70, '直属单位', 50, '国网新源控股有限公司');
INSERT INTO PM_IMR_ORG_SORTS (SORT_ID, ORG_NO, SORT_ORDER, SORT_NAME, ORG_ORDER, ORG_NAME)
VALUES ('100300', '100300', 20, '华北电网', 10, '华北电网有限公司');
INSERT INTO PM_IMR_ORG_SORTS (SORT_ID, ORG_NO, SORT_ORDER, SORT_NAME, ORG_ORDER, ORG_NAME)
VALUES ('101200', '101200', 70, '直属单位', 20, '国家电网国际发展有限公司');
INSERT INTO PM_IMR_ORG_SORTS (SORT_ID, ORG_NO, SORT_ORDER, SORT_NAME, ORG_ORDER, ORG_NAME)
VALUES ('370000', '370000', 20, '华北电网', 60, '山东电力集团公司');
INSERT INTO PM_IMR_ORG_SORTS (SORT_ID, ORG_NO, SORT_ORDER, SORT_NAME, ORG_ORDER, ORG_NAME)
VALUES ('430000', '430000', 40, '华中电网', 20, '湖南省电力公司');
INSERT INTO PM_IMR_ORG_SORTS (SORT_ID, ORG_NO, SORT_ORDER, SORT_NAME, ORG_ORDER, ORG_NAME)
VALUES ('540000', '540000', 60, '西北电网', 70, '西藏电力有限公司');
INSERT INTO PM_IMR_ORG_SORTS (SORT_ID, ORG_NO, SORT_ORDER, SORT_NAME, ORG_ORDER, ORG_NAME)
VALUES ('120000', '120000', 20, '华北电网', 30, '天津市电力公司');
INSERT INTO PM_IMR_ORG_SORTS (SORT_ID, ORG_NO, SORT_ORDER, SORT_NAME, ORG_ORDER, ORG_NAME)
VALUES ('100900', '100900', 70, '直属单位', 190, '英大证券有限责任公司');
INSERT INTO PM_IMR_ORG_SORTS (SORT_ID, ORG_NO, SORT_ORDER, SORT_NAME, ORG_ORDER, ORG_NAME)
VALUES ('101000', '101000', 70, '直属单位', 240, '国家电网技术学院');
INSERT INTO PM_IMR_ORG_SORTS (SORT_ID, ORG_NO, SORT_ORDER, SORT_NAME, ORG_ORDER, ORG_NAME)
VALUES ('101600', '101600', 70, '直属单位', 230, '国家电网公司高级培训中心');
INSERT INTO PM_IMR_ORG_SORTS (SORT_ID, ORG_NO, SORT_ORDER, SORT_NAME, ORG_ORDER, ORG_NAME)
VALUES ('101700', '101700', 70, '直属单位', 90, '中国电力科学研究院');
INSERT INTO PM_IMR_ORG_SORTS (SORT_ID, ORG_NO, SORT_ORDER, SORT_NAME, ORG_ORDER, ORG_NAME)
VALUES ('100400', '100400', 30, '华东电网', 10, '华东电网有限公司');
INSERT INTO PM_IMR_ORG_SORTS (SORT_ID, ORG_NO, SORT_ORDER, SORT_NAME, ORG_ORDER, ORG_NAME)
VALUES ('101100', '101100', 70, '直属单位', 140, '中国电力财务有限公司');
INSERT INTO PM_IMR_ORG_SORTS (SORT_ID, ORG_NO, SORT_ORDER, SORT_NAME, ORG_ORDER, ORG_NAME)
VALUES ('330000', '330000', 30, '华东电网', 40, '浙江省电力公司');
INSERT INTO PM_IMR_ORG_SORTS (SORT_ID, ORG_NO, SORT_ORDER, SORT_NAME, ORG_ORDER, ORG_NAME)
VALUES ('650000', '650000', 60, '西北电网', 60, '新疆电力公司');
INSERT INTO PM_IMR_ORG_SORTS (SORT_ID, ORG_NO, SORT_ORDER, SORT_NAME, ORG_ORDER, ORG_NAME)
VALUES ('630000', '630000', 60, '西北电网', 40, '青海省电力公司');
INSERT INTO PM_IMR_ORG_SORTS (SORT_ID, ORG_NO, SORT_ORDER, SORT_NAME, ORG_ORDER, ORG_NAME)
VALUES ('410000', '410000', 40, '华中电网', 30, '河南省电力公司');
INSERT INTO PM_IMR_ORG_SORTS (SORT_ID, ORG_NO, SORT_ORDER, SORT_NAME, ORG_ORDER, ORG_NAME)
VALUES ('100600', '100600', 50, '东北电网', 10, '东北有限公司电网');
INSERT INTO PM_IMR_ORG_SORTS (SORT_ID, ORG_NO, SORT_ORDER, SORT_NAME, ORG_ORDER, ORG_NAME)
VALUES ('620000', '620000', 60, '西北电网', 30, '甘肃省电力公司');
INSERT INTO PM_IMR_ORG_SORTS (SORT_ID, ORG_NO, SORT_ORDER, SORT_NAME, ORG_ORDER, ORG_NAME)
VALUES ('140000', '140000', 20, '华北电网', 50, '山西省电力公司');
COMMIT;
PROMPT 57 RECORDS LOADED
PROMPT ENABLING TRIGGERS FOR PM_IMR_ORG_SORTS...
ALTER TABLE PM_IMR_ORG_SORTS ENABLE ALL TRIGGERS;
SET FEEDBACK ON
SET DEFINE ON
PROMPT DONE.
