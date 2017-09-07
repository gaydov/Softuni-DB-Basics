-- Task 14
CREATE DATABASE CarRental
USE CarRental

CREATE TABLE Categories
(
Id int PRIMARY KEY IDENTITY,
CategoryName varchar(50) NOT NULL,
DailyRate decimal(7, 2) NOT NULL,
WeeklyRate decimal (7,2) NOT NULL,
MonthlyRate decimal (7,2) NOT NULL,
WeekendRate decimal (7,2) NOT NULL
)

CREATE TABLE Cars
(
Id int PRIMARY KEY IDENTITY,
PlateNumber varchar(10) NOT NULL,
Manufacturer varchar(20) NOT NULL,
Model varchar(20) NOT NULL,
CarYear int,
CategoryId int,
Doors int,
Picture varbinary(max), 
Condition varchar(max),
Available bit
)

CREATE TABLE Employees
(
Id int PRIMARY KEY IDENTITY,
FirstName varchar(20) NOT NULL,
LastName varchar(20) NOT NULL,
Title varchar(50),
Notes varchar(max)
)

CREATE TABLE Customers
(
Id int PRIMARY KEY IDENTITY,
DriverLicenceNumber varchar(20) NOT NULL,
FullName varchar(50) NOT NULL,
Address varchar(50),
City varchar(20),
ZIPCode varchar(20),
Notes varchar(max)
)

CREATE TABLE RentalOrders
(
Id int PRIMARY KEY IDENTITY,
EmployeeId int FOREIGN KEY REFERENCES Employees(Id),
CustomerId int FOREIGN KEY REFERENCES Customers(Id),
CarId int FOREIGN KEY REFERENCES Cars(Id),
TankLevel int NOT NULL,
KilometrageStart int NOT NULL,
KilometrageEnd int NOT NULL,
TotalKilometrage AS KilometrageEnd - KilometrageStart,
StartDate varchar(20),
EndDate varchar(20),
TotalDays int,
RateApplied decimal (7,2),
TaxRate decimal (7,2),
OrderStatus varchar(20),
Notes varchar(max)
)

INSERT INTO Categories (CategoryName, DailyRate, WeeklyRate, MonthlyRate, WeekendRate)
VALUES
('Regular', 21.50, 60.22, 250.22, 35.20),
('Luxury', 40.22, 85.20, 320.50, 55.200),
('VIP', 60.11, 110.40, 400.60, 70.15)

INSERT INTO Cars(PlateNumber, Manufacturer, Model, CarYear, CategoryId, Doors, Picture, Condition, Available)
VALUES
('ca2102nc', 'BMW', '320', 2005, 1, 4, 333, 'good', 1),
('pb0001xx', 'Mercedes', 'S-class', 2016, 2, 4, 664,'perfect', 0),
('B2121GG', 'Bentley', 'Continental', 2017, 3, 4, 998, 'incredible', 1)

INSERT INTO Employees (FirstName, LastName, Title, Notes)
VALUES
('Ivan', 'Stoqnov', 'Salesman', 'good person'),
('Maria', 'Petkova', 'Receptionis', 'very polite'),
('Georgi', 'Unknown', 'Manager', 'perfect')

INSERT INTO Customers(DriverLicenceNumber, FullName, Address, City, ZIPCode)
VALUES 
('432k4j32kj', 'Joro Atanasov','Lulin 3', 'Sofia', '1234'),
('432k21dasda4j32kj', 'Joro Georgiev','Mladost 3', 'Sofia', '1333'),
('adad2', 'Maria Atanasova','Drujba 2', 'Sofia', '1211134')

INSERT INTO RentalOrders(EmployeeId, CustomerId, CarId, TankLevel, KilometrageStart, KilometrageEnd)
VALUES
(1, 1, 1, 30, 112000, 115000),
(2, 2, 2, 38, 121000, 130000),
(3, 3, 3, 40, 95000, 115000)