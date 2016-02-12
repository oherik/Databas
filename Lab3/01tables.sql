-- TODO Fiska constraints. Typ textfält ska inte vara tomma
-- CONSTRAINT asdasdad CHECK(Attributet <> '')
CREATE TABLE Department (
    Name TEXT NOT NULL CONSTRAINT DepartmentNameNotEmpty CHECK(Name <> ''),
    Abbreviation CHAR(4) NOT NULL CONSTRAINT AbbreviationNameNotEmpty CHECK(Abbreviation <> ''),
    PRIMARY KEY(Abbreviation)
);

CREATE TABLE Programme (
	Name TEXT NOT NULL,
	Abbreviation CHAR(4) NOT NULL,
	PRIMARY KEY(Name)
);

CREATE TABLE Classification (
	Name TEXT NOT NULL,
	PRIMARY KEY(Name)
);

CREATE TABLE Course(
	Code TEXT NOT NULL,
	Credit FLOAT NOT NULL,
	Name	TEXT NOT NULL,
	Department	CHAR(4) NOT NULL,
	PRIMARY KEY(Code),
	FOREIGN KEY(Department)	REFERENCES Department(Abbreviation)
);

CREATE TABLE RestrictedCourse(
	Code  TEXT NOT NULL REFERENCES Course(Code),
	MaxStudents INT NOT NULL,
	PRIMARY KEY(Code)
);

CREATE TABLE Branch(
	Name TEXT NOT NULL,
	Programme TEXT NOT NULL,
	PRIMARY KEY(Name, Programme),
	FOREIGN KEY(Programme) REFERENCES Programme(Name)
 );

CREATE TABLE Student(
	ID TEXT NOT NULL,
	Name TEXT NOT NULL,
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
	Grade CHAR(1) NOT NULL,
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
