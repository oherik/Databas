-- TESTS FOR TRIGGERS
-- Should not throw error, existing student and a restricted course with another person waiting
INSERT INTO Registrations VALUES('851007-9091','MED21');
-- Should not throw error, existing student and a restructed course with no waiting list
INSERT INTO Registrations VALUES('851007-9091', 'TDA383')
-- Should throw error, this student is already waiting for this course
-- INSERT INTO Registrations VALUES('851007-9091','TDA358');

