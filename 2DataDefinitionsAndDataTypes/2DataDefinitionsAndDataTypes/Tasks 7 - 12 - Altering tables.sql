USE Minions

-- Task 7
CREATE TABLE People
(
Id int NOT NULL IDENTITY PRIMARY KEY,
Name varchar(200) NOT NULL,
Picture varbinary(max),
Height decimal(3,2),
Weight decimal(5,2), 
Gender char NOT NULL CHECK (Gender IN ('m', 'f')),
Birthdate date NOT NULL,
Biography varchar(max)
)

ALTER TABLE dbo.People ADD CONSTRAINT CHK_T_Pic__2MB CHECK (DATALENGTH(Picture) <= 2097152)

INSERT INTO People (Name, Picture, Height, Weight, Gender, Birthdate, Biography)
VALUES
('Georgi', 123, 1.75555, 85.454444, 'm', '1960-04-24', 'Georgi biography'),
('Ivan', 456, 1.8566666, 88.45111, 'm', '1966-04-16', 'Ivan biography'),
('Maria', 444, 1.654444, 55.45222, 'f', '1985-01-15', 'Maria biography'),
('Stoqn', 111123, 1.790000, 89.44343434, 'm', '1981-12-21', 'Stoqn biography'),
('Desi', 999, 1.653333, 51.44343435, 'f', '1989-03-12', 'Desi biography')

-- Task 8
CREATE TABLE Users
(
Id bigint IDENTITY PRIMARY KEY,
Username nvarchar(30) NOT NULL UNIQUE,
Password nvarchar(26) NOT NULL,
ProfilePicture varbinary(max),
LastLoginTime smalldatetime,
IsDeleted bit
)

ALTER TABLE Users ADD CONSTRAINT CHK_PicSize_900KB CHECK (DATALENGTH(ProfilePicture) <= 921600)

INSERT INTO Users (Username, Password, ProfilePicture, LastLoginTime, IsDeleted)
VALUES
('Georgi', 'pasdsadas', 123, '2016-01-10 13:01:00', 1),
('Ivan', 'pass1', 22243, '2016-12-10 10:00:30', 0),
('Maria', 'pass2', 434, '2014-12-17 11:01:01', 1),
('Desi', 'pass3', 22, '2011-11-11 01:13:00', 1),
('Veronika', 'pas3s', 111, '2012-01-01 18:16:29', 0)

-- Task 9
ALTER TABLE Users
DROP CONSTRAINT [PK__Users__3214EC0796B409A7]

ALTER TABLE Users
ADD CONSTRAINT PK_Users PRIMARY KEY (Id, Username)

-- Task 10
ALTER TABLE Users
ADD CONSTRAINT CHK_PassLen_5symbols CHECK (LEN(Password) >= 5)

-- Task 11
ALTER TABLE Users
ADD CONSTRAINT DF_CurrentTime DEFAULT GETDATE() for LastLoginTime

-- Task 12
ALTER TABLE Users
DROP CONSTRAINT PK_Users