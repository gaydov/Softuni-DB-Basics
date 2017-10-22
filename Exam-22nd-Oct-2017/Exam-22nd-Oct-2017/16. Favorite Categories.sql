WITH CTE_ReportsByDepartment
AS
(
SELECT d.[Name] AS DeptName, c.[Name] AS CatName, COUNT(c.[Name]) as [CountReports]
FROM Departments AS d
INNER JOIN Categories AS c ON c.DepartmentId = d.Id
INNER JOIN Reports AS r ON r.CategoryId = c.Id
GROUP BY d.[Name] , c.[Name] 
)

SELECT d.[Name] AS [Department Name], 
	  c.[Name] AS [Category Name], 
	  ROUND((CAST(COUNT(c.[Name]) AS FLOAT) / CAST((SELECT SUM([CountReports]) FROM CTE_ReportsByDepartment WHERE DeptName = d.[Name]) AS FLOAT)) * 100, 0) AS [Percentage]
FROM Departments AS d
INNER JOIN Categories AS c ON c.DepartmentId = d.Id
INNER JOIN Reports AS r ON r.CategoryId = c.Id
GROUP BY d.[Name], c.[Name]
ORDER BY d.[Name], c.[Name], [Percentage]