# Data Collection Methodology

## Overview

The SDG 9 School Technology Infrastructure Database was designed to collect, organize, and analyze information about school technology resources and technology-related challenges experienced by school staff.

The proposed methodology combines quantitative school infrastructure information with qualitative staff survey responses to support technology infrastructure assessment and data-driven decision-making.

## Research Objectives

The data collection process was designed to support three primary research objectives:

1. Identify common technology challenges experienced by school staff and determine potential solutions.
2. Identify schools with the greatest need for technology infrastructure improvements.
3. Determine which technology improvements should be prioritized at individual schools.

## Data Collection Instruments

Two proposed data collection instruments were developed.

### School Infrastructure Information Form

The school infrastructure information form is designed to collect quantitative information from school administrators or IT staff.

The information collected includes:

- School name
- School location
- Student enrollment
- Number of available technology devices
- Average device age
- Internet connection speed
- Annual technology budget

This information is stored in the schools table.

Each school is assigned a unique school_id that connects school infrastructure information to staff survey responses.

### Staff Technology Survey

The staff technology survey is designed to collect information from teachers, administrators, and IT staff.

The survey collects:

- Associated school
- Staff role
- Wi-Fi reliability
- Open-ended descriptions of technology challenges
- Survey completion date

Survey responses are stored in the surveys table.

Each survey is assigned a unique survey_id and is connected to its corresponding school through a foreign key.

## Types of Data Collected

### Quantitative Data

Quantitative data includes numerical measurements used to evaluate school infrastructure.

Examples include:

- Student enrollment
- Device counts
- Average device age
- Internet speed
- Technology budgets

### Qualitative Data

Qualitative data includes categorical information and written descriptions of technology experiences.

Examples include:

- Staff roles
- Wi-Fi reliability responses
- Technology issue descriptions
- Standardized issue categories
- Potential solutions

## Mock Data Generation

All data used in the current project is simulated for educational purposes.

The mock dataset was developed to represent a variety of school sizes, technology resources, infrastructure conditions, and staff experiences.

The dataset contains:

| Data Category | Number of Records |
|---|---:|
| Schools | 15 |
| Staff surveys | 60 |
| Technology issues | 12 |
| Potential solutions | 7 |
| Survey-to-issue relationships | 115 |
| Issue-to-solution relationships | 25 |
| Total database records | 234 |

Each simulated school has four staff survey responses.

The staff survey responses include:

| Staff Role | Number of Respondents |
|---|---:|
| Teachers | 34 |
| Administrators | 11 |
| IT staff | 15 |
| Total | 60 |

The simulated dataset provides sufficient variation to demonstrate database functionality, research queries, and analytical techniques.

## Technology Issue Categorization

Staff survey responses contain open-ended descriptions of technology challenges.

In the proposed real-world collection process, the research team would review each response and assign one or more standardized technology issue categories.

For the simulated dataset, issue assignments and standardized descriptions were generated to represent this process.

The twelve standardized issue categories are:

1. Slow Wi-Fi
2. Frequent internet disconnects
3. Outdated computers
4. Slow classroom computers
5. Not enough student devices
6. Device sharing delays
7. Outdated educational software
8. Software compatibility errors
9. Delayed technical support
10. Insufficient Wi-Fi coverage
11. Network equipment failures
12. Limited staff tech training

A survey response can contain multiple technology issues, and the same issue can appear in multiple survey responses.

The survey_issues junction table resolves this many-to-many relationship.

The current simulated dataset contains 115 survey-to-issue relationships.

## Issue-to-Solution Mapping

Each standardized technology issue is associated with one or more potential technology improvements.

The seven potential solutions are:

1. Internet upgrade
2. New computers
3. Additional devices
4. Software upgrades
5. IT support
6. Network equipment
7. Teacher technology training

The issue_solutions junction table stores these relationships.

Each relationship includes a mapping_rationale explaining why the proposed solution may address the corresponding issue.

For example:

| Technology Issue | Potential Solution | Rationale |
|---|---|---|
| Slow Wi-Fi | Internet upgrade | Increasing bandwidth may improve internet speed. |
| Outdated computers | New computers | New computers can replace outdated equipment. |
| Not enough student devices | Additional devices | Purchasing additional devices increases student access. |
| Software compatibility errors | Software upgrades | Compatible software versions may resolve errors. |
| Delayed technical support | IT support | Additional IT support may reduce response times. |

The database contains 25 issue-to-solution relationships.

These relationships allow multiple solutions to address the same issue and allow individual solutions to address multiple issues.

Potential solutions are based on predefined mappings and are not direct recommendations submitted by survey respondents.

## Data Processing Workflow

The proposed data processing procedure consists of the following steps:

1. Collect school infrastructure information.
2. Assign a unique school identifier to each school.
3. Collect staff technology survey responses.
4. Associate each survey with its corresponding school.
5. Review open-ended technology issue descriptions.
6. Categorize reported issues using standardized issue categories.
7. Store survey-to-issue relationships in the survey_issues table.
8. Connect technology issues to potential solutions.
9. Document the rationale for each issue-to-solution relationship.
10. Validate the accuracy and consistency of database records.
11. Execute SQL research queries.
12. Analyze findings and identify potential infrastructure improvements.

## Data Analysis Methodology

### Research Question 1: Technology Challenges and Solutions

Survey responses are analyzed to identify the most frequently reported technology issues.

Issue-to-solution mappings are used to determine which potential solutions address the greatest number of survey responses.

Responses are also grouped by staff role to compare technology challenges and potential solutions among teachers, administrators, and IT staff.

Distinct survey counts are used to prevent the same survey from being counted multiple times for the same solution.

### Research Question 2: Technology Infrastructure

Schools are evaluated using five infrastructure indicators:

| Indicator | Calculation or Measurement |
|---|---|
| Students per device | Student enrollment divided by available devices |
| Average device age | Average age of devices in years |
| Internet bandwidth per student | Internet speed divided by student enrollment |
| Wi-Fi unreliability | Percentage of surveys reporting unreliable Wi-Fi |
| Technology budget per student | Annual technology budget divided by student enrollment |

Each school is ranked according to its relative need for improvement for each indicator.

Higher students-per-device ratios, older devices, lower bandwidth per student, higher Wi-Fi unreliability, and lower budgets per student indicate greater relative infrastructure needs.

The five indicator ranks are equally weighted and added together to calculate an overall infrastructure priority score.

A lower combined score indicates a higher relative priority for improvement.

Schools with equal scores may receive the same priority rank.

An analytical benchmark of 1 Mbps per student is also used to evaluate internet bandwidth availability. This is a selected project benchmark rather than a universal infrastructure requirement.

### Research Question 3: Recommended Improvements

The school_solutions_summary SQL view connects school infrastructure records, staff surveys, technology issues, and potential solutions.

Potential solutions are evaluated using:

- Number of issue-to-solution matches
- Number of unique technology issues addressed
- Number of distinct surveys reporting relevant issues

Solutions are ranked within each school primarily by the number of relevant surveys and secondarily by the number of unique issues addressed.

The highest-ranked solutions are then compared across schools.

The analysis also identifies potential solutions for schools with the greatest overall infrastructure improvement needs.

Tied rankings are retained to avoid arbitrarily excluding equally ranked schools or solutions.

## Data Quality and Validation

Several database constraints are used to maintain data integrity:

- Primary keys
- Composite primary keys
- Foreign keys
- UNIQUE constraints
- NOT NULL constraints
- CHECK constraints

Database validation tests were performed to verify:

- Expected table and view creation
- Correct record counts
- Primary key uniqueness
- Foreign key integrity
- Required field completeness
- Valid data values
- Survey-to-issue relationships
- Issue-to-solution relationships
- Consistency of simulated survey descriptions
- Accuracy of the SQL view

## Research Limitations

- All data is simulated.
- The dataset contains only 15 schools and 60 survey responses.
- Staff roles are not equally represented.
- Technology issue categorization involves researcher judgment.
- Issue-to-solution mappings are based on predefined assumptions.
- The infrastructure priority indicators are equally weighted.
- Proposed solutions have not been tested through actual implementation.
- Implementation costs and available funding are not directly incorporated into solution rankings.
- Findings cannot be generalized to actual schools without additional research.
