INSERT INTO PM_BASE_INFO (PRJ_ID,PRJ_CODE,
       PRJ_NAME,
       APP_ORG_NO,
       APP_DEPT_NO,
       APP_EMP_NO,
       APP_DATE,
       BLG_ORG_NO,
       PLAN_START_DATE,
       PLAN_END_DATE,
       PROMOTE_FLAG,
       PROMOTE_PRJ_ID,
       PRJ_SORT_CODE,
       PRJ_NATURE_CODE,
       PRJ_SCALE_CODE,
       PRJ_TYPE_CODE,
       DEV_FLAG,
       PEF_FLAG,
       DEPLOY_MODE,
       REF_PRJ_ID,
       PRJ_BACKGROUND,
       PRJ_CONTENT,
       PRJ_PURPOSE,
       EXPECT_ACHM,
       PEF_SCOPE,
       PRJ_PLAN,
       VALID_FLAG,
       REMARK,
       DEPT_NAME,
       CONTACT_NAME)
SELECT AD.ADVICE_ID,
       PRJ_CODE,
       PRJ_NAME,
       APP_ORG_NO,
       APP_DEPT_NO,
       APP_EMP_NO,
       APP_DATE,
       BLG_ORG_NO,
       PLAN_START_DATE,
       PLAN_END_DATE,
       PROMOTE_FLAG,
       PROMOTE_PRJ_ID,
       PRJ_SORT_CODE,
       PRJ_NATURE_CODE,
       PRJ_SCALE_CODE,
       PRJ_TYPE_CODE,
       DEV_FLAG,
       PEF_FLAG,
       DEPLOY_MODE,
       REF_PRJ_ID,
       PRJ_BACKGROUND,
       PRJ_CONTENT,
       PRJ_PURPOSE,
       EXPECT_ACHM,
       PEF_SCOPE,
       PRJ_PLAN,
       VALID_FLAG,
       REMARK,
       DEPT_NAME,
       CONTACT_NAME
  FROM PM_ADVICE AD
 WHERE AD.PRJ_CODE IN ('711001112075', '711001112076', '711001112082')
   AND AD.PROMOTE_FLAG = '0'
   AND AD.VALID_FLAG = '1'
   AND NOT EXISTS (SELECT NULL FROM PM_BASE_INFO INF WHERE INF.PRJ_CODE = AD.PRJ_CODE)
UNION ALL
SELECT RE.RES_ID,
       PRJ_CODE,
       PRJ_NAME,
       APP_ORG_NO,
       APP_DEPT_NO,
       APP_EMP_NO,
       APP_DATE,
       BLG_ORG_NO,
       PLAN_START_DATE,
       PLAN_END_DATE,
       PROMOTE_FLAG,
       PROMOTE_PRJ_ID,
       PRJ_SORT_CODE,
       PRJ_NATURE_CODE,
       PRJ_SCALE_CODE,
       PRJ_TYPE_CODE,
       DEV_FLAG,
       PEF_FLAG,
       DEPLOY_MODE,
       REF_PRJ_ID,
       PRJ_BACKGROUND,
       PRJ_CONTENT,
       PRJ_PURPOSE,
       EXPECT_ACHM,
       PEF_SCOPE,
       PRJ_PLAN,
       VALID_FLAG,
       REMARK,
       DEPT_NAME,
       CONTACT_NAME
  FROM PM_RESEARCH RE
 WHERE RE.PRJ_CODE IN ('711001112075', '711001112076', '711001112082')
   AND RE.PROMOTE_FLAG = '1'
   AND RE.VALID_FLAG = '1'
   AND NOT EXISTS (SELECT NULL FROM PM_BASE_INFO INF WHERE INF.PRJ_CODE = RE.PRJ_CODE)
