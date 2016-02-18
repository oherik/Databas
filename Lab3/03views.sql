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
		Course as Unread_Course
FROM
	StudentsFollowing JOIN BranchHasMandatory
	ON StudentsFollowing.Branch = BranchHasMandatory.Branch AND StudentsFollowing.Programme = BranchHasMandatory.Programme

EXCEPT
SELECT Student, CourseCode
FROM PassedCourses
ORDER BY Student DESC ;
;
CREATE VIEW PathToGraduation AS
        SELECT
        StudentID,
        TotalCredit,
        Count(Unread_Course) AS NbrMandatoryLeft
        --MathCredits,
        --ResearchCredit,
        --NbrOfSeminarCourses,
        --Qualify
FROM (
        SELECT NationalID AS StudentID,
                Sum(Credit) AS TotalCredit
        FROM StudentsFollowing
                FULL OUTER JOIN PassedCourses
        ON      StudentsFollowing.NationalID = PassedCourses.Student
        GROUP BY StudentID) AS SumCredit
FULL OUTER JOIN UnreadMandatory
ON      SumCredit.StudentID = UnreadMandatory.Student
GROUP BY StudentID,TotalCredit
ORDER BY StudentID DESC ;
;



--TODO ändra till SchoolID