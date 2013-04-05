alter table lea add primary key (lea_unit_cd, lea_year_cd);
alter table site add primary key (ste_unit_cd, ste_site_cd, ste_year_cd);
-- lea_unit_cd 269 from "site" does not exist in lea table
insert into lea (lea_unit_cd, lea_year_cd, lea_unit_nm, lea_street_ad, lea_scity_ad,
 lea_state_ad, lea_szip_ad, lea_vphone_ad, lea_type_cd, lea_email_ad, lea_closed_ind,
lea_new_ind, lea_super_nm, lea_url_ad, lea_cover_letter_ad)
values (269, '2006-2007',  'Camp Lejeune Dependents Schools', '', 'Camp Lejeune',
'NC', '28547', '', 'P', 'NCDDESS.Supt@am.dodea.edu', 0,
0, 'Emily Marsh', '', '');
alter table site add foreign key (ste_unit_cd, ste_year_cd) references lea (lea_unit_cd, lea_year_cd);
-- lap_lea_cd 209 from lea_adequate_progress does not exist in lea table
delete from lea_adequate_progress where lap_lea_cd=209;

alter table city_xref_lea add foreign key (sxl_lea_cd, sxl_year_cd) references lea (lea_unit_cd, lea_year_cd);

alter table lea_adequate_progress add foreign key (lap_lea_cd, lap_year_cd) references lea (lea_unit_cd, lea_year_cd);

select lap_lea_cd from lea_adequate_progress where lap_lea_cd not in (
select lea_unit_cd from lea);
select * from lea_adequate_progress where lap_lea_cd=209;


select * from lea order by lea_unit_cd, lea_year_cd;
select * from site order by ste_unit_cd, ste_site_cd, ste_year_cd;

select ste_unit_cd from site where ste_unit_cd not in (select lea_unit_cd from lea);

select * from site where ste_unit_cd=269;
select * from lea where lea_unit_cd=269;



select * from site where ste_site_nm like 'Lejeune%';