insert into Pm_Alp_Fht
  (Fund_Ver_Id,
   Ver_Id,
   Fund_Id,
   Detail_Id,
   Fund_Type,
   Inv_Date,
   Total_Fund,
   Cost_Fund,
   Capital_Fund,
   Soft_Fund,
   Had_Fund,
   Devep_Fund,
   Pefm_Fund,
   Other_Fund)
  SELECT X.GID AS Fund_Ver_Id,
         D.VER_ID,
         F.FUND_ID,
         F.DETAIL_ID,
         F.FUND_TYPE,
         F.Inv_Date,
         F.TOTAL_FUND,
         F.CAPITAL_FUND,
         F.COST_FUND,
         F.SOFT_FUND,
         F.HAD_FUND,
         F.DEVEP_FUND,
         F.PEFM_FUND,
         F.OTHER_FUND
  
    FROM PM_ALP_FUND F
    LEFT JOIN PM_ALP_DHT D
      ON F.DETAIL_ID = D.DETAIL_ID
     AND EXISTS (SELECT NULL
            FROM PM_ALP_RELEASE R
           WHERE R.VER_ID = D.VER_ID
             AND R.RPT_YEAR = '2012'
             AND R.VER_NO = '1.1'),
   (SELECT SYS_GUID() AS GID FROM DUAL) X
   WHERE EXISTS (SELECT NULL
            FROM PM_ALP_RPT_DETAIL D
           WHERE D.DETAIL_ID = F.DETAIL_ID
             AND EXISTS (SELECT NULL
                    FROM PM_ALP_RPT R
                   WHERE R.APP_NO =
                         (SELECT MAX(C.APP_NO)
                            FROM PM_ALP_CREATE C
                           WHERE C.PLAN_YEAR = '2012')
                     AND R.RPT_ID = D.RPT_ID
                     AND R.STATUS_CODE = '04'))
