DELETE FROM Reports
WHERE StatusId = (SELECT Id FROM [Status] WHERE Label = 'blocked')