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
