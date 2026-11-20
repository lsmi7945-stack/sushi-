-- =====================================================================
-- SDG 9 School Technology Infrastructure Database
-- 01_create_tables.sql
-- Creates the database, the five tables and the school_needs_summary view.
-- Run this first. WARNING: it drops and recreates the database.
-- Tested on MySQL 8.0 (also runs on 8.4 LTS).
-- =====================================================================

DROP DATABASE IF EXISTS sdg9_school_tech;
CREATE DATABASE sdg9_school_tech;
USE sdg9_school_tech;

-- ---------------------------------------------------------------------
-- schools: one row per school, filled from the school information form.
-- Students per device is NOT stored; it is calculated in the queries
-- (students / devices) so the database stays in third normal form.
-- ---------------------------------------------------------------------
CREATE TABLE schools (
    school_id       INT            NOT NULL,
    school_name     VARCHAR(100)   NOT NULL,
    location        VARCHAR(100),
    students        INT            NOT NULL,
    devices         INT            NOT NULL,
    device_age      DECIMAL(3,1),
    internet_speed  INT,
    budget          INT,
    CONSTRAINT pk_schools PRIMARY KEY (school_id),
    CONSTRAINT chk_schools_students       CHECK (students > 0),
    CONSTRAINT chk_schools_devices        CHECK (devices >= 0),
    CONSTRAINT chk_schools_device_age     CHECK (device_age >= 0),
    CONSTRAINT chk_schools_internet_speed CHECK (internet_speed >= 0),
    CONSTRAINT chk_schools_budget         CHECK (budget >= 0)
);

-- ---------------------------------------------------------------------
-- needs: the 7 categories of technology improvement a school can need.
-- ---------------------------------------------------------------------
CREATE TABLE needs (
    need_id    INT          NOT NULL,
    need_name  VARCHAR(50)  NOT NULL,
    CONSTRAINT pk_needs PRIMARY KEY (need_id),
    CONSTRAINT uq_needs_need_name UNIQUE (need_name)
);

-- ---------------------------------------------------------------------
-- issues: the 12 technology problems staff can report on the survey.
-- Each issue belongs to one need (one need -> many issues).
-- ---------------------------------------------------------------------
CREATE TABLE issues (
    issue_id    INT          NOT NULL,
    issue_name  VARCHAR(50)  NOT NULL,
    need_id     INT          NOT NULL,
    CONSTRAINT pk_issues PRIMARY KEY (issue_id),
    CONSTRAINT uq_issues_issue_name UNIQUE (issue_name),
    INDEX idx_issues_need_id (need_id),
    CONSTRAINT fk_issues_need FOREIGN KEY (need_id) REFERENCES needs (need_id)
);

-- ---------------------------------------------------------------------
-- surveys: one row per staff survey response (one school -> many surveys).
-- ---------------------------------------------------------------------
CREATE TABLE surveys (
    survey_id    INT          NOT NULL,
    school_id    INT          NOT NULL,
    role         VARCHAR(20)  NOT NULL,
    wifi_works   VARCHAR(3)   NOT NULL,
    survey_date  DATE         NOT NULL,
    CONSTRAINT pk_surveys PRIMARY KEY (survey_id),
    INDEX idx_surveys_school_id (school_id),
    CONSTRAINT fk_surveys_school FOREIGN KEY (school_id) REFERENCES schools (school_id),
    CONSTRAINT chk_surveys_role       CHECK (role IN ('Teacher', 'Administrator', 'IT Staff')),
    CONSTRAINT chk_surveys_wifi_works CHECK (wifi_works IN ('yes', 'no'))
);

-- ---------------------------------------------------------------------
-- survey_issues: junction table for the many-to-many relationship
-- between surveys and issues. One survey can report several issues,
-- and one issue can be reported on many surveys. The composite primary
-- key stops the same issue being recorded twice on one survey.
-- ---------------------------------------------------------------------
CREATE TABLE survey_issues (
    survey_id  INT  NOT NULL,
    issue_id   INT  NOT NULL,
    CONSTRAINT pk_survey_issues PRIMARY KEY (survey_id, issue_id),
    INDEX idx_survey_issues_issue_id (issue_id),
    CONSTRAINT fk_survey_issues_survey FOREIGN KEY (survey_id) REFERENCES surveys (survey_id),
    CONSTRAINT fk_survey_issues_issue  FOREIGN KEY (issue_id)  REFERENCES issues (issue_id)
);

-- ---------------------------------------------------------------------
-- school_needs_summary (VIEW): replaces the old SchoolNeeds table.
-- For each school and need, counts how many times staff reported an
-- issue belonging to that need. Because it is calculated from the
-- survey data, it never has to be typed in or kept in sync by hand.
-- ---------------------------------------------------------------------
CREATE VIEW school_needs_summary AS
SELECT  s.school_id,
        s.school_name,
        n.need_id,
        n.need_name,
        COUNT(*)                     AS times_reported,
        COUNT(DISTINCT sv.survey_id) AS surveys_reporting
FROM    schools s
JOIN    surveys sv       ON sv.school_id = s.school_id
JOIN    survey_issues si ON si.survey_id = sv.survey_id
JOIN    issues i         ON i.issue_id   = si.issue_id
JOIN    needs n          ON n.need_id    = i.need_id
GROUP BY s.school_id, s.school_name, n.need_id, n.need_name;
