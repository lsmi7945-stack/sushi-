# School Infrastructure Information Form

## Purpose

The purpose of this form is to collect quantitative information about school technology infrastructure. The information will be used to evaluate technology resources, identify infrastructure shortages, and compare technology needs across schools.

## Intended Respondents

This form should be completed by a school administrator or IT staff member who has access to accurate school technology and enrollment information.

## School Information

### 1. School Name

Enter the full name of the school.

Response: ____________________

### 2. School Location

Enter the city and state where the school is located.

Response: ____________________

### 3. Student Enrollment

How many students are currently enrolled at the school?

Response: ____________________

### 4. Available Technology Devices

How many functional technology devices are available for student use?

Response: ____________________

### 5. Average Device Age

What is the average age of the school's technology devices in years?

Response: ____________________

### 6. Internet Speed

What is the school's internet connection speed in megabits per second (Mbps)?

Response: ____________________

### 7. Annual Technology Budget

What is the school's annual technology budget in U.S. dollars?

Response: ____________________

## Database Field Mapping

| Form Question | Database Column | Required |
|---|---|---|
| School name | school_name | Yes |
| School location | location | No |
| Student enrollment | students | Yes |
| Available devices | devices | Yes |
| Average device age | device_age | No |
| Internet speed | internet_speed | No |
| Annual technology budget | budget | No |

All responses are stored in the schools table.

A unique school_id is assigned to each school by the research team.

## Data Validation

- Student enrollment must be greater than zero.
- Device counts cannot be negative.
- Average device age cannot be negative.
- Internet speed cannot be negative.
- Technology budgets cannot be negative.
- School names cannot be missing.

## Calculated Indicators

The following indicators are calculated using SQL queries rather than stored directly in the database:

- Students per device
- Internet bandwidth per student
- Technology budget per student

These indicators allow schools of different sizes to be compared more effectively.

## Data Collection Status

This form is a proposed data collection instrument. The current project uses simulated school infrastructure data for educational and database testing purposes.
