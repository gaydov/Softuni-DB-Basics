CREATE PROCEDURE usp_AssignEmployeeToReport(@employeeId int, @reportId int)
AS
BEGIN TRANSACTION

	DECLARE @employeeDepartmentId int = (SELECT DepartmentId
					     FROM Employees
					     WHERE Id = @employeeId);
 					   
	DECLARE @reportDepartmentId int = (SELECT c.DepartmentId
				           FROM Reports AS r
				           INNER JOIN Categories AS c ON c.Id = r.CategoryId
				           WHERE r.Id = @reportId)

	IF(@employeeDepartmentId = @reportDepartmentId)
	BEGIN
		UPDATE Reports
		SET EmployeeId = @employeeId
		WHERE Id = @reportId
		COMMIT
	END
	ELSE 
	BEGIN
		ROLLBACK;
		THROW 51010, 'Employee doesn''t belong to the appropriate department!', 1;
		RETURN
	END