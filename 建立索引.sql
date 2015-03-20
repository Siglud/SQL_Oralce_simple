-- CREATE/RECREATE BUNCH INDEXES
CREATE INDEX SGIRS.PK_BUNCHNO ON SGIRS.PM_BUNCH (BUNCH_NO)
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
CREATE INDEX SGIRS.PK_BUNCHYEAR ON SGIRS.PM_BUNCH (BUNCH_YEAR)
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
CREATE INDEX SGIRS.PK_ORGID ON SGIRS.PM_BUNCH (ORG_NO)
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
CREATE INDEX SGIRS.PK_VERID ON SGIRS.PM_BUNCH (VER_ID)
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

-- CREATE/RECREATE BUNCH_DETAL INDEXES
CREATE INDEX SGIRS.PK_DT_PRJCODE ON SGIRS.PM_BUNCH_DETAIL (PRJ_CODE)
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
CREATE INDEX SGIRS.PK_PM_BUNCH_ID ON SGIRS.PM_BUNCH_DETAIL (BUNCH_ID)
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

-- CREATE/RECREATE P_CODE INDEXES
CREATE INDEX SGIRS.FK_P_CODE_CODE_TYPE ON SGIRS.P_CODE (VALUE, CODE_TYPE)
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
CREATE INDEX SGIRS.PK_P_CODE_ID ON SGIRS.P_CODE (P_CODE)
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
CREATE INDEX SGIRS.PK_P_VALUE ON SGIRS.P_CODE (VALUE)
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
-- CREATE/RECREATE RELEASE INDEXES
CREATE UNIQUE INDEX P_BOTH1 ON SGIRS.PM_ALP_RELEASE (VER_ID, RPT_ID)
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
CREATE INDEX SGIRS.P_BOTH5 ON SGIRS.PM_ALP_RELEASE (RPT_YEAR, ORG_NO)
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
-- CREATE/RECREATE DHT INDEXES
CREATE INDEX SGIRS.P_BOTH2 ON SGIRS.PM_ALP_DHT (VER_ID, RPT_ID)
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
  CREATE UNIQUE INDEX P_BOTH3 ON SGIRS.PM_ALP_DHT (VER_ID, DETAIL_ID)
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
  CREATE INDEX SGIRS.P_PF_SORT ON SGIRS.PM_ALP_DHT (PF_SORT_CODE)
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
  CREATE INDEX SGIRS.P_PT_SORT ON SGIRS.PM_ALP_DHT (PT_SORT_CODE)
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

-- CREATE/RECREATE BASEINFO INDEXES
CREATE INDEX SGIRS.PK_PM_APP_DEPT_NO ON SGIRS.PM_BASE_INFO (APP_DEPT_NO)
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
CREATE INDEX SGIRS.PK_PM_APP_ORG_NO ON SGIRS.PM_BASE_INFO (APP_ORG_NO)
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
CREATE INDEX SGIRS.PK_PM_BLG_ORG_NO ON SGIRS.PM_BASE_INFO (BLG_ORG_NO)
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
CREATE INDEX SGIRS.PK_PM_PLAN_END_DATE ON SGIRS.PM_BASE_INFO (PLAN_END_DATE)
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
CREATE INDEX SGIRS.PK_PM_PLAN_START_DATE ON SGIRS.PM_BASE_INFO (PLAN_START_DATE)
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
CREATE INDEX SGIRS.PK_PM_PRJ_NAME ON SGIRS.PM_BASE_INFO (PRJ_NAME)
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
CREATE UNIQUE INDEX PK_PRJ_CODE ON SGIRS.PM_BASE_INFO (PRJ_CODE)
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
CREATE INDEX SGIRS.PK_PRJ_NATURE_CODE ON SGIRS.PM_BASE_INFO (PRJ_NATURE_CODE)
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

-- CREATE/RECREATE FHT INDEXES
CREATE INDEX SGIRS.PK_BOTH4 ON SGIRS.PM_ALP_FHT (VER_ID, DETAIL_ID)
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
-- CREATE/RECREATE ORGAN INDEXES
CREATE INDEX SGIRS.PK_ORG_CODE ON STBPM.PUB_ORGAN (ORGAN_CODE)
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

-- CREATE/RECREATE CREATE INDEXES
CREATE INDEX SGIRS.PK_CREATE_YEAR ON SGIRS.PM_ALP_CREATE (PLAN_YEAR)
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