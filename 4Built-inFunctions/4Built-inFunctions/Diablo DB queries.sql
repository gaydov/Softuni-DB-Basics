USE Diablo

-- Games From 2011 and 2012 Year
SELECT TOP 50 Name, FORMAT(Start, 'yyyy-MM-dd') AS [Start date]
FROM Games
WHERE DATEPART(year, Start) in (2011, 2012)
ORDER BY [Start date], Name

-- User Email Providers
SELECT Username, SUBSTRING(Email, CHARINDEX('@', Email) + 1, LEN(Email)) AS [Email Provider]
FROM Users
ORDER BY [Email Provider], Username

-- Get Users with IPAddress Like Pattern
SELECT Username, IpAddress 
FROM Users
WHERE IpAddress LIKE '___.1%.%.___'
ORDER BY Username

-- Show All Games with Duration
SELECT Name, 
	'Part of the day' =
	CASE 
		WHEN DATEPART(hour, Start) >= 0 AND DATEPART(hour, Start) < 12 THEN 'Morning'
		WHEN DATEPART(hour, Start) >= 12 AND DATEPART(hour, Start) < 18 THEN 'Afternoon'
		ELSE 'Evening'
	END,
	Duration =
	CASE 
		WHEN Duration <= 3 THEN 'Extra Short'
		WHEN Duration > 3 AND Duration <= 6 THEN 'Short'
		WHEN Duration > 6 THEN 'Long'
		ELSE 'Extra Long'
	END
FROM Games
ORDER BY Name, Duration, [Part of the day]