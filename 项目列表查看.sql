--项目列表查看 BY H.F 20100614
SELECT RS.PRJCODE,
       RS.IS_BUNCH,
       DECODE(RS.IS_BUNCH, 1, B2.BUNCH_NAME, INF.PRJ_NAME) PRJNAME,
       C3.NAME,
       C2.NAME,
       C1.NAME,
       JHHJ,
       JHZBJ,
       JHCBJ,
       ZTRHJ,
       ZTRZBJ,
       ZTRCBJ,
       YWCHJ,
       YWCZBJ,
       YWCCBJ,
       B2.BUNCH_ID
  FROM (SELECT DECODE(DB.PRJ_CODE, NULL, D.PRJ_CODE, B.BUNCH_NO) PRJCODE,
               DECODE(COUNT(B.BUNCH_NO), 0, 0, 1) IS_BUNCH,
               SUM(F3.TOTAL_FUND) JHHJ,
               SUM(F3.COST_FUND) JHZBJ,
               SUM(F3.CAPITAL_FUND) JHCBJ,
               SUM(F1.TOTAL_FUND) ZTRHJ,
               SUM(F1.COST_FUND) ZTRZBJ,
               SUM(F1.CAPITAL_FUND) ZTRCBJ,
               SUM(F2.TOTAL_FUND) YWCHJ,
               SUM(F2.COST_FUND) YWCZBJ,
               SUM(F2.CAPITAL_FUND) YWCCBJ
          FROM PM_ALP_DHT D
          LEFT JOIN PM_ALP_RELEASE R
            ON R.VER_ID = D.VER_ID
           AND D.RPT_ID = R.RPT_ID
           AND D.EDIT_TYPE_CODE = 02
          LEFT JOIN (SELECT *
                      FROM PM_BUNCH_DETAIL DB
                     WHERE EXISTS (SELECT NULL
                              FROM PM_BUNCH B
                             WHERE B.BUNCH_ID = DB.BUNCH_ID
                               AND B.VER_ID = '1'
                               AND B.BUNCH_YEAR = 2010)) DB
            ON DB.PRJ_CODE = D.PRJ_CODE
          LEFT JOIN PM_BUNCH B
            ON DB.BUNCH_ID = B.BUNCH_ID
           AND B.VER_ID = 1
           AND B.BUNCH_YEAR = 2010
          LEFT JOIN PM_ALP_FHT F1
            ON D.DETAIL_ID = F1.DETAIL_ID
           AND D.VER_ID = F1.VER_ID
           AND F1.FUND_TYPE = 01
          LEFT JOIN PM_ALP_FHT F2
            ON D.DETAIL_ID = F2.DETAIL_ID
           AND D.VER_ID = F2.VER_ID
           AND F2.FUND_TYPE = 02
          LEFT JOIN PM_ALP_FHT F3
            ON D.DETAIL_ID = F3.DETAIL_ID
           AND D.VER_ID = F3.VER_ID
           AND F3.FUND_TYPE = 03
         WHERE R.RPT_YEAR = 2010
           AND R.VER_NO = 1
           --此处输入单位
           AND R.ORG_NO = '100100'
         GROUP BY DECODE(DB.PRJ_CODE, NULL, D.PRJ_CODE, B.BUNCH_NO)) RS
  LEFT JOIN PM_BUNCH B2
    ON RS.IS_BUNCH = 1
   AND B2.BUNCH_YEAR = 2010
   AND B2.VER_ID = 1
   AND B2.BUNCH_NO = RS.PRJCODE
--此条连接如果连上RS.IS_BUNCH = 0会导致结果不正常，原因不明
  LEFT JOIN (SELECT *
               FROM PM_ALP_DHT D2
              WHERE EXISTS (SELECT NULL
                       FROM PM_ALP_RELEASE RE2
                      WHERE RE2.VER_ID = D2.VER_ID
                        AND RE2.VER_NO = 1
                        AND RE2.RPT_YEAR = 2010
                        AND RE2.RPT_ID = D2.RPT_ID)) D3
    ON RS.PRJCODE = D3.PRJ_CODE
  LEFT JOIN PM_BASE_INFO INF
    ON RS.IS_BUNCH = 0
   AND INF.PRJ_CODE = RS.PRJCODE
  LEFT JOIN P_CODE C1
    ON D3.PT_SORT_CODE = C1.VALUE
   AND C1.CODE_TYPE = '23000000'
  LEFT JOIN P_CODE C2
    ON (C1.P_CODE = C2.VALUE OR B2.PRJ_SORT_CODE = C2.VALUE)
   AND C2.CODE_TYPE = '23000000'
  LEFT JOIN P_CODE C3
    ON C2.P_CODE = C3.VALUE
   AND C3.CODE_TYPE = '23000000'
   --WHERE DECODE(RS.IS_BUNCH, 1, B2.BUNCH_NAME, INF.PRJ_NAME) = '机房建设'
   ORDER BY C3.VALUE,C2.VALUE,C1.VALUE
