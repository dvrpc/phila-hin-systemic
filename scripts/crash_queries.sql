select cph.crash_year, count(*)
from crash_phila_hin cph 
where cph.hin_bin  = 'Future systemic safety improvements'
and cph.max_severity_level in ('1','2','3','4','8')
group by cph.crash_year
order by cph.crash_year asc


select 
	--cph.crash_year,
	sum(case when cph.max_severity_level in ('1','2') then 1 else 0 end) as KSI,
	sum(case when cph.max_severity_level in ('3','4','8','9') then 1 else 0 end) as NonKSI_Injury,
	count(*) as total
from crash_phila_hin cph 
where cph.hin_bin  = 'Future systemic safety improvements'
and cph.max_severity_level in ('1','2','3','4','8','9')
--group by cph.crash_year
--order by cph.crash_year asc