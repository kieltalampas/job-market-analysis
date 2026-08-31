-- How large is the sample for each role?
SELECT
  search_role,
  COUNT(*),
  ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS pct_of_total
FROM `gcp-project-507113.tech_job_market_ph.jobs_clean`
GROUP BY search_role
ORDER BY pct_of_total DESC

-- The dataset is reasonably balanced across Data Engineer, Data Analyst, Software Engineer, and Cloud Engineer, 
-- which each represent roughly 20–22% of the sample. Data Scientist is underrepresented at 13.79%, 
-- so cross-role comparisons should use percentages rather than raw counts.

-- Which technical skills are the most in demand overall?
SELECT
  s.skill,
  COUNT(DISTINCT s.job_id) AS jobs_requiring_skill,
  ROUND(
    COUNT(DISTINCT s.job_id) * 100.0 /
    (SELECT COUNT(DISTINCT job_id)
     FROM `gcp-project-507113.tech_job_market_ph.jobs_clean`),
    2
  ) AS pct_of_all_jobs
FROM `gcp-project-507113.tech_job_market_ph.job_skills` s
GROUP BY s.skill
ORDER BY jobs_requiring_skill DESC;
-- SQL is the most frequently detected technical skill, appearing in approximately 44% of all collected postings, 
-- followed by Python at roughly 39%.

-- What are the top skills for each role
WITH top_five AS (
  SELECT 
    search_role,
    skill,
    COUNT(*) AS total,
    DENSE_RANK() OVER(
        PARTITION BY search_role
        ORDER BY COUNT(*) DESC
    ) AS skill_rank
  FROM `gcp-project-507113.tech_job_market_ph.job_skills` 
  GROUP BY 1, 2
)

SELECT
  search_role,
  skill,
  total 
FROM top_five 
WHERE skill_rank <= 5
ORDER BY search_role, total DESC;

-- Data Engineer: SQL and Python rank highly alongside Azure, AWS, and Databricks. 
-- This suggests the collected DE postings combine programming/database fundamentals with cloud and data-platform technologies.


-- Excel, SQL, and Power BI ranking highly suggests a strong emphasis on data querying, spreadsheet analysis, and BI/reporting tools.

-- Python, SQL, and Machine Learning align closely with the technical core of data science, 
-- while Excel and Power BI indicate that some postings also expect reporting or business-facing analytical capabilities.

























