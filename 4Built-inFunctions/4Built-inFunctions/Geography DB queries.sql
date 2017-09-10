USE Geography

-- Countries Holding 'A'
SELECT CountryName, IsoCode 
FROM Countries
WHERE LEN(CountryName) - LEN(REPLACE(CountryName, 'a', '')) >= 3
ORDER BY IsoCode

-- Mix of Peak and River Names
SELECT PeakName, RiverName, LOWER(CONCAT(PeakName, '', SUBSTRING(RiverName, 2, LEN(RiverName) - 1))) AS Mix 
FROM Peaks, Rivers 
WHERE RIGHT(PeakName, 1) = LEFT(RiverName, 1)
ORDER BY Mix