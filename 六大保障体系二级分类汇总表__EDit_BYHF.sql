SELECT (CASE
         WHEN OS.HS_SHORT_NAME IS NULL AND RS.ORGTYPE = 1 THEN
          '国网'
         WHEN OS.HS_SHORT_NAME IS NULL AND RS.ORGTYPE = 2 THEN
          '网省合计'
         WHEN OS.HS_SHORT_NAME IS NULL AND RS.ORGTYPE = 3 THEN
          '直属单位合计'
         WHEN OS.HS_SHORT_NAME IS NULL AND RS.ORGTYPE = 0 THEN
          '合计'
         ELSE
          OS.HS_SHORT_NAME
       END) ORG_NAME,
       RS.SORT1,
       RS.TZESORT1,
       RS.SORT2,
       RS.TZESORT2,
       RS.SORT3,
       RS.TZESORT3,
       RS.SORT4,
       RS.TZESORT4,
       RS.SORT5,
       RS.TZESORT5,
       RS.SORT6,
       RS.TZESORT6
  FROM (SELECT (CASE
                 WHEN GROUPING(ORG_CODE) = 1 AND GROUPING(ORGTYPE) = 1 THEN
                  '0'
                 WHEN GROUPING(ORG_CODE) = 1 AND GROUPING(ORGTYPE) = 0 THEN
                  TO_CHAR(ORGTYPE)
                 ELSE
                  NVL(HS.ORG_CODE, '0')
               END) ORG_CODE,
               NVL(ORGTYPE, 0) ORGTYPE,
               SUM((CASE
                     WHEN HS.PRJ_TYPE = '安全防护体系' THEN
                      1
                     ELSE
                      0
                   END)) SORT1,
               SUM((CASE
                     WHEN HS.PRJ_TYPE IN ('安全防护体系') THEN
                      NVL(HS.FUND_FIRST, 0) + NVL(HS.FUND_SECOND, 0) +
                      NVL(HS.FUND_THREE, 0) + NVL(HS.FUND_FOUR, 0) +
                      NVL(HS.FUND_FIVE, 0)
                     ELSE
                      0
                   END)) TZESORT1,
               SUM((CASE
                     WHEN HS.PRJ_TYPE IN ('标准规范体系') THEN
                      1
                     ELSE
                      0
                   END)) SORT2,
               SUM((CASE
                     WHEN HS.PRJ_TYPE IN ('标准规范体系') THEN
                      NVL(HS.FUND_FIRST, 0) + NVL(HS.FUND_SECOND, 0) +
                      NVL(HS.FUND_THREE, 0) + NVL(HS.FUND_FOUR, 0) +
                      NVL(HS.FUND_FIVE, 0)
                     ELSE
                      0
                   END)) TZESORT2,
               SUM((CASE
                     WHEN HS.PRJ_TYPE IN ('管理调控体系建设') THEN
                      1
                     ELSE
                      0
                   END)) SORT3,
               SUM((CASE
                     WHEN HS.PRJ_TYPE IN ('管理调控体系建设') THEN
                      NVL(HS.FUND_FIRST, 0) + NVL(HS.FUND_SECOND, 0) +
                      NVL(HS.FUND_THREE, 0) + NVL(HS.FUND_FOUR, 0) +
                      NVL(HS.FUND_FIVE, 0)
                     ELSE
                      0
                   END)) TZESORT3,
               SUM((CASE
                     WHEN HS.PRJ_TYPE IN
                          ('评价考核体系') THEN
                      1
                     ELSE
                      0
                   END)) SORT4,
               
               SUM((CASE
                     WHEN HS.PRJ_TYPE IN
                          ('评价考核体系') THEN
                      NVL(HS.FUND_FIRST, 0) + NVL(HS.FUND_SECOND, 0) +
                      NVL(HS.FUND_THREE, 0) + NVL(HS.FUND_FOUR, 0) +
                      NVL(HS.FUND_FIVE, 0)
                     ELSE
                      0
                   END)) TZESORT4,
                   
               SUM((CASE
                     WHEN HS.PRJ_TYPE IN
                          ('技术研究体系') THEN
                      1
                     ELSE
                      0
                   END)) SORT5,
               
               SUM((CASE
                     WHEN HS.PRJ_TYPE IN
                          ('技术研究体系') THEN
                      NVL(HS.FUND_FIRST, 0) + NVL(HS.FUND_SECOND, 0) +
                      NVL(HS.FUND_THREE, 0) + NVL(HS.FUND_FOUR, 0) +
                      NVL(HS.FUND_FIVE, 0)
                     ELSE
                      0
                   END)) TZESORT5,
                   
               SUM((CASE
                     WHEN HS.PRJ_TYPE IN
                          ('人才队伍体系') THEN
                      1
                     ELSE
                      0
                   END)) SORT6,
               
               SUM((CASE
                     WHEN HS.PRJ_TYPE IN
                          ('人才队伍体系') THEN
                      NVL(HS.FUND_FIRST, 0) + NVL(HS.FUND_SECOND, 0) +
                      NVL(HS.FUND_THREE, 0) + NVL(HS.FUND_FOUR, 0) +
                      NVL(HS.FUND_FIVE, 0)
                     ELSE
                      0
                   END)) TZESORT6
        
          FROM (SELECT H.*,
                       (CASE
                         WHEN H.ORG_CODE = 100100 THEN
                          1
                         WHEN H.ORG_CODE < 110000 AND H.ORG_CODE > 100700 THEN
                          3
                         ELSE
                          2
                       END) ORGTYPE
                  FROM PM_PLAN_HS H WHERE H.PRJ_TYPE IN ('安全防护体系','标准规范体系','管理调控体系建设','评价考核体系','技术研究体系','人才队伍体系')) HS
         GROUP BY ROLLUP(HS.ORGTYPE, HS.ORG_CODE)) RS
  LEFT JOIN PM_PLAN_HS_ORG OS
    ON RS.ORG_CODE = OS.ORG_CODE
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
    ON RS.ORG_CODE = OS.ORG_NO
 WHERE RS.ORG_CODE != '1'
 ORDER BY RS.ORGTYPE, OS.SORT_ORDER, OS.ORG_ORDER
