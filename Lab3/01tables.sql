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
	Code TEXT NOT NULL CONSTRAINT course_name_not_empty CHECK(Code <> ''),
	Credit FLOAT NOT NULL CONSTRAINT course_credit_positive CHECK(Credit > 0),
	Name TEXT NOT NULL CONSTRAINT course_name_not_empty CHECK(Name <> ''),
	Department CHAR(4) NOT NULL CONSTRAINT course_department_not_empty CHECK(Department <> '    '),
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
	Programme TEXT NOT NULL,
	PRIMARY KEY(Name, Programme),
	FOREIGN KEY(Programme) REFERENCES Programme(Name)
 );

CREATE TABLE Student(
	NationalID CHAR(13) NOT NULL CONSTRAINT student_id_not_empty CHECK(ID <> '             '),  -- TODO sätt constraints!
	SchoolID TEXT NOT NULL CONSTRAINT student_id_not_empty CHECK(ID <> ''),
	Name TEXT NOT NULL CONSTRAINT student_name_not_empty CHECK(Name <> ''),
	Programme TEXT NOT NUll,
	PRIMARY KEY(NationalID),
	UNIQUE(SchoolID),
	FOREIGN KEY(Programme) REFERENCES Programme(Name)
);

CREATE TABLE Prerequisite(
	Course TEXT NOT NULL,
	RequiredCourse TEXT NOT NULL,
	PRIMARY KEY(Course, RequiredCourse),
	FOREIGN KEY(Course) REFERENCES Course(Code),
	FOREIGN KEY(RequiredCourse) REFERENCES Course(Code)
);

CREATE TABLE RegisteredOn(
	Student CHAR(13) NOT NULL,
	Course TEXT NOT NULL,
	PRIMARY KEY(Student,Course),
	FOREIGN KEY(Student) REFERENCES Student(NationalID),
	FOREIGN KEY(Course) REFERENCES Course(Code)
);

CREATE TABLE HasFinished(
	Student CHAR(13) NOT NULL,
	Course TEXT NOT NUll,
	Grade CHAR(1) NOT NULL CONSTRAINT hasfinished_valid_grade CHECK(Grade IN ('U','3','4','5')),
	PRIMARY KEY(Student, Course),
	FOREIGN KEY(Student) REFERENCES Student(NationalID),
	FOREIGN KEY(Course) REFERENCES Course(Code)
);

CREATE TABLE HostedBy(
	Programme TEXT NOT NULL,
	Department CHAR(4) NOT NULL,
	PRIMARY KEY(Programme, Department),
	FOREIGN KEY(Programme) REFERENCES Programme(Name),
	FOREIGN KEy(Department) REFERENCES Department(Abbreviation)
);

CREATE TABLE ProgrammeHasMandatory(
	Programme TEXT NOT NULL,
	Course TEXT NOT NULL,
	PRIMARY KEY(Programme, Course),
	FOREIGN KEY(Programme) REFERENCES Programme(Name),
	FOREIGN KEY(Course) REFERENCES Course(Code)
);


CREATE TABLE BranchHasMandatory(
	Branch TEXT NOT NULL,
	Programme TEXT NOT NULL,
	Course TEXT NOT NULL,
	PRIMARY KEY(Branch, Programme, Course),
	FOREIGN KEY(Branch, Programme) REFERENCES Branch(Name, Programme),
	FOREIGN KEY(Course) REFERENCES Course(Code)
);


CREATE TABLE HasRecommended(
	Branch TEXT NOT NULL,
	Programme TEXT NOT NULL,
	Course TEXT NOT NULL,
	PRIMARY KEY(Branch, Programme, Course),
	FOREIGN KEY(Branch, Programme) REFERENCES Branch(Name, Programme),
	FOREIGN KEY(Course) REFERENCES Course(Code)
);

CREATE TABLE StudiesBranch(
	Student CHAR(13) NOT NULL,
	Branch TEXT NOT NULL,
	Programme TEXT NOT NULL,
	PRIMARY KEY(Student, Branch, Programme),
	FOREIGN KEY(Branch, Programme) REFERENCES Branch(Name, Programme),
	FOREIGN KEY(Student) REFERENCES Student(NationalID)
);


CREATE TABLE IsOnWaitingList(
	Student CHAR(13) NOT NULL,
	RestrictedCourse TEXT NOT NULL,
	DateRegistered DATE NOT NULL,
	PRIMARY KEY(Student, RestrictedCourse),
	FOREIGN KEY(RestrictedCourse) REFERENCES RestrictedCourse(Code),
	FOREIGN KEY(Student) REFERENCES Student(NationalID)
);

CREATE TABLE HasClassification(
	Course TEXT NOT NULL,
	Classification TEXT NOT NULL,
	PRIMARY KEY(Course, Classification),
	FOREIGN KEY(Course) REFERENCES Course(Code),
	FOREIGN KEY(Classification) REFERENCES Classification(Name)
);
