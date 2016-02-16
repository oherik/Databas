INSERT INTO Department
--	Should throw errors:
-- VALUES('Test', 'TOOMANYLETTERS'),
-- VALUES('', 'QQ'),
-- VALUES('Test', ''),
--	Good values:
VALUES
	('Computer Science and Engineering', 'CSE'),
	('Mechanical Engineering', 'ME'),
	('Electronic Engineering', 'EE'),
	('Humanities', 'HUM'),
	('Biomedical Science', 'BMS'),
	('Mathematics', 'M')
	;

INSERT INTO Programme
--	Should throw errors:
-- VALUES('Test', 'TOOMANYLETTERS'),
-- VALUES('', 'QQ'),
-- VALUES('Test', ''),
--	Good values:
VALUES
	('Applied Information Technology', 'IT'),
	('Computer Science', 'CS'),
	('Electrical Engineering', 'E'),
	('Mechanical Engineering', 'M'),
	('Technical Design', 'TD'),
	('Liberal Arts', 'LA'),
	('Juridics', 'J'),
	('Nano-biotechnology', 'NBT'),
	('Political Science', 'PS')
	;
INSERT INTO Classification
VALUES
--Should not work:
--(''),
--(1.2),
--Good values:
('Mathematical'),
('Research'),
('Seminar')
;

INSERT INTO Course
--	Should throw errors:
-- VALUES('Test', 1, 'Test', 'WWW'),
-- VALUES('Test', -1, 'Test', 'CSE'),
-- VALUES('Test', 1, 'Test', 'TOOMANYLETTERS'),
-- VALUES('Test', '', 'Test', 'CSE'),
-- VALUES('Test', 'One', 'Test', 'CSE'),
-- VALUES('', 1, 'Test', '
-- VALUES('Test', 1, 'Test', ''),
-- VALUES('Test', 1, '', 'CSE'),
--	Good values:
VALUES
('TDA357', 7.5, 'Databases', 'CSE'),
('TDA383', 7.5, 'Concurrent Programming', 'CSE'),
('MVE343', 2.5, 'Introductory Course in Algebra', 'M'),
('TD333', 3, 'Newtonian Design', 'ME'),
('DAT321', 7.5, 'Data Structures and Algorithms', 'CSE'),
('TDA233', 7.5, 'Algorithms and Data Structures', 'CSE'),
('MVE334', 7.5, 'Analysis in Multiple Variables', 'M'),
('POL227', 8.5, 'Geopolitics', 'HUM'),
('FYA344', 7.5, 'Control Engineering', 'ME'),
('FYA27', 2.5, 'The History of Engineering', 'ME'),
('FYA4367', 7.5, 'Regular Technique', 'ME'),
('POL34', 15, 'International Diplomacy', 'HUM'),
('MVE357', 15, 'Six-Dimensional Spheres', 'M'),
('TDA358', 7.5, 'Based Data', 'CSE'),
('GUI222', 7.5, 'User Interface', 'CSE'),
('LAW3444', 9, 'The Art of Laying down the Law', 'HUM'),
('EDA333', 7.5, 'Concurrent Current', 'EE'),
('MDA2687', 13, 'The Study of Very Small Things', 'BMS'),
('MED21', 5, 'Body Control', 'BMS'),
('LAW4444', 7.5, 'How to Become Judge, Jury and Executioner', 'HUM')
;
INSERT INTO RestrictedCourse
VALUES
-- Should not work
-- ('Testtio', 23),
-- ('TDA357, 0),
-- ('MVE343', 'wer'),
-- (23, 34),
-- ('', ''),
-- ('TDA357', ''),
-- ('', 23'),
-- ('POL34', -1),
-- Good values:
('TDA357', 24),
('TDA383', 35),
('LAW4444', 89),
('MED21', 15),
('TDA358', 46),
('MDA2687', 87)
;

INSERT INTO Branch
VALUES
-- Should throw errors:
-- ('', 'Liberal Arts'),
-- ('Hardware Engineering', ''),
-- ('Hardware Engineering', 'IT'),
-- ('Software Engineering', 'Computer Science'),
-- Good values:
('Software Engineering', 'Applied Information Technology'),
('Graphical Experience', 'Applied Information Technology'),
('Java and suchlike', 'Applied Information Technology'),
('Algorithms', 'Computer Science'),
('Low level programming', 'Computer Science'),
('CPU construction', 'Electrical Engineering'),
('Wire cutting', 'Electrical Engineering'),
('Automotive', 'Mechanical Engineering'),
('Aeronautic', 'Mechanical Engineering'),
('Cortège', 'Mechanical Engineering'),
('Production Design', 'Technical Design'),
('User Interfaces', 'Technical Design'),
('Music Theory', 'Liberal Arts'),
('Rhetoric', 'Liberal Arts'),
('History', 'Liberal Arts'),
('Philosophy', 'Liberal Arts'),
('Company Juridics', 'Juridics'),
('Private Juridics', 'Juridics'),
('International Law', 'Juridics'),
('Copyright Law', 'Juridics'),
('Nanorobotics', 'Nano-biotechnology'),
('Osteon', 'Nano-biotechnology'),
('Sanguis', 'Nano-biotechnology'),
('Espionage', 'Political Science'),
('International Relations', 'Political Science'),
('Political Theory', 'Political Science')
;

INSERT INTO Student
VALUES
-- Should throw errors:
-- ('195203153895','janjan','Jan Jansson','Nano-biotechnology'),
-- ('5203153895','janjan','Jan Jansson','Nano-biotechnology'),
-- ('520315-3895','','Jan Jansson','Nano-biotechnology'),
-- ('520315-3895',,'Jan Jansson','Nano-biotechnology'),
-- ('520315-3895','janjan','Jan Jansson','Nano-biotechnology'),
-- ('520315-3895','janjan','','Nano-biotechnology'),
-- ('520315-3895','janjan','Jan Jansson',''),
-- ('520315-3895','janjan','Jan Jansson','Non-existing programme'),
-- ('520315-3895','janjan','Jan Jansson','NBT'),
-- ('','janjan','Jan Jansson','Nano-biotechnology'),
-- ('529315-3895','janjan','Jan Jansson','Nano-biotechnology'),
-- ('520395-3895','janjan','Jan Jansson','Nano-biotechnology'),
-- ('5203153-895','janjan','Jan Jansson','Nano-biotechnology'),
-- ('52031-53895','janjan','Jan Jansson','Nano-biotechnology'),
-- Good values:
('520215-3895','janjan','Jan Jansson','Nano-biotechnology'),
('821103-7265','helbir','Helga Birgitsdotter','Political Science'),
('560216-2579','quaank','Quarl Anka','Electrical Engineering'),
('720805-9605','thestu','Therese Sturesson','Applied Information Technology'),
('880121-5248','josulf','Josefin Ulfenborg','Political Science'),
('680607-8793','hamron','Hampus Rönström','Computer Science'),
('640328-8043','majnyb','Maja Nyberg','Applied Information Technology'),
('871126-5028','sabsam','Sabrina Samuelsson','Applied Information Technology'),
('851007-9091','oskwil','Oskar Wilman','Mechanical Engineering'),
('620314-2044','johsch','Johanna Schüldt','Mechanical Engineering'),
('570119-2162','maihap','Maija Happonen','Mechanical Engineering'),
('721217-2204','micsod','Mickaela Södergren','Technical Design'),
('780219-8973','mathog','Mats Högberg','Electrical Engineering'),
('790307-6193','bjohed','Björn Hedström','Nano-biotechnology'),
('841114-9571','toball','Tobias Alldén','Computer Science'),
('19871229-8424','linhan','Linn Hansen','Political Science'),
('19621217-7049','lovjab','Lovisa Jäberg','Liberal Arts'),
('19721104-4396','jonlin','Jonas Lindberg','Liberal Arts'),
('19851101-1325','aleket','Alexandra Kettil','Technical Design'),
('19650430-7734','danlam','Danny Lam','Juridics')
;

INSERT INTO Prerequisite
VALUES
-- Should throw errors:
-- ('TDA357','TDA357'),
-- ('Non-existing','MVE343'),
-- ('MVE343', 'Non-existing'),
-- TODO: Ska man kunna ta gå    Kurs -> kräver1 -> kräver2 ?
-- Good values:
('MVE334', 'MVE343'),
('LAW4444', 'LAW3444'),
('FYA344', 'MVE343'),
('FYA344', 'TD333'),
('FYA4367', 'MVE343'),
('MVE357', 'MVE334')
;

INSERT INTO RegisteredOn
VALUES
-- Should throw errors:
-- ('520215-3895','MED21'),('520215-3895','MED21'),
-- ('Non-existing','MVE343'),
-- ('520215-3895','Non-existing'),
-- ('','Non-existing'),
-- ('520215-3895',''),
-- ('520215-3895','MED21', 'MVE343'),
-- TODO: Ska man kunna ta gå    Kurs -> kräver1 -> kräver2 ? Och godkänt betyg?
-- Good values:
('520215-3895','MED21'),
('520215-3895','MDA2687'),
('560216-2579','MVE357'),
('720805-9605','GUI222'),
('880121-5248','LAW3444'),
('680607-8793','TDA233'),
('640328-8043','TDA233'),
('871126-5028','DAT321'),
('851007-9091','MVE343'),
('851007-9091','MVE233'),
('570119-2162','TD333'),
('721217-2204','TD333'),
('790307-6193','MDA2687'),
('841114-9571','TDA357'),
('19871229-8424','POL34'),
('19721104-4396','LAW4444'),
('19851101-1325','FYA344'),
('19650430-7734','LAW3444')
;

INSERT INTO HasFinished
VALUES
-- Should throw errors:
-- ('19721104-4396','LAW3444', 'I'),
-- ('620314-2044', 'TD333', 4),
-- ('Non-existing','LAW3444', '3'),
-- ('19721104-4396','Non-existing', '3'),
-- ('','LAW3444', '3'),
-- ('19721104-4396','', '3'),
-- ('19721104-4396','LAW3444', ''),
-- Good values:
('19721104-4396','LAW3444', '3'),
('19851101-1325','TD333', '5'),
('560216-2579','MVE334', '4'),
('560216-2579','MVE343', '3'),
('780219-8973','MVE343', '5'),
('880121-5248','POL227', 'U'),
('620314-2044', 'MVE343', '4'),
('620314-2044', 'MVE334', '5'),
('620314-2044', 'MVE357', '4'),
('620314-2044', 'MVE233', '3')
;

INSERT INTO HostedBy
VALUES
-- Should throw errors:
--
-- Good values::

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
	PRIMARY KEY(Student),
	FOREIGN KEY(Branch, Programme) REFERENCES Branch(Name, Programme),
	FOREIGN KEY(Student, Programme) REFERENCES Student(NationalID, Programme)
);


CREATE TABLE IsOnWaitingList(
	Student CHAR(13) NOT NULL,
	RestrictedCourse TEXT NOT NULL,
	QueuePos INT NOT NULL,
	PRIMARY KEY(Student, RestrictedCourse),
	FOREIGN KEY(RestrictedCourse) REFERENCES RestrictedCourse(Code),
	FOREIGN KEY(Student) REFERENCES Student(NationalID),
    UNIQUE (QueuePos, RestrictedCourse)
);

CREATE TABLE HasClassification(
	Course TEXT NOT NULL,
	Classification TEXT NOT NULL,
	PRIMARY KEY(Course, Classification),
	FOREIGN KEY(Course) REFERENCES Course(Code),
	FOREIGN KEY(Classification) REFERENCES Classification(Name)
);
