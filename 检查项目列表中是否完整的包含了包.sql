SELECT NVL(COUNT(*),0)
  FROM PM_BUNCH_DETAIL DT
 WHERE EXISTS (SELECT DT2.BUNCH_ID
          FROM PM_ALP_RPT_DETAIL D
          LEFT JOIN PM_ALP_RELEASE R
            ON R.RPT_ID = D.RPT_ID
            LEFT JOIN (SELECT *
                      FROM PM_BUNCH_DETAIL DB
                     WHERE EXISTS (SELECT NULL
                              FROM PM_BUNCH B
                             WHERE B.BUNCH_ID = DB.BUNCH_ID
                               AND B.VER_ID IS NULL)) DT2
            ON D.PRJ_CODE = DT2.PRJ_CODE
         WHERE EXISTS (SELECT NULL
                  FROM PM_ALP_RPT R
                 WHERE R.APP_NO =
                       (SELECT MAX(C.APP_NO)
                          FROM PM_ALP_CREATE C
                         WHERE C.PLAN_YEAR = '2010')
                   AND R.RPT_ID = D.RPT_ID
                   AND R.STATUS_CODE = '04')
          
         AND DT2.BUNCH_ID IS NOT NULL
         AND D.EDIT_TYPE_CODE = 02
           AND DT2.BUNCH_ID = DT.BUNCH_ID)
   AND NOT EXISTS (SELECT NULL
          FROM PM_ALP_RPT_DETAIL DET
          LEFT JOIN PM_ALP_RELEASE R
            ON R.RPT_ID = DET.RPT_ID
         WHERE EXISTS (SELECT NULL
                  FROM PM_ALP_RPT R
                 WHERE R.APP_NO =
                       (SELECT MAX(C.APP_NO)
                          FROM PM_ALP_CREATE C
                         WHERE C.PLAN_YEAR = '2010')
                   AND R.RPT_ID = DET.RPT_ID
                   AND R.STATUS_CODE = '04')
                   AND DET.EDIT_TYPE_CODE = 02
                   AND DET.PRJ_CODE = DT.PRJ_CODE)
