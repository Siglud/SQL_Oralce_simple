SELECT REM.ORG_NAME,
       U.USER_NAME,
       REM.STATUS_CODE,
       REM.RPT_TIME,
       RES.TOT,
       RES.COUNTPRJ,
       REM.ORG_NO,
       REM.REMARK
  FROM (SELECT RAX.ORG_NO,
               RAX.ORG_NAME,
               RAX.RPT_EMP_NO,
               RAX.STATUS_CODE,
               RAX.RPT_TIME,
               RAX.REMARK
          FROM PM_STORE_PREP_ORG RAX
          LEFT JOIN PM_STORE_PREP_INFO RAY
            ON RAX.INFO_ID = RAY.INFO_ID
         WHERE RAY.RPT_YEAR = '2013'
        UNION ALL
        SELECT '0' AS ORG_NO,
        'ºÏ¼Æ' AS ORG_NAME,
        NULL AS RPT_EMP_NO,
        NULL AS STATUS_CODE,
        NULL AS RPT_TIME,
        NULL AS REMARK
        FROM DUAL) REM
  LEFT JOIN (SELECT NVL(ORG.ORG_NO, '0') AS ORG_NO,
                    SUM(RPG.Z_TOTAL_FUND) AS TOT,
                    COUNT(RPG.PRJ_ID) AS COUNTPRJ
               FROM PM_STORE_PREP_PRJ RPG
               LEFT JOIN PM_STORE_PREP_ORG ORG
                 ON RPG.RPT_ID = ORG.RPT_ID
               LEFT JOIN PM_STORE_PREP_INFO INF
                 ON ORG.INFO_ID = INF.INFO_ID
              WHERE INF.RPT_YEAR = '2013'
              GROUP BY ROLLUP(ORG.ORG_NO)) RES
    ON REM.ORG_NO = RES.ORG_NO
    LEFT JOIN V_USERS U ON REM.RPT_EMP_NO = U.USER_ID
    LEFT JOIN PM_IMR_ORG_SORTS S ON REM.ORG_NO = S.ORG_NO
    ORDER BY NVL(S.SORT_ORDER,0),S.ORG_ORDER
