--专业输出2012年1-4月报表数据
SELECT A.ORG_ID,
A.ORG_NAME,
               A.YEARPLAN_MONEY,
               A.POINT_CODE,
               A.INVESTMENT_COUNT,
               A.COMPLETE_PERCENT,
               A.CHAIN_NUMBER,
               A.CAPITAL_MONEY,
               A.COST_MONEY
          FROM PM_IMR_CONSTRUCT_ARCHIVE A LEFT JOIN PM_IMR_ORG_SORTS S ON A.ORG_ID= S.ORG_NO
           WHERE A.STATISTIC_YEAR = 2012
          AND A.STATISTIC_MONTH = 1
          ORDER BY NVL(S.SORT_ORDER, A.ORG_ID), NVL(S.ORG_ORDER, 0)
