-- Peaks in Rila
USE Geography

SELECT MountainRange, PeakName, Elevation
FROM Mountains
JOIN Peaks ON Mountains.Id = Peaks.MountainId
WHERE MountainRange = 'Rila'
ORDER BY Elevation DESC