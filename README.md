# SDG 9: School Technology Infrastructure Database

## Project Overview

Our project focuses on Sustainable Development Goal 9 (SDG 9): Industry, Innovation, and Infrastructure, specifically addressing technology challenges faced by underfunded schools. Many schools struggle with limited access to technology, outdated devices, unreliable internet connections, and insufficient funding to improve their resources. These challenges can affect students' learning experiences and teachers' ability to effectively use technology in the classroom. The purpose of our project is to design a relational database that collects, organizes, and analyzes information about schools' technology resources and challenges. By examining this information, we hope to identify common technology-related problems, compare the resources available at different schools, and determine which schools may need additional support.

To collect this information, our project will use three main data sources: school information forms, staff surveys, and school technology needs-ranking forms. School information forms will provide general information about each school, including student enrollment, the number of available devices, internet speeds, and technology budgets. Staff surveys will allow teachers, administrators, and other school employees to report technology-related issues they experience, such as poor Wi-Fi connections, outdated computers, or insufficient devices. The needs-ranking forms will allow schools to identify and prioritize the technology improvements they consider most important. For this project, we will use mock data to represent the information that could realistically be collected from these sources.

## Research Questions

Our project aims to answer three main questions:

1. What are the most commonly reported technology problems and needs across schools?
2. Which schools have the greatest shortages of technology resources?
3. Which technology improvements should be prioritized based on the frequency of reported issues?

## Database Structure

Our database is named `sdg9_school_tech` and contains five tables.

### 1. schools
Stores information about each school's technology resources, including student enrollment, number of devices, average device age, internet speed, and technology budget.

### 2. needs
Stores categories of possible technology improvements, such as internet upgrades, new computers, and additional devices.

### 3. issues
Stores technology problems reported by school staff. Each issue is associated with a possible improvement in the `needs` table.

### 4. surveys
Stores individual survey responses from teachers, administrators, and other school employees. Each survey belongs to one school.

### 5. survey_issues
Connects surveys to the technology problems reported in them. This table allows a single survey to report multiple issues and creates a many-to-many relationship between surveys and issues.

### SQL View: school_needs_summary

The `school_needs_summary` view calculates how frequently each technology need is reported at each school.

This replaces our original `SchoolNeeds` table because school needs can be determined from survey responses without storing duplicate information.

## Database Relationships

- One school can have multiple surveys.
- One need can be associated with multiple issues.
- One survey can report multiple issues.
- One issue can appear in multiple surveys.
- The `survey_issues` table establishes the many-to-many relationship between surveys and issues.

## Data Sources

Our project uses synthetic mock data representing school technology resources and staff survey responses.

The dataset includes:

- 15 schools
- 7 technology need categories
- 12 technology issue categories
- 60 staff surveys
- 115 survey-issue records

The mock data is intended to demonstrate how a school technology database could be used to analyze infrastructure challenges.

## SQL Queries and Analysis

Our SQL queries are designed to:

- Identify the most commonly reported technology needs.
- Compare the number of students per available device.
- Determine which schools report the most Wi-Fi reliability problems.
- Compare technology budgets per student.
- Identify frequently reported needs at individual schools.

The database also includes indexes to support efficient data retrieval and relationships between tables.

## Database Normalization

Our database was revised to reduce redundant information and improve its relational structure.

We removed the original `SchoolNeeds` table and replaced it with the `school_needs_summary` view. We also added the `survey_issues` junction table to allow multiple technology problems to be recorded for each survey.

Additionally, the number of students per device is calculated using SQL rather than stored as a separate column.

## How to Run the Database

1. Install MySQL Server and MySQL Workbench.
2. Open MySQL Workbench and connect to your MySQL server.
3. Run `01_create_tables.sql` to create the database and tables.
4. Run `02_insert_mock_data.sql` to populate the tables.
5. Run `03_indexes.sql` to create any additional indexes.
6. Run `04_queries.sql` to execute the research queries.

**Note:** The database creation script may delete and recreate the existing database. Back up any existing data before running it.

## Project Documentation

The repository is intended to include:

- SQL scripts for database creation, mock data, indexes, and analysis.
- An entity-relationship diagram showing the database structure.
- A data dictionary defining the tables and attributes.
- Project documentation explaining our research questions, methodology, and findings.

## Project Goal

The purpose of this project is to demonstrate how a relational database can be used to analyze technology infrastructure challenges in schools.

By examining available resources and staff-reported issues, we aim to identify potential technology improvements and support more informed decisions about school technology investments.

