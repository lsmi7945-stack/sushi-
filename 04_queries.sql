-- =====================================================================
-- SDG 9 School Technology Infrastructure Database
-- 04_queries.sql
-- Queries that answer the project's three research questions.
-- Run after 01, 02 and 03. Requires MySQL 8.0 or later (uses WITH
-- clauses and window functions such as RANK()).
-- =====================================================================

USE sdg9_school_tech_revised;

-- =====================================================================
-- QUESTION 1: What are the most commonly reported technology problems
--             and needs across schools?
-- =====================================================================

-- 1a. Most commonly reported technology problems.
-- Counts the number of surveys and schools
-- reporting each standardized issue.

SELECT
    i.issue_name,
    COUNT(DISTINCT si.survey_id) AS times_reported,
    COUNT(DISTINCT sv.school_id) AS schools_reporting

FROM issues AS i

LEFT JOIN survey_issues AS si
    ON i.issue_id = si.issue_id

LEFT JOIN surveys AS sv
    ON si.survey_id = sv.survey_id

GROUP BY i.issue_id, i.issue_name

ORDER BY times_reported DESC,
         schools_reporting DESC,
         i.issue_name;

-- 1b. Potential solutions based on reported issues.
-- Counts unique surveys and schools associated
-- with each potential solution.

SELECT
    sol.solution_name,

    COUNT(DISTINCT si.survey_id)
        AS surveys_reporting,

    ROUND(
        100 * COUNT(DISTINCT si.survey_id)
        / NULLIF((SELECT COUNT(*) FROM surveys), 0),
        1
    ) AS pct_of_surveys,

    COUNT(DISTINCT sv.school_id)
        AS schools_reporting

FROM solutions AS sol

LEFT JOIN issue_solutions AS isol
    ON sol.solution_id = isol.solution_id

LEFT JOIN survey_issues AS si
    ON isol.issue_id = si.issue_id

LEFT JOIN surveys AS sv
    ON si.survey_id = sv.survey_id

GROUP BY sol.solution_id, sol.solution_name

ORDER BY surveys_reporting DESC,
         sol.solution_name;

-- 1c. Potential technology solutions by staff role.
-- Calculates the number and percentage of respondents
-- whose reported issues could be addressed by each solution.
-- Percentages account for unequal sample sizes across roles.

WITH role_totals AS (
    SELECT
        role,
        COUNT(*) AS total_respondents
    FROM surveys
    GROUP BY role
),

role_solutions AS (
    SELECT
        sv.role,
        sol.solution_id,
        sol.solution_name,
        COUNT(DISTINCT sv.survey_id)
            AS surveys_reporting

    FROM surveys AS sv

    JOIN survey_issues AS si
        ON sv.survey_id = si.survey_id

    JOIN issue_solutions AS isol
        ON si.issue_id = isol.issue_id

    JOIN solutions AS sol
        ON isol.solution_id = sol.solution_id

    GROUP BY
        sv.role,
        sol.solution_id,
        sol.solution_name
)

SELECT
    rs.role,
    rs.solution_name,
    rs.surveys_reporting,
    rt.total_respondents,

    ROUND(
        100.0 * rs.surveys_reporting
        / NULLIF(rt.total_respondents, 0),
        1
    ) AS pct_of_role,

    RANK() OVER (
        PARTITION BY rs.role
        ORDER BY rs.surveys_reporting DESC
    ) AS rank_in_role

FROM role_solutions AS rs

JOIN role_totals AS rt
    ON rs.role = rt.role

ORDER BY
    rs.role,
    rank_in_role,
    rs.solution_name;

-- =====================================================================
-- QUESTION 2: Which schools have the greatest shortages of technology
--             resources?
-- =====================================================================

-- 2a. Students per device and average device age.
-- A higher ratio indicates greater device shortages.
-- Students per device is calculated rather than
-- stored in the database.

SELECT
    school_name,
    students,
    devices,

    ROUND(
        students / NULLIF(devices, 0), 1
    ) AS students_per_device,

    device_age AS avg_device_age_years

FROM schools

ORDER BY (devices = 0) DESC,
         students_per_device DESC;

-- 2b. Internet speed per student.
-- Compares schools against a benchmark of
-- 1 Mbps per student.

SELECT
    school_name,
    students,
    internet_speed AS internet_mbps,

    ROUND(
        internet_speed / NULLIF(students, 0), 3
    ) AS mbps_per_student,

    CASE
        WHEN internet_speed IS NULL THEN 'Unknown'
        WHEN internet_speed / students >= 1 THEN 'Yes'
        ELSE 'No'
    END AS meets_benchmark

FROM schools

ORDER BY (internet_speed IS NULL),
         mbps_per_student ASC;

-- 2c. Wi-Fi reliability by school.
-- Calculates the percentage of staff surveys
-- reporting that Wi-Fi does not work.

SELECT
    s.school_name,

    COUNT(sv.survey_id) AS surveys,

    SUM(
        CASE
            WHEN sv.wifi_works = 'no' THEN 1
            ELSE 0
        END
    ) AS said_wifi_fails,

    ROUND(
        100 * SUM(
            CASE
                WHEN sv.wifi_works = 'no' THEN 1
                ELSE 0
            END
        ) / NULLIF(COUNT(sv.survey_id), 0),
        1
    ) AS pct_wifi_fails

FROM schools AS s

LEFT JOIN surveys AS sv
    ON s.school_id = sv.school_id

GROUP BY s.school_id, s.school_name

ORDER BY pct_wifi_fails DESC,
         s.school_name;

-- 2d. Technology budget per student.
-- Identifies schools with the lowest technology
-- funding relative to student enrollment.

SELECT
    school_name,
    students,
    budget AS technology_budget,

    ROUND(
        budget / NULLIF(students, 0), 2
    ) AS budget_per_student

FROM schools

ORDER BY (budget IS NULL),
         budget_per_student ASC,
         school_name;

-- 2e. Overall technology shortage ranking.
-- Combines five technology infrastructure measures.
-- Each measure receives equal weight.
-- A lower combined rank indicates greater need.

WITH school_metrics AS (
    SELECT
        s.school_id,
        s.school_name,
        s.devices,

        s.students / NULLIF(s.devices, 0)
            AS students_per_device,

        s.device_age,

        s.internet_speed / NULLIF(s.students, 0)
            AS mbps_per_student,

        s.budget / NULLIF(s.students, 0)
            AS budget_per_student,

        100 * SUM(
            CASE
                WHEN sv.wifi_works = 'no' THEN 1
                ELSE 0
            END
        ) / NULLIF(COUNT(sv.survey_id), 0)
            AS pct_wifi_fails

    FROM schools AS s

    LEFT JOIN surveys AS sv
        ON s.school_id = sv.school_id

    GROUP BY
        s.school_id,
        s.school_name,
        s.students,
        s.devices,
        s.device_age,
        s.internet_speed,
        s.budget
),

ranked_schools AS (
    SELECT
        *,

        RANK() OVER (
            ORDER BY (devices = 0) DESC,
                     students_per_device DESC
        ) AS device_rank,

        RANK() OVER (
            ORDER BY device_age DESC
        ) AS age_rank,

        RANK() OVER (
            ORDER BY mbps_per_student ASC
        ) AS internet_rank,

        RANK() OVER (
            ORDER BY pct_wifi_fails DESC
        ) AS wifi_rank,

        RANK() OVER (
            ORDER BY budget_per_student ASC
        ) AS budget_rank

    FROM school_metrics

    WHERE device_age IS NOT NULL
      AND mbps_per_student IS NOT NULL
      AND pct_wifi_fails IS NOT NULL
      AND budget_per_student IS NOT NULL
),

scored_schools AS (
    SELECT
        *,

        device_rank
        + age_rank
        + internet_rank
        + wifi_rank
        + budget_rank AS priority_score

    FROM ranked_schools
)

SELECT
    school_id,
    school_name,
    device_rank,
    age_rank,
    internet_rank,
    wifi_rank,
    budget_rank,
    priority_score,

    RANK() OVER (
        ORDER BY priority_score ASC
    ) AS overall_priority_rank

FROM scored_schools

ORDER BY overall_priority_rank,
         school_name;

-- =====================================================================
-- QUESTION 3: Which technology improvements should be prioritized based
--             on the frequency of reported issues?
-- =====================================================================

-- 3a. Top potential technology solutions by school.
-- Uses the school_solutions_summary view to rank
-- potential solutions based on reported issues.
-- Returns the top three ranks for each school,
-- including tied solutions.

WITH ranked_solutions AS (
    SELECT
        school_id,
        school_name,
        solution_id,
        solution_name,
        issue_solution_matches,
        unique_issues_addressed,
        surveys_reporting,

        RANK() OVER (
            PARTITION BY school_id
            ORDER BY surveys_reporting DESC,
                     unique_issues_addressed DESC
        ) AS solution_rank

    FROM school_solutions_summary
)

SELECT
    school_name,
    solution_name,
    surveys_reporting,
    unique_issues_addressed,
    issue_solution_matches,
    solution_rank

FROM ranked_solutions

WHERE solution_rank <= 3

ORDER BY school_name,
         solution_rank,
         solution_name;

-- 3b. Highest-ranked potential solutions across schools.
-- Counts how many schools rank each solution first.
-- Includes ties for first place.

WITH ranked_solutions AS (
    SELECT
        school_id,
        solution_id,
        solution_name,
        surveys_reporting,
        unique_issues_addressed,

        RANK() OVER (
            PARTITION BY school_id
            ORDER BY surveys_reporting DESC,
                     unique_issues_addressed DESC
        ) AS solution_rank

    FROM school_solutions_summary
)

SELECT
    sol.solution_name,

    COUNT(DISTINCT rs.school_id)
        AS schools_ranked_first,

    ROUND(
        100 * COUNT(DISTINCT rs.school_id)
        / NULLIF((SELECT COUNT(*) FROM schools), 0),
        1
    ) AS pct_of_schools

FROM solutions AS sol

LEFT JOIN ranked_solutions AS rs
    ON sol.solution_id = rs.solution_id
    AND rs.solution_rank = 1

GROUP BY sol.solution_id,
         sol.solution_name

ORDER BY schools_ranked_first DESC,
         sol.solution_name;

-- 3c. Highest-priority schools and potential solutions.
-- Combines the overall technology shortage ranking
-- with the top three solution ranks for each school.
-- Includes ties for fifth place and tied solutions.

WITH school_metrics AS (
    SELECT
        s.school_id,
        s.school_name,
        s.devices,

        s.students / NULLIF(s.devices, 0)
            AS students_per_device,

        s.device_age,

        s.internet_speed / NULLIF(s.students, 0)
            AS mbps_per_student,

        s.budget / NULLIF(s.students, 0)
            AS budget_per_student,

        100 * SUM(
            CASE
                WHEN sv.wifi_works = 'no' THEN 1
                ELSE 0
            END
        ) / NULLIF(COUNT(sv.survey_id), 0)
            AS pct_wifi_fails

    FROM schools AS s

    LEFT JOIN surveys AS sv
        ON s.school_id = sv.school_id

    GROUP BY
        s.school_id,
        s.school_name,
        s.students,
        s.devices,
        s.device_age,
        s.internet_speed,
        s.budget
),

ranked_schools AS (
    SELECT
        *,

        RANK() OVER (
            ORDER BY (devices = 0) DESC,
                     students_per_device DESC
        ) AS device_rank,

        RANK() OVER (
            ORDER BY device_age DESC
        ) AS age_rank,

        RANK() OVER (
            ORDER BY mbps_per_student ASC
        ) AS internet_rank,

        RANK() OVER (
            ORDER BY pct_wifi_fails DESC
        ) AS wifi_rank,

        RANK() OVER (
            ORDER BY budget_per_student ASC
        ) AS budget_rank

    FROM school_metrics

    WHERE device_age IS NOT NULL
      AND mbps_per_student IS NOT NULL
      AND pct_wifi_fails IS NOT NULL
      AND budget_per_student IS NOT NULL
),

scored_schools AS (
    SELECT
        *,

        device_rank
        + age_rank
        + internet_rank
        + wifi_rank
        + budget_rank AS priority_score

    FROM ranked_schools
),

priority_schools AS (
    SELECT
        *,

        RANK() OVER (
            ORDER BY priority_score ASC
        ) AS overall_priority_rank

    FROM scored_schools
),

ranked_solutions AS (
    SELECT
        school_id,
        solution_name,
        surveys_reporting,
        unique_issues_addressed,

        RANK() OVER (
            PARTITION BY school_id
            ORDER BY surveys_reporting DESC,
                     unique_issues_addressed DESC
        ) AS solution_rank

    FROM school_solutions_summary
)

SELECT
    ps.overall_priority_rank,
    ps.school_name,
    ps.priority_score,

    rs.solution_name,
    rs.surveys_reporting,
    rs.unique_issues_addressed,
    rs.solution_rank

FROM priority_schools AS ps

LEFT JOIN ranked_solutions AS rs
    ON ps.school_id = rs.school_id
    AND rs.solution_rank <= 3

WHERE ps.overall_priority_rank <= 5

ORDER BY
    ps.overall_priority_rank,
    ps.school_name,
    rs.solution_rank,
    rs.solution_name;