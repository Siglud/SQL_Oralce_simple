--年度计划版本查询主SQL BY HF 20110612
SELECT ORGS.ORGAN_CODE,
       ORGS.ORGAN_NAME,
       NVL(RESS.FIRPRJFUND, 0),
       NVL(RESS.FIRPRJNUM, 0),
       RESS.CT1,
       NVL(RESS.SECPRJFUND, 0),
       NVL(RESS.SECPRJNUM, 0),
       RESS.CT2,
       NVL(RESS.THRPRJFUND, 0),
       NVL(RESS.THRPRJNUM, 0),
       RESS.CT3
  FROM (SELECT S.ORGAN_CODE,
               DECODE(S.SHORT_NAME, '龙江', '黑龙江', S.SHORT_NAME) AS ORGAN_NAME,
               S.STRU_ORDER,
               (CASE
                 WHEN S.ORGAN_CODE = 100100 THEN
                  1
                 WHEN S.ORGAN_TYPE = 1 AND S.ORGAN_CODE != 100100 THEN
                  2
                 WHEN S.ORGAN_TYPE = 13 AND S.ORGAN_CODE != 100100 THEN
                  3
                 ELSE
                  0
               END) ORG_TYPE
          FROM V_STRU S
         WHERE (S.ORGAN_TYPE = '1' OR S.ORGAN_TYPE = '13')
           AND S.F_ORGAN_CODE = '100000'
        UNION ALL
        SELECT '0' ORGAN_CODE,
               '公司合计' ORGAN_NAME,
               0 STRU_ORDER,
               0 ORG_TYPE
          FROM DUAL
        UNION ALL
        SELECT '2' ORGAN_CODE,
               '省市合计' ORGAN_NAME,
               99 STRU_ORDER,
               2 ORG_TYPE
          FROM DUAL
        UNION ALL
        SELECT '3' ORGAN_CODE,
               '直属单位合计' ORGAN_NAME,
               0 STRU_ORDER,
               3 ORG_TYPE
          FROM DUAL) ORGS
  LEFT JOIN (SELECT (CASE
                      WHEN GROUPING(ORG_TYPE) = 1 AND GROUPING(ORG_NO) = 1 THEN
                       '0'
                      WHEN GROUPING(ORG_TYPE) = 0 AND GROUPING(ORG_NO) = 1 THEN
                       TO_CHAR(ORG_TYPE)
                      ELSE
                       ORG_NO
                    END) AS ORGAN_CODE,
                    SUM(DECODE(VERNO, 1, PRJ_NUMBER, 0)) FIRPRJNUM,
                    SUM(DECODE(VERNO, 1, FT, 0)) FIRPRJFUND,
                    MAX(DECODE(VERNO, 1, CREDATE, NULL)) CT1,
                    SUM(DECODE(VERNO, 2, PRJ_NUMBER, 0)) SECPRJNUM,
                    SUM(DECODE(VERNO, 2, FT, 0)) SECPRJFUND,
                    MAX(DECODE(VERNO, 2, CREDATE, NULL)) CT2,
                    SUM(DECODE(VERNO, 3, PRJ_NUMBER, 0)) THRPRJNUM,
                    SUM(DECODE(VERNO, 3, FT, 0)) THRPRJFUND,
                    MAX(DECODE(VERNO, 3, CREDATE, NULL)) CT3
               FROM (SELECT REX.PRJ_NUMBER,
                            RAY.ORG_NO,
                            '1' AS VERNO,
                            REX.FT,
                            (CASE
                              WHEN RAY.ORG_NO = 100100 THEN
                               1
                              WHEN ORG.ORGAN_TYPE = 1 AND RAY.ORG_NO != 100100 THEN
                               2
                              ELSE
                               3
                            END) ORG_TYPE,
                            RAY.CREATE_DATE AS CREDATE
                       FROM (SELECT *
                               FROM PM_ALP_RELEASE RE
                              WHERE RE.RPT_YEAR = 2011
                                AND RE.VER_NO = 1
                                AND RE.STATUS_CODE = 4) RAY
                       LEFT JOIN (SELECT S.ORGAN_CODE, S.ORGAN_TYPE
                                   FROM V_STRU S
                                  WHERE (S.ORGAN_TYPE = '1' OR
                                        S.ORGAN_TYPE = '13')
                                    AND S.F_ORGAN_CODE = '100000') ORG
                         ON RAY.ORG_NO = ORG.ORGAN_CODE
                       LEFT JOIN (SELECT RES.*
                                   FROM (SELECT NVL(COUNT(DISTINCT
                                                          NVL(DB.BUNCH_ID,
                                                              D.PRJ_CODE)),
                                                    0) AS PRJ_NUMBER,
                                                R.ORG_NO,
                                                '1' AS VERNO,
                                                SUM(F.TOTAL_FUND) AS FT,
                                                MAX(R.CREATE_DATE) AS CREDATE
                                           FROM PM_ALP_DHT D
                                           LEFT JOIN PM_ALP_RELEASE R
                                             ON R.VER_ID = D.VER_ID
                                            AND D.RPT_ID = R.RPT_ID
                                           LEFT JOIN PM_ALP_FHT F
                                             ON D.DETAIL_ID = F.DETAIL_ID
                                            AND D.VER_ID = F.VER_ID
                                            AND F.FUND_TYPE = 3
                                           LEFT JOIN (SELECT *
                                                       FROM PM_BUNCH_DETAIL DB
                                                      WHERE EXISTS
                                                      (SELECT NULL
                                                               FROM PM_BUNCH B
                                                              WHERE B.BUNCH_ID =
                                                                    DB.BUNCH_ID
                                                                AND B.VER_ID = '1'
                                                                AND B.BUNCH_YEAR = 2011)) DB
                                             ON DB.PRJ_CODE = D.PRJ_CODE
                                          WHERE R.RPT_YEAR = 2011
                                            AND R.VER_NO = '1'
                                            AND D.EDIT_TYPE_CODE = 02
                                          GROUP BY R.ORG_NO) RES) REX
                         ON REX.ORG_NO = RAY.ORG_NO
                     UNION ALL
                     SELECT REX.PRJ_NUMBER,
                            RAY.ORG_NO,
                            '2' AS VERNO,
                            REX.FT,
                            (CASE
                              WHEN RAY.ORG_NO = 100100 THEN
                               1
                              WHEN ORG.ORGAN_TYPE = 1 AND RAY.ORG_NO != 100100 THEN
                               2
                              ELSE
                               3
                            END) ORG_TYPE,
                            RAY.CREATE_DATE AS CREDATE
                       FROM (SELECT *
                               FROM PM_ALP_RELEASE RE
                              WHERE RE.RPT_YEAR = 2011
                                AND RE.VER_NO = 2
                                AND RE.STATUS_CODE = 4) RAY
                       LEFT JOIN (SELECT S.ORGAN_CODE, S.ORGAN_TYPE
                                    FROM V_STRU S
                                   WHERE (S.ORGAN_TYPE = '1' OR
                                         S.ORGAN_TYPE = '13')
                                     AND S.F_ORGAN_CODE = '100000') ORG
                         ON RAY.ORG_NO = ORG.ORGAN_CODE
                       LEFT JOIN (SELECT RES.*
                                    FROM (SELECT NVL(COUNT(DISTINCT
                                                           NVL(DB.BUNCH_ID,
                                                               D.PRJ_CODE)),
                                                     0) AS PRJ_NUMBER,
                                                 R.ORG_NO,
                                                 '2' AS VERNO,
                                                 SUM(F.TOTAL_FUND) AS FT,
                                                 MAX(R.CREATE_DATE) AS CREDATE
                                            FROM PM_ALP_DHT D
                                            LEFT JOIN PM_ALP_RELEASE R
                                              ON R.VER_ID = D.VER_ID
                                             AND D.RPT_ID = R.RPT_ID
                                            LEFT JOIN PM_ALP_FHT F
                                              ON D.DETAIL_ID = F.DETAIL_ID
                                             AND D.VER_ID = F.VER_ID
                                             AND F.FUND_TYPE = 3
                                            LEFT JOIN (SELECT *
                                                        FROM PM_BUNCH_DETAIL DB
                                                       WHERE EXISTS
                                                       (SELECT NULL
                                                                FROM PM_BUNCH B
                                                               WHERE B.BUNCH_ID =
                                                                     DB.BUNCH_ID
                                                                 AND B.VER_ID = '2'
                                                                 AND B.BUNCH_YEAR = 2011)) DB
                                              ON DB.PRJ_CODE = D.PRJ_CODE
                                           WHERE R.RPT_YEAR = 2011
                                             AND R.VER_NO = '2'
                                             AND D.EDIT_TYPE_CODE = 02
                                           GROUP BY R.ORG_NO) RES) REX
                         ON REX.ORG_NO = RAY.ORG_NO
                     UNION ALL
                     SELECT REX.PRJ_NUMBER,
                            RAY.ORG_NO,
                            '3' AS VERNO,
                            REX.FT,
                            (CASE
                              WHEN RAY.ORG_NO = 100100 THEN
                               1
                              WHEN ORG.ORGAN_TYPE = 1 AND RAY.ORG_NO != 100100 THEN
                               2
                              ELSE
                               3
                            END) ORG_TYPE,
                            RAY.CREATE_DATE AS CREDATE
                       FROM (SELECT *
                               FROM PM_ALP_RELEASE RE
                              WHERE RE.RPT_YEAR = 2011
                                AND RE.VER_NO = 3
                                AND RE.STATUS_CODE = 4) RAY
                       LEFT JOIN (SELECT S.ORGAN_CODE, S.ORGAN_TYPE
                                    FROM V_STRU S
                                   WHERE (S.ORGAN_TYPE = '1' OR
                                         S.ORGAN_TYPE = '13')
                                     AND S.F_ORGAN_CODE = '100000') ORG
                         ON RAY.ORG_NO = ORG.ORGAN_CODE
                       LEFT JOIN (SELECT RES.*
                                    FROM (SELECT NVL(COUNT(DISTINCT
                                                           NVL(DB.BUNCH_ID,
                                                               D.PRJ_CODE)),
                                                     0) AS PRJ_NUMBER,
                                                 R.ORG_NO,
                                                 '3' AS VERNO,
                                                 SUM(F.TOTAL_FUND) AS FT,
                                                 MAX(R.CREATE_DATE) AS CREDATE
                                            FROM PM_ALP_DHT D
                                            LEFT JOIN PM_ALP_RELEASE R
                                              ON R.VER_ID = D.VER_ID
                                             AND D.RPT_ID = R.RPT_ID
                                            LEFT JOIN PM_ALP_FHT F
                                              ON D.DETAIL_ID = F.DETAIL_ID
                                             AND D.VER_ID = F.VER_ID
                                             AND F.FUND_TYPE = 3
                                            LEFT JOIN (SELECT *
                                                        FROM PM_BUNCH_DETAIL DB
                                                       WHERE EXISTS
                                                       (SELECT NULL
                                                                FROM PM_BUNCH B
                                                               WHERE B.BUNCH_ID =
                                                                     DB.BUNCH_ID
                                                                 AND B.VER_ID = '3'
                                                                 AND B.BUNCH_YEAR = 2011)) DB
                                              ON DB.PRJ_CODE = D.PRJ_CODE
                                           WHERE R.RPT_YEAR = 2011
                                             AND R.VER_NO = '3'
                                             AND D.EDIT_TYPE_CODE = 02
                                           GROUP BY R.ORG_NO) RES) REX
                         ON REX.ORG_NO = RAY.ORG_NO)
              GROUP BY ROLLUP(ORG_TYPE, ORG_NO)) RESS
    ON ORGS.ORGAN_CODE = RESS.ORGAN_CODE
--WHERE ORGS.ORGAN_CODE = 115100
 ORDER BY ORGS.ORG_TYPE, ORGS.STRU_ORDER
