-- =====================================================================
-- SDG 9 School Technology Infrastructure Database
-- 03_indexes.sql
-- Adds indexes that support the research queries. Run after
-- 01_create_tables.sql (it can run before or after the mock data).
--
-- Indexes that already exist from 01_create_tables.sql:
--   Primary keys:  schools(school_id), needs(need_id), issues(issue_id),
--                  surveys(survey_id), survey_issues(survey_id, issue_id)
--   Unique keys:   needs(need_name), issues(issue_name)
--   Foreign keys:  issues(need_id), surveys(school_id),
--                  survey_issues(issue_id)
--                  (survey_issues.survey_id is covered by the first
--                   column of its composite primary key)
-- So every key already has an index. The indexes below are extra ones
-- for columns the queries in 04_queries.sql filter or group on.
-- =====================================================================

USE sdg9_school_tech;

-- Query 2c counts "no" Wi-Fi answers per school. A composite index on
-- (school_id, wifi_works) lets MySQL find a school's surveys and check
-- the answer from the index alone.
CREATE INDEX idx_surveys_school_wifi ON surveys (school_id, wifi_works);

-- The new index starts with school_id, so it also covers the foreign key
-- surveys.school_id. The single-column index from 01_create_tables.sql
-- is now redundant, and dropping it saves space and write time.
DROP INDEX idx_surveys_school_id ON surveys;

-- Query 1c groups survey answers by staff role.
CREATE INDEX idx_surveys_role ON surveys (role);

-- Queries 2b and 2d sort schools by internet speed and budget. With only
-- 15 schools this makes little difference now, but the real database
-- would hold every school that applies.
CREATE INDEX idx_schools_internet_speed ON schools (internet_speed);
CREATE INDEX idx_schools_budget ON schools (budget);

-- List every index so they can be checked against the data dictionary.
SELECT  TABLE_NAME, INDEX_NAME,
        GROUP_CONCAT(COLUMN_NAME ORDER BY SEQ_IN_INDEX) AS columns_in_index,
        IF(NON_UNIQUE = 0, 'unique', 'non-unique')      AS uniqueness
FROM    information_schema.STATISTICS
WHERE   TABLE_SCHEMA = 'sdg9_school_tech'
GROUP BY TABLE_NAME, INDEX_NAME, NON_UNIQUE
ORDER BY TABLE_NAME, INDEX_NAME;
