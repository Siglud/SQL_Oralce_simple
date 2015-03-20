SELECT (CASE
         WHEN OS.HS_SHORT_NAME IS NULL AND RS.SORTTYPE = 1 THEN
          '国网'
         WHEN OS.HS_SHORT_NAME IS NULL AND RS.SORTTYPE = 2 THEN
          '网省合计'
         WHEN OS.HS_SHORT_NAME IS NULL AND RS.SORTTYPE = 3 THEN
          '直属单位合计'
         WHEN OS.HS_SHORT_NAME IS NULL AND RS.SORTTYPE = 0 THEN
          '合计'
         ELSE
          OS.HS_SHORT_NAME
       END) ORG_NAME,
       RS.ORG_CODE,RS.PR,RS.TT,RS.PR2006,RS.TT2006,RS.PR2007,RS.TT2007,RS.PR2008,RS.TT2008,RS.PR2009,RS.TT2009,RS.PR2010,RS.TT2010
       --SELECT * 
  FROM (SELECT NVL((CASE
                 WHEN GROUPING(RST.ORG_CODE) = 1 THEN
                  TO_CHAR(SORTTYPE)
                 ELSE
                  NVL2(RST.ORG_CODE, RST.ORG_CODE, 4)
               END),0) ORG_CODE,
               NVL(SORTTYPE, 0) SORTTYPE,
               SUM(PRJCNT) PR,
               SUM(TOTALFUND) TT,
               SUM(DECODE(RST.HSYEAR, 2006, PRJCNT, 0)) PR2006,
               SUM(DECODE(RST.HSYEAR, 2006, TOTALFUND, 0)) TT2006,
               SUM(DECODE(RST.HSYEAR, 2007, PRJCNT, 0)) PR2007,
               SUM(DECODE(RST.HSYEAR, 2007, TOTALFUND, 0)) TT2007,
               SUM(DECODE(RST.HSYEAR, 2008, PRJCNT, 0)) PR2008,
               SUM(DECODE(RST.HSYEAR, 2008, TOTALFUND, 0)) TT2008,
               SUM(DECODE(RST.HSYEAR, 2009, PRJCNT, 0)) PR2009,
               SUM(DECODE(RST.HSYEAR, 2009, TOTALFUND, 0)) TT2009,
               SUM(DECODE(RST.HSYEAR, 2010, PRJCNT, 0)) PR2010,
               SUM(DECODE(RST.HSYEAR, 2010, TOTALFUND, 0)) TT2010
          FROM (SELECT ORG_CODE,
                       (CASE
                         WHEN MAX(HS.ORG_CODE) = 100100 THEN
                          1
                         WHEN MAX(HS.ORG_CODE) < 110000 AND
                              MAX(HS.ORG_CODE) > 100700 THEN
                          3
                         ELSE
                          2
                       END) SORTTYPE,
                       MIN(HS.YEAR) HSYEAR,
                       COUNT(HS.PRJ_NAME) PRJCNT,
                       SUM(NVL(HS.FUND_FIRST, 0)) +
                       SUM(NVL(HS.FUND_SECOND, 0)) +
                       SUM(NVL(HS.FUND_THREE, 0)) + SUM(NVL(HS.FUND_FOUR, 0)) +
                       SUM(NVL(HS.FUND_FIVE, 0)) TOTALFUND
                  FROM PM_PLAN_HS HS
                 GROUP BY (HS.ORG_CODE, HS.YEAR)) RST
         GROUP BY ROLLUP(SORTTYPE, RST.ORG_CODE)) RS
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
 ORDER BY SORTTYPE, OS.SORT_ORDER, OS.ORG_ORDER
