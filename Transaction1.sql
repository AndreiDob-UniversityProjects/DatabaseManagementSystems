USE Airport_Management
go
--Cerinta 3:
--DIRTY READ
--Transaction 1

BEGIN Tran
 
	UPDATE Planes set Model = 'BBBB' WHERE P_id = 1
 
	--costly operation
	WaitFor Delay '00:00:10'

	Rollback Transaction

---------------------------------------------------------------------------------------------------------------
--Unrepeatable read
--Transaction 1
--To fix:
--SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN Tran
	SELECT * FROM Planes WHERE P_id=1
	--costly operation
	WaitFor Delay '00:00:10'

	SELECT * FROM Planes WHERE P_id=1

COMMIT TRANSACTION

---------------------------------------------------------------------------------------------------------------
--Phantom
--Transaction 1
--To fix:
--SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
BEGIN Tran
	SELECT * FROM Planes WHERE P_id>8
	--costly operation
	WaitFor Delay '00:00:10'

	SELECT * FROM Planes WHERE P_id>8

COMMIT TRANSACTION
---------------------------------------------------------------------------------------------------------------
--Deadlock
--Transaction 1
--To fix, don not set REPEATABLE READ. Or do not make deadlocking transactions :))
go;
CREATE OR ALTER PROCEDURE DeadlockTransaction1
AS
	SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
	BEGIN Tran
	SELECT * FROM Planes WHERE P_id=1
	--costly operation
	WaitFor Delay '00:00:05'

	UPDATE Planes set Model = 'DEADLOCK' WHERE P_id = 1
	PRINT 'This succeeded. The other one was the victim'
	Rollback Transaction
go;