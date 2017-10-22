CREATE FUNCTION udf_GetReportsCount(@employeeId int, @statusId int) 
RETURNS INT
AS
BEGIN

	DECLARE @assignedReportsCount INT = (SELECT ISNULL(COUNT(Id), 0)
									FROM Reports
									WHERE EmployeeId = @employeeId
									AND StatusId = @statusId)
	
	RETURN @assignedReportsCount;

END