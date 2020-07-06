--Script to create the materialized view adults_first_admission_v2
--that contains the adult patients [15,90] and only their first admission

drop materialized view if exists mimic.mimiciii.adults_first_admission_v2;

create materialized view mimic.mimiciii.adults_first_admission_v2 as
with first_admission as (
	select * from 
	(select p.subject_id, p.dob, p.gender, p.dod, p.dod_hosp, a.hadm_id,
	    a.admittime, p.expire_flag,
	    min (a.admittime) OVER (partition by p.subject_id) as first_admittime,
		a.dischtime,
		round((cast(a.admittime as date) - cast(p.dob as date))/365.242) as age,
		a.admission_type
	from mimic.mimiciii.admissions a
	inner join mimic.mimiciii.patients p
	on p.subject_id = a.subject_id
	order by p.subject_id, a.hadm_id
	) as A
	where admittime = first_admittime
)
	select b.*, 
			round((cast(b.dischtime as date) - cast(b.first_admittime as date)), 2) as los_adm,
			a.icustay_id, a.los as los_icu,
			case when dod_hosp <= dischtime then 1 else 0 end as clase,
			a.first_careunit as care_unit
		from (
		select ie.subject_id, ie.hadm_id, ie.icustay_id, ie.los, ie.first_careunit 
			from mimic.mimiciii.icustays ie
			inner join mimic.mimiciii.patients pat
			on ie.subject_id = pat.subject_id) as a
		inner join first_admission b
		on a.subject_id = b.subject_id and a.hadm_id = b.hadm_id
		where age between 15 and 90;

select count(*) from adults_first_admission_v2
 where cast(dod_hosp as date) - cast(admittime as date) < 1;