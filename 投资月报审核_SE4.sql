--如果本月没有值，那么取上个月的数值
--2012.5.10修正了如果本月上报的年度计划值为空，那么从年度计划表中取值，否则按照原有的方式取值
WITH THISYEARS AS
 (SELECT 2012 THISYEAR FROM DUAL),
THISMONTHS AS
 (SELECT 11 THISMONTH FROM DUAL),
LASTYEARS AS
 (SELECT 2012 LASTYEAR FROM DUAL),
LASTMONTHS AS
 (SELECT 5 LASTMONTH FROM DUAL),
YEARPLAN AS
 (SELECT SUM(VP.TOTAL_FUND) YP, VP.ORG_NO
    FROM V_PM_ALP_FINAL_PROJECT VP
   WHERE VP.PLAN_YEAR = (SELECT THISYEAR FROM THISYEARS)
   GROUP BY VP.ORG_NO)
SELECT (CASE
         WHEN MB.ORG_NO = 1 OR MB.SORTKEY = 1 THEN
          '1'
         ELSE
          MB.ORG_NO
       END) AS ORG_NO,
       (CASE
         WHEN SORTKEY = 1 AND MB.ORG_NO = 1 THEN
          '总计'
         WHEN SORTKEY = 2 AND MB.ORG_NO = 1 THEN
          '总分部合计'
         WHEN SORTKEY = 3 AND MB.ORG_NO = 1 THEN
          '省市公司合计'
         WHEN SORTKEY = 4 AND MB.ORG_NO = 1 THEN
          '直属单位合计'
         ELSE
          ORGAN_NAME
       END) ORGNAME,
       NVL(NDJH, 0) YEARPLANMONEY,
       NVL(BQ, 0) THISMONTHUSED,
       --DECODE(O.RPT_STATE,'01','-',REGEXP_REPLACE((BQ - SQ), '^\.', '0.')) CHAINNUMBER, --未上报状态做特殊处理
       --赵中斌用
       DECODE(O.RPT_STATE, '01', NULL, BQ - SQ) CHAINNUMBER,
       NVL(LJTZ, 0) TOTALMONEYTHISYEAR,
       NVL(ZBJ, 0) CAPITALMONEY,
       NVL(CBJ, 0) COSTMONEY,
       --DECODE(NDJH,0,'-',REGEXP_REPLACE(ROUND((LJTZ / NDJH) * 100, 2), '^\.', '0.') || '%') AS LJTZWCL,
       --赵中斌用
       TO_NUMBER(DECODE(NDJH, 0, NULL, ROUND((LJTZ / NDJH) * 100, 2))) AS LJTZWCL,
       NVL(O.RETURN_TIMES, 0) RETURNTIMES,
       DECODE(O.RPT_STATE,
              '01',
              '未上报',
              '02',
              '待审核',
              '03',
              '已退回',
              '04',
              '已通过',
              '-') AS TRANSACTSTATE
  FROM (SELECT NVL(SUM(SQ), 0) AS SQ,
               NVL(SUM(T.MONTHPLAN), 0) AS BQ,
               NVL(SUM(T.YEARPLAN), 0) AS NDJH,
               NVL(SUM(LJTZ), 0) AS LJTZ,
               NVL(SUM(T.CAPITAL), 0) AS ZBJ,
               NVL(SUM(T.COSTMONEY), 0) AS CBJ,
               DECODE(GROUPING(SORTKEY), 1, '1', SORTKEY) AS SORTKEY,
               DECODE(GROUPING(ORG_NO), 1, '1', ORG_NO) AS ORG_NO
          FROM (
                --本月
                SELECT O.ORG_NO,
                        0 YEARPLAN,
                        P.THIS_MONTH_FEE MONTHPLAN,
                        0 CAPITAL,
                        0 COSTMONEY,
                        0 LJTZ,
                        0 SQ,
                        P.LJ_TOTAL_FUND TRUE_LJTZ,
                        (CASE
                          WHEN OS.SORT_ORDER < 70 AND OS.ORG_ORDER < 11 THEN
                           2
                          WHEN (OS.SORT_ORDER BETWEEN 20 AND 69) AND
                               OS.ORG_ORDER > 10 THEN
                           3
                          WHEN OS.SORT_ORDER > 69 THEN
                           4
                          ELSE
                           0
                        END) AS SORTKEY
                  FROM PM_IMR_ORG O
                  LEFT JOIN PM_IMR_PROJECT P
                    ON O.MON_ORG_ID = P.MON_ORG_ID
                  LEFT JOIN PM_IMR_ORG_SORTS OS
                    ON O.ORG_NO = OS.ORG_NO
                 WHERE O.RPT_YEAR = (SELECT THISYEAR FROM THISYEARS) --设置为当前年1
                   AND O.RPT_MONTH = (SELECT THISMONTH FROM THISMONTHS)
                   AND O.RPT_STATE IN (2, 3, 4, 5)
                UNION ALL
                --上月
                SELECT O.ORG_NO,
                       0 YEARPLAN,
                       0 MONTHPLAN,
                       0 CAPITAL,
                       0 COSTMONEY,
                       0 LJTZ,
                       NVL(P.THIS_MONTH_FEE, 0) SQ,
                       0 TRUE_LJTZ,
                       (CASE
                         WHEN OS.SORT_ORDER < 70 AND OS.ORG_ORDER < 11 THEN
                          2
                         WHEN (OS.SORT_ORDER BETWEEN 20 AND 69) AND
                              OS.ORG_ORDER > 10 THEN
                          3
                         WHEN OS.SORT_ORDER > 69 THEN
                          4
                         ELSE
                          0
                       END) AS SORTKEY
                  FROM PM_IMR_ORG O
                  LEFT JOIN PM_IMR_PROJECT P
                    ON O.MON_ORG_ID = P.MON_ORG_ID
                  LEFT JOIN PM_IMR_ORG_SORTS OS
                    ON O.ORG_NO = OS.ORG_NO
                 WHERE O.RPT_YEAR = (SELECT LASTYEAR FROM LASTYEARS) --设置为当前年1
                   AND O.RPT_MONTH = (SELECT LASTMONTH FROM LASTMONTHS)
                   AND O.RPT_STATE IN (2, 3, 4, 5)
                UNION ALL
                --取累计投资专用
                SELECT O.ORG_NO,
                       0 YEARPLAN,
                       0 MONTHPLAN,
                       P.LJ_CAPITAL_FUND CAPITAL,
                       P.LJ_COST_FUND COSTMONEY,
                       P.LJ_TOTAL_FUND LJTZ,
                       0 SQ,
                       0 TRUE_LJTZ,
                       (CASE
                         WHEN OS.SORT_ORDER < 70 AND OS.ORG_ORDER < 11 THEN
                          2
                         WHEN (OS.SORT_ORDER BETWEEN 20 AND 69) AND
                              OS.ORG_ORDER > 10 THEN
                          3
                         WHEN OS.SORT_ORDER > 69 THEN
                          4
                         ELSE
                          0
                       END) AS SORTKEY
                  FROM PM_IMR_ORG O
                  LEFT JOIN PM_IMR_PROJECT P
                    ON O.MON_ORG_ID = P.MON_ORG_ID
                  LEFT JOIN PM_IMR_ORG_SORTS OS
                    ON O.ORG_NO = OS.ORG_NO
                 WHERE O.RPT_YEAR = (SELECT THISYEAR FROM THISYEARS) --设置为当前年1
                   AND O.RPT_STATE IN (2, 3, 4, 5)
                   AND O.RPT_MONTH =
                       (SELECT MAX(T.RPT_MONTH)
                          FROM PM_IMR_ORG T
                         WHERE T.RPT_YEAR = (SELECT THISYEAR FROM THISYEARS)
                           AND T.RPT_MONTH <=
                               (SELECT THISMONTH FROM THISMONTHS)
                           AND T.RPT_MONTH >=
                               (SELECT THISMONTH FROM THISMONTHS) - 1
                           AND T.RPT_STATE IN (2, 3, 4, 5))
                UNION ALL
                
                --取年度计划值专用列
                --2012.5.10修正了如果本月上报的年度计划值为空，那么从年度计划表中取值，否则按照原有的方式取值
                SELECT DISTINCT O.ORG_NO,
                                DECODE(THISYP.YEARPLAN,
                                       NULL,
                                       Y.YP,
                                       THISYP.YEARPLAN) YEARPLAN,
                                0 MONTHPLAN,
                                0 CAPITAL,
                                0 COSTMONEY,
                                0 LJTZ,
                                0 SQ,
                                0 TRUE_LJTZ,
                                (CASE
                                  WHEN OS.SORT_ORDER < 70 AND OS.ORG_ORDER < 11 THEN
                                   2
                                  WHEN (OS.SORT_ORDER BETWEEN 20 AND 69) AND
                                       OS.ORG_ORDER > 10 THEN
                                   3
                                  WHEN OS.SORT_ORDER > 69 THEN
                                   4
                                  ELSE
                                   0
                                END) AS SORTKEY
                  FROM PM_IMR_ORG O
                  LEFT JOIN YEARPLAN Y
                    ON O.ORG_NO = Y.ORG_NO
                  LEFT JOIN PM_IMR_ORG_SORTS OS
                    ON O.ORG_NO = OS.ORG_NO
                  LEFT JOIN (SELECT O.ORG_NO, SUM(P.TOTAL_FUND) AS YEARPLAN
                               FROM PM_IMR_PROJECT P
                               LEFT JOIN PM_IMR_ORG O
                                 ON P.MON_ORG_ID = O.MON_ORG_ID
                              WHERE P.RPT_YEAR =
                                    (SELECT THISYEAR FROM THISYEARS)
                                AND P.RPT_MONTH =
                                    (SELECT THISMONTH FROM THISMONTHS)
                              GROUP BY O.ORG_NO) THISYP
                    ON THISYP.ORG_NO = Y.ORG_NO
                 WHERE O.RPT_YEAR = (SELECT THISYEAR FROM THISYEARS) --设置为当前年7
                   AND O.RPT_MONTH <= (SELECT THISMONTH FROM THISMONTHS)) T --设置为当前月（20120329修改，累计完成率的计算方法为当前月及之前的月份的总和）8
         WHERE EXISTS
         (SELECT NULL
                  FROM PM_IMR_ORG S
                 WHERE T.ORG_NO = S.ORG_NO
                   AND S.RPT_YEAR = (SELECT THISYEAR FROM THISYEARS) --设置为当前年7
                   AND S.RPT_MONTH = (SELECT THISMONTH FROM THISMONTHS)) --设置为当前月 8
         GROUP BY ROLLUP(SORTKEY, T.ORG_NO)) MB
--并上退回次数和状态
  LEFT JOIN (SELECT TO_CHAR(O.RETURN_TIMES) AS RETURN_TIMES,
                    TO_CHAR(O.RPT_STATE) AS RPT_STATE,
                    O.ORG_NO
               FROM PM_IMR_ORG O
              WHERE O.RPT_YEAR = (SELECT THISYEAR FROM THISYEARS) --设置为当前年9
                AND O.RPT_MONTH = (SELECT THISMONTH FROM THISMONTHS) --设置为当前月10
             ) O
    ON O.ORG_NO = MB.ORG_NO
--把公司的名字并进来
  LEFT JOIN (SELECT S.ORGAN_CODE, S.SHORT_NAME AS ORGAN_NAME, STRU_ORDER
               FROM V_STRU S
              WHERE (S.ORGAN_TYPE = '1' OR S.ORGAN_TYPE = '13')
                AND S.F_ORGAN_CODE = '100000'
             UNION ALL
             SELECT '1' AS ORGAN_CODE, 'TEMP' AS ORGAN_NAME, 1 AS STRU_ORDER
               FROM DUAL) ORGS
    ON ORGS.ORGAN_CODE = MB.ORG_NO
 ORDER BY MB.SORTKEY, ORGS.STRU_ORDER
