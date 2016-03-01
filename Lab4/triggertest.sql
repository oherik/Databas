-- TESTS FOR TRIGGERS
-- Should not throw error, existing student and a restricted course with another person waiting. Should be put on waiting List
INSERT INTO Registrations VALUES('851007-9091','MED21');
-- Should not throw error, existing student and a restructed course with no waiting list
INSERT INTO Registrations VALUES('851007-9091', 'TDA383');
-- Should throw error, this student is already waiting for this course
--INSERT INTO Registrations VALUES('851007-9091','TDA358');
-- Should throw error, this student is already reegistered on this course
--INSERT INTO Registrations VALUES('851007-9091','MVE334');


-- TESTCASES

-- 1.
\echo '------------------------------------------ \n Test 1: List info for a student \n'
SELECT * FROM PathToGraduation WHERE Student = '620314-2044';

-- 2.
\echo '------------------------------------------ \n Test 2: Register the student for an unrestricted course, \n and show that they end up registered (show info again).\n'
SELECT * FROM Registrations WHERE CourseCode = 'POL227';
\echo '\nAdding 620314-2044 to POL227\n'
INSERT INTO Registrations VALUES ('620314-2044', 'POL227');
SELECT * FROM Registrations WHERE CourseCode = 'POL227';

-- 3.
\echo '------------------------------------------ \n Test 3: Register the same student for the same course again, \n and show that the program doesn’t crash, and that the student gets an error message.\n'
INSERT INTO Registrations VALUES ('620314-2044', 'POL227');
SELECT * FROM Registrations WHERE CourseCode = 'POL227';

-- 4.
\echo '------------------------------------------ \n Test 4: Should not be registered after these calls.\n'
DELETE FROM Registrations WHERE Student = '19650430-7734' AND CourseCode = 'TDA358';
DELETE FROM Registrations WHERE Student = '19650430-7734' AND CourseCode = 'TDA358';
SELECT * FROM Registrations WHERE Student = '19650430-7734' AND CourseCode = 'TDA358';

-- 5.
\echo '------------------------------------------ \n Test 5: Register the student for a course that they don’t have \n the prerequisites for, and show that the registration doesn’t go through.\n'
INSERT INTO Registrations VALUES ('19851101-1325', 'LAW4444');
SELECT * FROM Registrations WHERE Student = '19851101-1325' AND CourseCode = 'LAW4444';


\echo '------------------------------------------ \n Test 6: Unregister the student from a restricted course that they are registered to, and which has at least two students in the queue. Register again to the same course and show that the student gets the correct (last) position in the waiting list.\n'
SELECT * FROM Registrations FULL JOIN IsOnWaitingList ON Registrations.Student = IsOnWaitingList.Student WHERE Registrations.CourseCode = 'MED21' AND (IsOnWaitingList.RestrictedCourse = 'MED21' OR Registrations.Status = 'Registred');
DELETE FROM Registrations WHERE Student = '880121-5248' AND CourseCode = 'MED21';
INSERT INTO Registrations VALUES('880121-5248','MED21');
SELECT * FROM Registrations FULL JOIN IsOnWaitingList ON Registrations.Student = IsOnWaitingList.Student WHERE Registrations.CourseCode = 'MED21' AND (IsOnWaitingList.RestrictedCourse = 'MED21' OR Registrations.Status = 'Registred');


\echo '------------------------------------------ \n Test 7: Unregister, unregister again and re-register the same student for the same restricted course, and show that the student is first removed and then ends up in the same position as before (last).\n'
DELETE FROM Registrations WHERE Student = '880121-5248' AND CourseCode = 'MED21';
DELETE FROM Registrations WHERE Student = '880121-5248' AND CourseCode = 'MED21';
SELECT * FROM Registrations WHERE Student = '880121-5248' AND CourseCode = 'MED21';
INSERT INTO Registrations VALUES('880121-5248','MED21');
SELECT * FROM Registrations FULL JOIN IsOnWaitingList ON Registrations.Student = IsOnWaitingList.Student WHERE Registrations.CourseCode = 'MED21' AND (IsOnWaitingList.RestrictedCourse = 'MED21' OR Registrations.Status = 'Registred');

\echo '------------------------------------------ \n Test 8: Unregister a student from an overfull course. Show that no student was moved from the queue to being registered as a result.\n'
SELECT * FROM Registrations WHERE CourseCode = 'MDA2687';
\echo '\nRemoving 520215-3895 to MDA2687\n'
DELETE FROM Registrations WHERE Student = '520215-3895' AND CourseCode = 'MDA2687';
\echo '\nShould still be one student waiting but only five registered.\n'
SELECT * FROM Registrations WHERE CourseCode = 'MDA2687';
