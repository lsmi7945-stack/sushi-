# Database Normalization

## Overview

The SDG 9 School Technology Infrastructure Database was designed using relational database normalization principles to reduce unnecessary data redundancy, maintain data integrity, and improve database organization.

The revised database contains six relational tables and one SQL view.

## Database Tables

| Table | Primary Key | Purpose |
|---|---|---|
| schools | school_id | Stores school infrastructure information |
| surveys | survey_id | Stores individual staff survey responses |
| issues | issue_id | Stores standardized technology issues |
| solutions | solution_id | Stores potential technology improvements |
| survey_issues | survey_id, issue_id | Connects surveys to technology issues |
| issue_solutions | issue_id, solution_id | Connects issues to potential solutions |

The database also contains the school_solutions_summary SQL view.

## First Normal Form (1NF)

### Requirements

A table satisfies First Normal Form when:

- Each field contains an atomic value.
- Repeating groups are eliminated.
- Each record can be uniquely identified.

### Application to the Database

All six tables have primary keys that uniquely identify their records.

Individual school attributes, survey attributes, issue categories, and potential solutions are stored in separate columns.

A survey may report multiple technology issues. Instead of storing multiple issue identifiers in a single field, the database uses the survey_issues junction table.

For example, if survey 1001 reports two technology issues, the relationships are stored as separate records.

| survey_id | issue_id |
|---|---|
| 1001 | 3 |
| 1001 | 5 |

Similarly, the issue_solutions junction table stores each issue-to-solution relationship as a separate record.

The issue_description field in the surveys table stores the original written response as a single text attribute. Standardized issue relationships are stored separately in the survey_issues table.

This eliminates repeating groups and allows individual technology issues to be analyzed independently.

Therefore, the database satisfies First Normal Form.

## Second Normal Form (2NF)

### Requirements

A table satisfies Second Normal Form when:

- It satisfies First Normal Form.
- Every non-key attribute depends on the entire candidate key.
- Partial dependencies are eliminated.

### Application to the Database

The schools, surveys, issues, and solutions tables each have a single-column primary key.

The survey_issues and issue_solutions tables have composite primary keys.

### survey_issues Table

Composite primary key:

    (survey_id, issue_id)

This table contains only the two attributes that form its primary key.

There are no non-key attributes and therefore no partial dependencies.

### issue_solutions Table

Composite primary key:

    (issue_id, solution_id)

The mapping_rationale attribute describes why a specific solution may address a specific technology issue.

The rationale depends on the combination of issue_id and solution_id rather than either identifier individually.

Functional dependency:

    (issue_id, solution_id) -> mapping_rationale

Issue names and descriptions are stored in the issues table, while solution names and descriptions are stored in the solutions table.

This prevents attributes that depend on only part of the composite key from being stored in the junction table.

Therefore, the database satisfies Second Normal Form under the intended functional dependencies.

## Third Normal Form (3NF)

### Requirements

A table satisfies Third Normal Form when:

- It satisfies Second Normal Form.
- Non-key attributes do not depend transitively on candidate keys through other non-key attributes.

### Application to the Database

Each table stores information about a specific entity or relationship.

### schools Table

The school_id determines the school's infrastructure information.

    school_id -> school_name, location, students,
                 devices, device_age, internet_speed,
                 budget

School infrastructure information is stored only in the schools table.

### surveys Table

The survey_id determines the information associated with an individual survey response.

    survey_id -> school_id, role, wifi_works,
                 issue_description, survey_date

School names and infrastructure information are not duplicated in the surveys table.

Instead, school_id connects survey responses to their corresponding school.

### issues Table

The issue_id determines the standardized issue name and description.

    issue_id -> issue_name, description

Issue information is not duplicated in the survey_issues or issue_solutions tables.

### solutions Table

The solution_id determines the solution name and description.

    solution_id -> solution_name, description

Solution information is not duplicated in the issue_solutions table.

### survey_issues Table

The composite primary key identifies each survey-to-issue relationship.

The table does not contain additional non-key attributes.

### issue_solutions Table

The composite primary key determines the mapping rationale.

    (issue_id, solution_id) -> mapping_rationale

The table does not duplicate issue names, issue descriptions, solution names, or solution descriptions.

Therefore, the database satisfies Third Normal Form under the intended functional dependencies.

## Boyce-Codd Normal Form (BCNF)

### Requirements

A table satisfies Boyce-Codd Normal Form when every determinant of a nontrivial functional dependency is a superkey.

BCNF provides a stronger normalization requirement than Third Normal Form.

### Application to the Database

The intended determinants and candidate keys are:

| Table | Candidate Keys |
|---|---|
| schools | school_id |
| surveys | survey_id |
| issues | issue_id, issue_name |
| solutions | solution_id, solution_name |
| survey_issues | (survey_id, issue_id) |
| issue_solutions | (issue_id, solution_id) |

The issue_name and solution_name attributes are alternate candidate keys because they are required and have UNIQUE constraints.

Under the intended functional dependencies, each nontrivial determinant is a candidate key or superkey.

Therefore, the six relational tables satisfy BCNF under the stated design assumptions.

## Elimination of Many-to-Many Relationships

The database contains two many-to-many relationships.

### Surveys and Technology Issues

- One survey can report multiple technology issues.
- One technology issue can appear in multiple surveys.

This relationship is resolved using the survey_issues junction table.

    surveys (1) --- (many) survey_issues
    issues  (1) --- (many) survey_issues

### Technology Issues and Potential Solutions

- One technology issue can have multiple potential solutions.
- One potential solution can address multiple technology issues.

This relationship is resolved using the issue_solutions junction table.

    issues    (1) --- (many) issue_solutions
    solutions (1) --- (many) issue_solutions

Composite primary keys prevent duplicate relationships in both junction tables.

## Elimination of Redundant Calculated Attributes

The revised database avoids storing calculated infrastructure indicators directly in the schools table.

Examples include:

| Calculated Attribute | Calculation |
|---|---|
| Students per device | students / devices |
| Internet bandwidth per student | internet_speed / students |
| Technology budget per student | budget / students |
| Wi-Fi unreliability percentage | Unreliable Wi-Fi surveys / total surveys |

These values are calculated using SQL queries when needed.

NULLIF can be used to prevent division-by-zero errors when calculating ratios.

Removing stored calculated values reduces redundancy and prevents inconsistencies when underlying data changes.

## SQL View and Normalization

The school_solutions_summary view combines information from the relational tables to generate school-specific solution summaries.

The view calculates:

- Issue-to-solution matches
- Unique issues addressed
- Distinct surveys reporting relevant issues

These calculated results are generated dynamically rather than stored in an additional base table.

This prevents redundant summary information and ensures that the results reflect the underlying database records.

## Prevention of Data Anomalies

Normalization helps prevent insertion, update, and deletion anomalies.

### Insertion Anomalies

New schools, issues, and solutions can be added independently without requiring unrelated survey records.

### Update Anomalies

School infrastructure information can be updated in the schools table without updating every associated survey.

Similarly, issue and solution descriptions can be updated in their respective tables without modifying every junction table record.

### Deletion Anomalies

Deleting a survey does not require deleting the associated school or standardized technology issue.

Foreign key constraints control how related records may be deleted and prevent orphaned relationships.

### Duplicate Relationships

Composite primary keys prevent the same survey-to-issue or issue-to-solution relationship from being entered more than once.

## Benefits of the Revised Database Design

The normalized database structure provides the following benefits:

- Reduced data redundancy
- Improved data consistency
- Stronger referential integrity
- Prevention of duplicate relationships
- Easier database maintenance
- More flexible research queries
- Improved scalability
- Clear separation of entities and relationships
- Reduced risk of data anomalies
