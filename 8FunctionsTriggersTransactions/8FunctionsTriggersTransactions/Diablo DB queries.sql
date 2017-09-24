USE Diablo

-- *Cash in User Games Odd Rows
GO
CREATE FUNCTION ufn_CashInUsersGames(@gameName varchar(max))
RETURNS @returnedTable TABLE
(
SumCash money
)
AS
BEGIN
	DECLARE @result money

	SET @result = 
	(SELECT SUM(ug.Cash) AS Cash
	FROM
		(SELECT Cash, GameId, ROW_NUMBER() OVER (ORDER BY Cash DESC) AS RowNumber
		FROM UsersGames
		WHERE GameId = (SELECT Id FROM Games WHERE Name = @gameName)
		) AS ug
	WHERE ug.RowNumber % 2 != 0
	)

	INSERT INTO @returnedTable SELECT @result
	RETURN
END
GO

-- *Massive Shopping
DECLARE @userName varchar(max) = 'Stamat'
DECLARE @gameName varchar(max) = 'Safflower'
DECLARE @userID int = (SELECT Id FROM Users WHERE Username = @userName)
DECLARE @gameID int = (SELECT Id FROM Games WHERE Name = @gameName)
DECLARE @userMoney money = (SELECT Cash FROM UsersGames WHERE UserId = @userID AND GameId = @gameID)
DECLARE @itemsTotalPrice money
DECLARE @userGameID int = (SELECT Id FROM UsersGames WHERE UserId = @userID AND GameId = @gameID)

BEGIN TRANSACTION
	SET @itemsTotalPrice = (SELECT SUM(Price) FROM Items WHERE MinLevel BETWEEN 11 AND 12)

	IF(@userMoney - @itemsTotalPrice >= 0)
	BEGIN
		INSERT INTO UserGameItems
		SELECT i.Id, @userGameID FROM Items AS i
		WHERE i.Id IN (SELECT Id FROM Items WHERE MinLevel BETWEEN 11 AND 12)

		UPDATE UsersGames
		SET Cash -= @itemsTotalPrice
		WHERE GameId = @gameID AND UserId = @userID
		COMMIT
	END
	ELSE
	BEGIN
		ROLLBACK
	END

SET @userMoney = (SELECT Cash FROM UsersGames WHERE UserId = @userID AND GameId = @gameID)
BEGIN TRANSACTION
	SET @itemsTotalPrice = (SELECT SUM(Price) FROM Items WHERE MinLevel BETWEEN 19 AND 21)

	IF(@userMoney - @itemsTotalPrice >= 0)
	BEGIN
		INSERT INTO UserGameItems
		SELECT i.Id, @userGameID FROM Items AS i
		WHERE i.Id IN (SELECT Id FROM Items WHERE MinLevel BETWEEN 19 AND 21)

		UPDATE UsersGames
		SET Cash -= @itemsTotalPrice
		WHERE GameId = @gameID AND UserId = @userID
		COMMIT
	END
	ELSE
	BEGIN
		ROLLBACK
	END

SELECT Name AS [Item Name]
FROM Items
WHERE Id IN (SELECT ItemId FROM UserGameItems WHERE UserGameId = @userGameID)
ORDER BY [Item Name]

-- Number of Users for Email Provider

SELECT pr.Provider AS [Email provider], COUNT(*) AS [Users count]
FROM 
(SELECT SUBSTRING(Email, CHARINDEX('@', Email) + 1, LEN(Email)) AS [Provider]
FROM Users) AS pr
GROUP BY pr.Provider
ORDER BY [Users count] DESC, Provider

-- All Users in Games
SELECT g.Name AS [Game], gt.Name AS [Game Type], u.Username, usg.Level, usg.Cash, c.Name AS [Character]
FROM Games AS g
INNER JOIN GameTypes AS gt ON g.GameTypeId = gt.Id
INNER JOIN UsersGames AS usg ON usg.GameId = g.Id
INNER JOIN Users AS u ON u.Id = usg.UserId
INNER JOIN Characters AS c ON c.Id = usg.CharacterId
ORDER BY usg.Level DESC, u.Username, g.Name

-- Users in Games with Their Items
SELECT u.Username, g.Name AS [Game], COUNT(usgi.ItemId) AS [Items count], SUM(i.Price) AS [Items Price]
FROM Users AS u
INNER JOIN UsersGames AS usg ON u.Id = usg.UserId
INNER JOIN Games AS g ON usg.GameId = g.Id
INNER JOIN UserGameItems AS usgi ON usgi.UserGameId = usg.Id
INNER JOIN Items AS i ON i.Id = usgi.ItemId
GROUP BY u.Username, g.Name
HAVING COUNT(usgi.ItemId) >= 10
ORDER BY [Items count] DESC, [Items Price] DESC, u.Username

-- * User in Games with Their Statistics
SELECT 
u.Username, 
g.Name AS [Game], 
MAX(c.Name) AS [Character],
SUM(itemstats.Strength) + MAX(gtstats.Strength) + MAX(chastats.Strength) AS [Strength],
SUM(itemstats.Defence) + MAX(gtstats.Defence) + MAX(chastats.Defence) AS [Defence],
SUM(itemstats.Speed) + MAX(gtstats.Speed) + MAX(chastats.Speed) AS [Speed],
SUM(itemstats.Mind) + MAX(gtstats.Mind) + MAX(chastats.Mind) AS [Mind],
SUM(itemstats.Luck) + MAX(gtstats.Luck) + MAX(chastats.Luck) AS [Luck]

FROM Users AS u
INNER JOIN UsersGames AS usg ON u.Id = usg.UserId
INNER JOIN Games AS g ON g.Id = usg.GameId
INNER JOIN Characters AS c ON c.Id = usg.CharacterId
INNER JOIN GameTypes AS gt ON gt.Id = g.GameTypeId
INNER JOIN [Statistics] AS gtstats ON gtstats.Id = gt.BonusStatsId
INNER JOIN [Statistics] AS chastats ON chastats.Id = c.StatisticId
INNER JOIN UserGameItems AS usgi ON usgi.UserGameId = usg.Id
INNER JOIN Items AS i ON i.Id = usgi.ItemId
INNER JOIN [Statistics] AS itemstats ON itemstats.Id = i.StatisticId
GROUP BY u.Username, g.Name
ORDER BY Strength DESC, Defence DESC, Speed DESC, Mind DESC, Luck DESC

-- All Items with Greater than Average Statistics
DECLARE @avgMind decimal = (SELECT AVG(Mind) FROM [Statistics])
DECLARE @avgLuck decimal = (SELECT AVG(Luck) FROM [Statistics])
DECLARE @avgSpeed decimal = (SELECT AVG(Speed) FROM [Statistics])


SELECT i.Name, i.Price, i.MinLevel, s.Strength, s.Defence, s.Speed, s.Luck, s.Mind 
FROM Items AS i
INNER JOIN [Statistics] AS s ON s.Id = i.StatisticId
WHERE s.Mind > @avgMind
AND s.Luck > @avgLuck
AND s.Speed > @avgSpeed

-- Display All Items about Forbidden Game Type
SELECT i.Name AS [Item], i.Price, i.MinLevel, gt.Name AS [Forbidden Game Type]
FROM Items AS i
LEFT OUTER JOIN GameTypeForbiddenItems AS gfbi ON gfbi.ItemId = i.Id
LEFT OUTER JOIN GameTypes AS gt ON gt.Id = gfbi.GameTypeId
ORDER BY gt.Name DESC, i.Name

-- Buy Items for User in Game
GO
DECLARE @userID int = (SELECT Id FROM Users WHERE Username = 'Alex')
DECLARE @gameID int = (SELECT Id FROM Games WHERE Name = 'Edinburgh')
DECLARE @AlexUserGameID int = (SELECT Id FROM UsersGames WHERE GameId = @gameID AND UserId = @userID) 
DECLARE @itemsTotalPrice money = (SELECT SUM(Price) FROM Items WHERE Name IN ('Blackguard', 'Bottomless Potion of Amplification', 'Eye of Etlich (Diablo III)', 'Gem of Efficacious Toxin', 'Golden Gorget of Leoric', 'Hellfire Amulet'))
DECLARE @AlexGameID int = (SELECT GameId FROM UsersGames WHERE Id = @AlexUserGameID)

INSERT INTO UserGameItems 
SELECT i.Id, @AlexUserGameID
FROM Items AS i
WHERE i.Name IN ('Blackguard', 'Bottomless Potion of Amplification', 'Eye of Etlich (Diablo III)', 'Gem of Efficacious Toxin', 'Golden Gorget of Leoric', 'Hellfire Amulet')

UPDATE UsersGames
SET Cash -= @itemsTotalPrice
WHERE Id = @AlexUserGameID

SELECT u.Username, g.Name, usg.Cash, i.Name AS [Item name]
FROM Users AS u
INNER JOIN UsersGames AS usg ON usg.UserId = u.Id
INNER JOIN Games AS g ON g.Id = usg.GameId
INNER JOIN UserGameItems AS usgi ON usgi.UserGameId = usg.Id
INNER JOIN Items AS i ON i.Id = usgi.ItemId
WHERE usg.GameId = @AlexGameID
ORDER BY [Item name]