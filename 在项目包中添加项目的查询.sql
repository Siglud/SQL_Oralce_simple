SELECT RSLT.PRJ_ID,
       RSLT.PRJ_CODE,
       RSLT.PRJ_NAME,
       RSLT.BUNCH_NAME,
       NVL(PB.TOTAL_FUND, 0) AS INV_AMT,
       (SELECT P1.NAME || '/' || P2.NAME
          FROM P_CODE P1, P_CODE P2
         WHERE P1.CODE_TYPE = P2.CODE_TYPE
           AND P1.VALUE = P2.P_CODE
           AND P2.VALUE = RSLT.PRJ_SORT_CODE
           AND P2.CODE_TYPE = '10100000') AS PRJ_SORT_NAME,
       (SELECT P.NAME
          FROM P_CODE P
         WHERE P.CODE_TYPE = '10200000'
           AND P.VALUE = RSLT.PRJ_NATURE_CODE) AS PRJ_NATURE_NAME,
       (SELECT P.NAME
          FROM P_CODE P
         WHERE P.CODE_TYPE = '10300000'
           AND P.VALUE = RSLT.PRJ_SCALE_CODE) AS PRJ_SCALE_NAME,
       (SELECT P.NAME
          FROM P_CODE P
         WHERE P.CODE_TYPE = '10400000'
           AND P.VALUE = RSLT.PRJ_TYPE_CODE) AS PRJ_TYPE_NAME
  FROM (SELECT B.PRJ_ID,
               B.PRJ_CODE,
               B.PRJ_NAME,
               A.BUNCH_NAME,
               B.PRJ_SORT_CODE,
               B.PRJ_NATURE_CODE,
               B.PRJ_SCALE_CODE,
               B.PRJ_TYPE_CODE
          FROM (SELECT PS.PRJ_CODE,
                       PS.GRADE_CODE,
                       PS.STATUS_CODE,
                       '' AS BUNCH_NAME
                  FROM PM_STORE PS
                 WHERE PS.PRJ_CODE NOT IN	
                       (SELECT D.PRJ_CODE
                          FROM PM_BUNCH_DETAIL D, PM_BUNCH B
                         WHERE B.BUNCH_ID = D.BUNCH_ID
                           AND B.VER_ID IS NULL)
                   AND PS.GRADE_CODE = 02
                   AND PS.STATUS_CODE IN (01, 03)
                UNION
                SELECT PS2.PRJ_CODE,
                       PS2.GRADE_CODE,
                       PS2.STATUS_CODE,
                       '' AS BUNCH_NAME
                  FROM PM_STORE PS2, PM_ALP_RPT_DETAIL ARD
                 WHERE PS2.STATUS_CODE IN (02, 04) AND PS2.PRJ_CODE NOT IN	
                       (SELECT D.PRJ_CODE
                          FROM PM_BUNCH_DETAIL D, PM_BUNCH B
                         WHERE B.BUNCH_ID = D.BUNCH_ID
                           AND B.VER_ID IS NULL)
                   AND PS2.PRJ_CODE = ARD.PRJ_CODE
                   AND PS2.GRADE_CODE = 02) A
          LEFT JOIN PM_BASE_INFO B
            ON B.PRJ_CODE = A.PRJ_CODE
         WHERE B.VALID_FLAG = 1
           AND EXISTS (SELECT NULL
                  FROM PM_BUNCH B2
                 WHERE B2.ORG_NO = B.BLG_ORG_NO
                   AND B2.BUNCH_ID = '4028da1c37ba31270137bb727ced01d5'
                   AND B2.VER_ID IS NULL)) RSLT
  LEFT JOIN PM_S_BUDGET PB
    ON PB.PRJ_CODE = RSLT.PRJ_CODE
   AND PB.DATA_STATUS = 1
