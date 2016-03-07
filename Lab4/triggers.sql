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
DECLARE hasReadPrerequisites BOOLEAN;
DECLARE maxStudents  INT;
DECLARE registeredStudents INT;
DECLARE nbrSpotsLeft INT;

	BEGIN
		maxStudents := (SELECT RestrictedCourse.MaxStudents FROM RestrictedCourse 
			WHERE (Code = OLD.CourseCode));
      	registredStudents := (SELECT count(Student) FROM Registrations 
      		WHERE Status = 'Registred' AND Registrations.CourseCode = OLD.CourseCode);
      	nbrSpotsLeft := (SELECT maxStudents-registredStudents);
		queueLength := (SELECT MAX(QueuePos) FROM IsOnWaitingList 
			WHERE NEW.CourseCode = IsOnWaitingList.RestrictedCourse);	
		
		/*
		 Check if the student can be added to the course or waiting list. 
		 */
		isWaiting := (SELECT EXISTS(SELECT 1 FROM IsOnWaitingList WHERE
				NEW.Student = IsOnWaitingList.Student AND NEW.CourseCode = IsOnWaitingList.RestrictedCourse));
		isRegistered := (SELECT EXISTS(SELECT 1 FROM RegisteredOn WHERE
				NEW.Student = RegisteredOn.Student AND NEW.CourseCode = RegisteredOn.Course));
		hasPassed := (SELECT EXISTS(SELECT 1 FROM HasFinished WHERE
			NEW.Student = HasFinished.Student AND NEW.CourseCode = HasFinished.Course));
		hasReadPrerequisites := (SELECT COALESCE((SELECT false FROM
		(SELECT RequiredCourse as Course FROM Prerequisite WHERE Prerequisite.Course = NEW.CourseCode
		EXCEPT
		SELECT Course FROM HasFinished WHERE HasFinished.Student = NEW.Student) as CoursesLeft
		WHERE CoursesLeft.Course IS NOT NULL LIMIT 1), true));
		
		IF isRegistered THEN
			RAISE NOTICE 'The student % is already registered on the course %.', NEW.Student, NEW.CourseCode;
		ELSEIF isWaiting THEN
			RAISE NOTICE 'The student % is already waiting for a place on the course %.', NEW.Student, NEW.CourseCode;
		ELSEIF hasPassed THEN
			RAISE NOTICE 'The student % has already passed the course %.', NEW.Student, NEW.CourseCode;
		ELSEIF NOT hasReadPrerequisites THEN
			RAISE NOTICE 'The student % has not finished the prerequisite course(s) from the course %.',
				NEW.Student, NEW.CourseCode;
		ELSE
		-- Add the student to the appropriate table
			IF queueLength > 0 OR nbrSpotsLeft < 1 THEN
				INSERT INTO IsOnWaitingList(Student, RestrictedCourse, QueuePos) 
					VALUES(NEW.Student, NEW.CourseCode, queueLength+1);
			ELSE
				INSERT INTO RegisteredOn(Student, Course) 
					VALUES(NEW.Student, NEW.CourseCode);
			END IF;
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
CREATE FUNCTION unregister_check() RETURNS TRIGGER AS $$
  DECLARE nbrSpotsLeft INT;
    maxStudents INT;
    registredStudents INT;
    queueLength INT;
    isRegistered BOOLEAN;
  BEGIN
    -- Check if the student is on the waiting list
    IF (OLD.Status = 'Waiting')THEN
      DELETE FROM IsOnWaitingList
      WHERE (OLD.Student = Student AND OLD.CourseCode = RestrictedCourse);
    ELSE
      -- Delete from course

      DELETE FROM RegisteredOn
      WHERE (OLD.Student = Student AND OLD.CourseCode = Course);

      -- Check if there is room on the course
      maxStudents := (SELECT RestrictedCourse.MaxStudents FROM RestrictedCourse WHERE (Code = OLD.CourseCode));
      registredStudents := (SELECT count(Student) FROM Registrations WHERE Status = 'Registred' AND Registrations.CourseCode = OLD.CourseCode);
      nbrSpotsLeft := (SELECT maxStudents-registredStudents);
      queueLength := (SELECT max(QueuePos) FROM IsOnWaitingList WHERE RestrictedCourse = Old.CourseCode);

      IF(nbrSpotsLeft < 1) THEN
      	RAISE NOTICE 'No spots left on course';
      ELSEIF(registredStudents < maxStudents)THEN
      -- If there is someone in the queue
        IF(queueLength > 0) THEN
          INSERT INTO RegisteredOn
            VALUES (
							(SELECT Student FROM IsOnWaitingList WHERE (QueuePos = 1 AND RestrictedCourse = OLD.CourseCode)), OLD.CourseCode); -- Blir fel student
          -- Remove it from waiting list
          DELETE FROM IsOnWaitingList WHERE (QueuePos = 1 AND RestrictedCourse = OLD.CourseCode);
          -- Update the queuePositions
					UPDATE IsOnWaitingList SET QueuePos = QueuePos - 1 WHERE IsOnWaitingList.RestrictedCourse = OLD.CourseCode;
        END IF;
      END IF;
    END IF;
    RETURN OLD;
  END;

$$ LANGUAGE plpgsql;

CREATE TRIGGER unregister_check INSTEAD OF DELETE ON Registrations
  FOR EACH ROW
  EXECUTE PROCEDURE unregister_check();

/*
when a student unregisters from a course if the student was properly
registered and not only on the waiting list, the first student (if any)
in the waiting list should be registered for the course instead.
Note: this should only be done if there is actually room on the course
(the course might have been over-full due to an administrator overriding
the restriction and adding students directly).
 */