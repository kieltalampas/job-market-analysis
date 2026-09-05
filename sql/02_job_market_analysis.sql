WITH skills_cte AS (
  SELECT 
    search_role,
    skill,
    COUNT(DISTINCT(job_id)) job_posts_requiring_skill
  FROM `gcp-project-507113.tech_job_market_ph.job_skills`
  GROUP BY 1,2 
),
roles_cte AS (
  SELECT 
    search_role,
    COUNT(DISTINCT job_id) AS total_job_posts
  FROM `gcp-project-507113.tech_job_market_ph.jobs_clean`
  GROUP BY 1
)

SELECT 
  s.search_role,
  s.skill,
  s.job_posts_requiring_skill,
  r.total_job_posts,
  ROUND(s.job_posts_requiring_skill * 100.0 / r.total_job_posts, 2) AS skill_perc
FROM skills_cte s 
JOIN roles_cte r 
  ON s.search_role = r.search_role
ORDER BY s.search_role, skill_perc DESC


WITH skills_count AS (
  SELECT 
    j.job_id,
    j.search_role,
    COUNT(DISTINCT s.skill) skill_count
  FROM `gcp-project-507113.tech_job_market_ph.jobs_clean` j
  LEFT JOIN `gcp-project-507113.tech_job_market_ph.job_skills` s 
    ON j.job_id = s.job_id
  GROUP BY 1, 2
)

SELECT 
  search_role,
  ROUND(AVG(skill_count), 2) avg_extracted_skills,
  APPROX_QUANTILES(skill_count, 2)[OFFSET(1)] median_extracted_skills
FROM skills_count  
GROUP BY 1 
ORDER BY 2 DESC








































