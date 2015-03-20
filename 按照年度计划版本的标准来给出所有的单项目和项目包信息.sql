select AX.* from (
select ORG.ORGAN_NAME,C3.NAME FN,C2.NAME SN,INF.PRJ_NAME,INF.PRJ_CODE,F1.COST_FUND,F1.CAPITAL_FUND,F1.TOTAL_FUND, ROWNUM as rowx 
from PM_ALP_DHT d left join PM_ALP_RELEASE r on d.VER_ID = r.VER_ID and d.RPT_ID = r.RPT_ID
LEFT JOIN PM_ALP_FHT F1
            ON D.DETAIL_ID = F1.DETAIL_ID
           AND D.VER_ID = F1.VER_ID
           AND F1.FUND_TYPE = '01'
           LEFT JOIN PM_BASE_INFO INF
           ON INF.PRJ_CODE = D.PRJ_CODE
  LEFT JOIN P_CODE C1
    ON D.PT_SORT_CODE = C1.VALUE
   AND C1.CODE_TYPE = '23000000'
  LEFT JOIN P_CODE C2
    ON C1.P_CODE = C2.VALUE
   AND C2.CODE_TYPE = '23000000'
  LEFT JOIN P_CODE C3
    ON C2.P_CODE = C3.VALUE
   AND C3.CODE_TYPE = '23000000'
   AND D.PRJ_CODE = INF.PRJ_CODE
   LEFT JOIN (SELECT S.ORGAN_CODE, S.ORGAN_NAME
                                   FROM V_STRU S
                                  WHERE (S.ORGAN_TYPE = '1' OR
                                        S.ORGAN_TYPE = '13')
                                    AND S.F_ORGAN_CODE = '100000') ORG
                         ON R.ORG_NO = ORG.ORGAN_CODE
                         WHERE r.RPT_YEAR = '2012'
                         order by r.ORG_NO,C3.VALUE,C2.VALUE) AX where ax.rowx < 2000
