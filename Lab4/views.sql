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
    Course  as Unread_Course
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
  ORDER BY Student DESC;
;

CREATE VIEW PathToGraduationHelp AS
SELECT
      TotalCreditTable.StudentID AS Student,
      TotalCredit,
      MandatoryLeft,
      MathCredit,
      ResearchCredit,
      SeminarCourses,
      RecommendedCredit
FROM (
      SELECT NationalID AS StudentID,
              Sum(Credit) AS TotalCredit
      FROM    PassedCourses
              FULL OUTER JOIN StudentsFollowing
      ON      StudentsFollowing.NationalID = PassedCourses.Student
      GROUP BY StudentID) AS TotalCreditTable
FULL OUTER JOIN (
      SELECT Student AS StudentID,
              sum(Credit) AS MathCredit
      FROM    PassedCourses
      FULL OUTER JOIN HasClassification
      ON      HasClassification.Course = PassedCourses.CourseCode
      WHERE HasClassification.Classification = 'Mathematical'
      GROUP BY StudentID) AS MathCreditTable
    ON (TotalCreditTable.StudentID = MathCreditTable.StudentID)
FULL OUTER JOIN (
      SELECT Student AS StudentID,
              sum(Credit) AS ResearchCredit
      FROM    PassedCourses
      LEFT OUTER JOIN HasClassification
      ON      HasClassification.Course = PassedCourses.CourseCode
      WHERE HasClassification.Classification = 'Research'
      GROUP BY StudentID) AS ResearchCreditTable
    ON (TotalCreditTable.StudentID = ResearchCreditTable.StudentID)
FULL OUTER JOIN(
      SELECT UnreadMandatory.Student AS StudentID,
              Count(Unread_Course) AS MandatoryLeft
      FROM    UnreadMandatory
      GROUP BY StudentID) AS UnreadMandatoryTable
    ON (TotalCreditTable.StudentID = UnreadMandatoryTable.StudentID)
FULL OUTER JOIN (
      SELECT Student AS StudentID,
              Count(Course) AS SeminarCourses
      FROM    PassedCourses
      LEFT OUTER JOIN HasClassification
      ON      HasClassification.Course = PassedCourses.CourseCode
      WHERE HasClassification.Classification = 'Seminar'
      GROUP BY StudentID) AS SeminarCoursesTable
    ON (TotalCreditTable.StudentID = SeminarCoursesTable.StudentID)
FULL OUTER JOIN (
      SELECT NationalID AS StudentID,
              Sum(Credit) AS RecommendedCredit
      FROM    PassedCourses
      LEFT OUTER JOIN HasRecommended
      ON      HasRecommended.Course = PassedCourses.CourseCode
      JOIN StudentsFollowing
      ON StudentsFollowing.NationalID = PassedCourses.Student
      WHERE (HasRecommended.Branch = StudentsFollowing.Branch AND HasRecommended.Programme = StudentsFollowing.Programme
              AND PassedCourses.CourseCode = HasRecommended.Course)
      GROUP BY StudentID) AS RecommendedCreditTable
    ON (TotalCreditTable.StudentID = RecommendedCreditTable.StudentID)
GROUP BY TotalCreditTable.StudentID,
      TotalCredit,
      MandatoryLeft,
      MathCredit,
      ResearchCredit,
      SeminarCourses,
      RecommendedCredit
 ;
CREATE VIEW PathToGraduation AS
SELECT Student,
      TotalCredit,
      MandatoryLeft,
      MathCredit,
      ResearchCredit,
      SeminarCourses,
      'Qualify' AS Graduated
FROM PathToGraduationHelp
WHERE(
  MandatoryLeft IS NULL AND RecommendedCredit >= 10 AND MathCredit >= 20 AND ResearchCredit >= 10 AND SeminarCourses >= 1)
UNION
  SELECT Student,
      TotalCredit,
      MandatoryLeft,
      MathCredit,
      ResearchCredit,
      SeminarCourses,
      'Not Qualified' AS Graduated
FROM PathToGraduationHelp
WHERE(
  MandatoryLeft > 0 OR RecommendedCredit < 10 OR MathCredit < 20
  OR ResearchCredit < 10 OR SeminarCourses < 1 OR RecommendedCredit IS NULL)
;

CREATE VIEW CourseQueuePositions AS
SELECT Student, RestrictedCourse AS Course, QueuePos AS Queue_Position
FROM IsOnWaitingList 
;


/*
when a student tries to register for a course that is full, that student is added to the waiting list for the course. 
Be sure to check that the student may actually register for the course before adding to either list, if it may not you 
should raise an error (use RAISE EXCEPTION). Hint: There are several requirements for registration stated in the domain 
description, and some implicit ones like that a student can not be both waiting and registered for the same course at the same time.

when a student unregisters from a course if the student was properly registered and not only on the waiting list, the 
first student (if any) in the waiting list should be registered for the course instead. Note: this should only be done 
if there is actually room on the course (the course might have been over-full due to an administrator overriding the 
restriction and adding students directly).

You need to write the triggers on the view Registrations instead of on the tables themselves (third bullet under task 3 above). 
(One reason for this is that we “pretend” that you only have the privileges listed under Task 4, which means you cannot insert 
data into, or delete data from, the underlying tables directly. But even if we lift this restriction, there is another reason 
for not defining these triggers on the underlying tables - can you figure out why?)
*/