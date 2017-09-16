-- University Database
CREATE DATABASE University
USE University

CREATE TABLE Majors
(
MajorID int NOT NULL,
Name varchar(50)
)

CREATE TABLE Students
(
StudentID int NOT NULL,
StudentNumber varchar(50),
StudentName varchar(50),
MajorID int 
)

CREATE TABLE Agenda
(
StudentID int NOT NULL,
SubjectID int NOT NULL
)

CREATE TABLE Subjects
(
SubjectID int NOT NULL,
SubjectName varchar(50) NOT NULL
)

CREATE TABLE Payments
(
PaymentID int NOT NULL,
PaymentDate date,
PaymentAmount decimal(8, 2) NOT NULL,
StudentID int
)

ALTER TABLE Majors
ADD CONSTRAINT PK_Majors PRIMARY KEY (MajorID)

ALTER TABLE Students
ADD CONSTRAINT PK_Students PRIMARY KEY (StudentID)

ALTER TABLE Students
ADD CONSTRAINT FK_Majors FOREIGN KEY (MajorID)
REFERENCES Majors(MajorID)

ALTER TABLE Payments
ADD CONSTRAINT PK_Payments PRIMARY KEY (PaymentID)

ALTER TABLE Payments
ADD CONSTRAINT FK_Students FOREIGN KEY (StudentID)
REFERENCES StudentS(StudentID)

ALTER TABLE Subjects
ADD CONSTRAINT PK_Subjects PRIMARY KEY (SubjectID)

ALTER TABLE Agenda
ADD CONSTRAINT PK_Agenda PRIMARY KEY(StudentID, SubjectID)

ALTER TABLE Agenda
ADD CONSTRAINT FK_AgendaStudents FOREIGN KEY(StudentID)
REFERENCES Students(StudentID)

ALTER TABLE Agenda
ADD CONSTRAINT FK_AgendaSubjects FOREIGN KEY(SubjectID)
REFERENCES Subjects(SubjectID)