-- =====================================================================
-- SDG 9 School Technology Infrastructure Database
-- 03_indexes.sql
-- Adds indexes that support the research queries.
-- Run after 01_create_tables.sql and 02_insert_mock_data.sql.
--
-- Indexes that already exist from 01_create_tables.sql:
--
-- Primary keys:
--   schools(school_id)
--   solutions(solution_id)
--   issues(issue_id)
--   surveys(survey_id)
--   survey_issues(survey_id, issue_id)
--   issue_solutions(issue_id, solution_id)
--
-- Unique keys:
--   solutions(solution_name)
--   issues(issue_name)
--
-- Foreign key indexes:
--   surveys(school_id)
--   survey_issues(issue_id)
--   issue_solutions(solution_id)
--
-- Other foreign keys are covered by the first column
-- of their respective composite primary keys.
-- =====================================================================

USE sdg9_school_tech_revised;

-- Supports queries that analyze Wi-Fi reliability
-- based on staff survey responses at each school.

CREATE INDEX idx_surveys_school_wifi
ON surveys (school_id, wifi_works);

-- The composite index also covers school_id.
-- Remove the redundant single-column index.

DROP INDEX idx_surveys_school_id ON surveys;

-- Supports queries that group survey responses
-- by teachers, administrators and IT staff.

CREATE INDEX idx_surveys_role
ON surveys (role);

-- Supports queries that sort or filter schools
-- based on internet connection speed.

CREATE INDEX idx_schools_internet_speed
ON schools (internet_speed);

-- Supports queries that sort or filter schools
-- based on their technology budgets.

CREATE INDEX idx_schools_budget
ON schools (budget);

-- =====================================================================
-- Verify all indexes in the revised database.
-- =====================================================================

SELECT
    TABLE_NAME,
    INDEX_NAME,
    GROUP_CONCAT(
        COLUMN_NAME ORDER BY SEQ_IN_INDEX
    ) AS columns_in_index,
    IF(NON_UNIQUE = 0, 'unique', 'non-unique')
        AS uniqueness

FROM information_schema.STATISTICS

WHERE TABLE_SCHEMA = 'sdg9_school_tech_revised'

GROUP BY
    TABLE_NAME,
    INDEX_NAME,
    NON_UNIQUE

ORDER BY
    TABLE_NAME,
    INDEX_NAME;
