SELECT DISTINCT u.Username
FROM Users AS u
LEFT JOIN Reports AS r ON r.UserId = u.Id
WHERE 
(ISNUMERIC(LEFT(u.Username, 1)) = 1 AND CAST(LEFT(u.Username, 1) AS INT) = r.CategoryId)
OR
(ISNUMERIC(RIGHT(u.Username, 1)) = 1 AND CAST(RIGHT(u.Username, 1) AS INT) = r.CategoryId)
ORDER BY u.Username