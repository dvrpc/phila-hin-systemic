-- This script contains queries used to analyze crashes in Philadelphia that are associated with the HIN bin "Future systemic safety improvements". 
-- The queries are used to help the project team identify focus crash types
-- Queries are based on PennDOT crash data from 2021-2025 and the HIN network binning from OTIS


-- injury crashes by year
select cph.crash_year, count(*)
from crash_phila_hin cph 
where cph.hin_bin  = 'Future systemic safety improvements'
and cph.max_severity_level in ('1','2','3','4','8')
group by cph.crash_year
order by cph.crash_year asc

--injury crashes by severity over 5 year period
select 
	sum(case when cph.max_severity_level in ('1','2') then 1 else 0 end) as KSI,
	sum(case when cph.max_severity_level in ('3','4','8','9') then 1 else 0 end) as NonKSI_Injury,
	count(*) as total
from crash_phila_hin cph 
where cph.hin_bin  = 'Future systemic safety improvements'
and cph.max_severity_level in ('1','2','3','4','8','9')


-- injury crashes by severity by year
select 
	cph.crash_year,
	sum(case when cph.max_severity_level in ('1','2') then 1 else 0 end) as KSI,
	sum(case when cph.max_severity_level in ('3','4','8','9') then 1 else 0 end) as NonKSI_Injury,
	count(*) as total
from crash_phila_hin cph 
where cph.hin_bin  = 'Future systemic safety improvements'
and cph.max_severity_level in ('1','2','3','4','8','9')
group by cph.crash_year
order by cph.crash_year asc