-- =====================================================================
-- SDG 9 School Technology Infrastructure Database
-- 02_insert_mock_data.sql
-- Loads fictional mock data.
-- Run after 01_create_tables.sql.
-- WARNING: Clears existing data before reloading.
-- =====================================================================

USE sdg9_school_tech_revised;

-- Clear existing mock data.
DELETE FROM issue_solutions;
DELETE FROM survey_issues;
DELETE FROM surveys;
DELETE FROM issues;
DELETE FROM solutions;
DELETE FROM schools;

-- schools: 15 schools, from the school information form
INSERT INTO schools (school_id, school_name, location, students, devices, device_age, internet_speed, budget) VALUES
(1, 'Hudson Valley Middle School', 'Newburgh, NY', 933, 89, 7.1, 35, 77000),
(2, 'Riverside Elementary', 'Middletown, NY', 444, 246, 4.3, 100, 86000),
(3, 'Pinecrest High School', 'Poughkeepsie, NY', 391, 349, 3.7, 100, 64000),
(4, 'Maple Grove Academy', 'Kingston, NY', 575, 182, 7.4, 150, 126000),
(5, 'Eastbrook Middle School', 'Beacon, NY', 558, 56, 5.7, 75, 124000),
(6, 'Westfield High School', 'New Windsor, NY', 312, 280, 3.3, 400, 61000),
(7, 'Oakridge Elementary', 'Montgomery, NY', 991, 120, 7.2, 250, 14000),
(8, 'Cedar Hill School', 'Goshen, NY', 341, 261, 6.9, 250, 68000),
(9, 'Brookside Academy', 'Wappingers Falls, NY', 914, 351, 5.7, 50, 113000),
(10, 'Summit Ridge High School', 'Fishkill, NY', 892, 461, 3.5, 35, 114000),
(11, 'Lakeside Middle School', 'Cornwall, NY', 452, 244, 3.2, 50, 92000),
(12, 'Valley View Elementary', 'Warwick, NY', 745, 152, 5.6, 400, 12000),
(13, 'Northgate High School', 'New Paltz, NY', 705, 536, 5.9, 400, 117000),
(14, 'Meadowbrook School', 'Monroe, NY', 752, 550, 4.4, 50, 125000),
(15, 'Stonebridge Academy', 'Highland, NY', 242, 107, 2.6, 400, 60000);

-- solutions: 7 potential technology improvements
-- identified by the research team.

INSERT INTO solutions
(solution_id, solution_name, description)
VALUES
(1, 'Internet upgrade',
'Increase internet bandwidth and improve connection reliability.'),

(2, 'New computers',
'Replace outdated or poorly performing computers.'),

(3, 'Additional devices',
'Increase the number of devices available to students.'),

(4, 'Software upgrades',
'Update educational software and improve compatibility.'),

(5, 'IT support',
'Improve the availability and responsiveness of technical support.'),

(6, 'Network equipment',
'Upgrade routers, access points and other network equipment.'),

(7, 'Teacher technology training',
'Provide training to help staff use technology effectively.');

-- issues: standardized categories identified
-- by the research team after reviewing surveys.

INSERT INTO issues
(issue_id, issue_name, description)
VALUES
(1, 'Slow Wi-Fi',
'Wireless internet connections operate at insufficient speeds.'),

(2, 'Frequent internet disconnects',
'Internet connections frequently drop or become unavailable.'),

(3, 'Outdated computers',
'Computers are aging or no longer meet technology requirements.'),

(4, 'Slow classroom computers',
'Classroom computers experience poor performance.'),

(5, 'Not enough student devices',
'Insufficient devices are available for student use.'),

(6, 'Device sharing delays',
'Students experience delays because devices must be shared.'),

(7, 'Outdated educational software',
'Educational applications are outdated or unsupported.'),

(8, 'Software compatibility errors',
'Software does not function correctly with existing systems.'),

(9, 'Delayed technical support',
'Staff experience long wait times for technology assistance.'),

(10, 'Insufficient Wi-Fi coverage',
'Wireless internet is unavailable or weak in certain areas.'),

(11, 'Network equipment failures',
'Network equipment experiences failures or interruptions.'),

(12, 'Limited staff tech training',
'Staff lack sufficient training to use available technology.');

-- Temporarily allow empty descriptions while loading
-- the original fictional survey records.

ALTER TABLE surveys
MODIFY issue_description TEXT NULL;

INSERT INTO surveys (survey_id, school_id, role, wifi_works, survey_date) VALUES
(1001, 1, 'Administrator', 'yes', '2026-09-15'),
(1002, 2, 'Administrator', 'no', '2026-10-22'),
(1003, 3, 'Administrator', 'no', '2026-10-09'),
(1004, 4, 'Teacher', 'no', '2026-09-27'),
(1005, 5, 'Teacher', 'no', '2026-10-30'),
(1006, 6, 'Teacher', 'no', '2026-09-23'),
(1007, 7, 'Teacher', 'yes', '2026-09-11'),
(1008, 8, 'Administrator', 'no', '2026-09-15'),
(1009, 9, 'Teacher', 'no', '2026-10-25'),
(1010, 10, 'IT Staff', 'no', '2026-10-08'),
(1011, 11, 'IT Staff', 'yes', '2026-10-16'),
(1012, 12, 'Teacher', 'no', '2026-09-04'),
(1013, 13, 'Teacher', 'yes', '2026-09-26'),
(1014, 14, 'Teacher', 'yes', '2026-11-05'),
(1015, 15, 'IT Staff', 'no', '2026-11-12'),
(1016, 1, 'Teacher', 'yes', '2026-09-20'),
(1017, 2, 'IT Staff', 'no', '2026-09-13'),
(1018, 3, 'Teacher', 'yes', '2026-10-13'),
(1019, 4, 'Teacher', 'no', '2026-11-07'),
(1020, 5, 'Teacher', 'no', '2026-10-17'),
(1021, 6, 'Teacher', 'no', '2026-10-29'),
(1022, 7, 'Teacher', 'no', '2026-10-04'),
(1023, 8, 'Administrator', 'yes', '2026-09-05'),
(1024, 9, 'IT Staff', 'no', '2026-11-05'),
(1025, 10, 'IT Staff', 'yes', '2026-10-26'),
(1026, 11, 'IT Staff', 'yes', '2026-10-12'),
(1027, 12, 'Teacher', 'yes', '2026-09-25'),
(1028, 13, 'IT Staff', 'no', '2026-10-27'),
(1029, 14, 'Teacher', 'no', '2026-11-10'),
(1030, 15, 'Teacher', 'yes', '2026-09-14'),
(1031, 1, 'Administrator', 'yes', '2026-11-11'),
(1032, 2, 'Teacher', 'no', '2026-11-14'),
(1033, 3, 'IT Staff', 'yes', '2026-09-09'),
(1034, 4, 'Administrator', 'no', '2026-10-15'),
(1035, 5, 'Administrator', 'no', '2026-09-04'),
(1036, 6, 'IT Staff', 'no', '2026-10-02'),
(1037, 7, 'Teacher', 'yes', '2026-11-08'),
(1038, 8, 'IT Staff', 'no', '2026-11-01'),
(1039, 9, 'Administrator', 'no', '2026-09-09'),
(1040, 10, 'Teacher', 'no', '2026-10-05'),
(1041, 11, 'Teacher', 'no', '2026-10-30'),
(1042, 12, 'Teacher', 'no', '2026-09-23'),
(1043, 13, 'IT Staff', 'yes', '2026-11-02'),
(1044, 14, 'Teacher', 'no', '2026-11-09'),
(1045, 15, 'Teacher', 'no', '2026-09-07'),
(1046, 1, 'Teacher', 'no', '2026-09-05'),
(1047, 2, 'Teacher', 'yes', '2026-10-18'),
(1048, 3, 'IT Staff', 'yes', '2026-09-08'),
(1049, 4, 'Teacher', 'no', '2026-10-14'),
(1050, 5, 'Teacher', 'no', '2026-11-09'),
(1051, 6, 'Teacher', 'no', '2026-10-05'),
(1052, 7, 'Teacher', 'no', '2026-11-08'),
(1053, 8, 'Administrator', 'no', '2026-09-30'),
(1054, 9, 'Administrator', 'no', '2026-09-22'),
(1055, 10, 'Teacher', 'no', '2026-09-22'),
(1056, 11, 'Teacher', 'no', '2026-11-08'),
(1057, 12, 'IT Staff', 'no', '2026-10-26'),
(1058, 13, 'Teacher', 'no', '2026-11-06'),
(1059, 14, 'IT Staff', 'no', '2026-09-25'),
(1060, 15, 'Teacher', 'yes', '2026-10-10');


-- survey_issues: 115 links: which issues each survey reported
INSERT INTO survey_issues (survey_id, issue_id) VALUES
(1001, 3),
(1001, 8),
(1002, 3),
(1002, 12),
(1003, 1),
(1003, 11),
(1004, 7),
(1004, 11),
(1005, 8),
(1006, 5),
(1006, 11),
(1007, 3),
(1007, 7),
(1008, 8),
(1008, 10),
(1009, 1),
(1009, 7),
(1010, 10),
(1011, 4),
(1011, 5),
(1012, 4),
(1012, 11),
(1013, 8),
(1013, 9),
(1014, 5),
(1014, 9),
(1015, 1),
(1015, 8),
(1016, 8),
(1017, 8),
(1017, 12),
(1018, 3),
(1018, 8),
(1019, 7),
(1019, 10),
(1020, 6),
(1021, 1),
(1021, 6),
(1021, 12),
(1022, 2),
(1022, 4),
(1023, 3),
(1023, 8),
(1024, 1),
(1025, 12),
(1026, 9),
(1026, 12),
(1027, 4),
(1027, 5),
(1028, 2),
(1028, 8),
(1029, 4),
(1029, 10),
(1030, 3),
(1030, 5),
(1031, 8),
(1031, 9),
(1032, 2),
(1032, 4),
(1033, 3),
(1033, 7),
(1034, 1),
(1034, 9),
(1035, 4),
(1035, 5),
(1035, 11),
(1036, 7),
(1037, 3),
(1037, 8),
(1038, 5),
(1039, 1),
(1039, 4),
(1039, 11),
(1040, 3),
(1040, 8),
(1041, 1),
(1041, 3),
(1042, 1),
(1042, 5),
(1043, 4),
(1043, 5),
(1043, 6),
(1044, 1),
(1044, 2),
(1045, 9),
(1046, 7),
(1047, 3),
(1047, 5),
(1048, 6),
(1049, 5),
(1049, 6),
(1050, 1),
(1050, 4),
(1050, 10),
(1051, 1),
(1051, 6),
(1051, 7),
(1052, 1),
(1052, 2),
(1053, 3),
(1053, 11),
(1053, 12),
(1054, 2),
(1054, 4),
(1054, 5),
(1055, 9),
(1055, 12),
(1056, 10),
(1057, 4),
(1057, 10),
(1058, 11),
(1058, 12),
(1059, 1),
(1060, 3),
(1060, 8);

-- Generate fictional written survey responses
-- consistent with the existing mock issue mappings.
-- In a real study, written responses would be
-- collected before researchers categorize them.

UPDATE surveys AS sv
JOIN (
    SELECT
        si.survey_id,
        GROUP_CONCAT(
            CASE si.issue_id
                WHEN 1 THEN
                    'The Wi-Fi is very slow during the school day'
                WHEN 2 THEN
                    'Our internet connection frequently disconnects'
                WHEN 3 THEN
                    'Many of our computers are outdated'
                WHEN 4 THEN
                    'Classroom computers take too long to load'
                WHEN 5 THEN
                    'There are not enough devices for all students'
                WHEN 6 THEN
                    'Students lose time waiting to share devices'
                WHEN 7 THEN
                    'Our educational software is outdated'
                WHEN 8 THEN
                    'Some software does not work with our computers'
                WHEN 9 THEN
                    'It takes too long to receive technical support'
                WHEN 10 THEN
                    'Some areas of the school have poor Wi-Fi coverage'
                WHEN 11 THEN
                    'Our network equipment frequently experiences failures'
                WHEN 12 THEN
                    'Staff need more training on how to use technology'
            END
            ORDER BY si.issue_id
            SEPARATOR '. '
        ) AS mock_response
    FROM survey_issues AS si
    GROUP BY si.survey_id
) AS responses
    ON sv.survey_id = responses.survey_id

SET sv.issue_description =
    CONCAT(responses.mock_response, '.');

-- Restore the original requirement that every
-- survey must contain a written response.

ALTER TABLE surveys
MODIFY issue_description TEXT NOT NULL;

-- issue_solutions: potential solutions identified
-- by the research team for each reported issue.

INSERT INTO issue_solutions
(issue_id, solution_id, mapping_rationale)
VALUES

-- Issue 1: Slow Wi-Fi
(1, 1, 'Increasing bandwidth may improve internet speed.'),
(1, 6, 'Upgraded network equipment may improve wireless performance.'),

-- Issue 2: Frequent internet disconnects
(2, 1, 'Improved internet service may reduce interruptions.'),
(2, 6, 'Replacing faulty network equipment may improve reliability.'),
(2, 5, 'IT support can identify and troubleshoot connection problems.'),

-- Issue 3: Outdated computers
(3, 2, 'New computers can replace outdated equipment.'),
(3, 4, 'Software upgrades may extend the usefulness of compatible computers.'),

-- Issue 4: Slow classroom computers
(4, 2, 'New computers may improve processing performance.'),
(4, 4, 'Updated software may improve system performance.'),
(4, 5, 'IT support can diagnose computer performance problems.'),

-- Issue 5: Not enough student devices
(5, 3, 'Purchasing additional devices increases student access.'),

-- Issue 6: Device sharing delays
(6, 3, 'Additional devices may reduce waiting and sharing time.'),

-- Issue 7: Outdated educational software
(7, 4, 'Software upgrades provide current supported applications.'),
(7, 7, 'Training helps teachers effectively use updated software.'),

-- Issue 8: Software compatibility errors
(8, 4, 'Compatible software versions may resolve errors.'),
(8, 2, 'New computers may support modern software requirements.'),
(8, 5, 'IT support can identify and resolve compatibility problems.'),

-- Issue 9: Delayed technical support
(9, 5, 'Additional IT support may reduce response times.'),
(9, 7, 'Staff training may reduce routine support requests.'),

-- Issue 10: Insufficient Wi-Fi coverage
(10, 6, 'Additional access points may improve wireless coverage.'),
(10, 5, 'IT staff can identify areas with weak wireless signals.'),

-- Issue 11: Network equipment failures
(11, 6, 'Replacing failing equipment may improve network reliability.'),
(11, 5, 'IT support can maintain and troubleshoot network equipment.'),

-- Issue 12: Limited staff tech training
(12, 7, 'Technology training can improve staff knowledge and skills.'),
(12, 5, 'IT support can provide ongoing technical guidance.');

