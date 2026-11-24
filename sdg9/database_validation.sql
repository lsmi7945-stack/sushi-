-- SDG 9 School Technology Infrastructure Database
-- 05_database_validation.sql
-- Purpose: Verify database structure, data integrity,
-- relationships, constraints and view accuracy.

USE sdg9_school_tech_revised;
-- Test 1: Verify all required tables and views exist.

SHOW FULL TABLES;

-- Test 2: Verify expected mock data record counts.

SELECT 'schools' AS table_name,
       COUNT(*) AS actual_count,
       15 AS expected_count,
       IF(COUNT(*) = 15, 'PASS', 'FAIL') AS status
FROM schools

UNION ALL

SELECT 'surveys', COUNT(*), 60,
       IF(COUNT(*) = 60, 'PASS', 'FAIL')
FROM surveys

UNION ALL

SELECT 'issues', COUNT(*), 12,
       IF(COUNT(*) = 12, 'PASS', 'FAIL')
FROM issues

UNION ALL

SELECT 'solutions', COUNT(*), 7,
       IF(COUNT(*) = 7, 'PASS', 'FAIL')
FROM solutions

UNION ALL

SELECT 'survey_issues', COUNT(*), 115,
       IF(COUNT(*) = 115, 'PASS', 'FAIL')
FROM survey_issues

UNION ALL

SELECT 'issue_solutions', COUNT(*), 25,
       IF(COUNT(*) = 25, 'PASS', 'FAIL')
FROM issue_solutions;

-- Test 3: Verify there are no duplicate primary keys.

SELECT 'schools' AS table_name,
       COUNT(*) - COUNT(DISTINCT school_id) AS duplicates
FROM schools

UNION ALL

SELECT 'surveys',
       COUNT(*) - COUNT(DISTINCT survey_id)
FROM surveys

UNION ALL

SELECT 'issues',
       COUNT(*) - COUNT(DISTINCT issue_id)
FROM issues

UNION ALL

SELECT 'solutions',
       COUNT(*) - COUNT(DISTINCT solution_id)
FROM solutions

UNION ALL

SELECT 'survey_issues',
       COUNT(*) - COUNT(DISTINCT survey_id, issue_id)
FROM survey_issues

UNION ALL

SELECT 'issue_solutions',
       COUNT(*) - COUNT(DISTINCT issue_id, solution_id)
FROM issue_solutions;

-- Test 4: Verify foreign key integrity.

SELECT 'surveys -> schools' AS relationship,
       COUNT(*) AS invalid_references
FROM surveys sv
LEFT JOIN schools s
    ON sv.school_id = s.school_id
WHERE s.school_id IS NULL

UNION ALL

SELECT 'survey_issues -> surveys',
       COUNT(*)
FROM survey_issues si
LEFT JOIN surveys sv
    ON si.survey_id = sv.survey_id
WHERE sv.survey_id IS NULL

UNION ALL

SELECT 'survey_issues -> issues',
       COUNT(*)
FROM survey_issues si
LEFT JOIN issues i
    ON si.issue_id = i.issue_id
WHERE i.issue_id IS NULL

UNION ALL

SELECT 'issue_solutions -> issues',
       COUNT(*)
FROM issue_solutions isol
LEFT JOIN issues i
    ON isol.issue_id = i.issue_id
WHERE i.issue_id IS NULL

UNION ALL

SELECT 'issue_solutions -> solutions',
       COUNT(*)
FROM issue_solutions isol
LEFT JOIN solutions sol
    ON isol.solution_id = sol.solution_id
WHERE sol.solution_id IS NULL;

-- Test 5: Verify required fields are populated.

SELECT 'schools' AS table_name,
       COUNT(*) AS missing_required_values
FROM schools
WHERE school_id IS NULL
   OR school_name IS NULL
   OR TRIM(school_name) = ''
   OR students IS NULL
   OR devices IS NULL

UNION ALL

SELECT 'surveys', COUNT(*)
FROM surveys
WHERE survey_id IS NULL
   OR school_id IS NULL
   OR role IS NULL
   OR TRIM(role) = ''
   OR wifi_works IS NULL
   OR TRIM(wifi_works) = ''
   OR issue_description IS NULL
   OR TRIM(issue_description) = ''
   OR survey_date IS NULL

UNION ALL

SELECT 'issues', COUNT(*)
FROM issues
WHERE issue_id IS NULL
   OR issue_name IS NULL
   OR TRIM(issue_name) = ''
   OR description IS NULL
   OR TRIM(description) = ''

UNION ALL

SELECT 'solutions', COUNT(*)
FROM solutions
WHERE solution_id IS NULL
   OR solution_name IS NULL
   OR TRIM(solution_name) = ''
   OR description IS NULL
   OR TRIM(description) = ''

UNION ALL

SELECT 'survey_issues', COUNT(*)
FROM survey_issues
WHERE survey_id IS NULL
   OR issue_id IS NULL

UNION ALL

SELECT 'issue_solutions', COUNT(*)
FROM issue_solutions
WHERE issue_id IS NULL
   OR solution_id IS NULL
   OR mapping_rationale IS NULL
   OR TRIM(mapping_rationale) = '';

-- Test 6: Verify data complies with CHECK constraints.

SELECT 'Positive student enrollment' AS validation_rule,
       COUNT(*) AS violations
FROM schools
WHERE students <= 0

UNION ALL

SELECT 'Nonnegative device count', COUNT(*)
FROM schools
WHERE devices < 0

UNION ALL

SELECT 'Nonnegative device age', COUNT(*)
FROM schools
WHERE device_age < 0

UNION ALL

SELECT 'Nonnegative internet speed', COUNT(*)
FROM schools
WHERE internet_speed < 0

UNION ALL

SELECT 'Nonnegative technology budget', COUNT(*)
FROM schools
WHERE budget < 0

UNION ALL

SELECT 'Valid staff role', COUNT(*)
FROM surveys
WHERE role NOT IN ('Teacher', 'Administrator', 'IT Staff')

UNION ALL

SELECT 'Valid Wi-Fi response', COUNT(*)
FROM surveys
WHERE wifi_works NOT IN ('yes', 'no');

-- Test 7: Verify survey-to-issue relationship completeness.

SELECT 'Surveys without assigned issues' AS validation_rule,
       COUNT(*) AS violations
FROM surveys sv
LEFT JOIN survey_issues si
    ON sv.survey_id = si.survey_id
WHERE si.survey_id IS NULL

UNION ALL

SELECT 'Issues not reported in any survey',
       COUNT(*)
FROM issues i
LEFT JOIN survey_issues si
    ON i.issue_id = si.issue_id
WHERE si.issue_id IS NULL;

-- Test 8: Verify issue-to-solution relationship completeness.

SELECT 'Issues without potential solutions' AS validation_rule,
       COUNT(*) AS violations
FROM issues i
LEFT JOIN issue_solutions isol
    ON i.issue_id = isol.issue_id
WHERE isol.issue_id IS NULL

UNION ALL

SELECT 'Solutions without associated issues',
       COUNT(*)
FROM solutions sol
LEFT JOIN issue_solutions isol
    ON sol.solution_id = isol.solution_id
WHERE isol.solution_id IS NULL;

-- Test 9: Verify survey descriptions match assigned issues.

WITH expected_descriptions AS (
    SELECT
        si.survey_id,
        CONCAT(
            GROUP_CONCAT(
                CASE si.issue_id
                    WHEN 1 THEN 'The Wi-Fi is very slow during the school day'
                    WHEN 2 THEN 'Our internet connection frequently disconnects'
                    WHEN 3 THEN 'Many of our computers are outdated'
                    WHEN 4 THEN 'Classroom computers take too long to load'
                    WHEN 5 THEN 'There are not enough devices for all students'
                    WHEN 6 THEN 'Students lose time waiting to share devices'
                    WHEN 7 THEN 'Our educational software is outdated'
                    WHEN 8 THEN 'Some software does not work with our computers'
                    WHEN 9 THEN 'It takes too long to receive technical support'
                    WHEN 10 THEN 'Some areas of the school have poor Wi-Fi coverage'
                    WHEN 11 THEN 'Our network equipment frequently experiences failures'
                    WHEN 12 THEN 'Staff need more training on how to use technology'
                END
                ORDER BY si.issue_id
                SEPARATOR '. '
            ),
            '.'
        ) AS expected_description
    FROM survey_issues si
    GROUP BY si.survey_id
)

SELECT
    COUNT(*) AS inconsistent_descriptions
FROM surveys sv
LEFT JOIN expected_descriptions ed
    ON sv.survey_id = ed.survey_id
WHERE NOT (
    BINARY sv.issue_description
    <=> BINARY ed.expected_description
);

-- Test 10: Verify school_solutions_summary accuracy.

WITH expected_summary AS (
    SELECT
        s.school_id,
        s.school_name,
        sol.solution_id,
        sol.solution_name,
        COUNT(*) AS issue_solution_matches,
        COUNT(DISTINCT si.issue_id) AS unique_issues_addressed,
        COUNT(DISTINCT sv.survey_id) AS surveys_reporting
    FROM schools s
    JOIN surveys sv
        ON s.school_id = sv.school_id
    JOIN survey_issues si
        ON sv.survey_id = si.survey_id
    JOIN issue_solutions isol
        ON si.issue_id = isol.issue_id
    JOIN solutions sol
        ON isol.solution_id = sol.solution_id
    GROUP BY
        s.school_id,
        s.school_name,
        sol.solution_id,
        sol.solution_name
)

SELECT
    'Missing or incorrect view records' AS validation_rule,
    COUNT(*) AS violations
FROM expected_summary e
LEFT JOIN school_solutions_summary v
    ON e.school_id = v.school_id
    AND e.solution_id = v.solution_id
WHERE v.school_id IS NULL
   OR NOT (e.school_name <=> v.school_name)
   OR NOT (e.solution_name <=> v.solution_name)
   OR NOT (e.issue_solution_matches <=> v.issue_solution_matches)
   OR NOT (e.unique_issues_addressed <=> v.unique_issues_addressed)
   OR NOT (e.surveys_reporting <=> v.surveys_reporting)

UNION ALL

SELECT
    'Unexpected view records',
    COUNT(*)
FROM school_solutions_summary v
LEFT JOIN expected_summary e
    ON v.school_id = e.school_id
    AND v.solution_id = e.solution_id
WHERE e.school_id IS NULL

UNION ALL

SELECT
    'Duplicate school-solution combinations',
    COUNT(*) - COUNT(DISTINCT school_id, solution_id)
FROM school_solutions_summary;


