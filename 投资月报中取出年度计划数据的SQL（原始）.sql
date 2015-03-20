--投资月报中取出年度计划数据的SQL
SELECT AA.*, PAC.APP_NO
  FROM (SELECT BB.BUNCH_NO,
               BB.BUNCH_NAME,
               BB.ORGAN_NAME,
               BB.NATURE_CODE,
               NVL(BB.TOTAL_FUND, 0),
               NVL(BB.NEXT_INV_FUND, 0),
               NVL(BB.Z_TOTAL_FUND, 0),
               BB.PRJ_SORT_NAME,
               BB.FIRST_SORT_NAME,
               BB.SECOND_SORT_NAME,
               BB.PLAN_YEAR,
               BB.BUNCH_ID
          FROM (SELECT VP.BUNCH_NO,
                       VP.BUNCH_NAME,
                       VS.ORGAN_NAME,
                       VP.NATURE_CODE,
                       VP.TOTAL_FUND,
                       VP.NEXT_INV_FUND,
                       VP.Z_TOTAL_FUND,
                       FRSTCD.NAME || '/' || SCNDCD.NAME PRJ_SORT_NAME,
                       FRSTCD.NAME AS FIRST_SORT_NAME,
                       SCNDCD.NAME AS SECOND_SORT_NAME,
                       VP.ORG_NO,
                       VP.PLAN_YEAR,
                       VP.BUNCH_ID
                  FROM
                  V_PM_ALP_RELEASE_PROJECT VP LEFT JOIN  V_STRU VS
                    ON VP.PLAN_YEAR = '2012' AND VS.ORGAN_CODE = VP.ORG_NO
                  LEFT JOIN P_CODE THRDCD
                    ON VP.PT_SORT_CODE = THRDCD.VALUE
                   AND THRDCD.CODE_TYPE = '23000000'
                  LEFT JOIN P_CODE SCNDCD
                    ON THRDCD.P_CODE = SCNDCD.VALUE
                   AND SCNDCD.CODE_TYPE = '23000000'
                  LEFT JOIN P_CODE FRSTCD
                    ON SCNDCD.P_CODE = FRSTCD.VALUE
                   AND FRSTCD.CODE_TYPE = '23000000') BB
         WHERE BB.ORG_NO IN ('100100')) AA LEFT JOIN 
       PM_ALP_CREATE PAC
ON PAC.PLAN_YEAR = AA.PLAN_YEAR
