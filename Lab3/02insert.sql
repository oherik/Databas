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
	('Computer Science', 'D'),
	('Electronic Engineering', 'E'),
	('Technical Design', 'TD'),
	('Liberal Arts', 'LA'),
	('Juridics', 'J'),
	('Nano-biotechnology', 'NBT'),
	('Political Science', 'PS')
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
('TDA233', 7.5, 'Algorithms and data Structures', 'CSE'),
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


