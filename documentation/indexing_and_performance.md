# Indexing and Performance Optimization

## Overview

The SDG 9 School Technology Infrastructure Database uses indexes to support efficient data retrieval, table relationships, data integrity, and research analysis. The database contains 14 indexes across six tables.

## Index Inventory

| Table | Index | Indexed Columns |
|---|---|---|
| schools | PRIMARY | school_id |
| schools | idx_schools_internet_speed | internet_speed |
| schools | idx_schools_budget | budget |
| surveys | PRIMARY | survey_id |
| surveys | idx_surveys_school_wifi | school_id, wifi_works |
| surveys | idx_surveys_role | role |
| issues | PRIMARY | issue_id |
| issues | uq_issues_issue_name | issue_name |
| solutions | PRIMARY | solution_id |
| solutions | uq_solutions_solution_name | solution_name |
| survey_issues | PRIMARY | survey_id, issue_id |
| survey_issues | idx_survey_issues_issue_id | issue_id |
| issue_solutions | PRIMARY | issue_id, solution_id |
| issue_solutions | idx_issue_solutions_solution_id | solution_id |

## Index Selection and Rationale

### Primary Key Indexes

Primary key indexes uniquely identify records and support relationships between tables. Composite primary keys in the junction tables prevent duplicate relationships.

### Unique Indexes

Unique indexes on issue names and solution names prevent duplicate technology categories and proposed solutions.

### Secondary Indexes

- **idx_schools_internet_speed:** Supports filtering schools by internet speed.
- **idx_schools_budget:** Supports filtering schools by technology budget.
- **idx_surveys_school_wifi:** Supports school-based survey retrieval and Wi-Fi reliability analysis.
- **idx_surveys_role:** Supports analysis of responses by staff role.
- **idx_survey_issues_issue_id:** Supports retrieving surveys associated with specific technology issues.
- **idx_issue_solutions_solution_id:** Supports retrieving issues associated with specific solutions.

## Performance Testing

The MySQL EXPLAIN statement was used to evaluate index usage and query execution plans.

The following query was tested:

    EXPLAIN
    SELECT survey_id
    FROM surveys
    WHERE school_id = 1
        AND wifi_works = 'no';

The execution plan confirmed that MySQL selected the composite index `idx_surveys_school_wifi`.

This allows MySQL to locate matching records through the index rather than performing a full table scan.

## Performance Limitations

The database currently contains 234 simulated records. Because the dataset is relatively small, significant improvements in execution time may not be observable.

Index usage depends on query structure, data distribution, and MySQL's query optimizer. No specific execution-time improvement is claimed without additional benchmarking.

## Conclusion

The indexing strategy supports the database's research objectives while maintaining data integrity and efficient access to related records. These indexes also prepare the database for potential expansion as additional schools and survey responses are collected.
