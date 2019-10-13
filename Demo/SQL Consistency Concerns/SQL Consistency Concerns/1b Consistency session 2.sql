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

-- Run a while loop to insert all visible records to a temp table and BREAK
-- if record count is not equal to 10.
-- Excecute this several times until you are happy
USE [ConsistencyConcernsAreInAllDBs]
GO
IF @@TRANCOUNT <> 0 ROLLBACK
SET NOCOUNT ON
DECLARE @Cars TABLE (id uniqueidentifier DEFAULT NEWID(), carname VARCHAR(20), 
	lastservice datetime DEFAULT getdate(), SpeedMPH INT, Details CHAR (7000));
DECLARE @ConsistentResults INT = 0
WHILE 1=1
BEGIN
	DELETE FROM @Cars
	INSERT INTO @Cars SELECT * FROM Cars --with (holdlock) --with (serializable)
	IF @@ROWCOUNT <> 10
		BREAK

	SET @ConsistentResults = @ConsistentResults + 1
	WAITFOR DELAY '00:00:00.013'
END
SELECT @ConsistentResults AS SuccessfulPriorRuns
SELECT * FROM @Cars
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


-- Repeating under SERIALIZABLE fixes problem but results in deadlocks

-- Repeating under SNAPSHOT fixes the problem

-- Note the biggest trigger for this problem is the table Cluster GUID
-- and the way SQL accesses mixed extents
-- See https://www.sqlskills.com/blogs/paul/read-committed-doesnt-guarantee-much/



-- Switch back to session 1
-- and stop the while loop



--------------------------------------------------------
-- In this example we will look at atomicity concerns --
--------------------------------------------------------
-- and attempt to solve them
SET NOCOUNT OFF
USE [2Fast2Furious]
GO
IF @@TRANCOUNT <> 0 ROLLBACK


-- Set a lock timeout to avoid any waiting on lock
SET LOCK_TIMEOUT 10


-- Run a transaction to insert a new record
-- and DELETE any records with an ID of 1
BEGIN TRAN
    INSERT INTO t1 VALUES ('2');
    DELETE FROM t1 WHERE c1 = 1;
COMMIT


-- Check transaction has rolled back (or committed...)
SELECT @@TRANCOUNT AS Trancount


-- Query table jumping over other
-- session locked records (if any)
SELECT * FROM t1 WITH (READPAST);


-- Switch back to session 1