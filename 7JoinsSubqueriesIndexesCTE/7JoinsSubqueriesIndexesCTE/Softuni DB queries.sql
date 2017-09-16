USE Softuni

-- Employee Address
SELECT TOP(5) EmployeeID, JobTitle, a.AddressID, AddressText 
FROM Employees AS e
INNER JOIN Addresses AS a ON e.AddressID = a.AddressID
ORDER BY e.AddressID

-- Addresses with Towns
SELECT TOP(50) FirstName, LastName, t.Name AS [Town], AddressText
FROM Employees AS e
INNER JOIN Addresses AS a ON e.AddressID = a.AddressID
INNER JOIN Towns as t ON t.TownID = a.TownID
ORDER BY FirstName, LastName

-- Sales Employees
SELECT EmployeeID, FirstName, LastName, d.Name AS [DepartmentName]
FROM Employees AS e INNER JOIN Departments AS d ON e.DepartmentID = d.DepartmentID
WHERE d.Name = 'Sales'
ORDER BY EmployeeID

-- Employee Departments
SELECT TOP(5) e.EmployeeID, e.FirstName, e.Salary, d.Name AS [DepartmentName]
FROM Employees AS e
INNER JOIN Departments AS d ON e.DepartmentID = d.DepartmentID
WHERE e.Salary > 15000
ORDER BY d.DepartmentID

-- Employees Without Projects
SELECT TOP(3) e.EmployeeID, e.FirstName
FROM Employees AS e
LEFT OUTER JOIN EmployeesProjects AS ep ON e.EmployeeID = ep.EmployeeID
WHERE ep.ProjectID IS null
ORDER BY e.EmployeeID

-- Employees Hired After
SELECT e.FirstName, e.LastName, e.HireDate, d.Name AS [DeptName]
FROM Employees AS e
INNER JOIN Departments AS d ON e.DepartmentID = d.DepartmentID
WHERE d.Name IN ('Sales', 'Finance')
AND e.HireDate > '1999-01-01'
ORDER BY e.HireDate

-- Employees With Project
SELECT TOP(5) e.EmployeeID, e.FirstName, p.Name AS [ProjectName]
FROM Employees AS e
INNER JOIN EmployeesProjects AS ep ON e.EmployeeID = ep.EmployeeID
INNER JOIN Projects as p ON ep.ProjectID = p.ProjectID
WHERE p.StartDate > '2002-08-13' AND p.EndDate IS NULL
ORDER BY e.EmployeeID

-- Employee 24
SELECT e.EmployeeID, e.FirstName, 
	CASE 
		WHEN p.StartDate > '2005' THEN NULL
		ELSE p.Name
	END AS [ProjectName]
FROM Employees AS e
INNER JOIN EmployeesProjects AS ep ON e.EmployeeID = ep.EmployeeID
INNER JOIN Projects AS p ON ep.ProjectID = p.ProjectID
WHERE e.EmployeeID = 24

-- Employee Manager
SELECT e.EmployeeID, e.FirstName, e.ManagerID, m.FirstName AS [ManagerName]
FROM Employees AS e
INNER JOIN Employees AS m ON e.ManagerID = m.EmployeeID
WHERE e.ManagerID IN (3, 7)
ORDER BY e.EmployeeID

-- Employees Summary
SELECT TOP(50) e.EmployeeID, e.FirstName + ' ' + e.LastName AS [EmployeeName], m.FirstName + ' ' + m.LastName AS [ManagerName], d.Name AS [DepartmentName]
FROM Employees AS e
INNER JOIN Employees AS m ON e.ManagerID = m.EmployeeID
INNER JOIN Departments AS d ON e.DepartmentID = d.DepartmentID
ORDER BY e.EmployeeID

-- Min Average Salary
SELECT MIN([Average salary]) AS [MinAverageSalary]
FROM
(SELECT e.DepartmentID, AVG(e.Salary) AS [Average salary]
FROM Employees AS e
GROUP BY e.DepartmentID) AS AvgSalaries