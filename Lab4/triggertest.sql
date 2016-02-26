-- TESTS FOR TRIGGERS

--______________________________________________________________________________________________

-- REGISTER

-- Should not throw error, existing student and a restricted course with another person waiting
INSERT INTO Registrations VALUES('851007-9091','MED21');

-- Should not throw error, existing student and a restructed course with no waiting list
INSERT INTO Registrations VALUES('851007-9091', 'TDA383');

-- Should throw error, this student is already waiting for this course
--INSERT INTO Registrations VALUES('851007-9091','TDA358');

-- Should throw error, this student is already registered on this course
--INSERT INTO Registrations VALUES('851007-9091','MVE334');

-- Should throw error, the student has already passed this course
-- INSERT INTO Registrations VALUES('620314-2044', 'TDA233');

-- Should throw error, the student hasn't read the prerequisute course(s)
-- INSERT INTO Registrations VALUES('790307-6193', 'FYA344');

--______________________________________________________________________________________________

-- UNREGISTER

-- Should not throw error
DELETE FROM Registrations WHERE Student = '721217-2204' AND CourseCode = 'TDA358';

-- Should throw error, this student is on the waiting list
-- DELETE FROM Registrations WHERE Student = '620314-2044' AND CourseCode = 'TDA358';