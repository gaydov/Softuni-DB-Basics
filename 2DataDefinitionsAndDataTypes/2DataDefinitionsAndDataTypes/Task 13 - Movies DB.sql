-- Task 13
CREATE DATABASE Movies
GO
USE Movies

CREATE TABLE Directors
(
Id int PRIMARY KEY IDENTITY,
DirectorName varchar(50) NOT NULL,
Notes varchar(max)
)

CREATE TABLE Genres 
(
Id int PRIMARY KEY IDENTITY,
GenreName varchar(50) NOT NULL,
Notes varchar(max)
)

CREATE TABLE Categories 
(
Id int PRIMARY KEY IDENTITY,
CategoryName varchar(50) NOT NULL,
Notes varchar(max)
)

CREATE TABLE Movies
(
Id int PRIMARY KEY IDENTITY,
Title varchar(50) NOT NULL,
DirectorId int FOREIGN KEY REFERENCES Directors(Id),
CopyrightYear int,
Length int,
GenreId int FOREIGN KEY REFERENCES Genres(Id),
CategoryId int FOREIGN KEY REFERENCES Categories(Id),
Rating int,
Notes varchar(max)
)

INSERT INTO Directors (DirectorName, Notes)
VALUES 
('Francis Ford Coppola', 'The godfather'),
('Quentin Tarantino', 'Kill Bill'),
('Robert Zemeckis', 'Forrest Gump'),
('Christopher Nolan', 'Interstellar'),
('George Lucas', 'Star wars')

INSERT INTO Genres(GenreName, Notes)
VALUES
('Horror', 'Scary stuff'),
('Action', 'Action movie'),
('Drama', 'Tears, man'),
('Thriller', 'Killings'),
('Comedy', 'Laugh')

INSERT INTO Categories(CategoryName, Notes)
VALUES 
('Scary', 'very scarry'),
('Fun', 'funny stuff'),
('Bad movies', 'wasted money'),
('Awful movies', 'should be banned'),
('Great', 'should be watched a million times')

INSERt INTO Movies (Title, DirectorId, CopyrightYear, Length, GenreId, CategoryId, Rating, Notes)
VALUES 
('Forrest Gump', 3, 1997, 180, 3, 5, 10, 'perfect'),
('Interstellar', 4, 2014, 186, 2, 5, 10, 'great movie'),
('Kill bill', 2, 2001, 179, 1, 2, 9, 'blood everywhere'),
('The godfather', 1, 1974, 189, 3, 5, 10, 'the best'),
('Star wars', 5, 1976, 201, 2, 2, 8, 'let the force be with you')