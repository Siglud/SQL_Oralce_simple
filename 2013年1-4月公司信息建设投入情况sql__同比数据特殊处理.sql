--2012.07.03�޸�����ȼƻ���ȡֵ����Դ����������ͼȡֵ��ȥ���˵���û��ֵ��ȡ���µ�ȡֵ��ʽ
--�޸Ĺ���Ĺ�˾��Ϣ����Ͷ����������û��ֵ��ȡ�ϸ��·ݵ���ֵ
--2012.5.10��������������ϱ�����ȼƻ�ֵΪ�գ���ô����ȼƻ�����ȡֵ��������ԭ�еķ�ʽȡֵ
WITH THISYEARS AS
 (SELECT 2013 THISYEAR FROM DUAL),
THISMONTHS AS
 (SELECT 3 THISMONTH FROM DUAL),
LASTYEARS AS
 (SELECT 2012 LASTYEAR FROM DUAL),
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
              'ֱ����λ',
              'ֱ����λ�ϼ�',
              OGG.ORGAN_NAME) AS ORG_NAME,
       OGG.POINT_CODE,
              
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
               ORG_ORDER,
               POINT_CODE
          FROM (SELECT S.ORGAN_CODE, S.ORGAN_NAME AS ORGAN_NAME
                  FROM V_STRU S
                 WHERE (S.ORGAN_TYPE = '1' OR S.ORGAN_TYPE = '13')
                   AND S.F_ORGAN_CODE = '100000') ORGS
        --����������������
          LEFT JOIN (SELECT S.ORG_NO, S.SORT_ORDER, S.ORG_ORDER, S.POINT_CODE
                      FROM PM_IMR_ORG_SORTS S WHERE S.VERSIONS = 1) SOS
            ON ORGS.ORGAN_CODE = SOS.ORG_NO
        UNION ALL
        SELECT DISTINCT TO_CHAR(T.SORT_ORDER) AS ORG_CODE,
                        T.SORT_NAME AS ORGAN_NAME,
                        TO_CHAR(T.SORT_ORDER) AS ORG_NO,
                        T.SORT_ORDER AS SORT_ORDER,
                        0 AS ORG_ORDER,
                        DECODE(T.SORT_ORDER,20,2,30,3,40,4,50,5,60,6,65,7,70,8,NULL) POINT_CODE
          FROM PM_IMR_ORG_SORTS T
        --���뼸���ϼ�ֵ������
        UNION ALL
        SELECT '1' AS ORG_CODE,
               '��˾�ϼ�' AS ORGAN_NAME,
               '1' AS ORG_NO,
               0 AS SORT_ORDER,
               0 AS ORG_ORDER,
               0 AS POINT_CODE
          FROM DUAL
        UNION ALL
        SELECT '5' AS ORG_CODE,
               '��˾�ϼ�' AS ORGAN_NAME,
               '5' AS ORG_NO,
               5 AS SORT_ORDER,
               0 AS ORG_ORDER,
               0 AS POINT_CODE
          FROM DUAL
        UNION ALL
        SELECT '8' AS ORG_CODE,
               'ֱ����λ�ϼ�' AS ORGAN_NAME,
               '8' AS ORG_NO,
               65 AS SORT_ORDER,
               0 AS ORG_ORDER,
               0 AS POINT_CODE
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
          SELECT O.ORG_ID ORG_NO,
                  0               YEARPLAN,
                  TO_NUMBER(O.INVESTMENT_COUNT) MONTHPLAN,
                  0               CAPITAL,
                  0               COSTMONEY,
                  2               AS TIMETAG
            FROM PM_IMR_CONSTRUCT_ARCHIVE O
           WHERE O.STATISTIC_YEAR = (SELECT LASTYEAR FROM LASTYEARS) --����Ϊ����
             AND O.STATISTIC_MONTH = (SELECT THISMONTH FROM THISMONTHS)
             AND O.ORG_ID > 100000
          UNION ALL
          --ȡ��ȼƻ�ֵר���У�����ȼƻ�����ֱ��ȡ����
          --2012.5.10��������������ϱ�����ȼƻ�ֵΪ�գ���ô����ȼƻ�����ȡֵ��������ԭ�еķ�ʽȡֵ
          SELECT DISTINCT Y.ORG_NO ORG_NO,
                          DECODE(THISYP.YEARPLAN,NULL,Y.YP,THISYP.YEARPLAN)  YEARPLAN,
                          0        MONTHPLAN,
                          0        CAPITAL,
                          0        COSTMONEY,
                          1        AS TIMETAG
            FROM  YEARPLAN Y LEFT JOIN (SELECT O.ORG_NO, SUM(P.TOTAL_FUND) AS YEARPLAN FROM PM_IMR_PROJECT P LEFT JOIN PM_IMR_ORG O ON P.MON_ORG_ID=O.MON_ORG_ID WHERE P.RPT_YEAR = (SELECT THISYEAR FROM THISYEARS) AND P.RPT_MONTH = (SELECT THISMONTH FROM THISMONTHS) GROUP BY O.Org_No) THISYP ON THISYP.ORG_NO = Y.ORG_NO
          UNION ALL
          --�����
          SELECT O.ORG_NO,
                 0                 YEARPLAN,
                 P.TOTAL_FUND * P.PROCESS / 100 MONTHPLAN,
                 P.CAPITAL_FUND * P.PROCESS / 100 CAPITAL,
                 P.COST_FUND * P.PROCESS / 100 COSTMONEY,
                 3                 AS TIMETAG
            FROM PM_IMR_ORG O
            LEFT JOIN PM_IMR_PROJECT P
              ON O.MON_ORG_ID = P.MON_ORG_ID
           WHERE O.RPT_YEAR = (SELECT THISYEAR FROM THISYEARS) --����Ϊ��ǰ��5
             AND O.RPT_STATE IN (2, 3, 4, 5)
             AND O.RPT_MONTH = (SELECT THISMONTH FROM THISMONTHS) ) T --����Ϊ��ǰ��
    LEFT JOIN PM_IMR_ORG_SORTS SO
      ON SO.ORG_NO = T.ORG_NO
   GROUP BY ROLLUP(DECODE(SO.SORT_ORDER, 70, 0, 1), SO.SORT_ORDER, T.ORG_NO)) MB
    ON OGG.ORGAN_CODE = MB.ORG_NO
    WHERE OGG.ORGAN_CODE NOT IN (5,8,10,65)
 ORDER BY SORT_ORDER, ORG_ORDER
