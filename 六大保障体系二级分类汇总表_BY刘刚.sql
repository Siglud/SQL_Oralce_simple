SELECT (CASE
         WHEN PS.UNITS IS NULL AND PS.ORG_CODE = 1 THEN
          '国网'
         WHEN PS.UNITS IS NULL AND PS.ORG_CODE = 2 THEN
          '网省合计'
         WHEN PS.UNITS IS NULL AND PS.ORG_CODE = 3 THEN
          '直属单位合计'
         WHEN PS.UNITS IS NULL AND PS.ORG_CODE = 0 THEN
          '合计'
         ELSE
          PS.UNITS
       END) UNITS,
       PS.SUM1,
       PS.FUND1,
       PS.SUM2,
       PS.FUND2,
       PS.SUM3,
       PS.FUND3,
       PS.SUM4,
       PS.FUND4,
       PS.SUM5,
       PS.FUND5,
       PS.SUM6,
       PS.FUND6
  FROM (SELECT SS.UNITS UNITS,
               NVL((CASE
                     WHEN GROUPING(SS.UNITS) = 1 THEN
                      TO_CHAR(SUMGROUP)
                     ELSE
                      NVL2(SS.UNITS, MAX(SS.ORG_CODE), 4)
                   END),
                   0) ORG_CODE,
               NVL(SS.SUMGROUP, 0) SUMGROUP,
               SUM(SS.SUM1) SUM1,
               SUM(SS.FUND1) FUND1,
               SUM(SS.SUM2) SUM2,
               SUM(SS.FUND2) FUND2,
               SUM(SS.SUM3) SUM3,
               SUM(SS.FUND3) FUND3,
               SUM(SS.SUM4) SUM4,
               SUM(SS.FUND4) FUND4,
               SUM(SS.SUM5) SUM5,
               SUM(SS.FUND5) FUND5,
               SUM(SS.SUM6) SUM6,
               SUM(SS.FUND6) FUND6
          FROM (WITH T1 AS (SELECT T.ORG_CODE,
                                   COUNT(*) AS PRJSUM,
                                   SUM(NVL(T.FUND_FIRST, 0) +
                                       NVL(T.FUND_SECOND, 0) +
                                       NVL(T.FUND_THREE, 0) +
                                       NVL(T.FUND_FOUR, 0) +
                                       NVL(T.FUND_FIVE, 0)) AS PRJFUND
                              FROM PM_PLAN_HS T
                             WHERE T.PRJ_TYPE = '安全防护体系'
                             GROUP BY T.PRJ_TYPE, T.ORG_CODE), T2 AS (SELECT T.ORG_CODE,
                                                                             COUNT(*) AS PRJSUM,
                                                                             SUM(NVL(T.FUND_FIRST,
                                                                                     0) +
                                                                                 NVL(T.FUND_SECOND,
                                                                                     0) +
                                                                                 NVL(T.FUND_THREE,
                                                                                     0) +
                                                                                 NVL(T.FUND_FOUR,
                                                                                     0) +
                                                                                 NVL(T.FUND_FIVE,
                                                                                     0)) AS PRJFUND
                                                                        FROM PM_PLAN_HS T
                                                                       WHERE T.PRJ_TYPE =
                                                                             '标准规范体系'
                                                                       GROUP BY T.PRJ_TYPE,
                                                                                T.ORG_CODE), T3 AS (SELECT T.ORG_CODE,
                                                                                                           COUNT(*) AS PRJSUM,
                                                                                                           SUM(NVL(T.FUND_FIRST,
                                                                                                                   0) +
                                                                                                               NVL(T.FUND_SECOND,
                                                                                                                   0) +
                                                                                                               NVL(T.FUND_THREE,
                                                                                                                   0) +
                                                                                                               NVL(T.FUND_FOUR,
                                                                                                                   0) +
                                                                                                               NVL(T.FUND_FIVE,
                                                                                                                   0)) AS PRJFUND
                                                                                                      FROM PM_PLAN_HS T
                                                                                                     WHERE T.PRJ_TYPE =
                                                                                                           '管理调控体系建设'
                                                                                                     GROUP BY T.PRJ_TYPE,
                                                                                                              T.ORG_CODE), T4 AS (SELECT T.ORG_CODE,
                                                                                                                                         COUNT(*) AS PRJSUM,
                                                                                                                                         SUM(NVL(T.FUND_FIRST,
                                                                                                                                                 0) +
                                                                                                                                             NVL(T.FUND_SECOND,
                                                                                                                                                 0) +
                                                                                                                                             NVL(T.FUND_THREE,
                                                                                                                                                 0) +
                                                                                                                                             NVL(T.FUND_FOUR,
                                                                                                                                                 0) +
                                                                                                                                             NVL(T.FUND_FIVE,
                                                                                                                                                 0)) AS PRJFUND
                                                                                                                                    FROM PM_PLAN_HS T
                                                                                                                                   WHERE T.PRJ_TYPE =
                                                                                                                                         '评价考核体系'
                                                                                                                                   GROUP BY T.PRJ_TYPE,
                                                                                                                                            T.ORG_CODE), T5 AS (SELECT T.ORG_CODE,
                                                                                                                                                                       COUNT(*) AS PRJSUM,
                                                                                                                                                                       SUM(NVL(T.FUND_FIRST,
                                                                                                                                                                               0) +
                                                                                                                                                                           NVL(T.FUND_SECOND,
                                                                                                                                                                               0) +
                                                                                                                                                                           NVL(T.FUND_THREE,
                                                                                                                                                                               0) +
                                                                                                                                                                           NVL(T.FUND_FOUR,
                                                                                                                                                                               0) +
                                                                                                                                                                           NVL(T.FUND_FIVE,
                                                                                                                                                                               0)) AS PRJFUND
                                                                                                                                                                  FROM PM_PLAN_HS T
                                                                                                                                                                 WHERE T.PRJ_TYPE =
                                                                                                                                                                       '技术研究体系'
                                                                                                                                                                 GROUP BY T.PRJ_TYPE,
                                                                                                                                                                          T.ORG_CODE), T6 AS (SELECT T.ORG_CODE,
                                                                                                                                                                                                     COUNT(*) AS PRJSUM,
                                                                                                                                                                                                     SUM(NVL(T.FUND_FIRST,
                                                                                                                                                                                                             0) +
                                                                                                                                                                                                         NVL(T.FUND_SECOND,
                                                                                                                                                                                                             0) +
                                                                                                                                                                                                         NVL(T.FUND_THREE,
                                                                                                                                                                                                             0) +
                                                                                                                                                                                                         NVL(T.FUND_FOUR,
                                                                                                                                                                                                             0) +
                                                                                                                                                                                                         NVL(T.FUND_FIVE,
                                                                                                                                                                                                             0)) AS PRJFUND
                                                                                                                                                                                                FROM PM_PLAN_HS T
                                                                                                                                                                                               WHERE T.PRJ_TYPE =
                                                                                                                                                                                                     '人才队伍体系'
                                                                                                                                                                                               GROUP BY T.PRJ_TYPE,
                                                                                                                                                                                                        T.ORG_CODE)
                 SELECT DISTINCT T.ORG_NAME AS UNITS,
                                 T.ORG_CODE,
                                 (CASE
                                   WHEN T.ORG_CODE <= '100100' THEN
                                    1
                                   WHEN T.ORG_CODE >= '100800' AND
                                        T.ORG_CODE <= '103100' THEN
                                    3
                                   ELSE
                                    2
                                 END) SUMGROUP,
                                 T1.PRJSUM AS SUM1,
                                 T1.PRJFUND AS FUND1,
                                 T2.PRJSUM AS SUM2,
                                 T2.PRJFUND AS FUND2,
                                 T3.PRJSUM AS SUM3,
                                 T3.PRJFUND AS FUND3,
                                 T4.PRJSUM AS SUM4,
                                 T4.PRJFUND AS FUND4,
                                 T5.PRJSUM AS SUM5,
                                 T5.PRJFUND AS FUND5,
                                 T6.PRJSUM AS SUM6,
                                 T6.PRJFUND AS FUND6
                   FROM PM_PLAN_HS T
                   LEFT JOIN T1
                     ON T1.ORG_CODE = T.ORG_CODE
                   LEFT JOIN T2
                     ON T2.ORG_CODE = T.ORG_CODE
                   LEFT JOIN T3
                     ON T3.ORG_CODE = T.ORG_CODE
                   LEFT JOIN T4
                     ON T4.ORG_CODE = T.ORG_CODE
                   LEFT JOIN T5
                     ON T5.ORG_CODE = T.ORG_CODE
                   LEFT JOIN T6
                     ON T6.ORG_CODE = T.ORG_CODE) SS
                  GROUP BY ROLLUP(SS.SUMGROUP, UNITS)
        ) PS
  LEFT JOIN (SELECT S.ORG_NO, S.SORT_ORDER, S.ORG_ORDER
               FROM PM_IMR_ORG_SORTS S
             UNION ALL
             SELECT '0' AS ORG_NO, 0 AS SORT_ORDER, 0 AS ORG_ORDER
               FROM DUAL
             UNION ALL
             SELECT '1' AS ORG_NO, 1 AS SORT_ORDER, 0 AS ORG_ORDER
               FROM DUAL
             UNION ALL
             SELECT '2' AS ORG_NO, 10 AS SORT_ORDER, 0 AS ORG_ORDER
               FROM DUAL
             UNION ALL
             SELECT '3' AS ORG_NO, 70 AS SORT_ORDER, 0 AS ORG_ORDER
               FROM DUAL) OS
    ON PS.ORG_CODE = OS.ORG_NO
 WHERE PS.ORG_CODE != '1'
 ORDER BY PS.SUMGROUP, OS.SORT_ORDER, OS.ORG_ORDER
