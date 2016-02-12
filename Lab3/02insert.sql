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
	('Electronic Engineering', 'E'),
	('Mechanical Engineering', 'M'),
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
('CPU construction', 'Electronic Engineering'),
('Wire cutting', 'Electronic Engineering'),
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


