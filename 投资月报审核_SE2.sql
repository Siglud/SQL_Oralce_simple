WITH THISYEARS AS (SELECT 2013 THISYEAR FROM DUAL),
THISMONTHS AS (SELECT 1 THISMONTH FROM DUAL),
LASTYEARS AS (SELECT 2012 LASTYEAR FROM DUAL),
LASTMONTHS AS (SELECT 12 LASTMONTH FROM DUAL),
YEARPLAN AS (SELECT SUM(VP.TOTAL_FUND) YP, VP.ORG_NO
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
          '�ܼ�'
         WHEN SORTKEY = 2 AND MB.ORG_NO = 1 THEN
          '�ֲܷ��ϼ�'
         WHEN SORTKEY = 3 AND MB.ORG_NO = 1 THEN
          'ʡ�й�˾�ϼ�'
         WHEN SORTKEY = 4 AND MB.ORG_NO = 1 THEN
          'ֱ����λ�ϼ�'
         ELSE
          ORGAN_NAME
       END) ORGNAME,
       NVL(NDJH, 0) YEARPLANMONEY,
       NVL(BYTZ, 0) THISMONTHUSED,
       DECODE(O.RPT_STATE,'01','-',REGEXP_REPLACE(BQ - SQ),'^\.','0.') CHAINNUMBER,--δ�ϱ�״̬�����⴦��
       NVL(LJTZ, 0) TOTALMONEYTHISYEAR,
       NVL(ZBJ, 0) CAPITALMONEY,
       NVL(CBJ, 0) COSTMONEY,
       DECODE(NDJH, 0, '-', REGEXP_REPLACE(ROUND((LJTZ / NDJH) * 100, 2),'^\.','0.') || '%') AS LJTZWCL,
       NVL(O.RETURN_TIMES, 0) RETURNTIMES,
       DECODE(O.RPT_STATE,
              '01',
              'δ�ϱ�',
              '02',
              '�����',
              '03',
              '���˻�',
              '04',
              '��ͨ��',
              '-') AS TRANSACTSTATE
  FROM (SELECT NVL(SUM(DECODE(T.TIMETAG, 2, T.MONTHPLAN, 0)), 0) AS SQ,
               NVL(SUM(DECODE(T.TIMETAG, 1, T.MONTHPLAN, 0)), 0) AS BQ,
               NVL(SUM(DECODE(T.TIMETAG, 1, T.YEARPLAN,0)), 0) AS NDJH,
               NVL(SUM(DECODE(T.TIMETAG, 1, T.MONTHPLAN, 0)), 0) AS BYTZ,
               NVL(SUM(DECODE(T.TIMETAG, 3, T.MONTHPLAN, 0)), 0) AS LJTZ,
               NVL(SUM(DECODE(T.TIMETAG, 1, T.CAPITAL, 0)), 0) AS ZBJ,
               NVL(SUM(DECODE(T.TIMETAG, 1, T.COSTMONEY, 0)), 0) AS CBJ,
               DECODE(GROUPING(SORTKEY), 1, '1', SORTKEY) AS SORTKEY,
               DECODE(GROUPING(ORG_NO), 1, '1', ORG_NO) AS ORG_NO
          FROM (SELECT O.ORG_NO,
                       0 YEARPLAN,
                       P.THIS_MONTH_FEE MONTHPLAN,
                       P.CAPITAL CAPITAL,
                       P.COST COSTMONEY,
                       1 AS TIMETAG,
                       (CASE
                         WHEN (O.ORG_NO < 100800 AND O.ORG_NO > 100000 AND O.ORG_NO != 100200) THEN
                          2
                         WHEN (O.ORG_NO > 103200 OR O.ORG_NO = 100200) THEN
                          3
                         WHEN (O.ORG_NO > 100700 AND O.ORG_NO < 110000) THEN
                          4
                         ELSE
                          0
                       END) AS SORTKEY
                  FROM PM_IMR_ORG O
                  LEFT JOIN PM_IMR_PROJECT P
                    ON O.MON_ORG_ID = P.MON_ORG_ID
                 WHERE O.RPT_YEAR = (SELECT THISYEAR FROM THISYEARS) --����Ϊ��ǰ��1
                   AND O.RPT_MONTH = (SELECT THISMONTH FROM THISMONTHS) --����Ϊ��ǰ��2
                   AND O.RPT_STATE IN (2,3,4,5)
                UNION ALL
                SELECT O.ORG_NO,
                       0 YEARPLAN,
                       P.THIS_MONTH_FEE MONTHPLAN,
                       P.CAPITAL CAPITAL,
                       P.COST COSTMONEY,
                       2 AS TIMETAG,
                       (CASE
                         WHEN (ORG_NO < 100800 AND ORG_NO > 100000) THEN
                          2
                         WHEN (ORG_NO > 103200 OR ORG_NO = 100200) THEN
                          3
                         WHEN (ORG_NO > 100700 AND ORG_NO < 110000) THEN
                          4
                         ELSE
                          0
                       END) AS SORTKEY
                  FROM PM_IMR_ORG O
                  LEFT JOIN PM_IMR_PROJECT P
                    ON O.MON_ORG_ID = P.MON_ORG_ID
                 WHERE O.RPT_YEAR = (SELECT LASTYEAR FROM LASTYEARS) --����Ϊ����3
                   AND O.RPT_MONTH = (SELECT LASTMONTH FROM LASTMONTHS) --����Ϊ����4
                   AND O.RPT_STATE IN (2,3,4,5)
                UNION ALL
                SELECT O.ORG_NO,
                       0 YEARPLAN,
                       P.THIS_MONTH_FEE MONTHPLAN,
                       P.CAPITAL CAPITAL,
                       P.COST COSTMONEY,
                       3 AS TIMETAG,
                       (CASE
                         WHEN (ORG_NO < 100800 AND ORG_NO > 100000) THEN
                          2
                         WHEN (ORG_NO > 103200 OR ORG_NO = 100200) THEN
                          3
                         WHEN (ORG_NO > 100700 AND ORG_NO < 110000) THEN
                          4
                         ELSE
                          0
                       END) AS SORTKEY
                  FROM PM_IMR_ORG O
                  LEFT JOIN PM_IMR_PROJECT P
                    ON O.MON_ORG_ID = P.MON_ORG_ID
                 WHERE O.RPT_YEAR = (SELECT THISYEAR FROM THISYEARS) --����Ϊ��ǰ��5
                   AND O.RPT_MONTH <= (SELECT THISMONTH FROM THISMONTHS) --����Ϊ��ǰ�£�20120329�޸ģ��ۼ�����ʵļ��㷽��Ϊ��ǰ�¼�֮ǰ���·ݵ��ܺͣ�6
                   AND O.RPT_STATE IN (2,3,4,5)
                   UNION ALL
                  --ȡ��ȼƻ�ֵר����
                 SELECT DISTINCT O.ORG_NO,
                        Y.YP YEARPLAN,
                        0 MONTHPLAN,
                        0 CAPITAL,
                        0 COSTMONEY,
                        1 AS TIMETAG,
                        (CASE
                         WHEN (O.ORG_NO < 100800 AND O.ORG_NO > 100000) THEN
                          2
                         WHEN (O.ORG_NO > 103200 OR O.ORG_NO = 100200) THEN
                          3
                         WHEN (O.ORG_NO > 100700 AND O.ORG_NO < 110000) THEN
                          4
                         ELSE
                          0
                       END) AS SORTKEY
                  FROM PM_IMR_ORG O 
                  LEFT JOIN YEARPLAN Y
                    ON O.ORG_NO = Y.ORG_NO
                    WHERE O.RPT_YEAR = (SELECT THISYEAR FROM THISYEARS) --����Ϊ��ǰ��7
                   AND O.RPT_MONTH <= (SELECT THISMONTH FROM THISMONTHS)) T --����Ϊ��ǰ�£�20120329�޸ģ��ۼ�����ʵļ��㷽��Ϊ��ǰ�¼�֮ǰ���·ݵ��ܺͣ�8
         WHERE EXISTS (SELECT NULL
                  FROM PM_IMR_ORG S
                 WHERE T.ORG_NO = S.ORG_NO
                   AND S.RPT_YEAR = (SELECT THISYEAR FROM THISYEARS) --����Ϊ��ǰ��7
                   AND S.RPT_MONTH = (SELECT THISMONTH FROM THISMONTHS)) --����Ϊ��ǰ�� 8
         GROUP BY ROLLUP(SORTKEY, T.ORG_NO)) MB
--�����˻ش�����״̬
  LEFT JOIN (SELECT TO_CHAR(O.RETURN_TIMES) AS RETURN_TIMES,
                    TO_CHAR(O.RPT_STATE) AS RPT_STATE,
                    O.ORG_NO
               FROM PM_IMR_ORG O
              WHERE O.RPT_YEAR = (SELECT THISYEAR FROM THISYEARS) --����Ϊ��ǰ��9
                AND O.RPT_MONTH = (SELECT THISMONTH FROM THISMONTHS) --����Ϊ��ǰ��10
             ) O
    ON O.ORG_NO = MB.ORG_NO
--�ѹ�˾�����ֲ�����
  LEFT JOIN (SELECT S.ORGAN_CODE, S.SHORT_NAME AS ORGAN_NAME, STRU_ORDER
               FROM V_STRU S
              WHERE (S.ORGAN_TYPE = '1' OR S.ORGAN_TYPE = '13')
                AND S.F_ORGAN_CODE = '100000'
             UNION ALL
             SELECT '1' AS ORGAN_CODE, 'TEMP' AS ORGAN_NAME, 1 AS STRU_ORDER
               FROM DUAL) ORGS
    ON ORGS.ORGAN_CODE = MB.ORG_NO
 ORDER BY MB.SORTKEY, ORGS.STRU_ORDER
