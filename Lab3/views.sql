
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
  StudentsFollowing LEFT OUTER JOIN ProgrammeHasMandatory
  ON StudentsFollowing.Programme = ProgrammeHasMandatory.Programme
UNION DISTINCT
  SELECT NationalID,
    Course as Unread_Course
  FROM
   StudentsFollowing LEFT OUTER JOIN BranchHasMandatory
   ON StudentsFollowing.Branch = BranchHasMandatory.Branch AND StudentsFollowing.Programme = BranchHasMandatory.Programme

 WHERE Course NOT IN (
    SELECT CourseCode
    FROM PassedCourses
    WHERE Course IS NOT NULL
    ) 
  ORDER BY Student DESC;

CREATE VIEW  PathToGraduation AS(
WITH  RecommendedCreditTable AS (
        SELECT NationalID AS StudentID,
              Sum(Credit) AS RecommendedCredit
        FROM    PassedCourses
        LEFT OUTER JOIN HasRecommended
        ON      HasRecommended.Course = PassedCourses.CourseCode
        JOIN StudentsFollowing
        ON StudentsFollowing.NationalID = PassedCourses.Student
        WHERE (HasRecommended.Branch = StudentsFollowing.Branch 
          AND HasRecommended.Programme = StudentsFollowing.Programme
          AND PassedCourses.CourseCode = HasRecommended.Course)
        GROUP BY StudentID),
      StudentCourses AS (
        SELECT NationalID AS StudentID,
                CourseCode,
                Credit 
                FROM
          Student LEFT OUTER JOIN
          PassedCourses
        ON Student.NationalID = PassedCourses.Student
        ),
      ResearchCourses AS (
        SELECT Course FROM 
          HasClassification
        WHERE HasClassification.Classification = 'Research'),
      ResearchCreditTable AS (
        SELECT  StudentID,
              coalesce(sum(Credit),0) AS ResearchCredit
        FROM
          StudentCourses  LEFT OUTER JOIN ResearchCourses
        ON      StudentCourses.CourseCode = ResearchCourses.Course
        
        GROUP BY StudentID),
      TotalCreditTable AS (
        SELECT NationalID AS StudentID,
              coalesce(Sum(Credit),0) AS TotalCredit
        FROM    PassedCourses
              FULL OUTER JOIN StudentsFollowing
        ON      StudentsFollowing.NationalID = PassedCourses.Student
        GROUP BY StudentID),
      SeminarCoursesTable AS (
        SELECT Student AS StudentID,
                coalesce(Count(Course),0) AS SeminarCourses
        FROM    PassedCourses
        LEFT OUTER JOIN HasClassification
        ON      HasClassification.Course = PassedCourses.CourseCode
        WHERE HasClassification.Classification = 'Seminar'
        GROUP BY StudentID),
      UnreadMandatoryTable AS (
        SELECT UnreadMandatory.Student AS StudentID,
              coalesce(Count(Unread_Course),0) AS MandatoryLeft
        FROM    UnreadMandatory
        GROUP BY StudentID), 
      MathCreditTable AS (
        SELECT Student AS StudentID,
              coalesce(sum(Credit),0) AS MathCredit
        FROM    PassedCourses
        FULL OUTER JOIN HasClassification
        ON      HasClassification.Course = PassedCourses.CourseCode
        WHERE HasClassification.Classification = 'Mathematical'
        GROUP BY StudentID),
      PathToGraduationHelp AS(
        SELECT
          TotalCreditTable.StudentID AS Student,

          TotalCreditTable.TotalCredit,
          UnreadMandatoryTable.MandatoryLeft AS MandatoryLeft,
          MathCreditTable.MathCredit,
          ResearchCreditTable.StudentID AS RS,
          ResearchCreditTable.ResearchCredit,
          SeminarCoursesTable.SeminarCourses,
          RecommendedCreditTable.RecommendedCredit
        FROM RecommendedCreditTable, UnreadMandatoryTable, MathCreditTable, ResearchCreditTable, 
        SeminarCoursesTable, TotalCreditTable
       WHERE
         --TotalCreditTable.StudentID = MathCreditTable.StudentID AND
          TotalCreditTable.StudentID = UnreadMandatoryTable.StudentID  
          -- AND
          --otalCreditTable.StudentID = MathCreditTable.StudentID AND
        -- TotalCreditTable.StudentID = ResearchCreditTable.StudentID --AND
          --TotalCreditTable.StudentID = SeminarCoursesTable.StudentID AND
         -- TotalCreditTable.StudentID = RecommendedCreditTable.StudentID
       GROUP BY Student,
       TotalCredit,
      MandatoryLeft,
      MathCredit,
      RS,
      ResearchCredit,
      SeminarCourses,
      RecommendedCredit
       )

--* Your "PathToGraduation" is rather complex and hard to read. You should structure it better. 
--One way of doing that is to define helper queries (the ones you join at the end) in a WITH-expression.

SELECT Student,
      TotalCredit,
      MandatoryLeft,
      MathCredit,
      RS,
      ResearchCredit,
      SeminarCourses,
      'Qualify' AS Graduated
FROM PathToGraduationHelp
WHERE(
  MandatoryLeft = 0 AND RecommendedCredit >= 10 AND MathCredit >= 20 AND ResearchCredit >= 10 AND SeminarCourses >= 1)
UNION
  SELECT Student,
      TotalCredit,
      MandatoryLeft,
      MathCredit,
      RS,
      ResearchCredit,
      SeminarCourses,
      'Not Qualified' AS Graduated
FROM PathToGraduationHelp
WHERE(
  MandatoryLeft > 0 OR RecommendedCredit < 10 OR MathCredit < 20
  OR ResearchCredit < 10 OR SeminarCourses < 1 OR RecommendedCredit = 0))
;