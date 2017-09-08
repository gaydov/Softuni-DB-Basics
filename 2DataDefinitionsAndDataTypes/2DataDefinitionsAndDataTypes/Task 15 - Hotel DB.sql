-- Task 15
CREATE DATABASE Hotel
GO
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
PaymentDate date NOT NULL,
AccountNumber int FOREIGN KEY REFERENCES Customers(AccountNumber) NOT NULL,
FirstDateOccupied date,
LastDateOccupied date,
TotalDays AS datediff(day, FirstDateOccupied, LastDateOccupied),
AmmountCharged decimal (7,2) NOT NULL,
TaxRate decimal (7,2),
TaxAmount decimal (7,2),
PaymentTotal decimal (7,2),
Notes varchar(max)
)

INSERT INTO Payments (EmployeeId, PaymentDate, AccountNumber, FirstDateOccupied, LastDateOccupied, AmmountCharged)
VALUES
(1, '2016-03-21', 1,'2016-03-22', '2016-03-27', 666.45),
(2, '2006-04-11', 2, '2006-04-12', '2006-04-22', 1444.45),
(3, '2017-08-26', 3, '2017-08-26', '2017-08-29', 166.45)

CREATE TABLE Occupancies 
(
Id int PRIMARY KEY IDENTITY,
EmployeeId int FOREIGN KEY REFERENCES Employees(Id) NOT NULL,
DateOccupied date,
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