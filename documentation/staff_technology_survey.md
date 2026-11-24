# Staff Technology Survey

## Purpose

The purpose of this survey is to identify technology-related challenges experienced by school staff and determine potential improvements to school technology infrastructure.

Survey responses will be analyzed alongside school infrastructure information to identify common issues and recommend potential solutions.

## Intended Respondents

- Teachers
- Administrators
- IT staff

## Survey Instructions

Please answer the following questions based on your experience with technology at your school.

Do not include personal information, student names, or other confidential information in your responses.

### Question 1: School

Which school do you currently work at?

Response: ____________________

### Question 2: Staff Role

What is your current role at the school?

Select one:

- [ ] Teacher
- [ ] Administrator
- [ ] IT Staff

### Question 3: Wi-Fi Reliability

Does your school's Wi-Fi generally work reliably when needed?

Select one:

- [ ] Yes
- [ ] No

### Question 4: Technology Challenges

Describe any technology-related challenges you experience at your school.

You may describe multiple issues in your response. If you do not experience any technology-related issues, enter "None."

Response:

__________________________________________________

__________________________________________________

__________________________________________________

### Question 5: Survey Date

Enter the date the survey was completed.

Response: ____________________

## Database Field Mapping

| Survey Question | Database Column |
|---|---|
| School | school_id |
| Staff role | role |
| Wi-Fi reliability | wifi_works |
| Technology challenges | issue_description |
| Survey date | survey_date |

Survey responses are stored in the surveys table.

Each survey receives a unique, automatically generated survey_id.

## Technology Issue Categorization

Open-ended survey responses are reviewed and categorized by the research team.

The standardized technology issue categories are:

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

A single survey response may be associated with multiple technology issues.

The survey_issues junction table connects individual survey responses to their corresponding issue categories.

Responses reporting no technology issues would not require a survey-to-issue relationship.

## Potential Solutions

Reported technology issues are connected to one or more of the following potential solutions:

1. Internet upgrade
2. New computers
3. Additional devices
4. Software upgrades
5. IT support
6. Network equipment
7. Teacher technology training

The issue_solutions junction table connects technology issues to potential solutions and includes a rationale explaining each relationship.

Potential solutions are determined through issue-to-solution mappings rather than directly selected by survey respondents.

## Confidentiality

The proposed survey does not collect respondent names, email addresses, employee identification numbers, or other directly identifying personal information.

## Data Collection Status

This survey is a proposed data collection instrument. All survey responses currently included in the database are simulated and were created for educational and analytical purposes.
