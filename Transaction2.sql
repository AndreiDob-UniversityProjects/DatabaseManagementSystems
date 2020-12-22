USE Airport_Management
go

--Dirty read
--Transaction 2
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
PRINT 'This is the dirty read. This select should return WW2B for model here:'
SELECT * FROM Planes WHERE P_id=1

-----------------------------------------------------------------------------
--Unrepeatable read
--Transaction 2
UPDATE Planes set Model = 'UNREPEATABLE_READ' WHERE P_id = 1

UPDATE Planes set Model = 'ww2b' WHERE P_id = 1
--------------------------------------------------------------------------------
--Phantom
--Transaction 2
INSERT INTO Planes (P_id, Model,Capacity,Fuel_consumption) VALUES (15,'PHANTOM',999,999)   ;
INSERT INTO Planes (P_id, Model,Capacity,Fuel_consumption) VALUES (16,'PHANTOM',999,999)   ;
INSERT INTO Planes (P_id, Model,Capacity,Fuel_consumption) VALUES (17,'PHANTOM',999,999)   ;
INSERT INTO Planes (P_id, Model,Capacity,Fuel_consumption) VALUES (18,'PHANTOM',999,999)   ;

-----------------------------------------------------------------------------------
DELETE FROM Planes WHERE P_id>10
--------------------------------------------------------------------------------
--Deadlock
--Transaction 2
--To fix, don not set REPEATABLE READ. Or do not make deadlocking transactions :))
go
CREATE OR ALTER PROCEDURE DeadlockTransaction2
AS
	SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
	BEGIN Tran
	SELECT * FROM Planes WHERE P_id=1

	UPDATE Planes set Model = 'DEADLOCK' WHERE P_id = 1
	PRINT 'This was the victim'
	Rollback Transaction
go
--------------------------------------------------------------------------------
