USE Bank

-- Find Full Name
GO
CREATE PROCEDURE usp_GetHoldersFullName 
AS
SELECT FirstName + ' ' + LastName AS [Full Name]
FROM AccountHolders

-- People with Balance Higher Than
GO
CREATE PROCEDURE usp_GetHoldersWithBalanceHigherThan(@amount money)
AS
SELECT FirstName AS [First Name], LastName AS [Last Name]
FROM AccountHolders AS ah
INNER JOIN Accounts AS a
ON ah.Id = a.AccountHolderId
GROUP BY FirstName, LastName
HAVING SUM(Balance) > @amount

-- Future Value Function
GO 
CREATE FUNCTION ufn_CalculateFutureValue(@sum money, @yearlyInterestRate float, @yearsCount int)
RETURNS MONEY
AS
BEGIN

RETURN @sum * POWER(1 + @yearlyInterestRate, @yearsCount)

END

-- Calculating Interest
GO
CREATE PROCEDURE usp_CalculateFutureValueForAccount(@accountId int, @interestRate float)
AS
SELECT a.Id AS [Account Id], FirstName AS [First Name], LastName AS [Last Name], Balance AS [Current Balance], dbo.ufn_CalculateFutureValue(Balance, @interestRate, 5) AS [Balance in 5 years]
FROM Accounts AS a
INNER JOIN AccountHolders AS ac
ON a.AccountHolderId = ac.Id
WHERE a.Id = @accountId

-- Deposit Money Procedure
GO
CREATE PROCEDURE usp_DepositMoney(@accountId int, @moneyAmount money)
AS
BEGIN TRANSACTION

UPDATE Accounts
SET Balance += @moneyAmount
WHERE Id = @accountId

COMMIT

-- Withdraw Money Procedure
GO
CREATE PROCEDURE usp_WithdrawMoney(@accountId int, @moneyAmount money)
AS
BEGIN TRANSACTION

UPDATE Accounts
SET Balance -= @moneyAmount
WHERE Id = @accountId

DECLARE @currentBalance money = (SELECT Balance FROM Accounts WHERE Id = @accountId)

IF(@currentBalance < 0)
BEGIN
	ROLLBACK
	RAISERROR('Insufficient funds!', 16, 1)
	RETURN
END
ELSE
BEGIN
	COMMIT
END

-- Money Transfer
GO
CREATE PROCEDURE usp_TransferMoney(@senderId int, @receiverId int, @amount money)
AS
BEGIN TRANSACTION

IF(@amount < 0)
BEGIN
	ROLLBACK
	RAISERROR('Amount is less then 0!', 16, 1)
	RETURN
END

EXEC usp_WithdrawMoney @senderId, @amount
EXEC usp_DepositMoney @receiverId, @amount

COMMIT

-- Create Table Logs
CREATE TABLE Logs
(
LogId int IDENTITY,
AccountId int,
OldSum money,
NewSum money,
CONSTRAINT PK_Logs PRIMARY KEY(LogId),
CONSTRAINT FK_Logs_Accounts FOREIGN KEY(AccountId) REFERENCES Accounts(Id)
)

GO
CREATE TRIGGER tr_BalanceChange ON Accounts AFTER UPDATE
AS
BEGIN

INSERT INTO Logs(AccountId, OldSum, NewSum)
SELECT i.Id, d.Balance, i.Balance 
FROM inserted AS i
INNER JOIN deleted AS d
ON i.Id = d.Id

END

-- Create Table Emails
CREATE TABLE NotificationEmails
(
Id int PRIMARY KEY IDENTITY,
Recipient int,
Subject varchar(max),
Body varchar(max)
)

GO
CREATE TRIGGER tr_EmailNotificationOnBalanceChange ON Logs AFTER INSERT
AS
BEGIN
	INSERT INTO NotificationEmails(Recipient, Subject, Body)
	SELECT	AccountId, 
			CONCAT('Balance change for account: ', AccountId), 
			CONCAT('On ', GETDATE(), ' your balance was changed from ', OldSum, ' to ', NewSum, '.') 
	FROM inserted
END