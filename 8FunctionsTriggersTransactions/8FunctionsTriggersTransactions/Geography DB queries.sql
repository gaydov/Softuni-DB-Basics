USE Geography

-- Peaks and Mountains
SELECT p.PeakName, m.MountainRange AS [Mountain], p.Elevation
FROM Peaks AS p
INNER JOIN Mountains AS m ON m.Id = p.MountainId
ORDER BY p.Elevation DESC, p.PeakName

-- Peaks with Mountain, Country and Continent
SELECT p.PeakName, m.MountainRange AS [Mountain], c.CountryName, con.ContinentName
FROM Peaks AS p
INNER JOIN Mountains AS m ON p.MountainId = m.Id
LEFT OUTER JOIN MountainsCountries AS mc ON mc.MountainId = m.Id
LEFT OUTER JOIN Countries AS c ON c.CountryCode = mc.CountryCode
INNER JOIN Continents AS con ON con.ContinentCode = c.ContinentCode
ORDER BY p.PeakName, c.CountryName

-- Rivers by Country
SELECT c.CountryName, cont.ContinentName, COUNT(r.Id) AS [RiversCount], [TotalLength] =
	CASE 
		WHEN SUM(r.Length) IS NULL THEN '0'
		ELSE SUM(r.Length)
	END
FROM Countries AS c
INNER JOIN Continents AS cont ON cont.ContinentCode = c.ContinentCode
LEFT OUTER JOIN CountriesRivers AS cr ON cr.CountryCode = c.CountryCode
LEFT OUTER JOIN Rivers AS r ON r.Id = cr.RiverId
GROUP BY c.CountryName, cont.ContinentName
ORDER BY RiversCount DESC, TotalLength DESC, c.CountryName

-- Count of Countries by Currency
SELECT cur.CurrencyCode, cur.Description AS [Currency], COUNT(c.CountryCode) AS NumberOfCountries
FROM Currencies AS cur
LEFT OUTER JOIN Countries AS c ON c.CurrencyCode = cur.CurrencyCode
GROUP BY cur.CurrencyCode, cur.Description
ORDER BY NumberOfCountries DESC, cur.Description

-- Population and Area by Continent
SELECT cont.ContinentName, SUM(CAST(c.AreaInSqKm AS bigint)) AS [CountriesArea], SUM(CAST(c.Population AS bigint)) AS [CountriesPopulation]
FROM Continents AS cont
INNER JOIN Countries AS c ON c.ContinentCode = cont.ContinentCode
GROUP BY cont.ContinentName
ORDER BY CountriesPopulation DESC

-- Monasteries by Country
CREATE TABLE Monasteries
(
Id int PRIMARY KEY IDENTITY,
[Name] varchar(max),
CountryCode char(2) FOREIGN KEY REFERENCES Countries(CountryCode)
)

INSERT INTO Monasteries(Name, CountryCode) VALUES
('Rila Monastery “St. Ivan of Rila”', 'BG'), 
('Bachkovo Monastery “Virgin Mary”', 'BG'),
('Troyan Monastery “Holy Mother''s Assumption”', 'BG'),
('Kopan Monastery', 'NP'),
('Thrangu Tashi Yangtse Monastery', 'NP'),
('Shechen Tennyi Dargyeling Monastery', 'NP'),
('Benchen Monastery', 'NP'),
('Southern Shaolin Monastery', 'CN'),
('Dabei Monastery', 'CN'),
('Wa Sau Toi', 'CN'),
('Lhunshigyia Monastery', 'CN'),
('Rakya Monastery', 'CN'),
('Monasteries of Meteora', 'GR'),
('The Holy Monastery of Stavronikita', 'GR'),
('Taung Kalat Monastery', 'MM'),
('Pa-Auk Forest Monastery', 'MM'),
('Taktsang Palphug Monastery', 'BT'),
('S?mela Monastery', 'TR')

ALTER TABLE Countries
ADD IsDeleted bit NOT NULL DEFAULT 0

UPDATE Countries
SET IsDeleted = 1
WHERE CountryCode IN (SELECT c.CountryCode
					FROM Countries As c
					INNER JOIN CountriesRivers AS cr ON cr.CountryCode = c.CountryCode
					INNER JOIN Rivers AS r ON cr.RiverId = r.Id
					GROUP BY c.CountryCode
					HAVING COUNT(r.Id) > 3)

SELECT m.Name AS [Monastery], c.CountryName AS [Country]
FROM Monasteries AS m
INNER JOIN Countries AS c ON c.CountryCode = m.CountryCode
WHERE c.IsDeleted = 0
ORDER BY m.Name

-- Monasteries by Continents and Countries
UPDATE Countries
SET CountryName = 'Burma'
WHERE CountryName = 'Myanmar'

INSERT INTO Monasteries 
VALUES
('Hanga Abbey', (SELECT CountryCode FROM Countries WHERE CountryName = 'Tanzania')),
('Myin-Tin-Daik', (SELECT CountryCode FROM Countries WHERE CountryName = 'Myanmar'))

SELECT cont.ContinentName, c.CountryName, COUNT(m.Id) AS [MonasteriesCount]
FROM Continents AS cont
INNER JOIN Countries AS c ON c.ContinentCode = cont.ContinentCode
LEFT OUTER JOIN Monasteries AS m ON m.CountryCode = c.CountryCode
WHERE c.IsDeleted = 0
GROUP BY cont.ContinentName, c.CountryName
ORDER BY MonasteriesCount DESC, c.CountryName