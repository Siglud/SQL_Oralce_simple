--�������û��ֵ����ôȡ�ϸ��µ���ֵ
--2012.5.10��������������ϱ�����ȼƻ�ֵΪ�գ���ô����ȼƻ�����ȡֵ��������ԭ�еķ�ʽȡֵ
--2012.05.11 �����˱���Ͷ�ʵ�ȡֵ
--2012.05.23 �����˵�����ֻ��һ����λ�ϱ���ʱ��������Ϊ���е�λ������ֵ�����±���Ͷ��ֵΪ���������⡣��Ϊ�������δ�ϱ�������ʾΪ0
WITH THISYEARS AS
 (SELECT 2012 THISYEAR FROM DUAL),
THISMONTHS AS
 (SELECT 7 THISMONTH FROM DUAL),
LASTYEARS AS
 (SELECT 2011 LASTYEAR FROM DUAL),
YEARPLAN AS
 (SELECT SUM(F.TOTAL_FUND) YP, R.ORG_NO
  FROM PM_ALP_DHT D
  LEFT JOIN PM_ALP_FHT F
    ON D.VER_ID = F.VER_ID
   AND D.DETAIL_ID = F.DETAIL_ID
   AND F.FUND_TYPE = '03'
  LEFT JOIN PM_ALP_RELEASE R
    ON D.VER_ID = R.VER_ID
   AND D.RPT_ID = R.RPT_ID
 WHERE R.RPT_YEAR = (SELECT THISYEAR FROM THISYEARS)
   AND R.VER_NO = (SELECT MAX(RX78.VER_NO)
                     FROM PM_ALP_RELEASE RX78
                    WHERE RX78.RPT_YEAR = (SELECT THISYEAR FROM THISYEARS))
 GROUP BY R.ORG_NO)
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
         WHEN ORGAN_NAME = '����' THEN
           '������'
         ELSE
          ORGAN_NAME
       END) ORGNAME,
       NVL(NDJH, 0) YEARPLANMONEY,
       DECODE(SQ,0,'-',REGEXP_REPLACE(ROUND(((LJTZ - SQ) / SQ) * 100, 2), '^(-)?\.', '\10.') || '%') AS TBZZ,
       --���б���
       --TO_NUMBER(DECODE(SQ,0,NULL,ROUND(((LJTZ - SQ / SQ) - 1) * 100, 2))) AS LJTZWCL,
       NVL(LJTZ, 0) TOTALMONEYTHISYEAR,
       NVL(ZBJ, 0) CAPITALMONEY,
       NVL(CBJ, 0) COSTMONEY,
       DECODE(NDJH,0,'-',REGEXP_REPLACE(ROUND((LJTZ / NDJH) * 100, 2), '^(-)?\.', '\10.') || '%') AS LJTZWCL,
       --���б���
       --TO_NUMBER(DECODE(NDJH, 0, NULL, ROUND((LJTZ / NDJH) * 100, 2))) AS LJTZWCL,
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
              '-') AS TRANSACTSTATE,LJTZ
  FROM (SELECT NVL(SUM(SQLJTZ), 0) AS SQ,
               NVL(SUM(T.YEARPLAN), 0) AS NDJH,
               NVL(SUM(LJTZ), 0) AS LJTZ,
               NVL(SUM(CAPITAL), 0) AS ZBJ,
               NVL(SUM(COSTMONEY), 0) AS CBJ,
               DECODE(GROUPING(SORTKEY), 1, '1', SORTKEY) AS SORTKEY,
               DECODE(GROUPING(ORG_NO), 1, '1', ORG_NO) AS ORG_NO
          FROM (
                --����
                SELECT O.ORG_NO,
                        0 YEARPLAN,
                        P.CAPITAL_FUND * P.PROCESS / 100 CAPITAL,
                        P.COST_FUND * P.PROCESS / 100 COSTMONEY,
                        P.TOTAL_FUND * P.PROCESS / 100 LJTZ,
                        0 SQLJTZ,
                        (CASE
                          WHEN OS.SORT_ORDER < 70 AND OS.ORG_ORDER < 11 THEN
                           2
                          WHEN (OS.SORT_ORDER BETWEEN 20 AND 69) AND
                               OS.ORG_ORDER > 10 THEN
                           3
                          WHEN OS.SORT_ORDER > 69 THEN
                           4
                          ELSE
                           4
                        END) AS SORTKEY                       
                  FROM PM_IMR_ORG O
                  LEFT JOIN PM_IMR_PROJECT P
                    ON O.MON_ORG_ID = P.MON_ORG_ID
                  LEFT JOIN PM_IMR_ORG_SORTS OS
                    ON O.ORG_NO = OS.ORG_NO
                 WHERE O.RPT_YEAR = (SELECT THISYEAR FROM THISYEARS) --����Ϊ��ǰ��1
                   AND O.RPT_MONTH = (SELECT THISMONTH FROM THISMONTHS)
                   AND O.RPT_STATE IN (2, 3, 4, 5)
                UNION ALL
                --����
                SELECT O.ORG_NO,
                        0 YEARPLAN,
                        0 CAPITAL,
                        0 COSTMONEY,
                        0 LJTZ,
                        P.TOTAL_FUND * P.PROCESS / 100 SQLJTZ,
                        (CASE
                          WHEN OS.SORT_ORDER < 70 AND OS.ORG_ORDER < 11 THEN
                           2
                          WHEN (OS.SORT_ORDER BETWEEN 20 AND 69) AND
                               OS.ORG_ORDER > 10 THEN
                           3
                          WHEN OS.SORT_ORDER > 69 THEN
                           4
                          ELSE
                           4
                        END) AS SORTKEY                       
                  FROM PM_IMR_ORG O
                  LEFT JOIN PM_IMR_PROJECT P
                    ON O.MON_ORG_ID = P.MON_ORG_ID
                  LEFT JOIN PM_IMR_ORG_SORTS OS
                    ON O.ORG_NO = OS.ORG_NO
                 WHERE O.RPT_YEAR = (SELECT LASTYEAR FROM LASTYEARS) --����Ϊ��ǰ��1
                   AND O.RPT_MONTH = (SELECT THISMONTH FROM THISMONTHS)
                   AND O.RPT_STATE IN (2, 3, 4, 5)
                   --������������ݣ��������걾�������Ѿ��ϱ���ʱ��ż��� 20120724 Ӧ����Ҫ��ȡ��
                   --AND EXISTS (SELECT NULL FROM PM_IMR_ORG OX WHERE O.ORG_NO = OX.ORG_NO AND OX.RPT_YEAR = (SELECT THISYEAR FROM THISYEARS) --����Ϊ��ǰ��1
                   --AND OX.RPT_MONTH = (SELECT THISMONTH FROM THISMONTHS)
                   --AND OX.RPT_STATE IN (2, 3, 4, 5))
                UNION ALL
                
                --ȡ��ȼƻ�ֵר����
                --2012.5.10��������������ϱ�����ȼƻ�ֵΪ�գ���ô����ȼƻ�����ȡֵ��������ԭ�еķ�ʽȡֵ
                SELECT DISTINCT O.ORG_NO,
                                DECODE(THISYP.YEARPLAN,
                                       NULL,
                                       Y.YP,
                                       THISYP.YEARPLAN) YEARPLAN,
                                0 CAPITAL,
                                0 COSTMONEY,
                                0 LJTZ,
                                0 SQLJTZ,
                                (CASE
                                  WHEN OS.SORT_ORDER < 70 AND OS.ORG_ORDER < 11 THEN
                                   2
                                  WHEN (OS.SORT_ORDER BETWEEN 20 AND 69) AND
                                       OS.ORG_ORDER > 10 THEN
                                   3
                                  WHEN OS.SORT_ORDER > 69 THEN
                                   4
                                  ELSE
                                   4
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
                    ON THISYP.ORG_NO = O.ORG_NO
                 WHERE O.RPT_YEAR = (SELECT THISYEAR FROM THISYEARS) --����Ϊ��ǰ��7
                   AND O.RPT_MONTH <= (SELECT THISMONTH FROM THISMONTHS)) T --����Ϊ��ǰ�£�20120329�޸ģ��ۼ�����ʵļ��㷽��Ϊ��ǰ�¼�֮ǰ���·ݵ��ܺͣ�8
         WHERE EXISTS
         (SELECT NULL
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
