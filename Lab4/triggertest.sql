

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

-- 4. Should not be registered after these calls.
DELETE FROM Registrations WHERE Student = '19650430-7734' AND CourseCode = 'TDA358';
DELETE FROM Registrations WHERE Student = '19650430-7734' AND CourseCode = 'TDA358';
