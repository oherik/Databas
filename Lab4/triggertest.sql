-- TESTS FOR TRIGGERS
-- Should not throw error, existing student and a restricted course with another person waiting. Should be put on waiting List
INSERT INTO Registrations VALUES('851007-9091','MED21');
-- Should not throw error, existing student and a restructed course with no waiting list
INSERT INTO Registrations VALUES('851007-9091', 'TDA383');
-- Should throw error, this student is already waiting for this course
--INSERT INTO Registrations VALUES('851007-9091','TDA358');
-- Should throw error, this student is already reegistered on this course
--INSERT INTO Registrations VALUES('851007-9091','MVE334');


-- UNREGISTER

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

-- 4. 
\echo '------------------------------------------ \n Test 4: Should not be registered after these calls.\n'
DELETE FROM Registrations WHERE Student = '19650430-7734' AND CourseCode = 'TDA358';
DELETE FROM Registrations WHERE Student = '19650430-7734' AND CourseCode = 'TDA358';

-- 5.
\echo '------------------------------------------ \n Test 5: Register the student for a course that they don’t have \n the prerequisites for, and show that the registration doesn’t go through.\n'
	 