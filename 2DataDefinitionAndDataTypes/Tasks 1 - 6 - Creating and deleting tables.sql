-- Task 1
CREATE DATABASE Minions

-- Task 2
CREATE TABLE Minions
(
Id int NOT NULL,
Name varchar(50),
Age int
)

CREATE TABLE Towns
(
Id int NOT NULL,
Name varchar(50)
)

ALTER TABLE Minions
ADD CONSTRAINT PK_Id
PRIMARY KEY (Id)

ALTER TABLE Towns
ADD CONSTRAINT PKTowns_Id
PRIMARY KEY (Id)

-- Task 3
ALTER TABLE Minions
ADD TownId int

ALTER TABLE Minions
ADD FOREIGN KEY (TownId) REFERENCES Towns(Id)

-- Task 4
INSERT INTO Towns (Id, Name)
VALUES (1, 'Sofia'), (2, 'Plovdiv'), (3, 'Varna')

INSERT INTO Minions (Id, Name, Age, TownId)
VALUES (1, 'Kevin', 22, 1), (2, 'Bob', 15, 3), (3, 'Steward', NULL, 2)

-- Task 5
TRUNCATE TABLE Minions

-- Task 6
DROP TABLE Minions
DROP TABLE Towns