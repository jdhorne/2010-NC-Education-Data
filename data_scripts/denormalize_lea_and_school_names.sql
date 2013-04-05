-- Overall suggestions:
-- 1. Denormalize LEA name onto all tables with an lea_code/year_code to make the tables easier to work with.
-- 2. Denormalize site name onto all tables with an lea_code/year_code/site_code to make the tables easier to work with.
-- 3. Standardize column names!  LEA code is called "lgl_lea_cd" in LEA_EOG_TEST_LEVEL,
--    "lgt_lea_cd" in LEA_EOG_TESTED_NOTTESTED, "lgd_lea_cd" in LEA_EOG_SUMM_DISAGG, and so forth.
--    It would be *much* easier to work with the data if it were always just "lea_cd" in every table.
--    This is also true for year codes and site codes.
-- 4. Fix referential integrity errors.  
--    a. There are many, many cases where a given lea_cd/year_cd in one of the LEA_* tables doesn't
--       actually have a corresponding row in the LEA table.
--    b. Ditto for site/school-level tables not having corresponding rows for lea_cd/site_cd/year_cd
--       in the SITE table.

create index idx_lea on lea (lea_unit_cd, lea_year_cd);
create index idx_lea_with_name on lea (lea_unit_cd, lea_year_cd, lea_unit_nm);

create index idx_site on site (ste_unit_cd, ste_site_cd, ste_year_cd);
create index idx_site_with_name on site (ste_unit_cd, ste_site_cd, ste_year_cd, ste_site_nm);

-- city_xref_lea: 229 rows where sxl_lea_cd/sxl_year_cd doesn't match a row in the "lea" table
alter table city_xref_lea add (lea_name varchar(255));
update city_xref_lea t set lea_name = (select lea_unit_nm from lea l where t.sxl_lea_cd=l.lea_unit_cd and t.sxl_year_cd=l.lea_year_cd)
 where 1 = (select count(*) from lea l where t.sxl_lea_cd=l.lea_unit_cd and t.sxl_year_cd=l.lea_year_cd);
select count(*) from city_xref_lea where lea_name is null;

-- county_xref_lea: 25 rows where tl_lea_cd/tl_year_cd doesn't match a row in the "lea" table
alter table county_xref_lea add (lea_name varchar(255));
update county_xref_lea t set lea_name = (select lea_unit_nm from lea l where t.tl_lea_cd=l.lea_unit_cd and t.tl_year_cd=l.lea_year_cd)
 where 1 = (select count(*) from lea l where t.tl_lea_cd=l.lea_unit_cd and t.tl_year_cd=l.lea_year_cd);
select count(*) from county_xref_lea where lea_name is null;

-- high_sch_graduation: 2 rows where lea_cd/year_cd doesn't match a row in the "lea" table
--    27 rows where lea_cd/year_cd/site_cd doesn't match a row in the "site" table
alter table high_sch_graduation add (lea_name varchar(255), school_name varchar(255));
update high_sch_graduation t set lea_name = (select lea_unit_nm from lea l where t.hsg_lea_cd=l.lea_unit_cd and t.hsg_year_cd=l.lea_year_cd)
 where 1 = (select count(*) from lea l where t.hsg_lea_cd=l.lea_unit_cd and t.hsg_year_cd=l.lea_year_cd);
select count(*) from high_sch_graduation where lea_name is null;
update high_sch_graduation t set school_name = (select ste_site_nm from site s where t.hsg_lea_cd=s.ste_unit_cd and t.hsg_year_cd=s.ste_year_cd and t.hsg_sch_cd=s.ste_site_cd)
 where 1 = (select count(*) from site s where t.hsg_lea_cd=s.ste_unit_cd and t.hsg_year_cd=s.ste_year_cd and t.hsg_sch_cd=s.ste_site_cd);
select count(*) from high_sch_graduation where school_name is null;

-- lea_adequate_progress: 8 rows where lea_cd/year_cd doesn't match a row in the "lea" table
alter table lea_adequate_progress add (lea_name varchar(255));
update lea_adequate_progress t set lea_name = (select lea_unit_nm from lea l where t.lap_lea_cd=l.lea_unit_cd and t.lap_year_cd=l.lea_year_cd)
 where 1 = (select count(*) from lea l where t.lap_lea_cd=l.lea_unit_cd and t.lap_year_cd=l.lea_year_cd);
select count(*) from lea_adequate_progress where lea_name is null;

-- lea_ayp_attendance: 2 rows where lea_cd/year_cd doesn't match a row in the "lea" table
alter table lea_ayp_attendance add (lea_name varchar(255));
update lea_ayp_attendance t set lea_name = (select lea_unit_nm from lea l where t.lsa_lea_cd=l.lea_unit_cd and t.lsa_year_cd=l.lea_year_cd)
 where 1 = (select count(*) from lea l where t.lsa_lea_cd=l.lea_unit_cd and t.lsa_year_cd=l.lea_year_cd);
select count(*) from lea_ayp_attendance where lea_name is null;

-- lea_category_summ: 28 rows where lea_cd/year_cd doesn't match a row in the "lea" table
alter table lea_category_summ add (lea_name varchar(255));
update lea_category_summ t set lea_name = (select lea_unit_nm from lea l where t.lcs_lea_cd=l.lea_unit_cd and t.lcs_year_cd=l.lea_year_cd)
 where 1 = (select count(*) from lea l where t.lcs_lea_cd=l.lea_unit_cd and t.lcs_year_cd=l.lea_year_cd);
select count(*) from lea_category_summ where lea_name is null;

-- lea_end_of_course_summ: 7 rows where lea_cd/year_cd doesn't match a row in the "lea" table
alter table lea_end_of_course_summ add (lea_name varchar(255));
update lea_end_of_course_summ t set lea_name = (select lea_unit_nm from lea l where t.loc_lea_cd=l.lea_unit_cd and t.loc_year_cd=l.lea_year_cd)
 where 1 = (select count(*) from lea l where t.loc_lea_cd=l.lea_unit_cd and t.loc_year_cd=l.lea_year_cd);
select count(*) from lea_end_of_course_summ where lea_name is null;

-- lea_end_of_grade_summ: 1311 rows where lea_cd/year_cd doesn't match a row in the "lea" table
alter table lea_end_of_grade_summ add (lea_name varchar(255));
update lea_end_of_grade_summ t set lea_name = (select lea_unit_nm from lea l where t.log_lea_cd=l.lea_unit_cd and t.log_year_cd=l.lea_year_cd)
 where 1 = (select count(*) from lea l where t.log_lea_cd=l.lea_unit_cd and t.log_year_cd=l.lea_year_cd);
select count(*) from lea_end_of_grade_summ where lea_name is null;

-- lea_eoc_composite_summ: 5 rows where lea_cd/year_cd doesn't match a row in the "lea" table
alter table lea_eoc_composite_summ add (lea_name varchar(255));
update lea_eoc_composite_summ t set lea_name = (select lea_unit_nm from lea l where t.lcc_lea_cd=l.lea_unit_cd and t.lcc_year_cd=l.lea_year_cd)
 where 1 = (select count(*) from lea l where t.lcc_lea_cd=l.lea_unit_cd and t.lcc_year_cd=l.lea_year_cd);
select count(*) from lea_eoc_composite_summ where lea_name is null;

-- lea_eoc_comp_test_level: 16 rows where lea_cd/year_cd doesn't match a row in the "lea" table
alter table lea_eoc_comp_test_level add (lea_name varchar(255));
update lea_eoc_comp_test_level t set lea_name = (select lea_unit_nm from lea l where t.lxl_lea_cd=l.lea_unit_cd and t.lxl_year_cd=l.lea_year_cd)
 where 1 = (select count(*) from lea l where t.lxl_lea_cd=l.lea_unit_cd and t.lxl_year_cd=l.lea_year_cd);
select count(*) from lea_eoc_comp_test_level where lea_name is null;

-- lea_eoc_summ_disagg: 45 rows where lea_cd/year_cd doesn't match a row in the "lea" table
alter table lea_eoc_summ_disagg add (lea_name varchar(255));
update lea_eoc_summ_disagg t set lea_name = (select lea_unit_nm from lea l where t.lcd_lea_cd=l.lea_unit_cd and t.lcd_year_cd=l.lea_year_cd)
 where 1 = (select count(*) from lea l where t.lcd_lea_cd=l.lea_unit_cd and t.lcd_year_cd=l.lea_year_cd);
select count(*) from lea_eoc_summ_disagg where lea_name is null;

-- lea_eoc_tested_nottested: 54 rows where lea_cd/year_cd doesn't match a row in the "lea" table
alter table lea_eoc_tested_nottested add (lea_name varchar(255));
update lea_eoc_tested_nottested t set lea_name = (select lea_unit_nm from lea l where t.lct_lea_cd=l.lea_unit_cd and t.lct_year_cd=l.lea_year_cd)
 where 1 = (select count(*) from lea l where t.lct_lea_cd=l.lea_unit_cd and t.lct_year_cd=l.lea_year_cd);
select count(*) from lea_eoc_tested_nottested where lea_name is null;

-- lea_eog_composite_summ: 9 rows where lea_cd/year_cd doesn't match a row in the "lea" table
alter table lea_eog_composite_summ add (lea_name varchar(255));
update lea_eog_composite_summ t set lea_name = (select lea_unit_nm from lea l where t.lgc_lea_cd=l.lea_unit_cd and t.lgc_year_cd=l.lea_year_cd)
 where 1 = (select count(*) from lea l where t.lgc_lea_cd=l.lea_unit_cd and t.lgc_year_cd=l.lea_year_cd);
select count(*) from lea_eog_composite_summ where lea_name is null;

-- lea_eog_promotion_disagg; all rows match in lea table!
alter table lea_eog_promotion_disagg add (lea_name varchar(255));
update lea_eog_promotion_disagg t set lea_name = (select lea_unit_nm from lea l where t.lgp_lea_cd=l.lea_unit_cd and t.lgp_year_cd=l.lea_year_cd)
 where 1 = (select count(*) from lea l where t.lgp_lea_cd=l.lea_unit_cd and t.lgp_year_cd=l.lea_year_cd);
select count(*) from lea_eog_promotion_disagg where lea_name is null;

-- lea_eog_summ_disagg: 76 rows where lea_cd/year_cd doesn't match a row in the "lea" table
alter table lea_eog_summ_disagg add (lea_name varchar(255));
update lea_eog_summ_disagg t set lea_name = (select lea_unit_nm from lea l where t.lgd_lea_cd=l.lea_unit_cd and t.lgd_year_cd=l.lea_year_cd)
 where 1 = (select count(*) from lea l where t.lgd_lea_cd=l.lea_unit_cd and t.lgd_year_cd=l.lea_year_cd);
select count(*) from lea_eog_summ_disagg where lea_name is null;

-- lea_eog_tested_nottested: 236 rows where lea_cd/year_cd doesn't match a row in the "lea" table
alter table lea_eog_tested_nottested add (lea_name varchar(255));
update lea_eog_tested_nottested t set lea_name = (select lea_unit_nm from lea l where t.lgt_lea_cd=l.lea_unit_cd and t.lgt_year_cd=l.lea_year_cd)
 where 1 = (select count(*) from lea l where t.lgt_lea_cd=l.lea_unit_cd and t.lgt_year_cd=l.lea_year_cd);
select count(*) from lea_eog_tested_nottested where lea_name is null;

-- lea_eog_test_level: 396 rows where lea_cd/year_cd doesn't match a row in the "lea" table
alter table lea_eog_test_level add (lea_name varchar(255));
update lea_eog_test_level t set lea_name = (select lea_unit_nm from lea l where t.lgl_lea_cd=l.lea_unit_cd and t.lgl_year_cd=l.lea_year_cd)
 where 1 = (select count(*) from lea l where t.lgl_lea_cd=l.lea_unit_cd and t.lgl_year_cd=l.lea_year_cd);
select count(*) from lea_eog_test_level where lea_name is null;

-- lea_high_sch_grad: 7 rows where lea_cd/year_cd doesn't match a row in the "lea" table
alter table lea_high_sch_grad add (lea_name varchar(255));
update lea_high_sch_grad t set lea_name = (select lea_unit_nm from lea l where t.lsg_lea_cd=l.lea_unit_cd and t.lsg_year_cd=l.lea_year_cd)
 where 1 = (select count(*) from lea l where t.lsg_lea_cd=l.lea_unit_cd and t.lsg_year_cd=l.lea_year_cd);
select count(*) from lea_high_sch_grad where lea_name is null;

-- lea_summary: 2 rows where lea_cd/year_cd doesn't match a row in the "lea" table
alter table lea_summary add (lea_name varchar(255));
update lea_summary t set lea_name = (select lea_unit_nm from lea l where t.lea_lea_cd=l.lea_unit_cd and t.lea_year_cd=l.lea_year_cd)
 where 1 = (select count(*) from lea l where t.lea_lea_cd=l.lea_unit_cd and t.lea_year_cd=l.lea_year_cd);
select count(*) from lea_summary where lea_name is null;



-- school_summary:
--   180 rows where lea_cd/year_cd doesn't match a row in the "lea" table
--   648 rows where lea_cd/year_cd/site_cd doesn't match a row in the "site" table
alter table school_summary add (lea_name varchar(255), school_name varchar(255));
update school_summary t set lea_name = (select lea_unit_nm from lea l where t.ssm_lea_cd=l.lea_unit_cd and t.ssm_year_cd=l.lea_year_cd)
 where 1 = (select count(*) from lea l where t.ssm_lea_cd=l.lea_unit_cd and t.ssm_year_cd=l.lea_year_cd);
select count(*) from school_summary where lea_name is null;
update school_summary t set school_name = (select ste_site_nm from site s where t.ssm_lea_cd=s.ste_unit_cd and t.ssm_year_cd=s.ste_year_cd and t.ssm_sch_cd=s.ste_site_cd)
 where 1 = (select count(*) from site s where t.ssm_lea_cd=s.ste_unit_cd and t.ssm_year_cd=s.ste_year_cd and t.ssm_sch_cd=s.ste_site_cd);
select count(*) from school_summary where school_name is null;

-- sch_adequate_progress:
--   12 rows where lea_cd/year_cd doesn't match a row in the "lea" table
--   30 rows where lea_cd/year_cd/site_cd doesn't match a row in the "site" table
alter table sch_adequate_progress add (lea_name varchar(255), school_name varchar(255));
update sch_adequate_progress t set lea_name = (select lea_unit_nm from lea l where t.sap_lea_cd=l.lea_unit_cd and t.sap_year_cd=l.lea_year_cd)
 where 1 = (select count(*) from lea l where t.sap_lea_cd=l.lea_unit_cd and t.sap_year_cd=l.lea_year_cd);
select count(*) from sch_adequate_progress where lea_name is null;
update sch_adequate_progress t set school_name = (select ste_site_nm from site s where t.sap_lea_cd=s.ste_unit_cd and t.sap_year_cd=s.ste_year_cd and t.sap_sch_cd=s.ste_site_cd)
 where 1 = (select count(*) from site s where t.sap_lea_cd=s.ste_unit_cd and t.sap_year_cd=s.ste_year_cd and t.sap_sch_cd=s.ste_site_cd);
select count(*) from sch_adequate_progress where school_name is null;

-- sch_ayp_attendance
--   4 rows where lea_cd/year_cd doesn't match a row in the "lea" table
--   123 rows where lea_cd/year_cd/site_cd doesn't match a row in the "site" table
alter table sch_ayp_attendance add (lea_name varchar(255), school_name varchar(255));
update sch_ayp_attendance t set lea_name = (select lea_unit_nm from lea l where t.esa_lea_cd=l.lea_unit_cd and t.esa_year_cd=l.lea_year_cd)
 where 1 = (select count(*) from lea l where t.esa_lea_cd=l.lea_unit_cd and t.esa_year_cd=l.lea_year_cd);
select count(*) from sch_ayp_attendance where lea_name is null;
update sch_ayp_attendance t set school_name = (select ste_site_nm from site s where t.esa_lea_cd=s.ste_unit_cd and t.esa_year_cd=s.ste_year_cd and t.esa_sch_cd=s.ste_site_cd)
 where 1 = (select count(*) from site s where t.esa_lea_cd=s.ste_unit_cd and t.esa_year_cd=s.ste_year_cd and t.esa_sch_cd=s.ste_site_cd);
select count(*) from sch_ayp_attendance where school_name is null;

-- sch_end_of_course_summ
--   22 rows where lea_cd/year_cd doesn't match a row in the "lea" table
--   388 rows where lea_cd/year_cd/site_cd doesn't match a row in the "site" table
alter table sch_end_of_course_summ add (lea_name varchar(255), school_name varchar(255));
update sch_end_of_course_summ t set lea_name = (select lea_unit_nm from lea l where t.eoc_lea_cd=l.lea_unit_cd and t.eoc_year_cd=l.lea_year_cd)
 where 1 = (select count(*) from lea l where t.eoc_lea_cd=l.lea_unit_cd and t.eoc_year_cd=l.lea_year_cd);
select count(*) from sch_end_of_course_summ where lea_name is null;
update sch_end_of_course_summ t set school_name = (select ste_site_nm from site s where t.eoc_lea_cd=s.ste_unit_cd and t.eoc_year_cd=s.ste_year_cd and t.eoc_sch_cd=s.ste_site_cd)
 where 1 = (select count(*) from site s where t.eoc_lea_cd=s.ste_unit_cd and t.eoc_year_cd=s.ste_year_cd and t.eoc_sch_cd=s.ste_site_cd);
select count(*) from sch_end_of_course_summ where school_name is null;

-- sch_end_of_grade_summ
--   7670 rows where lea_cd/year_cd doesn't match a row in the "lea" table
--   8141 rows where lea_cd/year_cd/site_cd doesn't match a row in the "site" table
alter table sch_end_of_grade_summ add (lea_name varchar(255), school_name varchar(255));
update sch_end_of_grade_summ t set lea_name = (select lea_unit_nm from lea l where t.eog_lea_cd=l.lea_unit_cd and t.eog_year_cd=l.lea_year_cd)
 where 1 = (select count(*) from lea l where t.eog_lea_cd=l.lea_unit_cd and t.eog_year_cd=l.lea_year_cd);
select count(*) from sch_end_of_grade_summ where lea_name is null;
update sch_end_of_grade_summ t set school_name = (select ste_site_nm from site s where t.eog_lea_cd=s.ste_unit_cd and t.eog_year_cd=s.ste_year_cd and t.eog_sch_cd=s.ste_site_cd)
 where 1 = (select count(*) from site s where t.eog_lea_cd=s.ste_unit_cd and t.eog_year_cd=s.ste_year_cd and t.eog_sch_cd=s.ste_site_cd);
select count(*) from sch_end_of_grade_summ where school_name is null;

-- sch_eoc_composite_summ
--   17 rows where lea_cd/year_cd doesn't match a row in the "lea" table
--   485 rows where lea_cd/year_cd/site_cd doesn't match a row in the "site" table
alter table sch_eoc_composite_summ add (lea_name varchar(255), school_name varchar(255));
update sch_eoc_composite_summ t set lea_name = (select lea_unit_nm from lea l where t.ecc_lea_cd=l.lea_unit_cd and t.ecc_year_cd=l.lea_year_cd)
 where 1 = (select count(*) from lea l where t.ecc_lea_cd=l.lea_unit_cd and t.ecc_year_cd=l.lea_year_cd);
select count(*) from sch_eoc_composite_summ where lea_name is null;
update sch_eoc_composite_summ t set school_name = (select ste_site_nm from site s where t.ecc_lea_cd=s.ste_unit_cd and t.ecc_year_cd=s.ste_year_cd and t.ecc_sch_cd=s.ste_site_cd)
 where 1 = (select count(*) from site s where t.ecc_lea_cd=s.ste_unit_cd and t.ecc_year_cd=s.ste_year_cd and t.ecc_sch_cd=s.ste_site_cd);
select count(*) from sch_eoc_composite_summ where school_name is null;

-- sch_eoc_comp_test_level
--   20 rows where lea_cd/year_cd doesn't match a row in the "lea" table
--   964 rows where lea_cd/year_cd/site_cd doesn't match a row in the "site" table
alter table sch_eoc_comp_test_level add (lea_name varchar(255), school_name varchar(255));
update sch_eoc_comp_test_level t set lea_name = (select lea_unit_nm from lea l where t.exl_lea_cd=l.lea_unit_cd and t.exl_year_cd=l.lea_year_cd)
 where 1 = (select count(*) from lea l where t.exl_lea_cd=l.lea_unit_cd and t.exl_year_cd=l.lea_year_cd);
select count(*) from sch_eoc_comp_test_level where lea_name is null;
update sch_eoc_comp_test_level t set school_name = (select ste_site_nm from site s where t.exl_lea_cd=s.ste_unit_cd and t.exl_year_cd=s.ste_year_cd and t.exl_sch_cd=s.ste_site_cd)
 where 1 = (select count(*) from site s where t.exl_lea_cd=s.ste_unit_cd and t.exl_year_cd=s.ste_year_cd and t.exl_sch_cd=s.ste_site_cd);
select count(*) from sch_eoc_comp_test_level where school_name is null;

-- sch_eoc_summ_disagg
--   93 rows where lea_cd/year_cd doesn't match a row in the "lea" table
--   2456 rows where lea_cd/year_cd/site_cd doesn't match a row in the "site" table
alter table sch_eoc_summ_disagg add (lea_name varchar(255), school_name varchar(255));
update sch_eoc_summ_disagg t set lea_name = (select lea_unit_nm from lea l where t.ecd_lea_cd=l.lea_unit_cd and t.ecd_year_cd=l.lea_year_cd)
 where 1 = (select count(*) from lea l where t.ecd_lea_cd=l.lea_unit_cd and t.ecd_year_cd=l.lea_year_cd);
select count(*) from sch_eoc_summ_disagg where lea_name is null;
update sch_eoc_summ_disagg t set school_name = (select ste_site_nm from site s where t.ecd_lea_cd=s.ste_unit_cd and t.ecd_year_cd=s.ste_year_cd and t.ecd_sch_cd=s.ste_site_cd)
 where 1 = (select count(*) from site s where t.ecd_lea_cd=s.ste_unit_cd and t.ecd_year_cd=s.ste_year_cd and t.ecd_sch_cd=s.ste_site_cd);
select count(*) from sch_eoc_summ_disagg where school_name is null;

-- sch_eoc_tested_nottested
--   278 rows where lea_cd/year_cd doesn't match a row in the "lea" table
--   6824 rows where lea_cd/year_cd/site_cd doesn't match a row in the "site" table
alter table sch_eoc_tested_nottested add (lea_name varchar(255), school_name varchar(255));
update sch_eoc_tested_nottested t set lea_name = (select lea_unit_nm from lea l where t.ect_lea_cd=l.lea_unit_cd and t.ect_year_cd=l.lea_year_cd)
 where 1 = (select count(*) from lea l where t.ect_lea_cd=l.lea_unit_cd and t.ect_year_cd=l.lea_year_cd);
select count(*) from sch_eoc_tested_nottested where lea_name is null;
update sch_eoc_tested_nottested t set school_name = (select ste_site_nm from site s where t.ect_lea_cd=s.ste_unit_cd and t.ect_year_cd=s.ste_year_cd and t.ect_sch_cd=s.ste_site_cd)
 where 1 = (select count(*) from site s where t.ect_lea_cd=s.ste_unit_cd and t.ect_year_cd=s.ste_year_cd and t.ect_sch_cd=s.ste_site_cd);
select count(*) from sch_eoc_tested_nottested where school_name is null;

-- sch_eog_composite_summ
--   12 rows where lea_cd/year_cd doesn't match a row in the "lea" table
--   16 rows where lea_cd/year_cd/site_cd doesn't match a row in the "site" table
alter table sch_eog_composite_summ add (lea_name varchar(255), school_name varchar(255));
update sch_eog_composite_summ t set lea_name = (select lea_unit_nm from lea l where t.egc_lea_cd=l.lea_unit_cd and t.egc_year_cd=l.lea_year_cd)
 where 1 = (select count(*) from lea l where t.egc_lea_cd=l.lea_unit_cd and t.egc_year_cd=l.lea_year_cd);
select count(*) from sch_eog_composite_summ where lea_name is null;
update sch_eog_composite_summ t set school_name = (select ste_site_nm from site s where t.egc_lea_cd=s.ste_unit_cd and t.egc_year_cd=s.ste_year_cd and t.egc_sch_cd=s.ste_site_cd)
 where 1 = (select count(*) from site s where t.egc_lea_cd=s.ste_unit_cd and t.egc_year_cd=s.ste_year_cd and t.egc_sch_cd=s.ste_site_cd);
select count(*) from sch_eog_composite_summ where school_name is null;

-- sch_eog_promotion_disagg
--   3 rows where lea_cd/year_cd doesn't match a row in the "lea" table
--   360 rows where lea_cd/year_cd/site_cd doesn't match a row in the "site" table
alter table sch_eog_promotion_disagg add (lea_name varchar(255), school_name varchar(255));
update sch_eog_promotion_disagg t set lea_name = (select lea_unit_nm from lea l where t.egp_lea_cd=l.lea_unit_cd and t.egp_year_cd=l.lea_year_cd)
 where 1 = (select count(*) from lea l where t.egp_lea_cd=l.lea_unit_cd and t.egp_year_cd=l.lea_year_cd);
select count(*) from sch_eog_promotion_disagg where lea_name is null;
update sch_eog_promotion_disagg t set school_name = (select ste_site_nm from site s where t.egp_lea_cd=s.ste_unit_cd and t.egp_year_cd=s.ste_year_cd and t.egp_sch_cd=s.ste_site_cd)
 where 1 = (select count(*) from site s where t.egp_lea_cd=s.ste_unit_cd and t.egp_year_cd=s.ste_year_cd and t.egp_sch_cd=s.ste_site_cd);
select count(*) from sch_eog_promotion_disagg where school_name is null;

-- sch_eog_summ_disagg
--   136 rows where lea_cd/year_cd doesn't match a row in the "lea" table
--   1831 rows where lea_cd/year_cd/site_cd doesn't match a row in the "site" table
alter table sch_eog_summ_disagg add (lea_name varchar(255), school_name varchar(255));
update sch_eog_summ_disagg t set lea_name = (select lea_unit_nm from lea l where t.egd_lea_cd=l.lea_unit_cd and t.egd_year_cd=l.lea_year_cd)
 where 1 = (select count(*) from lea l where t.egd_lea_cd=l.lea_unit_cd and t.egd_year_cd=l.lea_year_cd);
select count(*) from sch_eog_summ_disagg where lea_name is null;
update sch_eog_summ_disagg t set school_name = (select ste_site_nm from site s where t.egd_lea_cd=s.ste_unit_cd and t.egd_year_cd=s.ste_year_cd and t.egd_sch_cd=s.ste_site_cd)
 where 1 = (select count(*) from site s where t.egd_lea_cd=s.ste_unit_cd and t.egd_year_cd=s.ste_year_cd and t.egd_sch_cd=s.ste_site_cd);
select count(*) from sch_eog_summ_disagg where school_name is null;

-- sch_eog_tested_nottested
--   392 rows where lea_cd/year_cd doesn't match a row in the "lea" table
--   9130 rows where lea_cd/year_cd/site_cd doesn't match a row in the "site" table
alter table sch_eog_tested_nottested add (lea_name varchar(255), school_name varchar(255));
update sch_eog_tested_nottested t set lea_name = (select lea_unit_nm from lea l where t.egt_lea_cd=l.lea_unit_cd and t.egt_year_cd=l.lea_year_cd)
 where 1 = (select count(*) from lea l where t.egt_lea_cd=l.lea_unit_cd and t.egt_year_cd=l.lea_year_cd);
select count(*) from sch_eog_tested_nottested where lea_name is null;
update sch_eog_tested_nottested t set school_name = (select ste_site_nm from site s where t.egt_lea_cd=s.ste_unit_cd and t.egt_year_cd=s.ste_year_cd and t.egt_sch_cd=s.ste_site_cd)
 where 1 = (select count(*) from site s where t.egt_lea_cd=s.ste_unit_cd and t.egt_year_cd=s.ste_year_cd and t.egt_sch_cd=s.ste_site_cd);
select count(*) from sch_eog_tested_nottested where school_name is null;

-- sch_eog_test_level
--   552 rows where lea_cd/year_cd doesn't match a row in the "lea" table
--   8256 rows where lea_cd/year_cd/site_cd doesn't match a row in the "site" table
alter table sch_eog_test_level add (lea_name varchar(255), school_name varchar(255));
update sch_eog_test_level t set lea_name = (select lea_unit_nm from lea l where t.egl_lea_cd=l.lea_unit_cd and t.egl_year_cd=l.lea_year_cd)
 where 1 = (select count(*) from lea l where t.egl_lea_cd=l.lea_unit_cd and t.egl_year_cd=l.lea_year_cd);
select count(*) from sch_eog_test_level where lea_name is null;
update sch_eog_test_level t set school_name = (select ste_site_nm from site s where t.egl_lea_cd=s.ste_unit_cd and t.egl_year_cd=s.ste_year_cd and t.egl_sch_cd=s.ste_site_cd)
 where 1 = (select count(*) from site s where t.egl_lea_cd=s.ste_unit_cd and t.egl_year_cd=s.ste_year_cd and t.egl_sch_cd=s.ste_site_cd);
select count(*) from sch_eog_test_level where school_name is null;

