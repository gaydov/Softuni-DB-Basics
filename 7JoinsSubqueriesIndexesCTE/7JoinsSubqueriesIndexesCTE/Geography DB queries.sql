USE Geography

-- Highest Peaks in Bulgaria
SELECT mc.CountryCode ,m.MountainRange, p.PeakName, p.Elevation
FROM Mountains AS m
INNER JOIN Peaks AS p ON m.Id = p.MountainId
INNER JOIN MountainsCountries AS mc ON m.Id = mc.MountainId
WHERE p.Elevation > 2835
AND mc.CountryCode = 'BG'
ORDER BY Elevation DESC

-- Count Mountain Ranges
SELECT mc.CountryCode, COUNT(m.Id) AS [MountainRanges]
FROM MountainsCountries AS mc
INNER JOIN Mountains AS m ON mc.MountainId = m.Id
GROUP BY mc.CountryCode
HAVING mc.CountryCode IN ('BG', 'RU', 'US')
ORDER BY MountainRanges DESC

-- Countries With or Without Rivers
SELECT TOP(5) c.CountryName, r.RiverName
FROM Countries AS c
LEFT OUTER JOIN CountriesRivers AS cr ON c.CountryCode = cr.CountryCode
LEFT OUTER JOIN Rivers AS r ON cr.RiverId = r.Id
WHERE c.ContinentCode = (SELECT con.ContinentCode 
					FROM Continents AS con 
					WHERE con.ContinentName = 'Africa')
ORDER BY c.CountryName

-- *Continents and Currencies
SELECT rankedCurrencies.ContinentCode, rankedCurrencies.CurrencyCode, rankedCurrencies.Count
FROM (
SELECT c.ContinentCode, c.CurrencyCode, COUNT(c.CurrencyCode) AS [Count], DENSE_RANK() OVER (PARTITION BY c.ContinentCode ORDER BY COUNT(c.CurrencyCode) DESC) AS [rank] 
FROM Countries AS c
GROUP BY c.ContinentCode, c.CurrencyCode) AS rankedCurrencies
WHERE rankedCurrencies.rank = 1 and rankedCurrencies.Count > 1

-- Countries Without any Mountains
SELECT COUNT(c.CountryCode) AS [CountryCode]
FROM Countries AS c
LEFT OUTER JOIN MountainsCountries AS m ON c.CountryCode = m.CountryCode
WHERE m.MountainId IS NULL

-- Highest Peak and Longest River by Country
SELECT TOP(5) c.CountryName, MAX(p.Elevation) AS [HighestPeakElevation], MAX(r.Length) AS [LongestRiverLength]
FROM Countries AS c
LEFT OUTER JOIN MountainsCountries AS mc ON c.CountryCode = mc.CountryCode
LEFT OUTER JOIN Peaks AS p ON p.MountainId = mc.MountainId
LEFT OUTER JOIN CountriesRivers AS cr ON c.CountryCode = cr.CountryCode
LEFT OUTER JOIN Rivers AS r ON cr.RiverId = r.Id
GROUP BY c.CountryName
ORDER BY [HighestPeakElevation] DESC, [LongestRiverLength] DESC, c.CountryName

-- *Highest Peak Name and Elevation by Country
SELECT TOP (5) WITH TIES c.CountryName, ISNULL(p.PeakName, '(no highest peak)') AS 'HighestPeakName', ISNULL(MAX(p.Elevation), 0) AS 'HighestPeakElevation', ISNULL(m.MountainRange, '(no mountain)')
FROM Countries AS c
LEFT JOIN MountainsCountries AS mc
ON c.CountryCode = mc.CountryCode
LEFT JOIN Mountains AS m
ON mc.MountainId = m.Id
LEFT JOIN Peaks AS p
ON m.Id = p.MountainId
GROUP BY c.CountryName, p.PeakName, m.MountainRange
ORDER BY c.CountryName, p.PeakName