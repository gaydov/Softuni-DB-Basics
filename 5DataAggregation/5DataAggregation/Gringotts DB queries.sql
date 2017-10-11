USE Gringotts

-- Records’ Count
SELECT COUNT(Id) AS [Count]
FROM WizzardDeposits

-- Longest Magic Wand
SELECT MAX(MagicWandSize) AS [LongestMagicWand]
FROM WizzardDeposits

-- Longest Magic Wand per Deposit Groups
SELECT DepositGroup, MAX(MagicWandSize) AS [LongestMagicWand]
FROM WizzardDeposits
GROUP BY DepositGroup

-- Smallest Deposit Group per Magic Wand Size
SELECT DepositGroup
FROM WizzardDeposits
GROUP BY DepositGroup
HAVING AVG(MagicWandSize) = 
(
	SELECT MIN(WandSizesTable.AvgSizes)
	FROM 
	(SELECT AVG(MagicWandSize) AS AvgSizes
	FROM WizzardDeposits
	GROUP BY DepositGroup
	) AS WandSizesTable
)

-- Deposits Sum
SELECT DepositGroup, SUM(DepositAmount) AS TotalSum
FROM WizzardDeposits
GROUP BY DepositGroup

-- Deposits Sum for Ollivander Family
SELECT DepositGroup, SUM(DepositAmount) AS TotalSum
FROM WizzardDeposits
WHERE MagicWandCreator = 'Ollivander family'
GROUP BY DepositGroup
 
-- Deposits Filter
SELECT DepositGroup, SUM(DepositAmount) AS TotalSum
FROM WizzardDeposits
WHERE MagicWandCreator = 'Ollivander family'
GROUP BY DepositGroup
HAVING SUM(DepositAmount) < 150000
ORDER BY TotalSum DESC

-- Deposit Charge
SELECT DepositGroup, MagicWandCreator, MIN(DepositCharge)
FROM WizzardDeposits
GROUP BY DepositGroup, MagicWandCreator

-- Age Groups
SELECT grouped.AgeGroup, COUNT(*) AS WizzardCount 
FROM
	(SELECT 
		CASE
		  WHEN wd.Age BETWEEN 0 AND 10 THEN '[0-10]'
		  WHEN wd.Age BETWEEN 11 AND 20 THEN '[11-20]'
		  WHEN wd.Age BETWEEN 21 AND 30 THEN '[21-30]'
		  WHEN wd.Age BETWEEN 31 AND 40 THEN '[31-40]'
		  WHEN wd.Age BETWEEN 41 AND 50 THEN '[41-50]'
		  WHEN wd.Age BETWEEN 51 AND 60 THEN '[51-60]'
		  WHEN wd.Age >= 61 THEN '[61+]'
		END AS [AgeGroup]
	FROM WizzardDeposits AS wd
	) AS grouped
GROUP BY grouped.AgeGroup

-- First Letter
SELECT LEFT(FirstName, 1) AS FirstLetter
FROM WizzardDeposits
WHERE DepositGroup = 'Troll Chest'
GROUP BY LEFT(FirstName, 1)
ORDER BY FirstLetter

-- Average Interest
SELECT DepositGroup, IsDepositExpired, AVG(DepositInterest)
FROM WizzardDeposits
WHERE DepositStartDate >= '1985-01-01'
GROUP BY DepositGroup, IsDepositExpired
ORDER BY DepositGroup DESC, IsDepositExpired

-- Rich Wizard, Poor Wizard
SELECT SUM(ResultTable.[Difference]) AS SumDifference
FROM (SELECT DepositAmount - (SELECT DepositAmount FROM WizzardDeposits WHERE Id = WizDeposits.Id + 1) 
AS [Difference] FROM WizzardDeposits WizDeposits) AS ResultTable