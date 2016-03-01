
CREATE FUNCTION register() RETURNS trigger as $register$
DECLARE queueLength INT;
DECLARE isWaiting BOOLEAN;
DECLARE isRegistered BOOLEAN;
DECLARE hasPassed BOOLEAN;
DECLARE hasReadPrerequisites BOOLEAN;

	BEGIN
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
			IF queueLength > 0 THEN
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
      	RAISE EXCEPTION 'No spots left on Course';
      ELSE
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
