INSERT INTO PM_IMR_ORG_SORTS
  (SORT_ID, ORG_NO, sort_order, sort_name, org_order, ORG_NAME)
  select S.organ_code,
         S.organ_code,
         (CASE
           WHEN S.organ_code = 100100 THEN
            10
           WHEN S.organ_code IN
                ('110000', '120000', '130000', '370000', '140000', '100300') THEN
            20
           WHEN S.organ_code IN ('100500',
                                 '420000',
                                 '430000',
                                 '410000',
                                 '140000',
                                 '510000',
                                 '500000',
                                 '360000') THEN
            40
           WHEN S.organ_code IN
                ('100400', '310000', '330000', '320000', '340000', '350000') THEN
            30
           WHEN S.organ_code IN
                ('100600', '210000', '220000', '230000', '150000') THEN
            50
           WHEN S.organ_code IN ('100700',
                                 '610000',
                                 '620000',
                                 '640000',
                                 '650000',
                                 '630000',
                                 '540000') THEN
            60
         /*WHEN S.organ_code = 540000 THEN
         70*/
           WHEN S.organ_code > 100700 AND S.organ_code < 104000 THEN
            70
           ELSE
            0
         END) SORT_ORDER,
         (CASE
           WHEN S.organ_code = 100100 THEN
            '公司总部'
           WHEN S.organ_code IN
                ('110000', '120000', '130000', '370000', '140000', '100300') THEN
            '华北电网'
           WHEN S.organ_code IN ('100500',
                                 '420000',
                                 '430000',
                                 '410000',
                                 '140000',
                                 '510000',
                                 '500000',
                                 '360000') THEN
            '华中电网'
           WHEN S.organ_code IN
                ('100400', '310000', '330000', '320000', '340000', '350000') THEN
            '华东电网'
           WHEN S.organ_code IN
                ('100600', '210000', '220000', '230000', '150000') THEN
            '东北电网'
           WHEN S.organ_code IN ('100700',
                                 '610000',
                                 '620000',
                                 '640000',
                                 '650000',
                                 '630000',
                                 '540000') THEN
            '西北电网'
         /*WHEN S.organ_code = 540000 THEN
         '西藏电力公司'*/
           WHEN S.organ_code > 100700 AND S.organ_code < 104000 THEN
            '直属单位'
           ELSE
            '0'
         END) SORT_NAME,
         0,
         S.organ_name
    from V_STRU S
   WHERE (S.ORGAN_TYPE = '1' OR S.ORGAN_TYPE = '13')
     AND S.F_ORGAN_CODE = '100000'
