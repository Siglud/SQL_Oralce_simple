--�޸Ĺ���Ĺ�˾��Ϣ����Ͷ����������û��ֵ��ȡ���һ����ֵ���·�
WITH THISYEARS AS
 (SELECT 2012 THISYEAR FROM DUAL),
THISMONTHS AS
 (SELECT 12 THISMONTH FROM DUAL),
LASTYEARS AS
 (SELECT 2011 LASTYEAR FROM DUAL),
YEARPLAN AS
 (SELECT SUM(VP.TOTAL_FUND) YP, VP.ORG_NO
    FROM V_PM_ALP_FINAL_PROJECT VP
   WHERE VP.PLAN_YEAR = (SELECT THISYEAR FROM THISYEARS)
   GROUP BY VP.ORG_NO)
SELECT OGG.ORGAN_CODE AS ORG_NO,
       DECODE(OGG.ORGAN_NAME,
              '�����������޹�˾',
              '�����ֲ�',
              '�����������޹�˾',
              '�����ֲ�',
              '���е������޹�˾',
              '���зֲ�',
              '�������޹�˾����',
              '�����ֲ�',
              '�����������޹�˾',
              '�����ֲ�',
              OGG.ORGAN_NAME) AS ORG_NAME,
       NVL(NDJH, 0) YEARPLANMONEY,
       NVL(MB.LJTZ, 0) LJTZ,
       DECODE(MB.NDJH,
              0,
              '-',
              NULL,
              '-',
              REGEXP_REPLACE(ROUND((MB.LJTZ / MB.NDJH) * 100, 2),
                             '^\.',
                             '0.')) COMPLETEPERCENT, --�����
       DECODE(MB.SQ,
              0,
              '-',
              NULL,
              '-',
              REGEXP_REPLACE(ROUND((MB.LJTZ - SQ) / SQ * 100, 2),
                             '^\.',
                             '0.')) CHAINNUMBER, --ͬ��
       NVL(ZBJ, 0) CAPITALMONEY,
       NVL(CBJ, 0) COSTMONEY
  FROM --�ѹ�˾�����ֲ�����
       (SELECT ORGAN_CODE,
               DECODE(ORGAN_NAME,
                      '�����������޹�˾',
                      '�����ֲ�',
                      '�����������޹�˾',
                      '�����ֲ�',
                      '���е������޹�˾',
                      '���зֲ�',
                      '�������޹�˾����',
                      '�����ֲ�',
                      '�����������޹�˾',
                      '�����ֲ�',
                      ORGAN_NAME) AS ORGAN_NAME,
               ORG_NO,
               SORT_ORDER,
               ORG_ORDER
          FROM (SELECT S.ORGAN_CODE, S.ORGAN_NAME AS ORGAN_NAME
                  FROM V_STRU S
                 WHERE (S.ORGAN_TYPE = '1' OR S.ORGAN_TYPE = '13')
                   AND S.F_ORGAN_CODE = '100000') ORGS
        --����������������
          LEFT JOIN (SELECT S.ORG_NO, S.SORT_ORDER, S.ORG_ORDER
                      FROM PM_IMR_ORG_SORTS S) SOS
            ON ORGS.ORGAN_CODE = SOS.ORG_NO
        UNION ALL
        SELECT DISTINCT TO_CHAR(T.SORT_ORDER) AS ORG_CODE,
                        T.SORT_NAME AS ORGAN_NAME,
                        TO_CHAR(T.SORT_ORDER) AS ORG_NO,
                        T.SORT_ORDER AS SORT_ORDER,
                        0 AS ORG_ORDER
          FROM PM_IMR_ORG_SORTS T
        --���뼸���ϼ�ֵ������
        UNION ALL
        SELECT '1' AS ORG_CODE,
               '�ܼ�' AS ORGAN_NAME,
               '1' AS ORG_NO,
               0 AS SORT_ORDER,
               0 AS ORG_ORDER
          FROM DUAL
        UNION ALL
        SELECT '5' AS ORG_CODE,
               '��˾�ϼ�' AS ORGAN_NAME,
               '5' AS ORG_NO,
               5 AS SORT_ORDER,
               0 AS ORG_ORDER
          FROM DUAL
        UNION ALL
        SELECT '8' AS ORG_CODE,
               'ֱ����λ�ϼ�' AS ORGAN_NAME,
               '8' AS ORG_NO,
               65 AS SORT_ORDER,
               0 AS ORG_ORDER
          FROM DUAL
        
        ) OGG
  LEFT JOIN

 (SELECT NVL(SUM(DECODE(T.TIMETAG, 2, T.MONTHPLAN, 0)), 0) AS SQ,
         NVL(SUM(DECODE(T.TIMETAG, 3, T.MONTHPLAN, 0)), 0) AS BQ,
         NVL(SUM(DECODE(T.TIMETAG, 1, T.YEARPLAN, 0)), 0) AS NDJH,
         NVL(SUM(DECODE(T.TIMETAG, 3, T.MONTHPLAN, 0)), 0) AS LJTZ,
         NVL(SUM(DECODE(T.TIMETAG, 3, T.CAPITAL, 0)), 0) AS ZBJ,
         NVL(SUM(DECODE(T.TIMETAG, 3, T.COSTMONEY, 0)), 0) AS CBJ,
         (CASE
           WHEN GROUPING(T.ORG_NO) = 1 AND GROUPING(SO.SORT_ORDER) = 1 AND
                GROUPING(DECODE(SO.SORT_ORDER, 70, 0, 1)) = 1 THEN
            1
           WHEN GROUPING(T.ORG_NO) = 1 AND GROUPING(SO.SORT_ORDER) = 1 AND
                GROUPING(DECODE(SO.SORT_ORDER, 70, 0, 1)) != 1 AND
                DECODE(SO.SORT_ORDER, 70, 0, 1) = 1 THEN
            5
           WHEN GROUPING(T.ORG_NO) = 1 AND GROUPING(SO.SORT_ORDER) = 1 AND
                GROUPING(DECODE(SO.SORT_ORDER, 70, 0, 1)) != 1 AND
                DECODE(SO.SORT_ORDER, 70, 0, 1) = 0 THEN
            8
           WHEN GROUPING(T.ORG_NO) = 1 AND GROUPING(SO.SORT_ORDER) != 1 AND
                GROUPING(DECODE(SO.SORT_ORDER, 70, 0, 1)) != 1 THEN
            SO.SORT_ORDER
           ELSE
            TO_NUMBER(T.ORG_NO)
         END) AS ORG_NO
    FROM (
          --�����             
          SELECT O.ORG_NO,
                  0               YEARPLAN,
                  P.LJ_TOTAL_FUND MONTHPLAN,
                  0               CAPITAL,
                  0               COSTMONEY,
                  2               AS TIMETAG
            FROM PM_IMR_ORG O
            LEFT JOIN PM_IMR_PROJECT P
              ON O.MON_ORG_ID = P.MON_ORG_ID
           WHERE O.RPT_YEAR = (SELECT LASTYEAR FROM LASTYEARS) --����Ϊ����
             AND O.RPT_MONTH <= (SELECT THISMONTH FROM THISMONTHS)
             AND O.RPT_STATE IN (2, 3, 4, 5)
             AND O.RPT_MONTH =
                 (SELECT MAX(T.RPT_MONTH)
                    FROM PM_IMR_ORG T
                   WHERE T.RPT_YEAR = (SELECT LASTYEAR FROM LASTYEARS)
                     AND T.RPT_MONTH <= (SELECT THISMONTH FROM THISMONTHS)
                     AND T.RPT_STATE IN (2, 3, 4, 5))
          UNION ALL
          --ȡ��ȼƻ�ֵר����
          SELECT DISTINCT O.ORG_NO,
                          Y.YP     YEARPLAN,
                          0        MONTHPLAN,
                          0        CAPITAL,
                          0        COSTMONEY,
                          1        AS TIMETAG
            FROM PM_IMR_ORG O
            LEFT JOIN YEARPLAN Y
              ON O.ORG_NO = Y.ORG_NO
           WHERE O.RPT_YEAR = (SELECT THISYEAR FROM THISYEARS)
          UNION ALL
          --�����
          SELECT O.ORG_NO,
                 0                 YEARPLAN,
                 P.LJ_TOTAL_FUND   MONTHPLAN,
                 P.LJ_CAPITAL_FUND CAPITAL,
                 P.LJ_COST_FUND    COSTMONEY,
                 3                 AS TIMETAG
            FROM PM_IMR_ORG O
            LEFT JOIN PM_IMR_PROJECT P
              ON O.MON_ORG_ID = P.MON_ORG_ID
           WHERE O.RPT_YEAR = (SELECT THISYEAR FROM THISYEARS) --����Ϊ��ǰ��5
             AND O.RPT_MONTH <= (SELECT THISMONTH FROM THISMONTHS) --����Ϊ��ǰ�£�20120329�޸ģ��ۼ�����ʵļ��㷽��Ϊ��ǰ�¼�֮ǰ���·ݵ��ܺͣ�6
             AND O.RPT_STATE IN (2, 3, 4, 5)
             AND O.RPT_MONTH =
                 (SELECT MAX(T.RPT_MONTH)
                    FROM PM_IMR_ORG T
                   WHERE T.RPT_YEAR = (SELECT THISYEAR FROM THISYEARS)
                     AND T.RPT_MONTH <= (SELECT THISMONTH FROM THISMONTHS)
                     AND T.RPT_STATE IN (2, 3, 4, 5))) T --����Ϊ��ǰ��
    LEFT JOIN PM_IMR_ORG_SORTS SO
      ON SO.ORG_NO = T.ORG_NO
   GROUP BY ROLLUP(DECODE(SO.SORT_ORDER, 70, 0, 1), SO.SORT_ORDER, T.ORG_NO)) MB
    ON OGG.ORGAN_CODE = MB.ORG_NO
 ORDER BY SORT_ORDER, ORG_ORDER
