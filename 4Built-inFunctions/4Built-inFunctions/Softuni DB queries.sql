USE SoftUni

-- Find Names of All Employees by First Name
SELECT FirstName, LastName 
FROM Employees
WHERE LEFT(FirstName, 2) = 'SA'

-- Find Names of All Employees by Last Name
SELECT FirstName, LastName 
FROM Employees
WHERE LastName LIKE '%ei%'

-- Find First Names of All Employees
SELECT FirstName 
FROM Employees
WHERE DepartmentID in (3, 10) AND (DATEPART(year, HireDate) >= '1995' AND DATEPART(year, HireDate) <= '2005')

-- Find All Employees Except Engineers
SELECT FirstName, LastName 
FROM Employees
WHERE JobTitle NOT LIKE '%engineer%'

-- Find Towns with Name Length
SELECT Name 
FROM Towns
WHERE LEN(Name) in (5, 6)
ORDER BY Name

-- Find Towns Starting With
SELECT TownID, Name 
FROM Towns
WHERE LEFT(Name, 1) in ('M', 'K', 'B', 'E')
ORDER BY Name

-- Find Towns Not Starting With
SELECT TownID, Name 
FROM Towns
WHERE LEFT(Name, 1) NOT in ('R', 'B', 'D')
ORDER BY Name

-- Create View Employees Hired After
GO
CREATE VIEW V_EmployeesHiredAfter2000 AS
SELECT FirstName, LastName 
FROM Employees
WHERE DATEPART(year, HireDate) > '2000'
GO

-- Length of Last Name
SELECT FirstName, LastName 
FROM Employees
WHERE LEN(LastName) = 5