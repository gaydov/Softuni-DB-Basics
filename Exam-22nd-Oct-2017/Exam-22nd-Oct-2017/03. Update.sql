UPDATE Reports
SET StatusId = (SELECT Id FROM [Status] WHERE Label = 'in progress')
WHERE StatusId = (SELECT Id FROM [Status] WHERE Label = 'waiting')
AND CategoryId = (SELECT Id FROM Categories WHERE [Name] = 'Streetlight')