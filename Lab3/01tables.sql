CREATE TABLE Department (
    Name TEXT NOT NULL CONSTRAINT DepartmentNameNotEmpty CHECK(Name <> ''),
	Abbreviation CHAR(4) NOT NULL CONSTRAINT AbbreviationNameNotEmpty CHECK(Abbreviation <> '    '),  -- Check for four empty spaces, since Abbreviation is a CHAR(4)
    PRIMARY KEY(Abbreviation),
	UNIQUE(Name)
);

CREATE TABLE Programme (
	Name TEXT NOT NULL CONSTRAINT ProgrammeNameNotEmpty CHECK(Name <> ''),
	Abbreviation CHAR(4) NOT NULL CONSTRAINT ProgrammeAbbreviationNotEmpty CHECK(Abbreviation <> '    '),  
	PRIMARY KEY(Name)
);	

CREATE TABLE Classification (
	Name TEXT NOT NULL CONSTRAINT ClassificationNameNotEmpty CHECK(Name <> ''),
	PRIMARY KEY(Name)
);

CREATE TABLE Course(
	Code TEXT NOT NULL CONSTRAINT CourseNameNotEmpty CHECK(Code <> ''),
	Credit FLOAT NOT NULL CONSTRAINT CreditPositive CHECK(Credit > 0),
	Name TEXT NOT NULL CONSTRAINT CourseNameNotEmty CHECK(Name <> ''),
	Department CHAR(4) NOT NULL CONSTRAINT CourseDepartmentNotEmpty CHECK(Department <> '    '),
	PRIMARY KEY(Code),
	FOREIGN KEY(Department)	REFERENCES Department(Abbreviation)
);

CREATE TABLE RestrictedCourse(
	Code TEXT NOT NULL REFERENCES Course(Code),
	MaxStudents INT NOT NULL CONSTRAINT RestrictedCourseMaxStudentsPositive CHECK(MaxStudents > 0),
	PRIMARY KEY(Code)
);

CREATE TABLE Branch(
	Name TEXT NOT NULL CONSTRAINT BranchNameNotEmpty CHECK(Name <> ''),
	Programme TEXT NOT NULL,
	PRIMARY KEY(Name, Programme),
	FOREIGN KEY(Programme) REFERENCES Programme(Name)
 );

CREATE TABLE Student(
	ID TEXT NOT NULL CONSTRAINT StudentIDNotEmpty CHECK(ID <> ''),
	Name TEXT NOT NULL CONSTRAINT StudentNameNotEmpty CHECK(Name <> ''),
	Programme TEXT NOT NUll,
	PRIMARY KEY(ID),
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
	Student TEXT NOT NULL,
	Course TEXT NOT NULL,
	PRIMARY KEY(Student,Course),
	FOREIGN KEY(Student) REFERENCES Student(ID),
	FOREIGN KEY(Course) REFERENCES Course(Code)
);

CREATE TABLE HasFinished(
	Student TEXT NOT NULL,
	Course TEXT NOT NUll,
	Grade CHAR(1) NOT NULL CONSTRAINT HasFinishedValidGrade CHECK(Grade IN ('U','3','4','5')),
	PRIMARY KEY(Student, Course),
	FOREIGN KEY(Student) REFERENCES Student(ID),
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
	Student TEXT NOT NULL,
	Branch TEXT NOT NULL,
	Programme TEXT NOT NULL,
	PRIMARY KEY(Student, Branch, Programme),
	FOREIGN KEY(Branch, Programme) REFERENCES Branch(Name, Programme),
	FOREIGN KEY(Student) REFERENCES Student(ID)
);


CREATE TABLE IsOnWaitingList(
	Student TEXT NOT NULL,
	RestrictedCourse TEXT NOT NULL,
	DateRegistered DATE NOT NULL,
	PRIMARY KEY(Student, RestrictedCourse),
	FOREIGN KEY(RestrictedCourse) REFERENCES RestrictedCourse(Code),
	FOREIGN KEY(Student) REFERENCES Student(ID)
);

CREATE TABLE HasClassification(
	Course TEXT NOT NULL,
	Classification TEXT NOT NULL,
	PRIMARY KEY(Course, Classification),
	FOREIGN KEY(Course) REFERENCES Course(Code),
	FOREIGN KEY(Classification) REFERENCES Classification(Name)
);
