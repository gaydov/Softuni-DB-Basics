CREATE DATABASE WMS
GO
USE WMS

-- DDL

CREATE TABLE Clients
(
ClientId int PRIMARY KEY IDENTITY,
FirstName varchar(50) NOT NULL,
LastName varchar(50) NOT NULL,
Phone varchar(12) NOT NULL CHECK (LEN(Phone) = 12)
)

CREATE TABLE Mechanics
(
MechanicId int PRIMARY KEY IDENTITY,
FirstName varchar(50) NOT NULL,
LastName varchar(50) NOT NULL,
[Address] varchar(255) NOT NULL,
)

CREATE TABLE Jobs
(
JobId int PRIMARY KEY IDENTITY,
ModelId int NOT NULL,
[Status] varchar(11)  NOT NULL DEFAULT 'Pending' CHECK ([Status] IN ('Pending', 'In Progress', 'Finished')), 
ClientId int NOT NULL,
MechanicId int NULL,
IssueDate date NOT NULL,
FinishDate date NULL
)

CREATE TABLE Models
(
ModelId int PRIMARY KEY IDENTITY,
[Name] varchar(50) NOT NULL UNIQUE
)

CREATE TABLE Orders
(
OrderId int PRIMARY KEY IDENTITY,
JobId int NOT NULL,
IssueDate date NULL, 
Delivered bit NOT NULL DEFAULT 0
)

CREATE TABLE Parts
(
PartId int PRIMARY KEY IDENTITY,
SerialNumber varchar(50) NOT NULL UNIQUE,
[Description] varchar(255) NULL, 
Price decimal(6, 2) NOT NULL CHECK (Price > 0),
VendorId int NOT NULL,
StockQty int NOT NULL DEFAULT 0 CHECK(StockQty >= 0)
)

CREATE TABLE OrderParts
(
OrderId int NOT NULL,
PartId int NOT NULL,
Quantity int NOT NULL DEFAULT 1 CHECK(Quantity > 0)
)

CREATE TABLE PartsNeeded
(
JobId int NOT NULL,
PartId int NOT NULL,
Quantity int NOT NULL DEFAULT 1 CHECK(Quantity > 0)
)

CREATE TABLE Vendors
(
VendorId int PRIMARY KEY IDENTITY,
[Name] varchar(50) NOT NULL UNIQUE
)

ALTER TABLE Jobs
ADD CONSTRAINT FK_JobsMechanics FOREIGN KEY (MechanicId) REFERENCES Mechanics(MechanicId)

ALTER TABLE Jobs
ADD CONSTRAINT FK_JobsClients FOREIGN KEY (ClientId) REFERENCES Clients(ClientId)

ALTER TABLE Jobs
ADD CONSTRAINT FK_JobsModels FOREIGN KEY (ModelId) REFERENCES Models(ModelId)

ALTER TABLE PartsNeeded
ADD CONSTRAINT PK_PartsNeeded PRIMARY KEY(JobId, PartId)

ALTER TABLE PartsNeeded
ADD CONSTRAINT FK_PartsNeededJobs FOREIGN KEY (JobId) REFERENCES Jobs(JobId),
	CONSTRAINT FK_PtsNeededParts FOREIGN KEY (PartId) REFERENCES Parts(PartId)

ALTER TABLE Parts
ADD CONSTRAINT FK_PartsVendors FOREIGN KEY (VendorId) REFERENCES Vendors(VendorId)

ALTER TABLE OrderParts
ADD CONSTRAINT PK_OrderParts PRIMARY KEY (OrderId, PartId),
	CONSTRAINT FK_OrderPartsParts FOREIGN KEY (PartId) REFERENCES Parts(PartId),
	CONSTRAINT FK_OrderPartsOrders FOREIGN KEY(OrderId) REFERENCES Orders(OrderId)

ALTER TABLE Orders
ADD CONSTRAINT FK_OrdersJobs FOREIGN KEY (JobId) REFERENCES Jobs(JobId)

-- Insert
INSERT INTO Clients (FirstName, LastName, Phone)
VALUES
('Teri', 'Ennaco', '570-889-5187'),
('Merlyn', 'Lawler', '201-588-7810'),
('Georgene', 'Montezuma', '925-615-5185'),
('Jettie', 'Mconnell', '908-802-3564'),
('Lemuel', 'Latzke', '631-748-6479'),
('Melodie',	'Knipp', '805-690-1682'),
('Candida',	'Corbley', '908-275-8357')

INSERT INTO Parts (SerialNumber, Description, Price, VendorId)
VALUES
('WP8182119', 'Door Boot Seal',	117.86, 2),
('W10780048', 'Suspension Rod', 42.81, 1),
('W10841140', 'Silicone Adhesive', 	6.77, 4),
('WPY055980', 'High Temperature Adhesive', 13.94, 3)

-- Update
UPDATE Jobs
SET MechanicId = (SELECT MechanicId FROM Mechanics WHERE FirstName = 'Ryan' AND LastName = 'Harnos'),
	Status = 'In Progress'
WHERE [Status] = 'Pending'

-- Delete
DELETE FROM OrderParts
WHERE OrderId = 19

DELETE FROM Orders
WHERE OrderId = 19

-- Clients by Name
SELECT FirstName, LastName, Phone
FROM Clients
ORDER BY LastName, ClientId

-- Job Status
SELECT [Status], IssueDate
FROM Jobs
WHERE [Status] <> 'Finished' 
ORDER BY IssueDate, JobId

-- Mechanic Assignments
SELECT CONCAT(m.FirstName, ' ', m.LastName) AS Mechanic, j.[Status], j.IssueDate
FROM Mechanics AS m
INNER JOIN Jobs AS j ON j.MechanicId = m.MechanicId
ORDER BY m.MechanicId, j.IssueDate, j.JobId

-- Current Clients
SELECT CONCAT(c.FirstName, ' ', c.LastName) AS Client, DATEDIFF(day, j.IssueDate, '20170424') AS [Days going], j.[Status]
FROM Clients AS c
INNER JOIN Jobs AS j ON j.ClientId = c.ClientId
WHERE j.[Status] <> 'Finished'
ORDER BY [Days going] DESC, c.ClientId

-- Mechanic Performance
SELECT CONCAT(m.FirstName, ' ', m.LastName) AS Mechanic, AVG(DATEDIFF(day, j.IssueDate, j.FinishDate)) AS [Average Days]
FROM Mechanics AS m 
INNER JOIN Jobs AS j ON j.MechanicId = m.MechanicId
WHERE j.[Status] = 'Finished'
GROUP BY CONCAT(m.FirstName, ' ', m.LastName), m.MechanicId
ORDER BY m.MechanicId

-- Hard Earners
SELECT TOP 3 CONCAT(m.FirstName, ' ', m.LastName) AS Mechanic, COUNT(*) AS Jobs
FROM Mechanics AS m
INNER JOIN Jobs AS j ON j.MechanicId = m.MechanicId
WHERE j.[Status] <> 'Finished'
GROUP BY CONCAT(m.FirstName, ' ', m.LastName), m.MechanicId
HAVING COUNT(*) > 1
ORDER BY Jobs DESC, m.MechanicId

-- Available Mechanics
SELECT CONCAT(m.FirstName, ' ', m.LastName) AS Available
FROM Mechanics AS m
LEFT OUTER JOIN Jobs AS j ON j.MechanicId = m.MechanicId
WHERE m.MechanicId NOT IN (
							SELECT DISTINCT m.MechanicId 
							FROM Mechanics AS m
							LEFT OUTER JOIN Jobs AS j ON j.MechanicId = m.MechanicId
							WHERE j.[Status] <> 'Finished'
							)
GROUP BY CONCAT(m.FirstName, ' ', m.LastName), m.MechanicId
ORDER BY m.MechanicId

-- Parts Cost
SELECT ISNULL(SUM(p.Price * op.Quantity), 0.00) AS [Parts total]
FROM Parts AS p
INNER JOIN OrderParts AS op ON op.PartId = p.PartId
INNER JOIN Orders AS o ON o.OrderId = op.OrderId
WHERE DATEDIFF(week, o.IssueDate, '20170424') <= 3

-- Past Expenses
SELECT j.JobId, ISNULL(SUM(p.Price * op.Quantity), 0.00) AS Total
FROM Jobs AS j
LEFT OUTER JOIN Orders AS o ON o.JobId = j.JobId
LEFT OUTER JOIN OrderParts AS op ON op.OrderId = o.OrderId
LEFT OUTER JOIN Parts AS p ON p.PartId = op.PartId
WHERE j.[Status] = 'Finished'
GROUP BY j.JobId
ORDER BY Total DESC, j.JobId

-- Model Repair Time
SELECT m.ModelId, m.[Name], CONCAT(AVG(DATEDIFF(day, j.IssueDate, j.FinishDate)), ' ', 'days') AS [Average Service Time]
FROM Models AS m
INNER JOIN Jobs AS j ON j.ModelId = m.ModelId
WHERE j.[Status] = 'Finished'
GROUP BY m.ModelId, m.[Name]
ORDER BY AVG(DATEDIFF(day, j.IssueDate, j.FinishDate))

-- Faultiest Model
DECLARE @modelsWithServicedTimes TABLE 
(
ModelId int,
ModelName varchar(50),
CountOfRepairs int
);

INSERT INTO @modelsWithServicedTimes(ModelId, ModelName, CountOfRepairs)
SELECT m.ModelId, m.[Name], COUNT(j.JobId)
FROM Models AS m
INNER JOIN Jobs AS j ON j.ModelId = m.ModelId
GROUP BY m.ModelId, m.[Name]

DECLARE @countOfMostFaultiestModel int = (SELECT TOP 1 WITH TIES MAX(mst.CountOfRepairs)
										  FROM @modelsWithServicedTimes AS mst
										  GROUP BY mst.ModelId
										  ORDER BY MAX(mst.CountOfRepairs) DESC)

DECLARE @modelIdOfMostFaultiestModel int = (SELECT TOP 1 WITH TIES mst.ModelId
											FROM @modelsWithServicedTimes AS mst
											GROUP BY mst.ModelId
											ORDER BY MAX(mst.CountOfRepairs) DESC)

SELECT m.[Name] AS Model, @countOfMostFaultiestModel AS [Times Serviced], ISNULL(SUM(op.Quantity * p.Price), 0.00) AS [Parts Total]
FROM Models AS m
LEFT OUTER JOIN Jobs AS j ON j.ModelId = m.ModelId
LEFT OUTER JOIN Orders AS o On o.JobId = j.JobId
LEFT OUTER JOIN OrderParts as op on op.OrderId = o.OrderId
LEFT OUTER JOIN Parts as p on p.PartId = op.PartId
WHERE m.ModelId = @modelIdOfMostFaultiestModel
GROUP BY m.[Name]

-- Missing Parts

SELECT p.PartId,
       p.[Description],
       SUM(pn.Quantity) AS [Required],
       SUM(p.StockQty) AS [In Stock],
       ISNULL(SUM(op.Quantity), 0) AS Ordered
FROM Parts AS p
LEFT OUTER JOIN PartsNeeded pn ON pn.PartId = p.PartId
LEFT OUTER JOIN Jobs AS j ON j.JobId = pn.JobId
LEFT OUTER JOIN Orders AS o ON o.JobId = j.JobId
LEFT OUTER JOIN OrderParts AS op ON op.OrderId = o.OrderId
WHERE j.Status <> 'Finished'
GROUP BY p.PartId, p.[Description]
HAVING SUM(p.StockQty) + ISNULL(SUM(op.Quantity), 0) < SUM(pn.Quantity)
ORDER BY p.PartId

-- Cost of Order
GO
CREATE FUNCTION udf_GetCost(@jobId int)
RETURNS decimal(10, 2)
AS
BEGIN

	DECLARE @result decimal(10, 2) = (SELECT ISNULL(SUM(p.Price), 0.00)
									  FROM Jobs AS j
									  INNER JOIN Orders AS o ON o.JobId = j.JobId
									  INNER JOIN OrderParts AS op ON op.OrderId = o.OrderId
									  INNER JOIN Parts AS p ON p.PartId = op.PartId
									  WHERE j.JobId = @jobId);

	RETURN @result;
END

-- Place Order - not working
GO
CREATE PROCEDURE usp_PlaceOrder(@jobId int, @partSN varchar(50), @quantity int)
AS
BEGIN TRANSACTION
	
	if(@quantity <= 0)
	begin
		rollback;
		throw 50012, 'Part quantity must be more than zero!', 1
	end

	if (select Status from Jobs where JobId = @jobId) = 'Finished'
	begin
		rollback;
		throw 50011, 'This job is not active!', 1
	end

	if(not exists(select JobId from Jobs where JobId = @jobId))
	begin
		rollback;
		throw 50013, 'Job not found!', 1
	end

	if(not exists(select PartId from Parts where SerialNumber = @partSN))
	begin
		rollback;
		throw 50014, 'Part not found!', 1
	end


	DECLARE @currentOrder int = (select OrderId from Orders where JobId = @jobId);
	IF exists(select OrderId from Orders where JobId = @jobId)
	BEGIN

		declare @orderIssueDate date = (select IssueDate from Orders where OrderId = @currentOrder);
		if (@orderIssueDate is null)
		begin

			declare @partId int = (select PartId from Parts where SerialNumber = @partSN);
			if(exists(select PartId from OrderParts where OrderId = @currentOrder)) 
			begin
				
				update OrderParts
				set Quantity += @quantity
				where OrderId = @currentOrder

			end
			else
			begin 

				insert into OrderParts(OrderId, PartId, Quantity)
				select @currentOrder, @partId, @quantity

			end
		end

	END
	else 
	begin

		insert into Orders(JobId, IssueDate)
		select @jobId, null
		
		declare @addedOrderId int = (select OrderId from Orders where JobId = @jobId)

		insert into OrderParts(OrderId, PartId, Quantity)
		select @addedOrderId, @partId, @quantity

	end
	
COMMIT

-- Detect Delivery
GO
CREATE TRIGGER tr_AddsQuantityWhenDelivered ON Orders AFTER UPDATE
AS
BEGIN

	IF (EXISTS(SELECT i.OrderId FROM inserted AS i WHERE i.Delivered = 1))
	BEGIN
		DECLARE @deliveredOrders TABLE
		(
		DelOrderId int,
		DelPartId int,
		DelQty int
		)

		INSERT INTO @deliveredOrders(DelOrderId)
		SELECT i.OrderId 
		FROM inserted AS i
		WHERE i.Delivered = 1

		INSERT into @deliveredOrders(DelPartId, DelQty)
		SELECT op.PartId, op.Quantity 
		FROM OrderParts AS op
		WHERE op.OrderId IN (SELECT DelOrderId FROM @deliveredOrders)

		UPDATE Parts 
		SET StockQty += (SELECT DelQty 
						 FROM @deliveredOrders AS do 
						 WHERE Parts.PartId = do.DelPartId)
		WHERE PartId IN (SELECT DelPartId FROM @deliveredOrders)
	END
END


