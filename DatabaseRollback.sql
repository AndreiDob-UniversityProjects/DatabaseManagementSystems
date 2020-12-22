USE Airport_Management
go;
--------------------------------------------------------------------------------------------------------------------
--Cerinta 1

INSERT INTO Employees(E_id,Name) VALUES(5,'AAA');
go

CREATE OR ALTER PROCEDURE SimpleInsertRollbackSucces 
AS
	BEGIN TRY  
		BEGIN TRAN
		   INSERT INTO Flights(F_id, Plane_id,Origin,Destination) VALUES (1,  1,'ORIGIN_1','DESTINATION_1');
		   PRINT 'Inserted Flight1'	;
		   INSERT INTO Flights(F_id, Plane_id,Origin,Destination) VALUES (2,  1,'ORIGIN_2','DESTINATION_2');
		   PRINT 'Inserted Flight1'	;
		   INSERT INTO Employees(E_id,Name) VALUES (1, 'OLIVER');
		   PRINT 'Inserted Employee'	;
		   INSERT INTO Working_schedule(Employee_id,Flight_id) VALUES (1, 1);
		   PRINT 'Inserted Schedule1'	;
		   PRINT 'Trying to insert Schedule 2'	;
		   INSERT INTO Working_schedule(Employee_id,Flight_id) VALUES (1, 2);
		COMMIT TRAN
	END TRY  
	BEGIN CATCH  
		PRINT 'ERROR: ROLLING BACK'
		ROLLBACK TRANSACTION
	END CATCH  

GO;

CREATE OR ALTER PROCEDURE SimpleInsertRollbackFailure 
AS
	BEGIN TRY  
		BEGIN TRAN
		   INSERT INTO Flights(F_id, Plane_id,Origin,Destination) VALUES (1,  1,'ORIGIN_1','DESTINATION_1');
		   PRINT 'Inserted Flight1'	;
		   INSERT INTO Flights(F_id, Plane_id,Origin,Destination) VALUES (2,  1,'ORIGIN_2','DESTINATION_2');
		   PRINT 'Inserted Flight1'	;
		   INSERT INTO Employees(E_id,Name) VALUES (1, 'OLIVER');
		   PRINT 'Inserted Employee'	;
		   INSERT INTO Working_schedule(Employee_id,Flight_id) VALUES (1, 1);
		   PRINT 'Inserted Schedule1'	;
		   PRINT 'Trying to insert Schedule 2'	;
		   INSERT INTO Working_schedule(Employee_id,Flight_id) VALUES (1, 20);
		COMMIT TRAN
	END TRY  
	BEGIN CATCH 
		PRINT 'ERROR: ROLLING BACK' 
		ROLLBACK TRANSACTION
	END CATCH  

	
GO;

EXEC SimpleInsertRollbackSucces;
EXEC SimpleInsertRollbackFailure;

SELECT * FROM Employees;
SELECT * FROM Working_schedule;
SELECT * FROM Flights;

DELETE FROM Working_schedule;
DELETE FROM Flights;
DELETE FROM Employees;

-------------------------------------------------------------------------------------------------------------------
--Cerinta 2:
go;

CREATE OR ALTER PROCEDURE ComplexRollbackInsertSuccess
AS
	BEGIN TRY  
		BEGIN TRAN
			DECLARE @fid1 INT;
			DECLARE @fid2 INT;
			DECLARE @eid INT;
			DECLARE @sid1 INT;
			DECLARE @sid2 INT;
		   INSERT INTO Flights(F_id, Plane_id,Origin,Destination) VALUES (1,  1,'ORIGIN_1','DESTINATION_1');
		   SET @fid1 = @@ROWCOUNT;
		   SAVE TRANSACTION SP1;
		   PRINT 'Inserted Flight1'	;

		   INSERT INTO Flights(F_id, Plane_id,Origin,Destination) VALUES (2,  1,'ORIGIN_2','DESTINATION_2');
		   SET @fid2 = @@ROWCOUNT;
		   SAVE TRANSACTION SP2;
		   PRINT 'Inserted Flight1'	;

		   INSERT INTO Employees(E_id,Name) VALUES (1, 'OLIVER');
		   SET @eid = @@ROWCOUNT;
		   SAVE TRANSACTION SP3;
		   PRINT 'Inserted Employee'	;

		   INSERT INTO Working_schedule(Employee_id,Flight_id) VALUES (1, 1);
		   SET @sid1 = @@ROWCOUNT;
		   SAVE TRANSACTION SP4;
		   PRINT 'Inserted Schedule1'	;
		   PRINT 'Trying to insert Schedule 2'	;
		   INSERT INTO Working_schedule(Employee_id,Flight_id) VALUES (1, 2);
		   SET @sid2 = @@ROWCOUNT;
		COMMIT TRAN
	END TRY  
	BEGIN CATCH  

		IF @fid1=0
		BEGIN
			PRINT 'ERROR: ROLLING BACK TOTALLY'
			ROLLBACK TRANSACTION
		END
		IF @fid2=0
		BEGIN
			PRINT 'ERROR: ROLLING BACK TO SP1'
			ROLLBACK TRANSACTION SP1;
		END
		IF @eid=0
		BEGIN
			PRINT 'ERROR: ROLLING BACK TO SP2'
			ROLLBACK TRANSACTION SP2;
		END
		IF @sid1=0
		BEGIN
			PRINT 'ERROR: ROLLING BACK TO SP3'
			ROLLBACK TRANSACTION SP3;
		END
		IF @sid2=0
		BEGIN
			PRINT 'ERROR: ROLLING BACK TO SP4'
			ROLLBACK TRANSACTION SP4;
		END
		COMMIT TRAN
	END CATCH  

	GO;
CREATE OR ALTER PROCEDURE ComplexRollbackInsertFailure
AS
	BEGIN TRY  
		BEGIN TRAN
			DECLARE @fid1 INT;
			DECLARE @fid2 INT;
			DECLARE @eid INT;
			DECLARE @sid1 INT;
			DECLARE @sid2 INT;
		   INSERT INTO Flights(F_id, Plane_id,Origin,Destination) VALUES (1,  1,'ORIGIN_1','DESTINATION_1');
		   SET @fid1 = @@ROWCOUNT;
		   SAVE TRANSACTION SP1;
		   PRINT 'Inserted Flight1'	;

		   INSERT INTO Flights(F_id, Plane_id,Origin,Destination) VALUES (2,  1,'ORIGIN_2','DESTINATION_2');
		   SET @fid2 = @@ROWCOUNT;
		   SAVE TRANSACTION SP2;
		   PRINT 'Inserted Flight1'	;

		   INSERT INTO Employees(E_id,Name) VALUES (NULL, 'OLIVER');
		   SET @eid = @@ROWCOUNT;
		   SAVE TRANSACTION SP3;
		   PRINT 'Inserted Employee'	;

		   INSERT INTO Working_schedule(Employee_id,Flight_id) VALUES (1, 1);
		   SET @sid1 = @@ROWCOUNT;
		   SAVE TRANSACTION SP4;
		   PRINT 'Inserted Schedule1'	;
		   PRINT 'Trying to insert Schedule 2'	;
		   INSERT INTO Working_schedule(Employee_id,Flight_id) VALUES (1, 2);
		   SET @sid2 = @@ROWCOUNT;
		COMMIT TRAN
	END TRY  
	BEGIN CATCH  

		IF @fid1=0
		BEGIN
			PRINT 'ERROR: ROLLING BACK TOTALLY'
			ROLLBACK TRANSACTION
		END
		IF @fid2=0
		BEGIN
			PRINT 'ERROR: ROLLING BACK TO SP1'
			ROLLBACK TRANSACTION SP1;
		END
		IF @eid=0
		BEGIN
			PRINT 'ERROR: ROLLING BACK TO SP2'
			ROLLBACK TRANSACTION SP2;
		END
		IF @sid1=0
		BEGIN
			PRINT 'ERROR: ROLLING BACK TO SP3'
			ROLLBACK TRANSACTION SP3;
		END
		IF @sid2=0
		BEGIN
			PRINT 'ERROR: ROLLING BACK TO SP4'
			ROLLBACK TRANSACTION SP4;
		END
		COMMIT TRAN
	END CATCH  
GO;

EXEC ComplexRollbackInsertSuccess;
EXEC ComplexRollbackInsertFailure;

SELECT * FROM Employees;
SELECT * FROM Working_schedule;
SELECT * FROM Flights;

DELETE FROM Working_schedule;
DELETE FROM Flights;
DELETE FROM Employees;

------------------------------------------------------------------------------------------------------------------------
--Cerinta 3:
--DIRTY READ

--Transaction 1

	BEGIN Tran
	UPDATE Planes set Model = 'BBBB' WHERE P_id = 1
 
	--costly operation
	WaitFor Delay '00:00:10'

	Rollback Transaction

--Transaction 2
UPDATE Planes set Model = 'DIRTY_READ' WHERE P_id = 1