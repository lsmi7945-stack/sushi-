DROP DATABASE IF EXISTS sdg9_school_tech;
CREATE DATABASE sdg9_school_tech;
USE sdg9_school_tech;

CREATE TABLE Schools (
    SchoolID INT PRIMARY KEY,
    SchoolName VARCHAR(100),
    Location VARCHAR(100),
    Students INT,
    Devices INT,
    StudentsPerDevice DECIMAL(3,1),
    DeviceAge DECIMAL(3,1),
    InternetSpeed INT,
    WiFiProblems INT,
    Budget INT
);

CREATE TABLE Needs (
    NeedID INT PRIMARY KEY,
    NeedName VARCHAR(50)
);

CREATE TABLE Issues (
    IssueID INT PRIMARY KEY,
    IssueName VARCHAR(50),
    NeedID INT,
    FOREIGN KEY (NeedID) REFERENCES Needs(NeedID)
);

CREATE TABLE Surveys (
    SurveyID INT PRIMARY KEY,
    SchoolID INT,
    Role VARCHAR(20),
    IssueID INT,
    WiFiWorks VARCHAR(3),
    SurveyDate DATE,
    FOREIGN KEY (SchoolID) REFERENCES Schools(SchoolID),
    FOREIGN KEY (IssueID) REFERENCES Issues(IssueID)
);

CREATE TABLE SchoolNeeds (
    SchoolNeedID INT PRIMARY KEY,
    SchoolID INT,
    NeedID INT,
    Priority INT,
    FOREIGN KEY (SchoolID) REFERENCES Schools(SchoolID),
    FOREIGN KEY (NeedID) REFERENCES Needs(NeedID)
);
