-- DDL
CREATE DATABASE Bakery
GO
USE Bakery

CREATE TABLE Customers
(
Id int PRIMARY KEY IDENTITY,
FirstName nvarchar(25),
LastName nvarchar(25),
Gender char(1) CHECK (Gender IN ('M', 'F')),
Age int,
PhoneNumber char(10) CHECK (LEN(PhoneNumber) = 10),
CountryId int NOT NULL
)

CREATE TABLE Feedbacks
(
Id int PRIMARY KEY IDENTITY,
[Description] nvarchar(255), 
Rate decimal(4, 2),
ProductId int NOT NULL,
CustomerId int NOT NULL
)

CREATE TABLE Products
(
Id int PRIMARY KEY IDENTITY,
[Name] nvarchar(25) UNIQUE,
[Description] nvarchar(250),
Recipe nvarchar(max),
Price money CHECK (Price >= 0)
)

CREATE TABLE Ingredients
(
Id int PRIMARY KEY IDENTITY,
[Name] nvarchar(30),
[Description] nvarchar(200),
OriginCountryId int NOT NULL,
DistributorId int NOT NULL
)

CREATE TABLE ProductsIngredients
(
ProductId int NOT NULL,
IngredientId int NOT NULL
)

CREATE TABLE Distributors
(
Id int PRIMARY KEY IDENTITY,
[Name] nvarchar(25) UNIQUE,
AddressText nvarchar(30),
Summary nvarchar(200),
CountryId int NOT NULL
)

CREATE TABLE Countries
(
Id int PRIMARY KEY IDENTITY,
[Name] nvarchar(50) UNIQUE
)

ALTER TABLE ProductsIngredients
ADD CONSTRAINT PK_ProductsIngredients PRIMARY KEY (ProductId, IngredientId)

ALTER TABLE ProductsIngredients
ADD CONSTRAINT FK_Products FOREIGN KEY (ProductId) REFERENCES Products(Id)

ALTER TABLE ProductsIngredients
ADD CONSTRAINT FK_Ingredients FOREIGN KEY (IngredientId) REFERENCES Ingredients(Id)

ALTER TABLE Feedbacks
ADD CONSTRAINT FK_Feedbacks_Products FOREIGN KEY (ProductId) REFERENCES Products(Id)

ALTER TABLE Feedbacks
ADD CONSTRAINT FK_Feedbacks_Customers FOREIGN KEY (CustomerId) REFERENCES Customers(Id)

ALTER TABLE Customers
ADD CONSTRAINT FK_Customers_Countries FOREIGN KEY (CountryId) REFERENCES Countries(Id)

ALTER TABLE Ingredients
ADD CONSTRAINT FK_Ingr_Countries FOREIGN KEY (OriginCountryId) REFERENCES Countries(Id)

ALTER TABLE Ingredients
ADD CONSTRAINT FK_Ingr_Distributors FOREIGN KEY (DistributorId) REFERENCES Distributors(Id)

ALTER TABLE Distributors
ADD CONSTRAINT FK_Dist_Countries FOREIGN KEY (CountryId) REFERENCES Countries(Id)

-- Insert
INSERT INTO Distributors ([Name], CountryId, AddressText, Summary)
VALUES
('Deloitte & Touche', 2, '6 Arch St #9757', 'Customizable neutral traveling'),
('Congress Title', 13, '58 Hancock St', 'Customer loyalty'),
('Kitchen People', 1, '3 E 31st St #77', 'Triple-buffered stable delivery'),
('General Color Co Inc', 21, '6185 Bohn St #72', 'Focus group'),
('Beck Corporation', 23, '21 E 64th Ave', 'Quality-focused 4th generation hardware')

INSERT INTO Customers (FirstName, LastName, Age, Gender, PhoneNumber, CountryId)
VALUES
('Francoise', 'Rautenstrauch', 15, 'M', '0195698399', 5),
('Kendra', 'Loud', 22, 'F', '0063631526', 11),
('Lourdes', 'Bauswell', 50, 'M', '0139037043', 8),
('Hannah', 'Edmison', 18, 'F', '0043343686', 1),
('Tom', 'Loeza', 31, 'M', '0144876096', 23),
('Queenie', 'Kramarczyk', 30, 'F', '0064215793', 29),
('Hiu', 'Portaro', 25, 'M', '0068277755', 16),
('Josefa', 'Opitz', 43, 'F', '0197887645', 17)

-- Update
UPDATE Ingredients
SET DistributorId = 35
WHERE [Name] IN ('Bay Leaf', 'Paprika', 'Poppy')

UPDATE Ingredients
SET OriginCountryId = 14
WHERE OriginCountryId = 8

-- Delete
DELETE FROM Feedbacks
WHERE CustomerId = 14 OR ProductId = 5

-- Products By Price
SELECT [Name], Price, [Description] 
FROM Products
ORDER BY Price DESC, [Name] 

-- Ingredients
SELECT [Name], [Description], OriginCountryId
FROM Ingredients
WHERE OriginCountryId IN (1, 10, 20)
ORDER BY Id

-- Ingredients from Bulgaria and Greece
SELECT TOP (15) i.[Name], i.[Description], c.[Name] 
FROM Ingredients AS i
LEFT OUTER JOIN Countries AS c on i.OriginCountryId = c.Id
WHERE c.[Name] IN ('Bulgaria', 'Greece')
ORDER BY i.[Name], c.[Name]

-- Best Rated Products
SELECT TOP(10) p.[Name], p.[Description], AVG(f.Rate) AS [AverageRate], COUNT(f.Id) AS FeedbacksAmount
FROM Products AS p
LEFT OUTER JOIN Feedbacks AS f ON p.Id = f.ProductId
GROUP BY p.[Name], p.[Description]
ORDER BY AverageRate DESC, FeedbacksAmount DESC

-- Negative Feedback
SELECT f.ProductId, f.Rate, f.[Description], f.CustomerId, c.Age, c.Gender
FROM Feedbacks AS f
INNER JOIN Customers AS c ON f.CustomerId = c.Id
WHERE f.Rate < 5.0
ORDER BY f.ProductId DESC, f.Rate

-- Customers without Feedback
SELECT CONCAT(c.FirstName, ' ', c.LastName) AS [CustomerName], c.PhoneNumber, c.Gender 
FROM Customers AS c
WHERE c.Id NOT IN (SELECT DISTINCT f.CustomerId FROM Feedbacks AS f)
ORDER BY c.Id

-- Honorable Mentions
SELECT f.ProductId, CONCAT(c.FirstName, ' ', c.LastName) as CustomerName, f.[Description] AS FeedbackDescription
FROM Customers AS c
INNER JOIN Feedbacks AS f ON c.Id = f.CustomerId
WHERE c.Id IN (SELECT c.Id
				FROM Customers AS c
				INNER JOIN Feedbacks AS f ON c.Id = f.CustomerId
				GROUP BY c.Id
				HAVING COUNT(f.Id) >= 3) 
ORDER BY f.ProductId, CustomerName, f.Id

-- Customers by Criteria
SELECT cust.FirstName, cust.Age, cust.PhoneNumber
FROM Customers AS cust
INNER JOIN Countries AS cntr ON cust.CountryId = cntr.Id
WHERE (cust.Age >= 21 AND CHARINDEX('an', cust.FirstName, 1) > 0) OR (RIGHT(cust.PhoneNumber, 2) = '38' AND cntr.Name != 'Greece')
ORDER BY cust.FirstName, cust.Age DESC

-- Middle Range Distributors
SELECT d.[Name] AS DistributorName, i.[Name] AS IngredientName, p.[Name] AS ProductName, AVG(f.Rate) AS AverageRate
FROM Distributors AS d
INNER JOIN Ingredients AS i ON d.Id = i.DistributorId
INNER JOIN ProductsIngredients AS prdi ON i.Id = prdi.IngredientId
INNER JOIN Products AS p ON prdi.ProductId = p.Id
INNER JOIN Feedbacks AS f ON p.Id = f.ProductId
GROUP BY d.[Name], i.[Name], p.[Name]
HAVING AVG(f.Rate) BETWEEN 5 AND 8
ORDER BY d.[Name], i.[Name], p.[Name]

-- The Most Positive Country
SELECT TOP 1 WITH TIES cntr.[Name] AS CountryName, AVG(f.Rate) AS FeedbackRate
FROM Countries AS cntr
INNER JOIN Customers AS cust ON cntr.Id = cust.CountryId
INNER JOIN Feedbacks AS f ON cust.Id = f.CustomerId
GROUP BY cntr.[Name]
ORDER BY FeedbackRate DESC

-- Country Representative
SELECT ranked.CountryName, ranked.DistributorName
FROM
(SELECT c.[Name] AS CountryName, d.[Name] AS DistributorName, DENSE_RANK() OVER (PARTITION BY c.Name ORDER BY COUNT(i.Id) DESC) AS Position
FROM Distributors AS d
INNER JOIN Ingredients AS i ON d.Id = i.DistributorId
INNER JOIN Countries AS c ON d.CountryId = c.Id
GROUP BY c.[Name], d.[Name]) 
AS ranked
WHERE ranked.Position = 1
ORDER BY ranked.CountryName, ranked.DistributorName

-- Customers With Countries
GO
CREATE VIEW v_UserWithCountries 
AS
SELECT CONCAT(cust.FirstName, ' ', cust.LastName) AS CustomerName, cust.Age, cust.Gender, cntr.[Name] AS CountryName
FROM Customers AS cust
INNER JOIN Countries AS cntr ON cust.CountryId = cntr.Id

-- Feedback by Product Name
GO
CREATE FUNCTION udf_GetRating(@productName nvarchar(25))
RETURNS nvarchar(25)
AS
BEGIN

	DECLARE @resultRating nvarchar(25);
	SET @resultRating = (SELECT [Rating] =
							CASE 
								WHEN AVG(f.Rate) < 5 THEN 'Bad'
								WHEN AVG(f.Rate) >= 5 AND AVG(f.Rate) <= 8 THEN 'Average'
								WHEN AVG(f.Rate) > 8 THEN 'Good'
								WHEN AVG(f.Rate) IS NULL THEN 'No rating'
							END
						FROM Products AS p
						LEFT OUTER JOIN Feedbacks AS f ON p.Id = f.ProductId
						WHERE p.[Name] = @productName)

RETURN @resultRating
END

-- Send Feedback
GO
CREATE PROCEDURE usp_SendFeedback(@customerId int, @productId int, @rate decimal(4, 2), @description nvarchar(255))
AS
BEGIN
	BEGIN TRANSACTION

	DECLARE @currentFeedbacksCountForProduct int;
	SET @currentFeedbacksCountForProduct = (SELECT COUNT(f.Id)
											FROM Feedbacks AS f
											WHERE f.CustomerId = @customerId)

	IF(@currentFeedbacksCountForProduct < 3)
	BEGIN

		INSERT INTO Feedbacks (CustomerId, ProductId, Rate, [Description])
		VALUES (@customerId, @productId, @rate, @description)
		COMMIT

	END
	ELSE
	BEGIN
		ROLLBACK
		RAISERROR('You are limited to only 3 feedbacks per product!', 16, 1)
	END
END

-- Delete Products
GO
CREATE TRIGGER utr_DeleteProduct ON Products INSTEAD OF DELETE
AS
BEGIN

	DELETE FROM ProductsIngredients
	WHERE ProductId = (SELECT Id FROM deleted)

	DELETE FROM Feedbacks 
	WHERE ProductId = (SELECT Id FROM deleted)

	DELETE FROM Products
	WHERE Id = (SELECT Id FROM deleted) 

END

-- Products by One Distributor
WITH PrdDist_CTE
AS
(
SELECT p.Name AS ProductName, d.Name AS DistributorName 
FROM Products AS p
INNER JOIN ProductsIngredients AS pin ON p.Id = pin.ProductId
INNER JOIN Ingredients AS i ON pin.IngredientId = i.Id
INNER JOIN Distributors AS d ON i.DistributorId = d.Id
INNER JOIN Countries AS c on c.Id = d.CountryId
INNER JOIN Feedbacks AS f ON f.ProductId = p.Id
GROUP BY p.Name, d.Name
)

SELECT p.Name AS ProductName, AVG(f.Rate) AS ProductAverageRate, d.Name AS DistributorName, c.Name AS DistributorCountry
FROM Products AS p
INNER JOIN ProductsIngredients AS pin ON p.Id = pin.ProductId
INNER JOIN Ingredients AS i ON pin.IngredientId = i.Id
INNER JOIN Distributors AS d ON i.DistributorId = d.Id
INNER JOIN Countries AS c ON d.CountryId = c.Id
INNER JOIN Feedbacks AS f ON f.ProductId = p.Id
GROUP BY p.Id, p.Name, d.Name, c.Name
HAVING p.Name IN (
				 SELECT prddist.ProductName 
				 FROM PrdDist_CTE AS prddist
				 GROUP BY prddist.ProductName
				 HAVING COUNT(prddist.DistributorName) = 1
				 )
ORDER BY p.Id