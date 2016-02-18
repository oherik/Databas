CREATE VIEW StudentsFollowing AS
SELECT  NationalID,
        SchoolID,
        Name,
        Student.Programme,
        Branch
FROM    Student FULL OUTER JOIN StudiesBranch
ON      StudiesBranch.Student = Student.NationalID;

CREATE VIEW FinishedCourses AS
SELECT  Student,
        Course.Code AS CourseCode,
        Course.Name AS CourseName,
        Grade,
        Credit
FROM    HasFinished JOIN Course
ON      HasFinished.Course = Course.Code;

CREATE VIEW Registrations AS
SELECT  Student,
        Code AS CourseCode,
        Name AS CourseName,
        'Waiting' AS Status
FROM    IsOnWaitingList JOIN Course
ON      IsOnWaitingList.RestrictedCourse = Course.Code
UNION
SELECT  Student,
        Code AS CourseCode,
        Name AS CourseName,
        'Registred' AS Status
FROM    RegisteredOn JOIN Course
ON      RegisteredOn.Course = Course.Code;

CREATE VIEW PassedCourses AS
SELECT  Student,
        Code AS CourseCode,
        Name AS CourseName,
        Credit
FROM    HasFinished JOIN Course
ON      HasFinished.Course = Course.Code
WHERE   Grade <> 'U';

CREATE VIEW UnreadMandatory AS
SELECT NationalID as Student,
		Course	as Unread_Course
FROM
	StudentsFollowing JOIN ProgrammeHasMandatory
 	ON StudentsFollowing.Programme = ProgrammeHasMandatory.Programme
UNION DISTINCT
SELECT NationalID,
		Course
FROM
	StudentsFollowing JOIN BranchHasMandatory
	ON StudentsFollowing.Branch = BranchHasMandatory.Branch AND StudentsFollowing.Programme = BranchHasMandatory.Programme

EXCEPT
SELECT Student, CourseCode
FROM PassedCourses
;
CREATE VIEW PathToGraduation AS
SELECT NationalID AS StudentID,
        Sum(Credit) AS TotalCredit
        --Count(Unread_Course) AS NbrMandatoryLeft
        --MathCredits,
        --ResearchCredit,
        --NbrOfSeminarCourses,
        --Qualify
FROM StudentsFollowing JOIN PassedCourses
ON      StudentsFollowing.NationalID = PassedCourses.Student
     --   JOIN UnreadMandatory
--ON      StudentsFollowing.NationalID = UnreadMandatory.Student
GROUP BY StudentID
UNION DISTINCT
-- When no courses are passed
SELECT NationalID AS StudentID,
        0 AS TotalCredit
        --Count(Unread_Course) AS NbrMandatoryLeft
        --MathCredits,
        --ResearchCredit,
        --NbrOfSeminarCourses,
        --Qualify
FROM StudentsFollowing JOIN PassedCourses
ON      StudentsFollowing.NationalID <> PassedCourses.Student
       -- JOIN UnreadMandatory
--ON      StudentsFollowing.NationalID = UnreadMandatory.Student
GROUP BY StudentID
;



--TODO ändra till SchoolID