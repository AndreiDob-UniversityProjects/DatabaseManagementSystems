USE Airport_Management
GO
/*
CREATE PROCEDURE D1
AS
	BEGIN
		ALTER TABLE Repairs
		ALTER COLUMN Cost FLOAT
		PRINT 'Made Cost to float'
	END
GO
CREATE PROCEDURE U1
AS
	BEGIN
		ALTER TABLE Repairs
		ALTER COLUMN Cost INT
		PRINT 'Made Cost to int'
	END
GO

CREATE PROCEDURE D2
AS
	BEGIN 
		ALTER TABLE Repairs
		ADD RepairTime DATE
		PRINT 'Added RepairTime'
	END
GO
CREATE PROCEDURE U2
AS
	BEGIN 
		ALTER TABLE Repairs
		DROP COLUMN RepairTime 
		PRINT 'Removed RepairTime'
	END
GO

CREATE PROCEDURE D3
AS
	BEGIN 
		ALTER TABLE Repairs
		ADD CONSTRAINT df_100 DEFAULT 100
		FOR Cost
		
		PRINT 'Added Constraint'
	END
GO

CREATE PROCEDURE U3
AS
	BEGIN 
		ALTER TABLE Repairs
		DROP CONSTRAINT df_100
		PRINT 'Deleted Constraint'
	END
GO

CREATE PROCEDURE D4
AS
	BEGIN 
		ALTER TABLE Parts
		ADD CONSTRAINT pk_Parts PRIMARY KEY(Part_id)
		PRINT 'Added Constraint PK'
	END
GO
CREATE PROCEDURE U4
AS
	BEGIN 
		ALTER TABLE Parts
		DROP CONSTRAINT pk_Parts
		PRINT 'Removed Constraint PK'
	END
GO

CREATE PROCEDURE D5
AS
	BEGIN 
		ALTER TABLE Parts
		ADD CONSTRAINT uk_Parts UNIQUE(Part_no)
		PRINT 'Added Constraint UK'
	END
GO
CREATE PROCEDURE U5
AS
	BEGIN 
		ALTER TABLE Parts
		DROP CONSTRAINT uk_Parts
		PRINT 'Deleted Constraint UK'
	END
GO

CREATE PROCEDURE D6
AS
	BEGIN 
		ALTER TABLE Parts
		ADD CONSTRAINT fk_Parts_Repairs FOREIGN KEY(Repair_id) REFERENCES Repairs(Repair_id)
		PRINT 'Added Constraint FK'
	END
GO
CREATE PROCEDURE U6
AS
	BEGIN 
		ALTER TABLE Parts
		DROP CONSTRAINT fk_Parts_Repairs
		PRINT 'Deleted Constraint FK'
	END
GO

CREATE PROCEDURE D7
AS
	BEGIN 
		CREATE TABLE Manufacturer(
			M_id INT IDENTITY,
			Name VARCHAR(50),
			Capital INT)
		PRINT 'Added Table'
	END
GO
CREATE PROCEDURE U7
AS
	BEGIN 
		DROP TABLE Manufacturer
		PRINT 'Removed Table'
	END
GO

CREATE PROCEDURE ChangeVersion @vers INT
AS
	BEGIN
		IF @vers<0 OR @vers>7
			PRINT 'Invalid version'
		ELSE
		BEGIN
		DECLARE @current int =(SELECT V.Version	FROM Versions V where V.State='current')
		PRINT @current
		WHILE @current<@vers
			BEGIN
				SET @current=@current+1
				DECLARE @procD varchar(50)='D'+CONVERT(varchar(5), @current)
				UPDATE Versions  SET Version=@current 
				WHERE State='current'
				EXECUTE @procD
			END
		WHILE @current>@vers
			BEGIN
				DECLARE @procU varchar(50)='U'+CONVERT(varchar(5), @current)
				EXECUTE @procU
				SET @current=@current-1
				UPDATE Versions  SET Version=@current 
				WHERE State='current'
			END
			END
	END
GO
*/
EXEC ChangeVersion 0
--DROP PROCEDURE ChangeVersion
--GO







		
		