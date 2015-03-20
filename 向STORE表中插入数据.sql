INSERT INTO PM_STORE
  (STORE_ID,
   PRJ_CODE,
   IN_DATE,
   GRADE_CODE,
   STATUS_CODE,
   IS_UNI_PROMOTE,
   PRJ_SOURCE,
   PROMOTE_PRJ_ID,
   PRJ_RESP_ORG_NO,
   PRJ_NAME)
  SELECT AD.ADVICE_ID,
         AD.PRJ_CODE,
         SYSDATE,
         '01' AS GRADE_CODE,
         '03' AS STATUS_CODE,
         '0' AS IS_UNI_PROMOTE,
         '1' AS PRJ_SOURCE,
         NULL AS PROMOTE_PRJ_ID,
         AD.DUTY_ORG_NO,
         AD.PRJ_NAME
    FROM PM_ADVICE AD
   WHERE AD.PRJ_CODE IN ('711001112075', '711001112076', '711001112082')
     AND AD.PROMOTE_FLAG = '0'
     AND AD.VALID_FLAG = '1'
  UNION ALL
  SELECT RE.RES_ID,
         RE.PRJ_CODE,
         SYSDATE,
         '01' AS GRADE_CODE,
         '03' AS STATUS_CODE,
         '1' AS IS_UNI_PROMOTE,
         '2' AS PRJ_SOURCE,
         RE.PROMOTE_PRJ_ID AS PROMOTE_PRJ_ID,
         RE.DUTY_ORG_NO,
         RE.PRJ_NAME
    FROM PM_RESEARCH RE
   WHERE RE.PRJ_CODE IN ('711001112075', '711001112076', '711001112082')
   AND RE.PROMOTE_FLAG = '1'
   AND RE.VALID_FLAG = '1'
