-- =====================================================================
-- SDG 9 School Technology Infrastructure Database
-- 01_create_tables.sql
-- Creates the revised database, six tables,
-- and the school_solutions_summary view.
-- Run this script first.
-- WARNING: Drops and recreates the revised database.
-- Designed for MySQL 8.0 or later.
-- =====================================================================

DROP DATABASE IF EXISTS sdg9_school_tech_revised;
CREATE DATABASE sdg9_school_tech_revised;
USE sdg9_school_tech_revised;

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
-- solutions: potential technology improvements
-- identified by the research team.
-- ---------------------------------------------------------------------
CREATE TABLE solutions (
    solution_id INT NOT NULL,
    solution_name VARCHAR(50) NOT NULL,
    description TEXT NOT NULL,
    CONSTRAINT pk_solutions PRIMARY KEY (solution_id),
    CONSTRAINT uq_solutions_solution_name UNIQUE (solution_name)
);

-- ---------------------------------------------------------------------
-- issues: standardized technology problem categories
-- identified by researchers reviewing survey responses.
-- New categories can be added as needed.
-- ---------------------------------------------------------------------
CREATE TABLE issues (
    issue_id INT NOT NULL,
    issue_name VARCHAR(50) NOT NULL,
    description TEXT NOT NULL,
    CONSTRAINT pk_issues PRIMARY KEY (issue_id),
    CONSTRAINT uq_issues_issue_name UNIQUE (issue_name)
);

-- ---------------------------------------------------------------------
-- surveys: one row per staff survey response.
-- Respondents can describe any technology problem
-- without being limited to predefined categories.
-- ---------------------------------------------------------------------

CREATE TABLE surveys (
    survey_id INT NOT NULL AUTO_INCREMENT,
    school_id INT NOT NULL,
    role VARCHAR(20) NOT NULL,
    wifi_works VARCHAR(3) NOT NULL,
    issue_description TEXT NOT NULL,
    survey_date DATE NOT NULL,

    CONSTRAINT pk_surveys
        PRIMARY KEY (survey_id),

    INDEX idx_surveys_school_id (school_id),

    CONSTRAINT fk_surveys_school
        FOREIGN KEY (school_id)
        REFERENCES schools (school_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,

    CONSTRAINT chk_surveys_role
        CHECK (role IN (
            'Teacher',
            'Administrator',
            'IT Staff'
        )),

    CONSTRAINT chk_surveys_wifi_works
        CHECK (wifi_works IN ('yes', 'no'))
);

-- ---------------------------------------------------------------------
-- survey_issues: junction table for the many-to-many relationship
-- between surveys and issues. One survey can report several issues,
-- and one issue can be reported on many surveys. The composite primary
-- key stops the same issue being recorded twice on one survey.
-- research team assigns issue categories after reviewing the written responses
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
-- issue_solutions: junction table connecting
-- technology issues to potential solutions.
-- One issue can have multiple solutions,
-- and one solution can address multiple issues.
-- ---------------------------------------------------------------------

CREATE TABLE issue_solutions (
    issue_id INT NOT NULL,
    solution_id INT NOT NULL,
    mapping_rationale TEXT NOT NULL,

    CONSTRAINT pk_issue_solutions
        PRIMARY KEY (issue_id, solution_id),

    INDEX idx_issue_solutions_solution_id (solution_id),

    CONSTRAINT fk_issue_solutions_issue
        FOREIGN KEY (issue_id)
        REFERENCES issues (issue_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT fk_issue_solutions_solution
        FOREIGN KEY (solution_id)
        REFERENCES solutions (solution_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- ---------------------------------------------------------------------
-- school_solutions_summary:
-- Identifies potential improvements for each school
-- based on issues identified in staff surveys.
-- Counts the number of issue-solution matches,
-- unique issues addressed, and surveys supporting
-- each potential solution.
-- ---------------------------------------------------------------------

CREATE OR REPLACE VIEW school_solutions_summary AS

SELECT
    s.school_id,
    s.school_name,
    sol.solution_id,
    sol.solution_name,
    COUNT(*) AS issue_solution_matches,
    COUNT(DISTINCT si.issue_id) AS unique_issues_addressed,
    COUNT(DISTINCT sv.survey_id) AS surveys_reporting

FROM schools AS s

JOIN surveys AS sv
    ON sv.school_id = s.school_id

JOIN survey_issues AS si
    ON si.survey_id = sv.survey_id

JOIN issue_solutions AS isol
    ON isol.issue_id = si.issue_id

JOIN solutions AS sol
    ON sol.solution_id = isol.solution_id

GROUP BY
    s.school_id,
    s.school_name,
    sol.solution_id,
    sol.solution_name;


