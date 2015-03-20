SELECT *
  FROM (SELECT SUBSTR(MAX(R.VER_EXP),0,10), 1 AS VERNO
          FROM PM_ALP_RELEASE R
         WHERE R.RPT_YEAR = '2012'
           AND R.VER_NO = '1'
           AND R.CREATE_DATE = (SELECT MAX(RX78.CREATE_DATE)
                                  FROM PM_ALP_RELEASE RX78
                                 WHERE RX78.RPT_YEAR = '2012'
                                   AND RX78.VER_NO = 1)
        UNION ALL
        SELECT SUBSTR(MAX(R.VER_EXP),0,10), 2 AS VERNO
          FROM PM_ALP_RELEASE R
         WHERE R.RPT_YEAR = '2012'
           AND R.VER_NO = '2'
           AND R.CREATE_DATE = (SELECT MAX(RX78.CREATE_DATE)
                                  FROM PM_ALP_RELEASE RX78
                                 WHERE RX78.RPT_YEAR = '2012'
                                   AND RX78.VER_NO = 2)
        UNION ALL
        SELECT SUBSTR(MAX(R.VER_EXP),0,10), 3 AS VERNO
          FROM PM_ALP_RELEASE R
         WHERE R.RPT_YEAR = '2012'
           AND R.VER_NO = '3'
           AND R.CREATE_DATE = (SELECT MAX(RX78.CREATE_DATE)
                                  FROM PM_ALP_RELEASE RX78
                                 WHERE RX78.RPT_YEAR = '2012'
                                   AND RX78.VER_NO = 3))
 ORDER BY VERNO
