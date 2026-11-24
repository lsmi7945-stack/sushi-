# SDG 9: School Technology Infrastructure Database

## Project Overview

Our project focuses on Sustainable Development Goal 9 (SDG 9): Industry, Innovation, and Infrastructure, specifically addressing technology challenges faced by underfunded schools. Many schools struggle with limited access to technology, outdated devices, unreliable internet connections, and insufficient funding to improve their resources. These challenges can affect students' learning experiences and teachers' ability to effectively use technology in the classroom. The purpose of our project is to design a relational database that collects, organizes, and analyzes information about schools' technology resources and challenges. By examining this information, we hope to identify common technology-related problems, compare the resources available at different schools, and determine which schools may need additional support.

To collect this information, our project will use three main data sources: school information forms, staff surveys, and school technology needs-ranking forms. School information forms will provide general information about each school, including student enrollment, the number of available devices, internet speeds, and technology budgets. Staff surveys will allow teachers, administrators, and other school employees to report technology-related issues they experience, such as poor Wi-Fi connections, outdated computers, or insufficient devices. The needs-ranking forms will allow schools to identify and prioritize the technology improvements they consider most important. For this project, we will use mock data to represent the information that could realistically be collected from these sources.

## Project Objectives

- Identify common technology challenges experienced by school staff.
- Evaluate the availability and quality of school technology resources.
- Compare technology needs across schools and staff roles.
- Identify schools with the greatest need for infrastructure improvements.
- Recommend potential solutions based on reported technology issues.
- Demonstrate relational database design, normalization, indexing, and SQL analysis.

## Research Questions

### Research Question 1: Technology Challenges and Solutions

What technology-related challenges are most commonly experienced by school staff, and what potential solutions could address these challenges?

- Q1a: What are the most frequently reported technology issues?
- Q1b: Which potential solutions address the greatest number of survey responses?
- Q1c: How do potential solutions differ across staff roles?

### Research Question 2: Technology Infrastructure

Which schools have the greatest need for technology infrastructure improvements?

- Q2a: Which schools have the greatest device shortages?
- Q2b: Which schools have the lowest internet bandwidth per student?
- Q2c: Which schools experience the most Wi-Fi reliability problems?
- Q2d: Which schools have the lowest technology budgets per student?
- Q2e: Which schools have the highest overall infrastructure improvement priority?

### Research Question 3: Recommended Improvements

Which technology improvements should be prioritized across individual schools?

- Q3a: What are the highest-ranked potential solutions for each school?
- Q3b: Which solutions are most frequently ranked first across schools?
- Q3c: Which solutions should be prioritized at the schools with the greatest infrastructure needs?

## Database Design

The database is named `sdg9_school_tech_revised` and contains six relational tables and one SQL view.

| Table | Description | Records |
|---|---|---:|
| schools | Stores school technology infrastructure information | 15 |
| surveys | Stores staff survey responses | 60 |
| issues | Stores standardized technology issue categories | 12 |
| solutions | Stores potential technology improvements | 7 |
| survey_issues | Connects survey responses to reported issues | 115 |
| issue_solutions | Connects technology issues to potential solutions | 25 |
| Total | Total records across all tables | 234 |

### Database Relationships

- One school can have many survey responses.
- One survey can report multiple technology issues.
- One technology issue can appear in multiple surveys.
- One technology issue can have multiple potential solutions.
- One potential solution can address multiple technology issues.

The `survey_issues` and `issue_solutions` junction tables resolve many-to-many relationships.

### SQL View

The `school_solutions_summary` view combines school information, survey responses, technology issues, and potential solutions.

The view calculates:

- Issue-solution matches
- Unique issues addressed
- Number of surveys reporting relevant issues

This view supports school-specific solution recommendations without storing redundant calculated information.

## Data Collection Methodology

The project uses two proposed data collection instruments.

### School Infrastructure Information Form

Collects information about:

- School name and location
- Student enrollment
- Number of available devices
- Average device age
- Internet speed
- Annual technology budget

### Staff Technology Survey

Collects information about:

- Associated school
- Staff role
- Wi-Fi reliability
- Open-ended technology issue descriptions
- Survey date

Staff roles include teachers, administrators, and IT staff.

Survey responses are categorized into standardized technology issues. Each issue is then connected to one or more potential solutions using documented mapping rationales.

## Mock Data

All data used in this project is simulated for educational purposes.

The dataset includes:

- 15 simulated schools
- 60 simulated staff survey responses
- 12 standardized technology issues
- 7 potential technology solutions
- 115 survey-to-issue relationships
- 25 issue-to-solution relationships

The dataset demonstrates how the database could support real-world technology infrastructure analysis if actual school and survey data were collected.

## Database Normalization

The database was designed according to relational database normalization principles.

- First Normal Form (1NF): Attributes contain atomic values, and repeating groups are eliminated.
- Second Normal Form (2NF): Non-key attributes depend on the entire primary key.
- Third Normal Form (3NF): Transitive dependencies and unnecessary data redundancy are eliminated.
- Boyce-Codd Normal Form (BCNF): Under the intended functional dependencies, determinants are candidate keys.

Calculated values, including students per device and budget per student, are generated through SQL queries rather than stored directly in the database.

## Data Integrity

The database uses the following mechanisms to maintain data accuracy and consistency:

- Primary keys
- Composite primary keys
- Foreign keys
- UNIQUE constraints
- NOT NULL constraints
- CHECK constraints
- Referential integrity rules

These mechanisms prevent duplicate records, invalid relationships, missing required information, and invalid data values.

## Indexing and Performance

The database contains 14 indexes, including primary key indexes, unique indexes, and secondary indexes.

Secondary indexes support:

- Internet speed analysis
- Technology budget analysis
- School-based survey retrieval
- Wi-Fi reliability analysis
- Staff role analysis
- Issue-based relationships
- Solution-based relationships

MySQL EXPLAIN was used to evaluate query execution plans and confirm the use of the composite school and Wi-Fi index.

Because the dataset is relatively small, no specific execution-time improvement is claimed.

## Research Findings

### Technology Challenges

The most frequently reported technology issues were:

| Technology Issue | Surveys Reporting |
|---|---:|
| Slow Wi-Fi | 14 |
| Software compatibility errors | 14 |
| Outdated computers | 13 |
| Not enough student devices | 12 |
| Slow classroom computers | 12 |

### Potential Solutions

| Solution | Relevant Surveys | Percentage of Surveys |
|---|---:|---:|
| IT support | 44 | 73.3% |
| Software upgrades | 39 | 65.0% |
| New computers | 33 | 55.0% |
| Network equipment | 30 | 50.0% |
| Teacher technology training | 21 | 35.0% |
| Internet upgrade | 18 | 30.0% |
| Additional devices | 16 | 26.7% |

IT support was the most broadly applicable potential solution across all three staff roles.

These percentages represent survey responses containing issues that a solution could potentially address. They do not represent direct votes for solutions.

### School Infrastructure Priorities

Schools were evaluated using five equally weighted infrastructure indicators:

- Students per device
- Average device age
- Internet bandwidth per student
- Wi-Fi reliability
- Technology budget per student

| Priority Rank | School | Priority Score |
|---|---|---:|
| 1 | Brookside Academy | 20 |
| 2 | Hudson Valley Middle School | 22 |
| 3 | Oakridge Elementary | 24 |
| 4 | Eastbrook Middle School | 29 |
| 5 | Maple Grove Academy | 30 |
| 5 | Valley View Elementary | 30 |

Lower priority scores indicate greater relative infrastructure needs.

### Recommended Improvements

| School | Highest-Ranked Potential Solution |
|---|---|
| Brookside Academy | Network equipment |
| Hudson Valley Middle School | Software upgrades |
| Oakridge Elementary | Software upgrades |
| Eastbrook Middle School | IT support |
| Maple Grove Academy | IT support and network equipment |
| Valley View Elementary | IT support and network equipment |

IT support ranked first or tied for first at nine of the fifteen schools, making it the most frequently prioritized potential solution.

## Database Validation and Testing

The database was tested to verify:

- Correct table and view creation
- Expected record counts
- Primary key uniqueness
- Foreign key integrity
- Required field completeness
- CHECK constraint compliance
- Survey-to-issue relationships
- Issue-to-solution relationships
- Survey description consistency
- SQL view accuracy

Eight additional constraint enforcement tests were performed using intentionally invalid records.

All validation tests passed, and the original 234 mock data records remained intact.

## Technologies Used

- MySQL
- SQL
- MySQL Shell
- GitHub
- Microsoft Excel
- dbdiagram.io

## How to Run the Project

1. Download or clone the GitHub repository.
2. Open a MySQL connection.
3. Execute the SQL scripts in the following order:

| Order | Script | Purpose |
|---|---|---|
| 1 | 01_create_tables.sql | Creates the database, tables, constraints, and view |
| 2 | 02_insert_mock_data.sql | Populates the database |
| 3 | 03_indexes.sql | Creates additional indexes |
| 4 | 04_queries.sql | Executes the research analysis |
| 5 | 05_database_validation.sql | Verifies database integrity |

The project uses MySQL 8.0.16 or later to support enforced CHECK constraints, common table expressions, and window functions.

### Important Testing Note

The constraint testing script intentionally produces MySQL errors.

Execute each constraint test individually and run ROLLBACK after each test. These errors demonstrate that the database successfully rejects invalid data.

## Project Documentation

Supporting documentation includes:

- Entity Relationship Diagram (ERD)
- Data dictionary
- Mock data workbook
- School infrastructure information form
- Staff technology survey
- Data collection methodology
- Database normalization documentation
- Indexing and performance documentation
- Database validation evidence
- Research results and analysis

## Project Limitations

- All school information and survey responses are simulated.
- The dataset contains a limited number of schools and respondents.
- Technology issue categorization involves researcher judgment.
- Potential solutions are based on predefined issue-to-solution mappings.
- Infrastructure priority indicators are equally weighted.
- Recommended solutions have not been evaluated through actual implementation.
- Results should not be generalized to real schools without collecting actual data.

## Future Improvements

- Collect actual school infrastructure information.
- Expand the number of participating schools.
- Collect additional staff survey responses.
- Include estimated implementation costs for proposed solutions.
- Develop a dashboard for technology infrastructure analysis.
- Evaluate alternative infrastructure priority weights.
- Track technology improvements over time.

