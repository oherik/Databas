CREATE TABLE Department (
    Name TEXT NOT NULL CONSTRAINT department_name_not_empty CHECK(Name <> ''),
	Abbreviation CHAR(4) NOT NULL CONSTRAINT department_abbreviation_not_empty CHECK(Abbreviation <> '    '),  -- Check for four empty spaces, since Abbreviation is a CHAR(4)
    PRIMARY KEY(Abbreviation),
	UNIQUE(Name)
);

CREATE TABLE Programme (
	Name TEXT NOT NULL CONSTRAINT programme_name_not_empty CHECK(Name <> ''),
	Abbreviation CHAR(4) NOT NULL CONSTRAINT programme_abbreviation_not_empty CHECK(Abbreviation <> '    '),  
	PRIMARY KEY(Name)
);	

CREATE TABLE Classification (
	Name TEXT NOT NULL CONSTRAINT Classification_name_not_empty CHECK(Name <> ''),
	PRIMARY KEY(Name)
);

CREATE TABLE Course(
	Code TEXT NOT NULL CONSTRAINT course_code_not_empty CHECK(Code <> ''),
	Credit FLOAT NOT NULL CONSTRAINT course_credit_positive CHECK(Credit > 0),
	Name TEXT NOT NULL CONSTRAINT course_name_not_empty CHECK(Name <> ''),
	Department CHAR(4),
	PRIMARY KEY(Code),
	FOREIGN KEY(Department)	REFERENCES Department(Abbreviation)
);

CREATE TABLE RestrictedCourse(
	Code TEXT NOT NULL REFERENCES Course(Code),
	MaxStudents INT NOT NULL CONSTRAINT restrictedcourse_maxstudents_positive CHECK(MaxStudents > 0),
	PRIMARY KEY(Code)
);

CREATE TABLE Branch(
	Name TEXT NOT NULL CONSTRAINT branch_name_not_empty CHECK(Name <> ''),
	Programme TEXT,
	PRIMARY KEY(Name, Programme),
	FOREIGN KEY(Programme) REFERENCES Programme(Name)
 );

CREATE TABLE Student(
	NationalID CHAR(13) NOT NULL CONSTRAINT student_nationalid_not_empty CHECK(NationalID <> ''), 
	-- TODO The constraint below doesn't work as intended
		--CONSTRAINT student_id_not_matching_format SIMILAR TO '[^0-9]*6[^0-9]*$'
	SchoolID TEXT NOT NULL CONSTRAINT student_schoolid_not_empty CHECK(SchoolID <> ''),
	Name TEXT NOT NULL CONSTRAINT student_name_not_empty CHECK(Name <> ''),
	Programme TEXT,
	PRIMARY KEY(NationalID),
	UNIQUE(SchoolID),
	UNIQUE(NationalID, Programme),  -- TODO: Osäker på detta, kolla upp
	FOREIGN KEY(Programme) REFERENCES Programme(Name)
);



-- TODO Fix empty string checks below



CREATE TABLE Prerequisite(
	Course TEXT,
	RequiredCourse TEXT,
	PRIMARY KEY(Course, RequiredCourse),
	FOREIGN KEY(Course) REFERENCES Course(Code),
	FOREIGN KEY(RequiredCourse) REFERENCES Course(Code)
);

CREATE TABLE RegisteredOn(
	Student CHAR(13),
	Course TEXT,
	PRIMARY KEY(Student,Course),
	FOREIGN KEY(Student) REFERENCES Student(NationalID),
	FOREIGN KEY(Course) REFERENCES Course(Code)
);

CREATE TABLE HasFinished(
	Student CHAR(13),
	Course TEXT,
	Grade CHAR(1) NOT NULL CONSTRAINT hasfinished_valid_grade CHECK(Grade IN ('U','3','4','5')),
	PRIMARY KEY(Student, Course),
	FOREIGN KEY(Student) REFERENCES Student(NationalID),
	FOREIGN KEY(Course) REFERENCES Course(Code)
);

CREATE TABLE HostedBy(
	Programme TEXT,
	Department CHAR(4),
	PRIMARY KEY(Programme, Department),
	FOREIGN KEY(Programme) REFERENCES Programme(Name),
	FOREIGN KEy(Department) REFERENCES Department(Abbreviation)
);

CREATE TABLE ProgrammeHasMandatory(
	Programme TEXT,
	Course TEXT,
	PRIMARY KEY(Programme, Course),
	FOREIGN KEY(Programme) REFERENCES Programme(Name),
	FOREIGN KEY(Course) REFERENCES Course(Code)
);


CREATE TABLE BranchHasMandatory(
	Branch TEXT,
	Programme TEXT,
	Course TEXT,
	PRIMARY KEY(Branch, Programme, Course),
	FOREIGN KEY(Branch, Programme) REFERENCES Branch(Name, Programme),
	FOREIGN KEY(Course) REFERENCES Course(Code)
);


CREATE TABLE HasRecommended(
	Branch TEXT,
	Programme TEXT,
	Course TEXT,
	PRIMARY KEY(Branch, Programme, Course),
	FOREIGN KEY(Branch, Programme) REFERENCES Branch(Name, Programme),
	FOREIGN KEY(Course) REFERENCES Course(Code)
);

CREATE TABLE StudiesBranch(
	Student CHAR(13),
	Branch TEXT,
	Programme TEXT,
	PRIMARY KEY(Student),
	FOREIGN KEY(Branch, Programme) REFERENCES Branch(Name, Programme),
	FOREIGN KEY(Student, Programme) REFERENCES Student(NationalID, Programme)
);


CREATE TABLE IsOnWaitingList(
	Student CHAR(13),
	RestrictedCourse TEXT,
	QueuePos INT NOT NULL CONSTRAINT IsOnWaitingList_QueuePos_Positive CHECK(QueuePos > 0),
	PRIMARY KEY(Student, RestrictedCourse),
	FOREIGN KEY(RestrictedCourse) REFERENCES RestrictedCourse(Code),
	FOREIGN KEY(Student) REFERENCES Student(NationalID),
    UNIQUE (QueuePos, RestrictedCourse)
);

CREATE TABLE HasClassification(
	Course TEXT,
	Classification TEXT,
	PRIMARY KEY(Course, Classification),
	FOREIGN KEY(Course) REFERENCES Course(Code),
	FOREIGN KEY(Classification) REFERENCES Classification(Name)
);
