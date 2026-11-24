USE sdg9_school_tech_revised;

SELECT 'schools' AS table_name, COUNT(*) AS records
FROM schools

UNION ALL

SELECT 'solutions', COUNT(*) FROM solutions

UNION ALL

SELECT 'issues', COUNT(*) FROM issues

UNION ALL

SELECT 'surveys', COUNT(*) FROM surveys

UNION ALL

SELECT 'survey_issues', COUNT(*) FROM survey_issues

UNION ALL

SELECT 'issue_solutions', COUNT(*) FROM issue_solutions;

USE sdg9_school_tech_revised;

SELECT *
FROM surveys
LIMIT 10;

SELECT COUNT(*) AS missing_responses
FROM surveys
WHERE issue_description IS NULL
   OR TRIM(issue_description) = '';

SELECT *
FROM school_solutions_summary
ORDER BY school_id, surveys_reporting DESC;

