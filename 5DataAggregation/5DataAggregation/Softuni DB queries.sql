USE SoftUni

-- Departments Total Salaries
SELECT DepartmentID, SUM(Salary) AS TotalSalary
FROM Employees
GROUP BY DepartmentID
ORDER BY DepartmentID

-- Employees Minimum Salaries
SELECT DepartmentID, MIN(Salary)
FROM Employees
WHERE DepartmentID in (2, 5, 7) AND HireDate >= 2000-01-01
GROUP BY DepartmentID

-- Employees Average Salaries
SELECT * 
INTO NewTable
FROM Employees
WHERE Salary > 30000

DELETE
FROM NewTable
WHERE ManagerID = 42

UPDATE NewTable
SET Salary += 5000
WHERE DepartmentID = 1

SELECT DepartmentID, AVG(Salary)
FROM NewTable
GROUP BY DepartmentID

-- Employees Maximum Salaries
SELECT DepartmentID, MAX(Salary) AS MaxSalary
FROM Employees
GROUP BY DepartmentID
HAVING MAX(Salary) < 30000 OR MAX(Salary) > 70000

-- Employees Count Salaries
SELECT COUNT(e.Salary) AS [Count]
FROM Employees AS e
WHERE ManagerId IS NULL

-- 3rd Highest Salary
SELECT DepartmentID, 
	(SELECT DISTINCT Salary FROM Employees WHERE DepartmentID = e.DepartmentID ORDER BY Salary DESC OFFSET 2 ROWS FETCH NEXT 1 ROWS ONLY) AS ThirdHighestSalary
FROM Employees e
WHERE (SELECT DISTINCT Salary FROM Employees WHERE DepartmentID = e.DepartmentID ORDER BY Salary DESC OFFSET 2 ROWS FETCH NEXT 1 ROWS ONLY) IS NOT NULL
GROUP BY DepartmentID

-- Salary Challenge
SELECT TOP(10) e.FirstName, e.LastName, e.DepartmentID
FROM Employees AS e
WHERE e.Salary >(SELECT AVG(e2.Salary)
				FROM Employees AS e2
				WHERE e.DepartmentID = e2.DepartmentID
				)
ORDER BY e.DepartmentID


					