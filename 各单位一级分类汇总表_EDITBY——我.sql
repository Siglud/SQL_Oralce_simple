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
       RS.TZESORT4
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
                     WHEN HS.PRJ_TYPE IN ('信息网络',
                                          '数据交换',
                                          '数据中心',
                                          '应用集成',
                                          '企业门户',
                                          '机房及基础设施') THEN
                      1
                     ELSE
                      0
                   END)) SORT1,
               SUM((CASE
                     WHEN HS.PRJ_TYPE IN ('信息网络',
                                          '数据交换',
                                          '数据中心',
                                          '应用集成',
                                          '企业门户',
                                          '机房及基础设施') THEN
                      NVL(HS.FUND_FIRST, 0) + NVL(HS.FUND_SECOND, 0) +
                      NVL(HS.FUND_THREE, 0) + NVL(HS.FUND_FOUR, 0) +
                      NVL(HS.FUND_FIVE, 0)
                     ELSE
                      0
                   END)) TZESORT1,
               SUM((CASE
                     WHEN HS.PRJ_TYPE IN ('成熟套装软件',
                                          '财务（资金）管理',
                                          '营销管理',
                                          '安全生产管理',
                                          '协同办公',
                                          '人力资源管理',
                                          '物资管理',
                                          '项目管理',
                                          '综合管理') THEN
                      1
                     ELSE
                      0
                   END)) SORT2,
               SUM((CASE
                     WHEN HS.PRJ_TYPE IN ('成熟套装软件',
                                          '财务（资金）管理',
                                          '营销管理',
                                          '安全生产管理',
                                          '协同办公',
                                          '人力资源管理',
                                          '物资管理',
                                          '项目管理',
                                          '综合管理') THEN
                      NVL(HS.FUND_FIRST, 0) + NVL(HS.FUND_SECOND, 0) +
                      NVL(HS.FUND_THREE, 0) + NVL(HS.FUND_FOUR, 0) +
                      NVL(HS.FUND_FIVE, 0)
                     ELSE
                      0
                   END)) TZESORT2,
               SUM((CASE
                     WHEN HS.PRJ_TYPE IN ('安全防护体系',
                                          '标准规范体系',
                                          '管理调控体系建设',
                                          '评价考核体系',
                                          '技术研究体系',
                                          '人才队伍体系') THEN
                      1
                     ELSE
                      0
                   END)) SORT3,
               SUM((CASE
                     WHEN HS.PRJ_TYPE IN ('安全防护体系',
                                          '标准规范体系',
                                          '管理调控体系建设',
                                          '评价考核体系',
                                          '技术研究体系',
                                          '人才队伍体系') THEN
                      NVL(HS.FUND_FIRST, 0) + NVL(HS.FUND_SECOND, 0) +
                      NVL(HS.FUND_THREE, 0) + NVL(HS.FUND_FOUR, 0) +
                      NVL(HS.FUND_FIVE, 0)
                     ELSE
                      0
                   END)) TZESORT3,
               SUM((CASE
                     WHEN HS.PRJ_TYPE IN
                          ('软件正版化', '笔记本、PC机、打印机购置', '其他') THEN
                      1
                     ELSE
                      0
                   END)) SORT4,
               
               SUM((CASE
                     WHEN HS.PRJ_TYPE IN
                          ('软件正版化', '笔记本、PC机、打印机购置', '其他') THEN
                      NVL(HS.FUND_FIRST, 0) + NVL(HS.FUND_SECOND, 0) +
                      NVL(HS.FUND_THREE, 0) + NVL(HS.FUND_FOUR, 0) +
                      NVL(HS.FUND_FIVE, 0)
                     ELSE
                      0
                   END)) TZESORT4
        
          FROM (SELECT H.*,
                       (CASE
                         WHEN H.ORG_CODE = 100100 THEN
                          1
                         WHEN H.ORG_CODE < 110000 AND H.ORG_CODE > 100700 THEN
                          3
                         ELSE
                          2
                       END) ORGTYPE
                  FROM PM_PLAN_HS H) HS
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
