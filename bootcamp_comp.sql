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

SELECT schools.school_name, COUNT(overall_score) AS total_reviews, round(AVG(overall_score),2) as overall_score, round(AVG(curric_score),2) as curric_score, round(AVG(job_score),2) as job_score
FROM bootcamp.comments
inner join bootcamp.programs
on comments.program_id = programs.program_id
inner join bootcamp.schools
on comments.school_id = schools.school_id
where programs.category = "web development"
group by schools.school_name
order by overall_score DESC
Limit 10;
