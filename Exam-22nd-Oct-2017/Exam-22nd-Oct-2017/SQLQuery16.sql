CREATE FUNCTION udf_ReturnMainType(@categoryName varchar(50))
RETURNS VARCHAR(25)
AS
BEGIN
	DECLARE @categoriesWithStatus TABLE
	(
		CatName varchar(50),
		RepId int,
		[Status] varchar(30)
	) 

	INSERT INTO @categoriesWithStatus
	SELECT c.[Name] AS CatName, r.Id AS RepId, s.Label
	FROM Categories AS c
	INNER JOIN Reports AS r ON r.CategoryId = c.Id
	INNER JOIN [Status] AS s ON s.Id = r.StatusId
	WHERE c.[Name] = @categoryName
	AND r.StatusId IN (SELECT Id FROM [Status] WHERE Label IN ('waiting', 'in progress'))

	DECLARE @inprogressCount int = 
	(SELECT COUNT(*)
	FROM @categoriesWithStatus
	WHERE [Status] = 'in progress')

	DECLARE @waitingCount int = 
	(SELECT COUNT(*)
	FROM @categoriesWithStatus
	WHERE [Status] = 'waiting')

	IF(@inprogressCount > @waitingCount)
	BEGIN
		RETURN 'in progress'
	END
	
	ELSE IF (@waitingCount > @inprogressCount)
	BEGIN
		RETURN 'waiting'
	END

	RETURN 'equal'
	
END
