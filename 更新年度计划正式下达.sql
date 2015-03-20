INSERT INTO PM_ALP_RELEASE
  (VER_ID,
   RPT_YEAR,
   RPT_ID,
   VER_NO,
   VER_EXP,
   CREATE_DATE,
   RPT_EMP_NO,
   RPT_TIME,
   ORG_NO,
   ORG_NAME)
  SELECT X.GID AS VER_ID,
         '2012' AS RPT_YEAR,
         I.RPT_ID,
         '1' AS VER_NO,
         '21312312' AS VeR_EXP,
         SYSDATE AS CREATE_DATE,
         I.RPT_EMP_NO,
         I.RPT_TIME,
         I.ORG_NO,
         I.ORG_NAME
    FROM PM_ALP_RPT I, (SELECT SYS_GUID() AS GID FROM DUAL) X
   WHERE I.APP_NO = (SELECT MAX(C.APP_NO) APP_NO
                       FROM PM_ALP_CREATE C
                      WHERE C.PLAN_YEAR = '2012')
     AND I.STATUS_CODE = '04'
     --变更
     AND I.ORG_NO IN (100100);
     
     
     
     
     
     
INSERT INTO PM_ALP_DHT
  (DET_VER_ID,
   VER_ID,
   DETAIL_ID,
   RPT_ID,
   PRJ_CODE,
   EDIT_TYPE_CODE,
   PF_SORT_CODE,
   PT_SORT_CODE,
   INVE_EXP,
   NEXT_INV_FUND,
   REMARK)
  SELECT X.GID AS DET_VER_ID,
         R.VER_ID,
         D.DETAIL_ID,
         D.RPT_ID,
         D.PRJ_CODE,
         D.EDIT_TYPE_CODE,
         D.PF_SORT_CODE,
         D.PT_SORT_CODE,
         D.INVE_EXP,
         D.NEXT_INV_FUND,
         D.Remark
    FROM PM_ALP_RPT_DETAIL D
    LEFT JOIN PM_ALP_RELEASE R
      ON R.RPT_ID = D.RPT_ID, (SELECT SYS_GUID() AS GID FROM DUAL) X
   WHERE EXISTS (SELECT NULL
            FROM PM_ALP_RPT R
           WHERE R.APP_NO = (SELECT MAX(C.APP_NO)
                               FROM PM_ALP_CREATE C
                              WHERE C.PLAN_YEAR = '2012')
             AND R.RPT_ID = D.RPT_ID
             AND R.STATUS_CODE = '04'
             --变更
             AND R.ORG_NO IN (100100))
     AND R.VER_NO = '1'
     AND R.RPT_YEAR = '2012'
     --变更
     AND R.ORG_NO IN (100100);
     
     
     
     
INSERT INTO PM_ALP_FHT
  (FUND_VER_ID,
   VER_ID,
   FUND_ID,
   DETAIL_ID,
   FUND_TYPE,
   INV_DATE,
   TOTAL_FUND,
   CAPITAL_FUND,
   COST_FUND,
   SOFT_FUND,
   HAD_FUND,
   DEVEP_FUND,
   PEFM_FUND,
   OTHER_FUND)
  SELECT X.GID AS FUND_VER_ID,
         D.VER_ID,
         F.FUND_ID,
         F.DETAIL_ID,
         F.FUND_TYPE,
         F.INV_DATE,
         F.TOTAL_FUND,
         F.CAPITAL_FUND,
         F.COST_FUND,
         F.SOFT_FUND,
         F.HAD_FUND,
         F.DEVEP_FUND,
         F.PEFM_FUND,
         F.OTHER_FUND
    FROM PM_ALP_FUND F
    LEFT JOIN PM_ALP_DHT D
      ON F.DETAIL_ID = D.DETAIL_ID
     AND EXISTS (SELECT NULL
            FROM PM_ALP_RELEASE R
           WHERE R.VER_ID = D.VER_ID
             AND R.RPT_YEAR = '2012'
             AND R.VER_NO = '1'
             --变更
             AND R.ORG_NO IN (100100)),
   (SELECT SYS_GUID() AS GID FROM DUAL) X
   WHERE EXISTS (SELECT NULL
            FROM PM_ALP_RPT_DETAIL D
           WHERE D.DETAIL_ID = F.DETAIL_ID
             AND EXISTS (SELECT NULL
                    FROM PM_ALP_RPT R
                   WHERE R.APP_NO =
                         (SELECT MAX(C.APP_NO)
                            FROM PM_ALP_CREATE C
                           WHERE C.PLAN_YEAR = '2012')
                     AND R.RPT_ID = D.RPT_ID
                     AND R.STATUS_CODE = '04'
                     --变更
                     AND R.ORG_NO IN (100100)));
                     
                     
                     
                     
INSERT INTO PM_BUNCH
  (BUNCH_ID,
   BUNCH_NAME,
   BUNCH_NO,
   ORG_NO,
   PRJ_SORT_CODE,
   NATURE_CODE,
   SCALE_CODE,
   PRJ_TYPE_CODE,
   BACKGROUND,
   PRJ_CONTENT,
   PRJ_PURPOSE,
   EXPECT_ACHM,
   PEF_SCOPE,
   PRJ_PLAN,
   INV_COMMENT,
   BUNCH_TIME,
   APP_ORG_NO,
   APP_DEPT_NO,
   PLAN_START_DATE,
   PLAN_END_DATE,
   BUNCH_YEAR,
   VER_ID)
  SELECT sys_guid() AS BUNCH_ID,
         BUNCH_NAME,
         BUNCH_NO,
         ORG_NO,
         PRJ_SORT_CODE,
         NATURE_CODE,
         SCALE_CODE,
         PRJ_TYPE_CODE,
         BACKGROUND,
         PRJ_CONTENT,
         PRJ_PURPOSE,
         EXPECT_ACHM,
         PEF_SCOPE,
         PRJ_PLAN,
         INV_COMMENT,
         BUNCH_TIME,
         APP_ORG_NO,
         APP_DEPT_NO,
         PLAN_START_DATE,
         PLAN_END_DATE,
         '2012' AS BUNCH_YEAR,
         '1' AS VER_ID
    FROM PM_BUNCH I
   WHERE I.VER_ID IS NULL;
   
   
   
   
INSERT INTO PM_BUNCH_DETAIL
  (DETAIL_ID, BUNCH_ID, PRJ_CODE)
  SELECT SYS_GUID(), B2.BUNCH_ID, BD.PRJ_CODE
    FROM (SELECT D.BUNCH_ID,
                 D.PRJ_CODE,
                 B.BUNCH_NAME,
                 B.BUNCH_NO,
                 B.ORG_NO,
                 B.APP_ORG_NO,
                 B.APP_DEPT_NO
            FROM PM_BUNCH B, PM_BUNCH_DETAIL D
           WHERE B.BUNCH_ID = D.BUNCH_ID
             AND B.VER_ID IS NULL) BD
    LEFT JOIN PM_BUNCH B2
      ON BD.BUNCH_NAME = B2.BUNCH_NAME
     AND BD.BUNCH_NO = B2.BUNCH_NO
     AND BD.ORG_NO = B2.ORG_NO
     AND BD.APP_ORG_NO = B2.APP_ORG_NO
     AND BD.APP_DEPT_NO = B2.APP_DEPT_NO
     AND B2.VER_ID = '1'
     AND B2.BUNCH_YEAR = '2012';
