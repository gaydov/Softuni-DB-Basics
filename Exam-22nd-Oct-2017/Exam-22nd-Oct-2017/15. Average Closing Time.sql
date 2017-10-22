SELECT	d.[Name] AS [Department Name], 
	ISNULL(CONVERT(VARCHAR(10), AVG(DATEDIFF(day, r.OpenDate, r.CloseDate))), 'no info') AS [Average Duration]
FROM Departments AS d
INNER JOIN Categories AS c ON c.DepartmentId = d.Id
INNER JOIN Reports AS r ON r.CategoryId = c.Id
GROUP BY d.[Name]
ORDER BY d.[Name]