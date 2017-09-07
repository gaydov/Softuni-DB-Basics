-- Task 16
CREATE DATABASE SoftUni
USE SoftUni

CREATE TABLE Towns
(
Id int PRIMARY KEY IDENTITY,
Name varchar(50) NOT NULL
)

CREATE TABLE Addresses 
(
Id int PRIMARY KEY IDENTITY,
AddressText varchar(50) NOT NULL,
TownId int FOREIGN KEY REFERENCES Towns(Id) NOT NULL
)

CREATE TABLE Departments
(
Id int PRIMARY KEY IDENTITY,
Name varchar(50) NOT NULL
)

CREATE TABLE Employees
(
Id int PRIMARY KEY IDENTITY,
FirstName varchar(20) NOT NULL,
MiddleName varchar(20),
LastName varchar(20) NOT NULL,
JobTitle varchar (50) NOT NULL,
DepartmentId int FOREIGN KEY REFERENCES Departments(Id) NOT NULL,
HireDate varchar(20),
Salary decimal (7,2), 
AddressId int FOREIGN KEY REFERENCES Addresses(Id) NOT NULL
)