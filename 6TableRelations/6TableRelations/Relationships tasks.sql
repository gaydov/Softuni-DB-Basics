-- One-To-One Relationship
USE People

CREATE TABLE Persons
(
PersonID int IDENTITY,
FirstName varchar(50),
Salary decimal(7, 2),
PassportID int UNIQUE
)

CREATE TABLE Passports
(
PassportID int UNIQUE,
PassportNumber varchar(50)
)

INSERT INTO Persons (FirstName, Salary, PassportID)
VALUES
('Roberto', 43300.00, 102),
('Tom', 56100.00, 103),
('Yana', 60200.00, 101)

INSERT INTO Passports (PassportID, PassportNumber)
VALUES
(101, 'N34FG21B'),
(102, 'K65LO4R7'),
(103, 'ZE657QP2')

ALTER TABLE Persons
ADD CONSTRAINT PK_Persons PRIMARY KEY (PersonID)

ALTER TABLE Persons
ADD CONSTRAINT FK_Persons_Passports
FOREIGN KEY (PassportID) REFERENCES Passports(PassportID)

-- One-To-Many Relationship
CREATE DATABASE Cars
USE Cars

CREATE TABLE Models
(
ModelID int NOT NULL,
Name varchar(50),
ManufacturerID int
)

CREATE TABLE Manufacturers
(
ManufacturerID int NOT NULL,
Name varchar(50),
EstablishedOn date
)

INSERT INTO Models (ModelID, Name, ManufacturerID)
VALUES
(101, 'X1', 1),
(102, 'i6', 1),
(103, 'Model S', 2),
(104, 'Model X', 2),
(105, 'Model 3', 2),
(106, 'Nova', 3)

INSERT INTO Manufacturers (ManufacturerID, Name, EstablishedOn)
VALUES
(1, 'BMW', '07/03/1916'),
(2, 'Tesla', '01/01/2003'),
(3, 'Lada', '01/05/1966')

ALTER TABLE Models
ADD CONSTRAINT PK_Models PRIMARY KEY (ModelId)

ALTER TABLE Manufacturers
ADD CONSTRAINT PK_Manufacturers PRIMARY KEY (ManufacturerID)

ALTER TABLE Models
ADD CONSTRAINT FK_Models_Manufacturers 
FOREIGN KEY (ManufacturerID) REFERENCES Manufacturers(ManufacturerID)

-- Many-To-Many Relationship
CREATE DATABASE StudentsDB
USE StudentsDB

CREATE TABLE Students
(
StudentID int NOT NULL,
Name varchar(50)
)

CREATE TABLE Exams
(
ExamID int NOT NULL,
Name varchar(50)
)

CREATE TABLE StudentsExams
(
StudentID int NOT NULL,
ExamID int NOT NULL
)

INSERT INTO Students (StudentID, Name)
VALUES
(1, 'Mila'),
(2, 'Toni'),
(3, 'Ron')

INSERT INTO Exams(ExamID, Name)
VALUES
(101, 'SpringMVC'),
(102, 'Neo4j'),
(103, 'Oracle 11g')

INSERT INTO StudentsExams (StudentID, ExamID)
VALUES
(1, 101),
(1, 102),
(2, 101),
(3, 103),
(2, 102),
(2, 103)

ALTER TABLE Students
ADD CONSTRAINT PK_Students PRIMARY KEY (StudentID)

ALTER TABLE Exams
ADD CONSTRAINT PK_Exams PRIMARY KEY (ExamID)

ALTER TABLE StudentsExams
ADD CONSTRAINT PK_StudentsExams PRIMARY KEY (StudentId, ExamId)

ALTER TABLE StudentsExams
ADD CONSTRAINT FK_Students FOREIGN KEY (StudentID)
REFERENCES Students(StudentID)

ALTER TABLE StudentsExams
ADD CONSTRAINT FK_Exams FOREIGN KEY (ExamID)
REFERENCES Exams(ExamID)

-- Self-Referencing
CREATE TABLE Teachers
(
TeacherID int NOT NULL,
Name varchar(50),
ManagerID int
)

INSERT INTO Teachers(TeacherID, Name, ManagerID)
VALUES
(101, 'John', NULL),
(102, 'Maya', 106),
(103, 'Silvia', 106),
(104, 'Ted', 105),
(105, 'Mark', 101),
(106, 'Greta', 101)

ALTER TABLE Teachers
ADD CONSTRAINT PK_Teachers PRIMARY KEY(TeacherID)

ALTER TABLE Teachers
ADD CONSTRAINT FK_Teacher_Manager FOREIGN KEY (ManagerID) 
REFERENCES Teachers(TeacherID)