USE sdg9_school_tech;

-- 1. Most needed upgrade
SELECT Needs.NeedName, COUNT(*) AS TimesRankedFirst
FROM SchoolNeeds
JOIN Needs ON SchoolNeeds.NeedID = Needs.NeedID
WHERE SchoolNeeds.Priority = 1
GROUP BY Needs.NeedName
ORDER BY TimesRankedFirst DESC;

-- 2. Students per device
SELECT SchoolName, StudentsPerDevice, DeviceAge
FROM Schools
ORDER BY StudentsPerDevice DESC;

-- 3. Internet speed
SELECT SchoolName, Students, InternetSpeed
FROM Schools
WHERE InternetSpeed < Students
ORDER BY InternetSpeed;

-- 4. Wi-Fi problems
SELECT Schools.SchoolName, Schools.WiFiProblems, COUNT(*) AS SaidNo
FROM Schools
JOIN Surveys ON Schools.SchoolID = Surveys.SchoolID
WHERE Surveys.WiFiWorks = 'No'
GROUP BY Schools.SchoolName, Schools.WiFiProblems
ORDER BY Schools.WiFiProblems DESC;

-- 5. Budget
SELECT SchoolName, Budget, StudentsPerDevice, DeviceAge
FROM Schools
ORDER BY Budget DESC;

-- 6. Problems by job
SELECT Surveys.Role, Issues.IssueName, COUNT(*) AS Answers
FROM Surveys
JOIN Issues ON Surveys.IssueID = Issues.IssueID
GROUP BY Surveys.Role, Issues.IssueName
ORDER BY Surveys.Role, Answers DESC;

-- 7. Problems that match ranked needs
SELECT COUNT(*) AS Matches
FROM Surveys
JOIN Issues ON Surveys.IssueID = Issues.IssueID
JOIN SchoolNeeds ON SchoolNeeds.SchoolID = Surveys.SchoolID
                AND SchoolNeeds.NeedID = Issues.NeedID;

-- 8. Schools to help first
SELECT Schools.SchoolName, Needs.NeedName AS TopNeed
FROM Schools
JOIN SchoolNeeds ON Schools.SchoolID = SchoolNeeds.SchoolID
JOIN Needs ON SchoolNeeds.NeedID = Needs.NeedID
WHERE SchoolNeeds.Priority = 1
  AND Schools.StudentsPerDevice > 3
  AND Schools.DeviceAge > 6
  AND Schools.InternetSpeed < 100
  AND Schools.WiFiProblems >= 9;
