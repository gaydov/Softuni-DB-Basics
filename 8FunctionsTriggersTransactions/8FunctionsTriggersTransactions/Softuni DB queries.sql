USE SoftUni

-- Employees with Salary Above 35000
GO
CREATE PROCEDURE usp_GetEmployeesSalaryAbove35000 
AS
SELECT FirstName AS [First Name], LastName AS [Last Name]
FROM Employees
WHERE Salary > 35000

-- Employees with Salary Above Number
GO
CREATE PROCEDURE usp_GetEmployeesSalaryAboveNumber(@amount money)
AS
SELECT FirstName AS [First Name], LastName AS [Last Name]
FROM Employees
WHERE Salary >= @amount

-- Town Names Starting With
GO
CREATE PROCEDURE usp_GetTownsStartingWith(@startString varchar(max))
AS
SELECT Name AS [Town]
FROM Towns
WHERE CHARINDEX(@startString, Name, 1) = 1

-- Employees from Town
GO
CREATE PROCEDURE usp_GetEmployeesFromTown(@townName varchar(max))
AS
SELECT FirstName AS [First Name], LastName AS [Last Name]
FROM Employees AS e
INNER JOIN Addresses AS a ON e.AddressID = a.AddressID
INNER JOIN Towns AS t ON a.TownID = t.TownID
WHERE t.Name = @townName

-- Salary Level Function
GO
CREATE FUNCTION dbo.ufn_GetSalaryLevel(@salary money) 
RETURNS varchar(10)
AS
BEGIN

DECLARE @salaryLevel varchar(10);

IF(@salary < 30000)
BEGIN
	SET @salaryLevel = 'Low';
END
ELSE IF(@salary >= 30000 AND @salary <= 50000)
BEGIN
	SET @salaryLevel = 'Average';
END
ELSE IF(@salary > 50000)
BEGIN
	SET @salaryLevel = 'High';
END

RETURN @salaryLevel;
END

-- Employees by Salary Level
GO
CREATE PROCEDURE usp_EmployeesBySalaryLevel(@salaryLevel varchar(10))
AS
SELECT FirstName AS [First Name], LastName AS [Last Name]
FROM Employees
WHERE dbo.ufn_GetSalaryLevel(Salary) = @salaryLevel

-- Define Function
GO
CREATE FUNCTION ufn_IsWordComprised(@setOfLetters varchar(max), @word varchar(max))
RETURNS BIT
AS
BEGIN
DECLARE @currentIndex int = 1;

WHILE(@currentIndex <= LEN(@word))
	BEGIN

	DECLARE @currentLetter varchar(1) = SUBSTRING(@word, @currentIndex, 1);

	IF(CHARINDEX(@currentLetter, @setOfLetters)) = 0
	BEGIN
	RETURN 0;
	END

	SET @currentIndex += 1;
	END

RETURN 1;
END
GO

-- Delete Employees and Departments

-- Creating table in which to store the IDs of the employees that need to be deleted:
CREATE PROC usp_DeleteEmployeesFromDepartment (@departmentId INT)
AS

DECLARE @empIDsToBeDeleted TABLE
(
Id int
)

INSERT INTO @empIDsToBeDeleted
SELECT e.EmployeeID
FROM Employees AS e
WHERE e.DepartmentID = @departmentId

ALTER TABLE Departments
ALTER COLUMN ManagerID int NULL

DELETE FROM EmployeesProjects
WHERE EmployeeID IN (SELECT Id FROM @empIDsToBeDeleted)

UPDATE Employees
SET ManagerID = NULL
WHERE ManagerID IN (SELECT Id FROM @empIDsToBeDeleted)

UPDATE Departments
SET ManagerID = NULL
WHERE ManagerID IN (SELECT Id FROM @empIDsToBeDeleted)

DELETE FROM Employees
WHERE EmployeeID IN (SELECT Id FROM @empIDsToBeDeleted)

DELETE FROM Departments
WHERE DepartmentID = @departmentId 

SELECT COUNT(*) AS [Employees Count] FROM Employees AS e
JOIN Departments AS d
ON d.DepartmentID = e.DepartmentID
WHERE e.DepartmentID = @departmentId

-- Employees with Three Projects
GO
CREATE PROCEDURE usp_AssignProject(@emloyeeId int, @projectID int)
AS
BEGIN TRANSACTION

DECLARE @currentEmpProjectsCount int = 
(SELECT COUNT(ProjectID)
FROM EmployeesProjects
WHERE EmployeeID = @emloyeeId)

IF(@currentEmpProjectsCount >= 3)
BEGIN
	ROLLBACK
	RAISERROR('The employee has too many projects!', 16, 1)
	RETURN
END

INSERT INTO EmployeesProjects
VALUES
(@emloyeeId, @projectID)

COMMIT