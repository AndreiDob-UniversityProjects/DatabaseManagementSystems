CREATE VIEW V1_Planes AS(
SELECT * FROM Planes )
GO
CREATE VIEW V2_PlanesFlights AS(
SELECT P.P_id,P.Model,F.F_id,F.Origin,F.Destination 
FROM Planes P, Flights F
WHERE P.P_id=F.Plane_id
 )
GO
--AVERAGE DURATION OF FLIGHTS CARRIED BY EACH MODEL
 CREATE VIEW V3_GB_PlanesFlights AS(
SELECT P.Model, AVG(F.Duration) AS Mean
FROM Planes P, Flights F
WHERE P.P_id=F.Plane_id
GROUP BY P.Model
 )
GO
SELECT * FROM V3_GB_PlanesFlights

go
CREATE PROCEDURE insertPlanes @nr INT
AS
	BEGIN
				DECLARE @n int
				DECLARE @t VARCHAR(30)
				SET @n=1 -- first we have no row inserted
				WHILE @n<@nr
				BEGIN
					SET @t = 'INSERTED ROW' + CONVERT (VARCHAR(5), @n)
					INSERT INTO Planes(P_id,Model,Fuel_consumption) VALUES ( @n,@t,@n)
					SET @n=@n+1	
				END
	END
go
CREATE PROCEDURE insertFlights @nr INT
AS
	BEGIN
				DECLARE @n int
				DECLARE @t VARCHAR(30)
				declare @pid int
				SET @n=1 -- first we have no row inserted
				WHILE @n<@nr
				BEGIN
					SET @t = 'ORIGIN' + CONVERT (VARCHAR(5), @n)
					select top 1 @pid=p.P_id	from Planes p
					INSERT INTO Flights(F_id,Plane_id,Origin) VALUES (@n,@pid, @t)
					SET @n=@n+1	
				END
	END
go
CREATE PROCEDURE insertSchedule @nr INT
AS
	BEGIN
				DECLARE @n int
				SET @n=1 -- first we have no row inserted
				WHILE @n<@nr
				BEGIN
					declare @fid int
					select top 1 @fid=F.F_id from Flights F
					INSERT INTO Working_schedule(Employee_id,Flight_id) VALUES (@n, @n)
					SET @n=@n+1	
				END
	END
go
CREATE PROCEDURE insertEmployee @nr INT
AS
	BEGIN
				DECLARE @n int
				DECLARE @t VARCHAR(30)
				SET @n=1 -- first we have no row inserted
				WHILE @n<@nr
				BEGIN
					SET @t = 'Employee' + CONVERT (VARCHAR(5), @n)
					INSERT INTO Employees(E_id,Name) VALUES (@n, @t)
					SET @n=@n+1	
				END
	END
go

EXEC testTable 3, 100

EXEC testDatabase

SELECT * FROM Planes

SELECT * FROM TestRuns
SELECT * FROM TestRunTables
SELECT * FROM TestRunViews

DELETE FROM TestRunTables
DELETE FROM TestRuns
delete from TestRunViews

DELETE FROM Working_schedule
DELETE FROM Flights
DELETE FROM Employees
DELETE FROM Planes
GO
CREATE PROCEDURE testTable (@table_id int, @nr INT)
AS
	BEGIN 
		DECLARE @dts DATETIME
		DECLARE @dte DATETIME

		IF @table_id>(SELECT COUNT(*) FROM Tables)
			RETURN
		IF @table_id=1
			BEGIN				--INSERT THINGS INTO PLANES ONCE AGAIN
				EXEC insertPlanes @nr
				--get start date
				SET @dts = GETDATE()
				--make the delete+insert
				DELETE FROM Planes
				EXEC insertPlanes @nr
				--take end date
				SET @dte = GETDATE()
			END
		
		IF @table_id=2
			BEGIN
				EXEC insertFlights @nr
				SET @dts = GETDATE()
				--make the delete+insert
				DELETE FROM Flights
				EXEC insertFlights @nr
				--take end date
				SET @dte = GETDATE()
			END
		IF @table_id=3
			BEGIN
				EXEC insertSchedule @nr
				SET @dts = GETDATE()
				--make the delete+insert
				DELETE FROM Working_schedule
				EXEC insertSchedule @nr
				--take end date
				SET @dte = GETDATE()
			END
		IF @table_id=4
			BEGIN
				EXEC insertEmployee @nr
				SET @dts = GETDATE()
				--make the delete+insert
				DELETE FROM Employees
				EXEC insertEmployee @nr
				--take end date
				SET @dte = GETDATE()
			END
		DECLARE @v1s DATETIME
		DECLARE @v1e DATETIME
		DECLARE @v2s DATETIME
		DECLARE @v2e DATETIME
		DECLARE @v3s DATETIME
		DECLARE @v3e DATETIME

		SET @v1s = GETDATE()
		SELECT* FROM V1_Planes
		SET @v1e = GETDATE()

		SET @v2s = GETDATE()
		SELECT* FROM V2_PlanesFlights
		SET @v2e = GETDATE()

		SET @v3s = GETDATE()
		SELECT* FROM V3_GB_PlanesFlights
		SET @v3e = GETDATE()

		DECLARE @t VARCHAR(50) = 'DELETE+INSERT ON Table' + CONVERT (VARCHAR(5), @table_id)
		INSERT INTO TestRuns(Description,StartAt,EndAt) VALUES (@t,@dts,@v3e)
		DECLARE @tr_id INT
		SELECT TOP 1 @tr_id=t.TestRunID FROM TestRuns T WHERE T.StartAt=@dts
		INSERT INTO TestRunTables(TestRunID,TableID,StartAt,EndAt) VALUES(@tr_id,@table_id,@dts,@dte)
		
		INSERT INTO TestRunViews(TestRunID,ViewID,StartAt,EndAt) VALUES(@tr_id,1,@v1s,@v1e)
		INSERT INTO TestRunViews(TestRunID,ViewID,StartAt,EndAt) VALUES(@tr_id,2,@v2s,@v2e)
		INSERT INTO TestRunViews(TestRunID,ViewID,StartAt,EndAt) VALUES(@tr_id,3,@v3s,@v3e)
		
	END
GO

CREATE PROCEDURE testDatabase 
AS
	BEGIN 
		/*DECLARE @totest INT 
		DECLARE @crpos int = 0

		SELECT TOP 1 @totest=T.TableID, @crpos=T.Position
		FROM TestTables T
		WHERE @crpos<T.Position
		GROUP BY T.TableID,T.Position
		ORDER BY T.Position

		print @totest  
		PRINT @crpos

		WHILE @totest IS NOT NULL
			BEGIN
				print @totest

				SELECT TOP 1   @totest=T.TableID, @crpos=T.Position
				FROM TestTables T
				WHERE @crpos<T.Position
				GROUP BY T.TableID,T.Position
				ORDER BY T.Position
			END
		*/
		declare @maxpos int =(SELECT MAX(T.Position) FROM TestTables T)
		DECLARE @crpos int = 1
		DECLARE @totest INT 
		DECLARE @rows INT

		DELETE FROM Working_schedule
		DELETE FROM Flights
		DELETE FROM Employees
		DELETE FROM Planes

		WHILE @crpos<=@maxpos
			BEGIN
				SELECT TOP 1 @totest=T.TableID,@rows=T.NoOfRows
				FROM TestTables T
				WHERE T.Position=@crpos

				EXEC testTable @totest, @rows
				SET @crpos = @crpos+1
				
			END

	END
GO


