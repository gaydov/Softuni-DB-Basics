-- Task 7
CREATE TABLE People
(
Id int NOT NULL IDENTITY PRIMARY KEY,
Name varchar(200) NOT NULL,
Picture varbinary(max),
Height decimal(3,2),
Weight decimal(5,2), 
Gender char NOT NULL CHECK (Gender IN ('m', 'f')),
Birthdate varchar(50) NOT NULL,
Biography varchar(max)
)

ALTER TABLE dbo.People ADD CONSTRAINT CHK_T_Pic__2MB CHECK (DATALENGTH(Picture) <= 2097152)

INSERT INTO People (Name, Picture, Height, Weight, Gender, Birthdate, Biography)
VALUES
('Georgi', 123, 1.75555, 85.454444, 'm', '21/04/1989', 'Georgi biography'),
('Ivan', 456, 1.8566666, 88.45111, 'm', '19/04/1991', 'Ivan biography'),
('Maria', 444, 1.654444, 55.45222, 'f', '15/01/1985', 'Maria biography'),
('Stoqn', 111123, 1.790000, 89.44343434, 'm', '21/12/1981', 'Stoqn biography'),
('Desi', 999, 1.653333, 51.44343435, 'f', '12/03/1989', 'Desi biography')

-- Task 8
CREATE TABLE Users
(
Id bigint IDENTITY PRIMARY KEY,
Username nvarchar(30) NOT NULL UNIQUE,
Password nvarchar(26) NOT NULL,
ProfilePicture varbinary(max),
LastLoginTime varchar(50),
IsDeleted bit
)

ALTER TABLE Users ADD CONSTRAINT CHK_PicSize_900KB CHECK (DATALENGTH(ProfilePicture) <= 921600)

INSERT INTO Users (Username, Password, ProfilePicture, LastLoginTime, IsDeleted)
VALUES
('Georgi', 'pass', 123, '10/01/2016', 1),
('Ivan', 'pass1', 22243, '05/12/2016', 0),
('Maria', 'pass2', 434, '17/12/2014', 1),
('Desi', 'pass3', 22, '11/11/2011', 1),
('Veronika', 'pas3s', 111, '01/01/2012', 0)

-- Task 9
ALTER TABLE Users
DROP CONSTRAINT [PK__Users__3214EC076298AEB4]

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