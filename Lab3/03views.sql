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