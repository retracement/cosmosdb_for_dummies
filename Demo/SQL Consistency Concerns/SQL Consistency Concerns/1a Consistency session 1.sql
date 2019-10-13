/************************************************************
* All scripts contained within are Copyright © 2015 of      *
* Mark Broadbent, whether they are derived or actual        *
* works by him or his representatives                       *
*************************************************************
* They are distributed under the Apache 2.0 licence and any *
* reproducion, transmittion, storage, or derivation must    *
* comply with the terms under the licence linked below.     *
* If in any doubt, contact the license owner for written    *
* permission by emailing contactme@sturmovik.net            *
*************************************************************
Copyright [2019] [Mark Broadbent]

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.*/

--------------------------------------------------------
-- In this example we will look at inconsistent reads --
--------------------------------------------------------
-- Execute a transaction to delete all records and insert with 10 records.
-- Since this modification is transactional we would expect other sessions
-- to always return 10 records or be blocked.
SET NOCOUNT ON
USE [ConsistencyConcernsAreInAllDBs]
GO
IF @@TRANCOUNT <> 0 ROLLBACK
TRUNCATE TABLE Cars

WHILE 1=1
BEGIN 
	BEGIN TRAN
		DELETE FROM Cars

		INSERT INTO Cars(Carname, SpeedMPH, Details) VALUES('Ferrari', 170, '')
		INSERT INTO Cars(Carname, SpeedMPH, Details) VALUES('Porsche', 150, '')
		INSERT INTO Cars(Carname, SpeedMPH, Details) VALUES('Lamborghini', 175, '')
		INSERT INTO Cars(Carname, SpeedMPH, Details) VALUES('Mini', 110, '')	
		WAITFOR DELAY '00:00:00.02'
		INSERT INTO Cars(Carname, SpeedMPH, Details) VALUES('Datsun', 90, '')
		INSERT INTO Cars(Carname, SpeedMPH, Details) VALUES('Ford', 125, '')
		INSERT INTO Cars(Carname, SpeedMPH, Details) VALUES('Audi', 138, '')
		INSERT INTO Cars(Carname, SpeedMPH, Details) VALUES('BMW', 120, '')
		INSERT INTO Cars(Carname, SpeedMPH, Details) VALUES('Honda', 87, '')
		INSERT INTO Cars(Carname, SpeedMPH, Details) VALUES('Mercedes', 155, '')   
	COMMIT TRAN
END


-- Switch to session 2


-- Stop the running while loop



----------------------------------------------------------
-- In this example we will look at lost update concerns --
----------------------------------------------------------
-- This is a common (and usually incorrectly managed)
-- database development pattern

-- Rollback any open transactions
SET NOCOUNT OFF
USE [ConsistencyConcernsAreInAllDBs]
GO
IF @@TRANCOUNT <> 0 ROLLBACK



-- Take a peek into the GunInventory table
SELECT * from GunInventory





-- Run in SQLQueryStress
-- 100 iterations, 10 threads = 1000 decrements
DECLARE @basketcount INT = 1
DECLARE @id INT = 1
DECLARE @newquantity INT
BEGIN TRANSACTION
	--assign current quantity value of gun type 1
	SELECT @newquantity = quantity FROM GunInventory WHERE id = @id
	--decrement sales quantity
	SET @newquantity = @newquantity - @basketcount
	--update value of new quantity
	UPDATE GunInventory SET quantity = @newquantity WHERE id = @id
COMMIT


-- What is the final quantity?
SELECT * from GunInventory