-- Task 15
CREATE DATABASE Hotel
USE Hotel

CREATE TABLE Employees 
(
Id int PRIMARY KEY IDENTITY,
FirstName varchar(20) NOT NULL,
LastName varchar(20) NOT NULL,
Title varchar(20) NOT NULL,
Notes varchar(max)
)

INSERT INTO Employees(FirstName, LastName, Title)
VALUES 
('Ivan', 'Ivanov', 'Receptionist'),
('Stoqn', 'Ivanov', 'Cleaner'),
('Georgi', 'Ivanov', 'Boss')

CREATE TABLE Customers 
(
AccountNumber int PRIMARY KEY IDENTITY,
FirstName varchar(20) NOT NULL,
LastName varchar(20) NOT NULL,
PhoneNumber varchar(20) NOT NULL,
EmergencyName varchar(20),
EmergencyNumber varchar(20) NOT NULL,
Notes varchar(max)
)

INSERT INTO Customers (FirstName, LastName, PhoneNumber, EmergencyNumber)
VALUES 
('Georgi', 'Ivanov', '*88', '123'),
('Maria', 'Ivanova', '123', '3333'),
('Georgi', 'Dimitrov', '1111', '32131')

CREATE TABLE RoomStatus
(
RoomStatus varchar(20) PRIMARY KEY NOT NULL,
Notes varchar(max)
)

INSERT INTO RoomStatus (RoomStatus)
VALUES
('Clean'),
('Dirty'),
('Unavailable')


CREATE TABLE RoomTypes
(
RoomType varchar(20) PRIMARY KEY NOT NULL,
Notes varchar(max)
)

INSERT INTO RoomTypes (RoomType)
VALUES
('Regular'),
('Luxury'),
('VIP')

CREATE TABLE BedTypes
(
BedType varchar(20) PRIMARY KEY NOT NULL,
Notes varchar(max)
)

INSERT INTO BedTypes (BedType)
VALUES
('Single'),
('Double'),
('King size')

CREATE TABLE Rooms
(
RoomNumber int PRIMARY KEY IDENTITY,
RoomType varchar(20) FOREIGN KEY REFERENCES RoomTypes(RoomType) NOT NULL,
BedType varchar(20) FOREIGN KEY REFERENCES BedTypes(BedType) NOT NULL,
Rate decimal(7,2) NOT NULL,
RoomStatus varchar(20) FOREIGN KEY REFERENCES RoomStatus(RoomStatus) NOT NULL,
Notes varchar(max)
)

INSERT INTO Rooms (RoomType, BedType, Rate, RoomStatus)
VALUES 
('Luxury', 'Double', 55.223, 'Clean'),
('Regular', 'King size', 89.223, 'Dirty'),
('VIP', 'Single', 333.223, 'Unavailable')

CREATE TABLE Payments
(
Id int PRIMARY KEY IDENTITY,
EmployeeId int FOREIGN KEY REFERENCES Employees(Id) NOT NULL,
PaymentDate varchar(20) NOT NULL,
AccountNumber int FOREIGN KEY REFERENCES Customers(AccountNumber) NOT NULL,
FirstDateOccupied varchar(20),
LastDateOccupied varchar(20),
TotalDays int NOT NULL,
AmmountCharged decimal (7,2) NOT NULL,
TaxRate decimal (7,2),
TaxAmount decimal (7,2),
PaymentTotal decimal (7,2),
Notes varchar(max)
)

INSERT INTO Payments (EmployeeId, PaymentDate, AccountNumber, TotalDays, AmmountCharged)
VALUES
(1, '21/03/2016', 1, 7, 666.45),
(2, '11/04/2006', 2, 10, 1444.45),
(3, '26/08/2017', 3, 4, 166.45)

CREATE TABLE Occupancies 
(
Id int PRIMARY KEY IDENTITY,
EmployeeId int FOREIGN KEY REFERENCES Employees(Id) NOT NULL,
DateOccupied varchar(20),
AccountNumber int FOREIGN KEY REFERENCES Customers(AccountNumber) NOT NULL,
RoomNumber int FOREIGN KEY REFERENCES Rooms(RoomNumber),
RateApplied decimal (7,2) NOT NULL,
PhoneCharge decimal (7,2),
Notes varchar(max)
)

INSERT INTO Occupancies (EmployeeId, AccountNumber, RoomNumber, RateApplied)
VALUES
(1, 1, 1, 45.66),
(2, 2, 2, 115.10),
(3, 3, 3, 239.25)