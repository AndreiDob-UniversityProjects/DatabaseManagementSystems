CREATE DATABASE Food
GO
CREATE TABLE Restaurants(
	R_id INT PRIMARY KEY IDENTITY,
	CIF INT UNIQUE,
	Ranking INT,
	Name VARCHAR(50))
CREATE  TABLE Passengers(
	CNP INT PRIMARY KEY IDENTITY,
	Name varchar(50))
CREATE TABLE Orders(
	O_id INT PRIMARY KEY IDENTITY,
	Rest_id INT FOREIGN KEY REFERENCES Restaurants(R_id),
	PassId INT FOREIGN KEY REFERENCES Passengers(CNP),
	Date DATETIME,
	Price INT )
--CI SCAN
SELECT * 
FROM Restaurants

--CI SEEK
SELECT * 
FROM Restaurants R
WHERE R.R_id=1

--NCI SCAN
SELECT R.CIF 
FROM Restaurants R

--NCI SEEK
SELECT R.CIF
FROM Restaurants R
WHERE R.CIF=222

--KEY LOOKUP
SELECT *
FROM Restaurants R
WHERE R.CIF=222


SELECT P.CNP
FROM Passengers P
WHERE P.PName ='Ana'

IF EXISTS (SELECT name FROM sys.indexes WHERE name = N'N_idx_Passengers_Name')
 DROP INDEX N_idx_Passengers_Name ON Passengers;
GO
CREATE NONCLUSTERED INDEX N_idx_Passengers_Name ON Passengers(PName);
GO

CREATE VIEW V1 AS(
	SELECT DISTINCT P.PName,R.Name 
	FROM Passengers P INNER JOIN Orders O ON P.CNP=O.PassId INNER JOIN Restaurants R ON R.R_id=O.Rest_id
	
)
GO
SELECT * FROM V1
GO
