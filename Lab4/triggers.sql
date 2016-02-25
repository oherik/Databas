/*
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

*/

CREATE FUNCTION register() RETURNS trigger as $register$
DECLARE queueLength INT;
DECLARE isWaiting BOOLEAN;
DECLARE isRegistered BOOLEAN;
DECLARE hasPassed BOOLEAN;
	BEGIN
		queueLength := (SELECT MAX(QueuePos) FROM IsOnWaitingList 
			WHERE NEW.CourseCode = IsOnWaitingList.RestrictedCourse);	
		
		/*
		 Check if the student can be added to the course or waiting list. Uses separate IFs for greater speed.
		 The alternative would be a IF - ELSEIF statement after these variables have been declared, but there
		 is no need to declare the following variables if an exception should be raised.
		*/
		isWaiting := (SELECT EXISTS(SELECT 1 FROM IsOnWaitingList WHERE
				NEW.Student = IsOnWaitingList.Student AND NEW.CourseCode = IsOnWaitingList.RestrictedCourse));
		IF isWaiting THEN
			RAISE EXCEPTION 'The student is already waiting for a place on this course';
		END IF;

		isRegistered := (SELECT EXISTS(SELECT 1 FROM RegisteredOn WHERE
				NEW.Student = RegisteredOn.Student AND NEW.CourseCode = RegisteredOn.Course));
		IF isRegistered THEN
			RAISE EXCEPTION 'The student is already registered on this course';
		END IF;

		hasPassed := (SELECT EXISTS(SELECT 1 FROM HasFinished WHERE
			NEW.Student = HasFinished.Student AND NEW.CourseCode = HasFinished.Course));
		IF hasPassed THEN
			RAISE EXCEPTION 'The student has already passed this course';
		END IF;
		-- Har inte läst förkrav 


		-- Add the student to the appropriate table
		IF queueLength > 0 THEN
			INSERT INTO IsOnWaitingList(Student, RestrictedCourse, QueuePos) 
				VALUES(NEW.Student, NEW.CourseCode, queueLength+1);
		ELSE
			INSERT INTO RegisteredOn(Student, Course) 
				VALUES(NEW.Student, NEW.CourseCode);
		END IF;
		RETURN NEW;
	END;
$register$ LANGUAGE plpgsql;

CREATE TRIGGER register INSTEAD OF INSERT ON Registrations
	FOR EACH ROW EXECUTE PROCEDURE register();	

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