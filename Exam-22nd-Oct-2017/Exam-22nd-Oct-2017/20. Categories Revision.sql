WITH CTE_FilteredCategories
AS
(
SELECT c.[Name] AS [Category Name], s.Label
FROM Categories AS c
INNER JOIN Reports AS r ON r.CategoryId = c.Id
INNER JOIN [Status] AS s on s.Id = r.StatusId
WHERE r.StatusId IN (SELECT Id FROM [Status] WHERE Label IN ('waiting', 'in progress'))
)

SELECT  c.[Name] AS [Category Name], 
		COUNT(r.Id) AS [Reports Number], 
		[Main Status] =
				CASE
					WHEN (SELECT COUNT(cte.[Category Name])
					      FROM CTE_FilteredCategories AS cte 
					      WHERE cte.Label = 'in progress' 
					      AND cte.[Category Name] = c.[Name]) 
						 > 
						 (SELECT COUNT(cte.[Category Name])
						  FROM   CTE_FilteredCategories AS cte 
						  WHERE  cte.Label = 'waiting' 
						  AND    cte.[Category Name] = c.[Name])
					THEN 'in progress'

					WHEN (SELECT COUNT(cte.[Category Name])
						  FROM   CTE_FilteredCategories AS cte 
						  WHERE  cte.Label = 'in progress' 
						  AND    cte.[Category Name] = c.[Name]) 
						  < 
						 (SELECT COUNT(cte.[Category Name])
						  FROM   CTE_FilteredCategories AS cte 
						  WHERE  cte.Label = 'waiting' 
						  AND    cte.[Category Name] = c.[Name])
					THEN 'waiting'
					ELSE 'equal'
				END 
FROM Categories AS c
INNER JOIN Reports AS r ON r.CategoryId = c.Id
WHERE r.StatusId IN (SELECT Id FROM [Status] WHERE Label IN ('waiting', 'in progress'))
GROUP BY c.[Name]
ORDER BY C.[Name], [Reports Number], [Main Status]

