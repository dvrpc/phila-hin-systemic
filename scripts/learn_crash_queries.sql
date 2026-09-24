-- PennDOT Crash Data Dictionary: https://gis.penndot.pa.gov/gishub/crashZip/Crash_Data_Dictionary_2026.pdf

--select all
select *
from crash_pennsylvania cp 
limit 10

-- select attributes
select cp.crn, cp.district, cp.county, cp.crash_year, cp.max_severity_level 
from crash_pennsylvania cp 
limit 10

-- select with a condition
select cp.*
from crash_pennsylvania cp
where cp.crash_year = 2020

-- what years are in the dataset?
select distinct cp.crash_year
from crash_pennsylvania cp

-- select last 5 years
select cp.*
from crash_pennsylvania cp
where cp.crash_year in ('2020', '2021', '2022', '2023', '2024')

-- group by year and count crashes
select cp.crash_year, count(*) as crash_count
from crash_pennsylvania cp
where cp.crash_year in ('2020', '2021', '2022', '2023', '2024')
group by cp.crash_year

--now group by and include severity level (KSI)
select cp.crash_year, cp.max_severity_level, count(*) as crash_count
from crash_pennsylvania cp
where cp.crash_year in ('2020', '2021', '2022', '2023', '2024')
group by cp.crash_year, cp.max_severity_level

--MAX_SEVERITY_LEVEL
--0 – Property Damage Only
--1 – Fatal
--2 – Suspected Serious Injury
--3 – Suspected Minor Injury
--4 – Possible Injury
--5 – Died Prior to Crash
--8 – Injury – Unknown Severity
--9 – Unknown if Injured

--just KSI
select cp.crash_year, cp.max_severity_level, count(*) as crash_count
from crash_pennsylvania cp
where cp.crash_year in ('2020', '2021', '2022', '2023', '2024')
and cp.max_severity_level in ('1', '2')
group by cp.crash_year, cp.max_severity_level

-- just ksi but format differently so its easier to read
select 
    cp.crash_year,
    count(*) filter (where cp.max_severity_level = '1') as fatal,
    count(*) filter (where cp.max_severity_level = '2') as suspected_serious_injury,
    count(*) as total_crashes
from crash_pennsylvania cp
where cp.crash_year in ('2020', '2021', '2022', '2023', '2024')
group by cp.crash_year
order by cp.crash_year;
--same thing using case instead of filter
select 
    cp.crash_year,
    sum(case when cp.max_severity_level = '1' then 1 else 0 end) as fatal,
    sum(case when cp.max_severity_level = '2' then 1 else 0 end) as suspected_serious_injury,
    count(*) as total_crashes
from crash_pennsylvania cp
where cp.crash_year in ('2020', '2021', '2022', '2023', '2024')
group by cp.crash_year
order by cp.crash_year;

-- add percent fatal or serious injury column
select 
    cp.crash_year,
    count(*) filter (where cp.max_severity_level = '1') as fatal,
    count(*) filter (where cp.max_severity_level = '2') as suspected_serious_injury,
    count(*) as total_crashes,
    round(100.0 * count(*) filter (where cp.max_severity_level in ('1', '2')) / count(*), 2) as pct_fatal_or_serious
from crash_pennsylvania cp
where cp.crash_year in ('2020', '2021', '2022', '2023', '2024')
group by cp.crash_year
order by cp.crash_year;

-- basic join
select cp.crn, cp.max_severity_level, cpp.crn, cpp.person_num, cpp.age, cpp.inj_severity
from crash_pennsylvania cp
join crash_pa_persons cpp 
on cp.crn = cpp.crn

--join with condition
select *
from(
	select cp.crn, cp.max_severity_level, cpp.crn as crn2, cpp.person_num, cpp.age, cpp.inj_severity
	from crash_pennsylvania cp
	join crash_pa_person cpp 
	on cp.crn = cpp.crn) as foo
where foo.crn = '2019001777'

--show in Q