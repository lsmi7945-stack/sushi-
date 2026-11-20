-- =====================================================================
-- SDG 9 School Technology Infrastructure Database
-- 04_queries.sql
-- Queries that answer the project's three research questions.
-- Run after 01, 02 and 03. Requires MySQL 8.0 or later (uses WITH
-- clauses and window functions such as RANK()).
-- =====================================================================

USE sdg9_school_tech;

-- =====================================================================
-- QUESTION 1: What are the most commonly reported technology problems
--             and needs across schools?
-- =====================================================================

-- 1a. Most reported problems.
-- Counts how many surveys reported each of the 12 issues, and how many
-- different schools reported it. An issue reported at many schools is a
-- widespread problem, not just one school's complaint.
SELECT  i.issue_name,
        n.need_name                    AS related_need,
        COUNT(*)                       AS times_reported,
        COUNT(DISTINCT sv.school_id)   AS schools_reporting
FROM    survey_issues si
JOIN    issues  i  ON i.issue_id   = si.issue_id
JOIN    needs   n  ON n.need_id    = i.need_id
JOIN    surveys sv ON sv.survey_id = si.survey_id
GROUP BY i.issue_id, i.issue_name, n.need_name
ORDER BY times_reported DESC, schools_reporting DESC, i.issue_name;

-- 1b. Most reported needs.
-- Rolls the issues up into the 7 need categories (e.g. "Slow Wi-Fi" and
-- "Frequent internet disconnects" both count toward "Internet upgrade").
-- pct_of_surveys shows what share of all 60 surveys mentioned that need.
SELECT  n.need_name,
        COUNT(*)                                      AS times_reported,
        COUNT(DISTINCT si.survey_id)                  AS surveys_reporting,
        ROUND(100 * COUNT(DISTINCT si.survey_id)
                  / (SELECT COUNT(*) FROM surveys), 1) AS pct_of_surveys,
        COUNT(DISTINCT sv.school_id)                  AS schools_reporting
FROM    needs n
LEFT JOIN issues i         ON i.need_id    = n.need_id
LEFT JOIN survey_issues si ON si.issue_id  = i.issue_id
LEFT JOIN surveys sv       ON sv.survey_id = si.survey_id
GROUP BY n.need_id, n.need_name
ORDER BY times_reported DESC, n.need_name;

-- 1c. Problems by staff role.
-- Shows whether teachers, administrators and IT staff point to different
-- needs. Each role's needs are ranked, so rank 1 is that role's top need.
SELECT  role, need_name, times_reported, rank_in_role
FROM (
    SELECT  sv.role,
            n.need_name,
            COUNT(*) AS times_reported,
            RANK() OVER (PARTITION BY sv.role ORDER BY COUNT(*) DESC) AS rank_in_role
    FROM    surveys sv
    JOIN    survey_issues si ON si.survey_id = sv.survey_id
    JOIN    issues i         ON i.issue_id   = si.issue_id
    JOIN    needs n          ON n.need_id    = i.need_id
    GROUP BY sv.role, n.need_name
) AS by_role
ORDER BY role, rank_in_role, need_name;

-- =====================================================================
-- QUESTION 2: Which schools have the greatest shortages of technology
--             resources?
-- =====================================================================

-- 2a. Students per device and device age.
-- students_per_device is calculated here (students / devices) instead of
-- being stored. A higher number means more students share each device.
SELECT  school_name,
        students,
        devices,
        ROUND(students / devices, 1) AS students_per_device,
        device_age                   AS avg_device_age_years
FROM    schools
ORDER BY students_per_device DESC;

-- 2b. Internet speed per student compared with the FCC goal.
-- The FCC's long-term goal is 1 Mbps per student. meets_fcc_goal shows
-- whether each school reaches it.
SELECT  school_name,
        students,
        internet_speed                       AS internet_mbps,
        ROUND(internet_speed / students, 3)  AS mbps_per_student,
        IF(internet_speed / students >= 1, 'Yes', 'No') AS meets_fcc_goal
FROM    schools
ORDER BY mbps_per_student;

-- 2c. Wi-Fi reliability by school.
-- Counts how many staff at each school said the Wi-Fi does not work, out
-- of all their surveys. Every school is listed, including any where
-- nobody said "no".
SELECT  s.school_name,
        COUNT(sv.survey_id)                                    AS surveys,
        SUM(CASE WHEN sv.wifi_works = 'no' THEN 1 ELSE 0 END)  AS said_wifi_fails,
        ROUND(100 * SUM(CASE WHEN sv.wifi_works = 'no' THEN 1 ELSE 0 END)
                  / COUNT(sv.survey_id), 0)                    AS pct_wifi_fails
FROM    schools s
LEFT JOIN surveys sv ON sv.school_id = s.school_id
GROUP BY s.school_id, s.school_name
ORDER BY pct_wifi_fails DESC, s.school_name;

-- 2d. Technology budget per student.
-- Total budget is misleading for schools of different sizes, so this
-- divides the yearly technology budget by enrollment.
SELECT  school_name,
        students,
        budget,
        ROUND(budget / students, 2) AS budget_per_student
FROM    schools
ORDER BY budget_per_student;

-- 2e. Overall shortage ranking.
-- Combines the four measures above. Each school is ranked 1-15 on each
-- measure (1 = worst), and the ranks are added together. The lowest
-- total is the school with the greatest overall shortage. Each measure
-- counts equally.
WITH measures AS (
    SELECT  s.school_id,
            s.school_name,
            s.students / s.devices                                       AS students_per_device,
            s.internet_speed / s.students                                AS mbps_per_student,
            s.budget / s.students                                        AS budget_per_student,
            AVG(CASE WHEN sv.wifi_works = 'no' THEN 1 ELSE 0 END)        AS share_wifi_fails
    FROM    schools s
    LEFT JOIN surveys sv ON sv.school_id = s.school_id
    GROUP BY s.school_id, s.school_name, s.students, s.devices, s.internet_speed, s.budget
),
ranked AS (
    SELECT  school_id, school_name,
            RANK() OVER (ORDER BY students_per_device DESC) AS device_rank,
            RANK() OVER (ORDER BY mbps_per_student ASC)     AS internet_rank,
            RANK() OVER (ORDER BY share_wifi_fails DESC)    AS wifi_rank,
            RANK() OVER (ORDER BY budget_per_student ASC)   AS budget_rank
    FROM    measures
)
SELECT  school_name, device_rank, internet_rank, wifi_rank, budget_rank,
        device_rank + internet_rank + wifi_rank + budget_rank AS shortage_score
FROM    ranked
ORDER BY shortage_score, school_name;

-- =====================================================================
-- QUESTION 3: Which technology improvements should be prioritized based
--             on the frequency of reported issues?
-- =====================================================================

-- 3a. Each school's most reported need.
-- Uses the school_needs_summary view, which counts reports of each need
-- at each school. Rank 1 is the need that school's staff reported most
-- (ties share a rank, so a school can show more than one top need).
SELECT  school_name, need_name, times_reported
FROM (
    SELECT  school_name, need_name, times_reported,
            RANK() OVER (PARTITION BY school_id ORDER BY times_reported DESC) AS need_rank
    FROM    school_needs_summary
) AS ranked_needs
WHERE   need_rank = 1
ORDER BY school_name, need_name;

-- 3b. How many schools have each need as a top need.
-- A need that is the top need at many schools is a strong candidate for
-- a district- or state-wide purchase.
SELECT  need_name,
        COUNT(*) AS schools_where_top_need
FROM (
    SELECT  school_id, need_name,
            RANK() OVER (PARTITION BY school_id ORDER BY times_reported DESC) AS need_rank
    FROM    school_needs_summary
) AS ranked_needs
WHERE   need_rank = 1
GROUP BY need_name
ORDER BY schools_where_top_need DESC, need_name;

-- 3c. Priority list: the five schools with the greatest shortages and
-- the improvement each one needs most.
-- Combines the shortage ranking from 2e with each school's top need from
-- 3a, giving the finance office a short list of which school to fund
-- first and what to buy.
WITH measures AS (
    SELECT  s.school_id,
            s.school_name,
            s.students / s.devices                                AS students_per_device,
            s.internet_speed / s.students                         AS mbps_per_student,
            s.budget / s.students                                 AS budget_per_student,
            AVG(CASE WHEN sv.wifi_works = 'no' THEN 1 ELSE 0 END) AS share_wifi_fails
    FROM    schools s
    LEFT JOIN surveys sv ON sv.school_id = s.school_id
    GROUP BY s.school_id, s.school_name, s.students, s.devices, s.internet_speed, s.budget
),
shortage AS (
    SELECT  school_id, school_name,
            RANK() OVER (ORDER BY students_per_device DESC)
          + RANK() OVER (ORDER BY mbps_per_student ASC)
          + RANK() OVER (ORDER BY share_wifi_fails DESC)
          + RANK() OVER (ORDER BY budget_per_student ASC) AS shortage_score
    FROM    measures
),
top_needs AS (
    SELECT  school_id,
            GROUP_CONCAT(need_name ORDER BY need_name SEPARATOR ', ') AS top_needs
    FROM (
        SELECT  school_id, need_name,
                RANK() OVER (PARTITION BY school_id ORDER BY times_reported DESC) AS need_rank
        FROM    school_needs_summary
    ) AS r
    WHERE   need_rank = 1
    GROUP BY school_id
)
SELECT  sh.school_name, sh.shortage_score, tn.top_needs
FROM    shortage sh
JOIN    top_needs tn ON tn.school_id = sh.school_id
ORDER BY sh.shortage_score, sh.school_name
LIMIT 5;
