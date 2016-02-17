CREATE VIEW StudentsFollowing AS
SELECT  NationalID,
SchoolID,
Name,
Programme,
Branch
FROM    Student JOIN StudiesBranch
ON      StudiesBranch.Student = Student.NationalID;

CREATE VIEW FinishedCourses AS
SELECT  Student,
Course.Name AS CourseName,
Grade,
Credit
FROM    HasFinished JOIN Course
ON      HasFinished.Course = Course.Code;

CREATE VIEW Registrations AS
SELECT  Student,
Name AS CourseName,
'Waiting' AS Status
FROM    IsOnWaitingList JOIN Course
ON      IsOnWaitingList.RestrictedCourse = Course.Code
UNION
SELECT  Student,
Name AS CourseName,
'Registred' AS Status
FROM    RegisteredOn JOIN Course
ON      RegisteredOn.Course = Course.Code;

CREATE VIEW PassedCourses AS
SELECT  Student,
Name AS CourseName,
Credit
FROM    HasFinished JOIN Course
ON      HasFinished.Course = Course.Code;
WHERE   Grade <> 'U';'

//CREATE VIEW UnreadMandatory AS
//SELECT  Student,
Name AS CourseName
//FROM    PR