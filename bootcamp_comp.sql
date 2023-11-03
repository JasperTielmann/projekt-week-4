SELECT anonymous, round(AVG(overall_score),2) as overall_score, round(AVG(curric_score),2) as curric_score, round(AVG(job_score),2) as job_score
FROM bootcamp.comments
group by anonymous;

SELECT programs.category, round(AVG(overall_score),2) as overall_score, round(AVG(curric_score),2) as curric_score, round(AVG(job_score),2) as job_score
FROM bootcamp.comments
inner join bootcamp.programs
on comments.program_id = programs.program_id
inner join bootcamp.schools
on comments.school_id = schools.school_id
WHERE schools.school_name = "ironhack"
group by programs.category;

With top_webs AS(
SELECT programs.school_id, COUNT(overall_score) AS total_reviews, round(AVG(overall_score),2) as overall_score, round(AVG(curric_score),2) as curric_score, round(AVG(job_score),2) as job_score
FROM bootcamp.comments
inner join bootcamp.programs
on comments.program_id = programs.program_id
where programs.category = "web development"
group by programs.school_id
order by overall_score DESC
Limit 10)

SELECT schools.school_name, GROUP_CONCAT(location.city_name SEPARATOR ', ') as cities from top_webs
inner join bootcamp.location
on top_webs.school_id = location.school_id
inner join bootcamp.schools
on top_webs.school_id = schools.school_id
group by top_webs.school_id;


With top_datas AS(
SELECT programs.school_id, COUNT(overall_score) AS total_reviews, round(AVG(overall_score),2) as overall_score, round(AVG(curric_score),2) as curric_score, round(AVG(job_score),2) as job_score
FROM bootcamp.comments
inner join bootcamp.programs
on comments.program_id = programs.program_id
where programs.category = "data"
group by programs.school_id
order by overall_score DESC
Limit 10)

SELECT schools.school_name, GROUP_CONCAT(location.city_name SEPARATOR ', ') as cities from top_datas
inner join bootcamp.location
on top_datas.school_id = location.school_id
inner join bootcamp.schools
on top_datas.school_id = schools.school_id
group by top_datas.school_id;

With top_uxs AS(
SELECT programs.school_id, COUNT(overall_score) AS total_reviews, round(AVG(overall_score),2) as overall_score, round(AVG(curric_score),2) as curric_score, round(AVG(job_score),2) as job_score
FROM bootcamp.comments
inner join bootcamp.programs
on comments.program_id = programs.program_id
where programs.category = "UX/UI Design"
group by programs.school_id
order by overall_score DESC
Limit 10)

SELECT schools.school_name, GROUP_CONCAT(location.city_name SEPARATOR ', ') as cities from top_uxs
inner join bootcamp.location
on top_uxs.school_id = location.school_id
inner join bootcamp.schools
on top_uxs.school_id = schools.school_id
group by top_uxs.school_id;

#DATE VALUES: CONVERTING STRING TO DATE AND SAVING TO VIEW
CREATE VIEW vw_comments AS
SELECT *,LAST_DAY(STR_TO_DATE(comment_date, '%m/%d/%Y')) as comment_month from bootcamp.comments;
SELECT anonymous, count(comment_id) as num_comments from bootcamp.comments group by anonymous;
#comparing avg overall score for Ironhack anon vs non-anon - is there a trend we can test?
SELECT DISTINCT anonymous, AVG(overall_score) 
FROM bootcamp.comments
WHERE school_id=10828
GROUP BY anonymous;
#see historically trend over time in Tableau
#which Ironhack location has higher reviews per category?
SELECT
p.category,
CASE WHEN country_name is null THEN "Online" ELSE country_name END AS country_name,
CASE WHEN city_name is null THEN "Online" ELSE city_name END AS city_name,
AVG(C.overall_score),AVG(c.job_score),AVG(c.curric_score)
FROM bootcamp.comments C
LEFT JOIN bootcamp.location L ON l.school_id=c.school_id
LEFT JOIN bootcamp.programs P ON p.school_id=c.school_id
WHERE c.school_id=10828 and category<>"Other"
GROUP BY p.category,
country_name,
city_name;
#most attended category? historical
SELECT CATEGORY, COUNT(C.comment_id),AVG(C.overall_score),AVG(c.job_score),AVG(c.curric_score)
FROM bootcamp.PROGRAMS P
LEFT JOIN bootcamp.COMMENTS C ON C.program_id=P.program_id
GROUP BY category;
#let's see it plotted overtime per month
SELECT CATEGORY, comment_month, COUNT(C.comment_id), AVG(C.overall_score),AVG(c.job_score),AVG(c.curric_score)
FROM bootcamp.PROGRAMS P
LEFT JOIN vw_COMMENTS C ON C.program_id=P.program_id
WHERE COMMENT_DATE IS NOT NULL
GROUP BY category, comment_month;
#let's see that overtime for Ironhack only
SELECT CATEGORY, comment_month, COUNT(C.comment_id), AVG(C.overall_score),AVG(c.job_score),AVG(c.curric_score)
FROM PROGRAMS P
LEFT JOIN vw_COMMENTS C ON C.program_id=P.program_id
WHERE COMMENT_DATE IS NOT NULL and c.school_id=10828
GROUP BY category, comment_month;

#EXPORTING WITH FILTERS TO CSV TO LOAD TO TABLEAU
#comments table:
select c.* from vw_comments c left join bootcamp.programs p on p.program_id=c.program_id
where  year is not null and category is not null and category<>"Other";
#location table:
select location_id, CASE WHEN country_name is null then "Online" ELSE country_name END AS country_name,
CASE WHEN city_name is null then "Online" ELSE city_name END AS city_name,
school_id
from bootcamp.location;
#schools table:
select * from bootcamp.schools;
#programs table:
select * from bootcamp.programs where category is not null and category<>"Other"
