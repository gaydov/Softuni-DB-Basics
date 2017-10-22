CREATE TRIGGER TR_CloseReports ON Reports AFTER UPDATE
AS
	DECLARE @completedStatusId int = (SELECT Id
					  FROM [Status]
					  WHERE Label = 'completed')

	UPDATE Reports
	SET StatusId = @completedStatusId
	WHERE Id = (SELECT Id
			FROM inserted AS i
			WHERE CloseDate IS NOT NULL)