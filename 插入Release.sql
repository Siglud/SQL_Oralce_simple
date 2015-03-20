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
         '1.1' AS VER_NO,
         '测试' AS VeR_EXP,
         SYSDATE AS CREATE_DATE,
         I.RPT_EMP_NO,
         I.RPT_TIME,
         I.ORG_NO,
         I.ORG_NAME
    FROM PM_ALP_RPT I, (SELECT SYS_GUID() AS GID FROM DUAL) X
   WHERE I.APP_NO = (SELECT MAX(C.APP_NO) APP_NO
                       FROM PM_ALP_CREATE C
                      WHERE C.PLAN_YEAR = '2012') AND I.STATUS_CODE = '04'
