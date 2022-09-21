SELECT * FROM .Accidents  

-- select data for analysis

select month, day, year, sic, state, aii, deginj, subunit, injtype, narrtxt1
from Accidents
order by 1,2;

--looking at total deaths vs total accidents
WITH 
T1 AS (SELECT COUNT(injtype) as FatalAccidents from Accidents where injtype like 'occupational fatality'),
T2 AS (SELECT COUNT(*) as TotalAccidents from Accidents)
SELECT CAST(T1.FatalAccidents AS float) / CAST(T2.TotalAccidents as float) * 100 as PercentFatal
FROM T1, T2;

--looking at total accidents underground vs total accidents
WITH 
T3 AS (SELECT COUNT(*) as UGAccidents from Accidents where subunit like 'underground%'),
T4 AS (SELECT COUNT(*) as TotalAccidentLoc from Accidents)
SELECT CAST(T3.UGAccidents AS float) / CAST(T4.TotalAccidentLoc as float) * 100 as PercentAccidentUG
FROM T3, T4;


--looking at total deaths underground vs total deaths
WITH 
T5 AS (SELECT COUNT(*) as UGDeaths from Accidents where subunit like 'underground%' and deginj like '%fatal'),
T6 AS (SELECT COUNT(*) as TotalDeaths from Accidents where deginj like '%fatal')
SELECT CAST(T5.UGDeaths AS float) / CAST(T6.TotalDeaths as float) * 100 as PercentFatalUG
FROM T5, T6;


-- looking at states with most accidents
select state, count(*) as TotalAccidents
from Accidents
group by state
order by count(deginj) DESC;

-- looking at states with most fatalities
select state, count(*) as TotalFatalities
from Accidents
where deginj like '%fatal'
group by state
order by count(deginj) DESC;

--male vs female accidents
select sex, count(*) as TotalAccidentsbyGender
from Accidents
where sex is not null
group by sex;

--male vs female fatalities
select sex, count(*) as TotalAccidentsbyGender
from Accidents
where sex is not null and deginj like '%fatal'
group by sex;

--accidents by age
select round(avg(age),0) as AccidentsbyAge, deginj as InjuryType from Accidents
where age is not null
Group by deginj;

--oldest person killed in a mine accident in 2020
select round(max(age),0) as MaxFatalAge from Accidents
where age is not null and deginj like '%fatal';

--youngest person killed in a mine accident in 2020
select round(min(age),0) as MinFatalAge from Accidents
where age is not null and deginj like '%fatal';

--month with most accidents 
select month as Month, count(*) as TotalAccidents from Accidents
group by month
order by count(*) DESC;