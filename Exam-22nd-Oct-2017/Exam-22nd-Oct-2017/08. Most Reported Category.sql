SELECT c.[Name] AS CategoryName, COUNT(r.Id) AS ReportsNumber
FROM Categories AS c
INNER JOIN Reports AS r ON r.CategoryId = c.Id
GROUP BY c.Name
ORDER BY ReportsNumber DESC, CategoryName