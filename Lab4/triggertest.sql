-- TESTS FOR TRIGGERS
-- Should not throw error
INSERT INTO Registrations VALUES('851007-9091','MED21');
-- Should throw error, this student is already waiting for this course
--INSERT INTO Registrations VALUES('851007-9091','TDA358');