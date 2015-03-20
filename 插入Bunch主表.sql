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
         '1.1' AS VER_ID
    FROM PM_BUNCH I
    WHERE I.VER_ID IS NULL;
