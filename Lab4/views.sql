
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
SELECT Student,
    Unread_Course
FROM(
  SELECT NationalID as Student,
    Course  as Unread_Course
  FROM
  StudentsFollowing JOIN ProgrammeHasMandatory
  ON StudentsFollowing.Programme = ProgrammeHasMandatory.Programme
UNION DISTINCT
  SELECT NationalID as Student,
    Course as Unread_Course
  FROM
   StudentsFollowing JOIN BranchHasMandatory
   ON StudentsFollowing.Branch = BranchHasMandatory.Branch AND StudentsFollowing.Programme = BranchHasMandatory.Programme)
  AS MandatoryHelp
EXCEPT
  SELECT Student, CourseCode as Unread_Course
  FROM PassedCourses
  ORDER BY Student DESC;
;
CREATE VIEW  PathToGraduation AS(
WITH  RecommendedCreditTable AS (
        SELECT NationalID AS StudentID,
              coalesce(Sum(Credit), 0) AS RecommendedCredit
        FROM    PassedCourses
        Inner JOIN HasRecommended
        ON      HasRecommended.Course = PassedCourses.CourseCode
        RIGHT OUTER JOIN StudentsFollowing
        ON StudentsFollowing.NationalID = PassedCourses.Student AND
          HasRecommended.Branch = StudentsFollowing.Branch
          AND HasRecommended.Programme = StudentsFollowing.Programme
        GROUP BY StudentID),
      ResearchCreditTable AS (
        SELECT  NationalID AS StudentID,
                coalesce(sum(Credit), 0) AS ResearchCredit
        FROM    PassedCourses
        INNER  JOIN HasClassification
        ON      HasClassification.Course = PassedCourses.CourseCode AND HasClassification.Classification = 'Research'
        RIGHT OUTER JOIN StudentsFollowing
        ON      StudentsFollowing.NationalID = PassedCourses.Student
        GROUP BY StudentID),
      TotalCreditTable AS (
        SELECT NationalID AS StudentID,
              coalesce(Sum(Credit),0) AS TotalCredit
        FROM    PassedCourses
              FULL OUTER JOIN StudentsFollowing
        ON      StudentsFollowing.NationalID = PassedCourses.Student
        GROUP BY StudentID),
      SeminarCoursesTable AS (
        SELECT NationalID AS StudentID,
                coalesce(Count(Course), 0) AS SeminarCourses
        FROM    PassedCourses
        INNER  JOIN HasClassification
        ON      HasClassification.Course = PassedCourses.CourseCode AND HasClassification.Classification = 'Seminar'
        RIGHT OUTER JOIN StudentsFollowing
        ON      StudentsFollowing.NationalID = PassedCourses.Student
        GROUP BY StudentID),
      UnreadMandatoryTable AS (
        SELECT NationalID AS StudentID,
               coalesce(Count(Unread_Course), 0) AS MandatoryLeft
        FROM    UnreadMandatory
        FULL OUTER JOIN StudentsFollowing
        ON StudentsFollowing.NationalID = UnreadMandatory.Student
        GROUP BY StudentID),
      MathCreditTable AS (
        SELECT NationalID AS StudentID,
               coalesce(sum(Credit), 0) AS MathCredit
        FROM    PassedCourses
        INNER  JOIN HasClassification
        ON      HasClassification.Course = PassedCourses.CourseCode AND HasClassification.Classification = 'Mathematical'
        RIGHT OUTER JOIN StudentsFollowing
        ON      StudentsFollowing.NationalID = PassedCourses.Student
        GROUP BY StudentID),
      PathToGraduationHelp AS(
        SELECT
          TotalCreditTable.StudentID AS Student,
          TotalCreditTable.TotalCredit,
          MandatoryLeft,
          MathCreditTable.MathCredit,
          ResearchCreditTable.ResearchCredit AS ResearchCredit,
          SeminarCoursesTable.SeminarCourses,
          RecommendedCreditTable.RecommendedCredit
        FROM RecommendedCreditTable, UnreadMandatoryTable, MathCreditTable, ResearchCreditTable,
        SeminarCoursesTable, TotalCreditTable

       WHERE
          TotalCreditTable.StudentID = UnreadMandatoryTable.StudentID AND
          TotalCreditTable.StudentID = MathCreditTable.StudentID AND
          TotalCreditTable.StudentID = ResearchCreditTable.StudentID AND
          TotalCreditTable.StudentID = SeminarCoursesTable.StudentID AND
          TotalCreditTable.StudentID = RecommendedCreditTable.StudentID

       GROUP BY Student,
       TotalCredit,
      MandatoryLeft,
      MathCredit,
      ResearchCredit,
      SeminarCourses,
      RecommendedCredit
       )
SELECT Student,
      TotalCredit,
      MandatoryLeft,
      MathCredit,
      ResearchCredit,
      SeminarCourses,
      RecommendedCredit,
      'Qualify' AS Graduated
FROM PathToGraduationHelp
WHERE(
  MandatoryLeft = 0 AND RecommendedCredit >= 10 AND MathCredit >= 20 AND ResearchCredit >= 10 AND SeminarCourses >= 1)
UNION
  SELECT Student,
      TotalCredit,
      MandatoryLeft,
      MathCredit,
      ResearchCredit,
      SeminarCourses,
      RecommendedCredit,
      'Not Qualified' AS Graduated
FROM PathToGraduationHelp
WHERE(
  MandatoryLeft > 0 OR RecommendedCredit < 10 OR MathCredit < 20
  OR ResearchCredit < 10 OR SeminarCourses < 1 OR RecommendedCredit = 0))
;