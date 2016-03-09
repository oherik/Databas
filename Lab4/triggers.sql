CREATE FUNCTION register() RETURNS trigger as $register$
DECLARE queueLength INT;
isWaiting BOOLEAN;
isRegistered BOOLEAN;
hasPassed BOOLEAN;
hasReadPrerequisites BOOLEAN;
maxStudents  INT;
registeredStudents INT;
nbrSpotsLeft INT;
BEGIN
		maxStudents := (SELECT RestrictedCourse.MaxStudents FROM RestrictedCourse
			WHERE (Code = NEW.CourseCode));
      	registeredStudents := (SELECT count(Student) FROM Registrations
      		WHERE Status = 'Registred' AND Registrations.CourseCode = NEW.CourseCode);
      	nbrSpotsLeft := (SELECT maxStudents-registeredStudents);
		queueLength := (SELECT COALESCE(MAX(QueuePos),0) FROM CourseQueuePositions
			WHERE NEW.CourseCode = CourseQueuePositions.Course);

		isWaiting := (SELECT EXISTS(SELECT 1 FROM CourseQueuePositions WHERE
			NEW.Student = CourseQueuePositions.Student AND NEW.CourseCode = CourseQueuePositions.Course));
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
		ELSE-- Add the student to the appropriate table
			IF queueLength > 0 OR nbrSpotsLeft < 1 THEN
				INSERT INTO CourseQueuePositions(Student, Course, QueuePos)
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

*/
CREATE FUNCTION unregister_check() RETURNS TRIGGER AS $hatarallt$
  DECLARE nbrSpotsLeft INT;
    maxStudents INT;
    registredStudents INT;
    queueLength INT;
    queuePosition INT;
    isRegistered BOOLEAN;
  BEGIN  -- Check if the student is on the waiting list
					maxStudents := (SELECT RestrictedCourse.MaxStudents FROM RestrictedCourse WHERE (Code = OLD.CourseCode));
    	registredStudents := (SELECT count(Student) FROM Registrations WHERE Status = 'Registred' AND Registrations.CourseCode = OLD.CourseCode);
    	nbrSpotsLeft := (SELECT maxStudents-registredStudents);
    queueLength := (SELECT max(QueuePos) FROM CourseQueuePositions WHERE Course = Old.CourseCode);
    IF (OLD.Status = 'Waiting')THEN
      queuePosition := (SELECT QueuePos FROM CourseQueuePositions WHERE Course = Old.CourseCode AND Student = Old.Student);
      DELETE FROM CourseQueuePositions
      	WHERE (OLD.Student = Student AND OLD.CourseCode = Course);
      queueLength := (SELECT max(QueuePos) FROM CourseQueuePositions WHERE Course = Old.CourseCode);
	  IF(queueLength > 0) THEN
			UPDATE CourseQueuePositions
			SET QueuePos = QueuePos - 1
			WHERE QueuePos > queuePosition
				AND Course = OLD.CourseCode;
	  END IF;
    ELSE   -- Delete from course
      queuePosition := 0;
      DELETE FROM RegisteredOn
      WHERE (OLD.Student = Student AND OLD.CourseCode = Course);  -- Check if there is room on the course
			maxStudents := (SELECT RestrictedCourse.MaxStudents FROM RestrictedCourse WHERE (Code = OLD.CourseCode));
    	registredStudents := (SELECT count(Student) FROM Registrations WHERE Status = 'Registred' AND Registrations.CourseCode = OLD.CourseCode);
    	nbrSpotsLeft := (SELECT maxStudents-registredStudents);
      IF(nbrSpotsLeft < 1) THEN
      	RAISE NOTICE 'No spots left on course';
      ELSEIF(registredStudents < maxStudents)THEN -- If there is someone in the queue
        IF(queueLength > 0) THEN
          INSERT INTO RegisteredOn
            VALUES ((SELECT Student FROM CourseQueuePositions WHERE (QueuePos = 1 AND Course = OLD.CourseCode)), OLD.CourseCode); -- Remove it from waiting list
          DELETE FROM CourseQueuePositions WHERE (QueuePos = 1 AND Course = OLD.CourseCode);
          UPDATE CourseQueuePositions
			SET QueuePos = QueuePos - 1
			WHERE QueuePos > 0
				AND Course = OLD.CourseCode;
        END IF;
      END IF;
    END IF;
    RETURN OLD;
  END;
$hatarallt$ LANGUAGE plpgsql;

CREATE TRIGGER unregister_check INSTEAD OF DELETE ON Registrations
  FOR EACH ROW
  EXECUTE PROCEDURE unregister_check();
