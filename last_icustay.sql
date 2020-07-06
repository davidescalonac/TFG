--Gets icustay_id from last icustay 

drop materialized view if exists last_icustay;

create materialized view last_icustay as
select icustay_id from (
	select hadm_id, icustay_id, intime, outtime,
	 max (intime) OVER (partition by hadm_id) as last_intime
	 from icustays
	 where icustay_id in (select distinct icustay_id from adults_first_admission_v2)) as a
  where intime = last_intime;