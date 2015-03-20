SELECT BB.BUNCH_NO,
       BB.BUNCH_NAME,
       TO_CHAR(BB.ORG_NO) AS ORG_NO,
       BB.APP_ORG_NO,
       BB.APP_DEPT_NO,
       BB.PLAN_START_DATE,
       BB.PLAN_END_DATE,
       TO_CHAR(BB.PLAN_YEAR) AS PLAN_YEAR,
       BB.TOTAL_FUND,     -- 本年金额    默认已选取 fund_type = '03'
       BB.CAPITAL_FUND,   -- 本年资本金
       BB.COST_FUND,      -- 本年成本金
       BB.SOFT_FUND,BB.HAD_FUND,BB.DEVEP_FUND,BB.PEFM_FUND,BB.OTHER_FUND,  -- 本年五项分值
       BB.NEXT_INV_FUND,  -- 下年计划
       BB.Y_TOTAL_FUND,   -- 已完成总金额   默认已选取 fund_type = '02'
       BB.Y_CAPITAL_FUND, -- 已完成资本金
       BB.Y_COST_FUND,    -- 已完成成本金
       BB.Z_TOTAL_FUND,   -- 总投入资金     默认已选取 fund_type = '01'
       BB.Z_CAPITAL_FUND, -- 总投入资本金
       BB.Z_COST_FUND,    -- 总投入成本金
       BB.PF_SORT_CODE,   -- 四大类
       BB.PT_SORT_CODE,   -- 三级分类
       BB.NATURE_CODE,    -- 项目性质
       BB.BUNCH_ID,
       '1' AS ISBUNCH     -- 是否为包项目  1： 为包  0 ：不为包
  FROM (SELECT PB.BUNCH_NO,
               PB.BUNCH_NAME,
               PB.ORG_NO,
               PB.APP_ORG_NO,
               PB.APP_DEPT_NO,
               PB.PLAN_START_DATE,
               PB.PLAN_END_DATE,
               PB.BUNCH_YEAR AS PLAN_YEAR,
               SUM(SS.TOTAL_FUND) AS TOTAL_FUND,
               SUM(SS.CAPITAL_FUND) AS CAPITAL_FUND,
               SUM(SS.COST_FUND) AS COST_FUND,
               SUM(SS.SOFT_FUND) AS SOFT_FUND,
               SUM(SS.HAD_FUND) AS HAD_FUND,
               SUM(SS.DEVEP_FUND) AS DEVEP_FUND,
               SUM(SS.PEFM_FUND) AS PEFM_FUND,
               SUM(SS.OTHER_FUND) AS OTHER_FUND,
               SUM(SS.NEXT_INV_FUND) AS NEXT_INV_FUND,
               SUM(SS.Y_TOTAL_FUND) AS Y_TOTAL_FUND,
               SUM(SS.Y_CAPITAL_FUND) AS Y_CAPITAL_FUND,
               SUM(SS.Y_COST_FUND) AS Y_COST_FUND,
               SUM(SS.Z_TOTAL_FUND) AS Z_TOTAL_FUND,
               SUM(SS.Z_CAPITAL_FUND) AS Z_CAPITAL_FUND,
               SUM(SS.Z_COST_FUND) AS Z_COST_FUND,
               SORTCODE.PF_SORT_CODE,
               SORTCODE.PT_SORT_CODE,
               PB.NATURE_CODE,
               PB.BUNCH_ID,
               '1' ISBUNCH
          FROM SGIRS.PM_BUNCH PB
               LEFT JOIN SGIRS.PM_BUNCH_DETAIL PBD ON PB.BUNCH_ID = PBD.BUNCH_ID
               LEFT JOIN
               (SELECT BCH.BUNCH_NO,BCH.VER_ID,BCH.BUNCH_YEAR,
                       SCNPC.VALUE AS PF_SORT_CODE,
                       PC.VALUE || '01' AS PT_SORT_CODE
                  FROM SGIRS.PM_BUNCH BCH
                  LEFT JOIN SGIRS.P_CODE PC ON PC.VALUE = BCH.PRJ_SORT_CODE
                                           AND PC.CODE_TYPE = '23000000'
                  LEFT JOIN SGIRS.P_CODE SCNPC ON SCNPC.VALUE = PC.P_CODE
                                              AND SCNPC.CODE_TYPE ='23000000'
                  LEFT JOIN (SELECT T1.RPT_YEAR AS RPT_YEAR,
                                           MAX(TO_NUMBER(VER_NO)) AS VER_NO,
                                           T1.ORG_NO
                                      FROM SGIRS.PM_ALP_RELEASE T1
                                     GROUP BY T1.RPT_YEAR, T1.ORG_NO) GG ON BCH.VER_ID = GG.VER_NO AND BCH.ORG_NO = GG.ORG_NO AND BCH.BUNCH_YEAR = GG.RPT_YEAR
                 GROUP BY BCH.BUNCH_NO,BCH.VER_ID,BCH.BUNCH_YEAR, SCNPC.VALUE, PC.VALUE ) SORTCODE
                        ON SORTCODE.BUNCH_NO = PB.BUNCH_NO AND PB.BUNCH_YEAR = SORTCODE.BUNCH_YEAR AND PB.VER_ID = SORTCODE.VER_ID
               INNER JOIN
               (SELECT JJ.PRJ_CODE,
                       JJ.PRJ_NAME,
                       JJ.BLG_ORG_NO,
                       JJ.APP_ORG_NO,
                       JJ.APP_DEPT_NO,
                       JJ.PLAN_START_DATE,
                       JJ.PLAN_END_DATE,
                       JJ.RPT_YEAR,
                       JJ.TOTAL_FUND,
                       JJ.CAPITAL_FUND,
                       JJ.COST_FUND,
                       JJ.SOFT_FUND,JJ.HAD_FUND,JJ.DEVEP_FUND,JJ.PEFM_FUND,JJ.OTHER_FUND,JJ.NEXT_INV_FUND,
                       JJ.Y_TOTAL_FUND,
                       JJ.Y_CAPITAL_FUND,
                       JJ.Y_COST_FUND,
                       JJ.Z_TOTAL_FUND,
                       JJ.Z_CAPITAL_FUND,
                       JJ.Z_COST_FUND,
                       JJ.PF_SORT_CODE,
                       JJ.PT_SORT_CODE,
                       JJ.PRJ_NATURE_CODE
                  FROM (SELECT PAD.PRJ_CODE,
                               PBI.PRJ_NAME,
                               PBI.BLG_ORG_NO,
                               PBI.APP_ORG_NO,
                               PBI.APP_DEPT_NO,
                               PBI.PLAN_START_DATE,
                               PBI.PLAN_END_DATE,
                               PAR.RPT_YEAR,
                               PAF.TOTAL_FUND,
                               PAF.CAPITAL_FUND,
                               PAF.COST_FUND,
                               Y_PAF.TOTAL_FUND AS Y_TOTAL_FUND,
                               Y_PAF.CAPITAL_FUND AS Y_CAPITAL_FUND,
                               Y_PAF.COST_FUND AS Y_COST_FUND,
                               Z_PAF.TOTAL_FUND AS Z_TOTAL_FUND,
                               Z_PAF.CAPITAL_FUND AS Z_CAPITAL_FUND,
                               Z_PAF.COST_FUND AS Z_COST_FUND,
                               PAF.SOFT_FUND,PAF.HAD_FUND,PAF.DEVEP_FUND,PAF.PEFM_FUND,PAF.OTHER_FUND,PAD.NEXT_INV_FUND,
                               PAD.PF_SORT_CODE,
                               PAD.PT_SORT_CODE,
                               PBI.PRJ_NATURE_CODE,
                               '0' AS ISBUNCH
                          FROM SGIRS.PM_ALP_DHT PAD
                               LEFT JOIN SGIRS.PM_ALP_RELEASE PAR ON PAR.VER_ID = PAD.VER_ID AND PAR.RPT_ID = PAD.RPT_ID
                               LEFT JOIN SGIRS.PM_BASE_INFO PBI ON PBI.PRJ_CODE = PAD.PRJ_CODE
                               LEFT JOIN SGIRS.PM_ALP_FHT PAF ON PAD.VER_ID = PAF.VER_ID AND PAD.DETAIL_ID = PAF.DETAIL_ID AND PAF.FUND_TYPE = '03'
                               LEFT JOIN SGIRS.PM_ALP_FHT Y_PAF ON PAD.VER_ID = Y_PAF.VER_ID AND PAD.DETAIL_ID = Y_PAF.DETAIL_ID AND Y_PAF.FUND_TYPE = '02'
                               LEFT JOIN SGIRS.PM_ALP_FHT Z_PAF ON PAD.VER_ID = Z_PAF.VER_ID AND PAD.DETAIL_ID = Z_PAF.DETAIL_ID AND Z_PAF.FUND_TYPE = '01'
                               INNER JOIN
                                   (SELECT T1.RPT_YEAR AS RPT_YEAR,
                                           MAX(TO_NUMBER(VER_NO)) AS VER_NO,
                                           T1.ORG_NO
                                      FROM SGIRS.PM_ALP_RELEASE T1
                                     GROUP BY T1.RPT_YEAR, T1.ORG_NO) GG ON PAR.VER_NO = GG.VER_NO AND PAR.ORG_NO = GG.ORG_NO AND PAR.RPT_YEAR = GG.RPT_YEAR
                         WHERE PAD.EDIT_TYPE_CODE = '02') JJ
                                  ) SS ON PB.BUNCH_YEAR = SS.RPT_YEAR AND PBD.PRJ_CODE = SS.PRJ_CODE
               INNER JOIN
               (SELECT T2.RPT_YEAR,
                       MAX(TO_NUMBER(VER_NO)) AS VER_NO,
                       T2.ORG_NO
                  FROM SGIRS.PM_ALP_RELEASE T2
                 GROUP BY T2.RPT_YEAR, T2.ORG_NO) MM ON PB.ORG_NO = MM.ORG_NO AND PB.VER_ID = MM.VER_NO AND PB.BUNCH_YEAR = MM.RPT_YEAR
         GROUP BY PB.BUNCH_NO,
                  PB.BUNCH_NAME,
                  PB.ORG_NO,
                  PB.APP_ORG_NO,
                  PB.APP_DEPT_NO,
                  PB.PLAN_START_DATE,
                  PB.PLAN_END_DATE,
                  SS.RPT_YEAR,
                  PB.VER_ID,
                  PB.BUNCH_YEAR,
                  SORTCODE.PF_SORT_CODE,
                  SORTCODE.PT_SORT_CODE,
                  PB.NATURE_CODE,PB.BUNCH_ID) BB
UNION ALL
SELECT PP.PRJ_CODE,
       PP.PRJ_NAME,
       TO_CHAR(PP.BLG_ORG_NO),
       PP.APP_ORG_NO,
       PP.APP_DEPT_NO,
       PP.PLAN_START_DATE,
       PP.PLAN_END_DATE,
       TO_CHAR(PP.RPT_YEAR),
       PP.TOTAL_FUND,
       PP.CAPITAL_FUND,
       PP.COST_FUND,
       PP.SOFT_FUND,PP.HAD_FUND,PP.DEVEP_FUND,PP.PEFM_FUND,PP.OTHER_FUND,PP.NEXT_INV_FUND,
       PP.Y_TOTAL_FUND,
       PP.Y_CAPITAL_FUND,
       PP.Y_COST_FUND,
       PP.Z_TOTAL_FUND,
       PP.Z_CAPITAL_FUND,
       PP.Z_COST_FUND,
       PP.PF_SORT_CODE,
       PP.PT_SORT_CODE,
       PP.PRJ_NATURE_CODE,
       '',
       '0' AS ISBUNCH
  FROM (SELECT PAD.PRJ_CODE,
               PBI.PRJ_NAME,
               PBI.BLG_ORG_NO,
               PBI.APP_ORG_NO,
               PBI.APP_DEPT_NO,
               PBI.PLAN_START_DATE,
               PBI.PLAN_END_DATE,
               PAR.RPT_YEAR,
               PAF.TOTAL_FUND,
               PAF.CAPITAL_FUND,
               PAF.COST_FUND,
               Y_PAF.TOTAL_FUND AS Y_TOTAL_FUND,
               Y_PAF.CAPITAL_FUND AS Y_CAPITAL_FUND,
               Y_PAF.COST_FUND AS Y_COST_FUND,
               Z_PAF.TOTAL_FUND AS Z_TOTAL_FUND,
               Z_PAF.CAPITAL_FUND AS Z_CAPITAL_FUND,
               Z_PAF.COST_FUND AS Z_COST_FUND,
               PAF.SOFT_FUND,PAF.HAD_FUND,PAF.DEVEP_FUND,PAF.PEFM_FUND,PAF.OTHER_FUND,
               PAD.NEXT_INV_FUND,
               PAD.PF_SORT_CODE,
               PAD.PT_SORT_CODE,
               PBI.PRJ_NATURE_CODE,
               '0' AS ISBUNCH
          FROM SGIRS.PM_ALP_DHT PAD
               LEFT JOIN SGIRS.PM_ALP_RELEASE PAR ON PAR.VER_ID = PAD.VER_ID AND PAR.RPT_ID = PAD.RPT_ID
               LEFT JOIN SGIRS.PM_BASE_INFO PBI ON PBI.PRJ_CODE = PAD.PRJ_CODE
               LEFT JOIN SGIRS.PM_ALP_FHT PAF ON PAR.VER_ID = PAF.VER_ID AND PAD.DETAIL_ID = PAF.DETAIL_ID AND PAF.FUND_TYPE = '03'
               LEFT JOIN SGIRS.PM_ALP_FHT Y_PAF ON PAR.VER_ID = Y_PAF.VER_ID AND PAD.DETAIL_ID = Y_PAF.DETAIL_ID AND Y_PAF.FUND_TYPE = '02'
               LEFT JOIN SGIRS.PM_ALP_FHT Z_PAF ON PAR.VER_ID = Z_PAF.VER_ID AND PAD.DETAIL_ID = Z_PAF.DETAIL_ID AND Z_PAF.FUND_TYPE = '01'
               INNER JOIN
                   (SELECT T1.RPT_YEAR AS RPT_YEAR,
                           MAX(TO_NUMBER(VER_NO)) AS VER_NO,
                           T1.ORG_NO
                      FROM SGIRS.PM_ALP_RELEASE T1
                     GROUP BY T1.RPT_YEAR, T1.ORG_NO) GG ON PAR.VER_NO = GG.VER_NO AND PAR.ORG_NO = GG.ORG_NO AND PAR.RPT_YEAR = GG.RPT_YEAR
         WHERE PAD.EDIT_TYPE_CODE = '02'
           AND NOT EXISTS
               (SELECT NULL
                  FROM SGIRS.PM_BUNCH PB, SGIRS.PM_BUNCH_DETAIL PBD
                 WHERE PB.BUNCH_ID = PBD.BUNCH_ID AND  PB.VER_ID = GG.VER_NO AND PB.ORG_NO = GG.ORG_NO AND PAD.PRJ_CODE = PBD.PRJ_CODE)) PP