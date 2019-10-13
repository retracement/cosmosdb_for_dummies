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

/************************************************/
/* Create Database ConsistencyConcernsAreInAllDBs */
/************************************************/
USE master
GO
IF EXISTS(SELECT 1 FROM sys.databases WHERE name = 'ConsistencyConcernsAreInAllDBs')
BEGIN
	ALTER DATABASE [ConsistencyConcernsAreInAllDBs] 
		SET READ_ONLY WITH ROLLBACK IMMEDIATE;
		DROP DATABASE [ConsistencyConcernsAreInAllDBs];
END

IF EXISTS(SELECT 1 FROM sys.databases WHERE name = 'ConsistencyConcernsAreInAllDBs')
BEGIN
	PRINT 'Warning ConsistencyConcernsAreInAllDBs database still exists'
END
CREATE DATABASE [ConsistencyConcernsAreInAllDBs]


/*********************/
/* Create Table Cars */
/*********************/
USE [ConsistencyConcernsAreInAllDBs]
GO
CREATE TABLE Cars (id uniqueidentifier DEFAULT NEWID(), carname VARCHAR(20), lastservice datetime DEFAULT getdate(), SpeedMPH INT, Details CHAR (7000) CONSTRAINT [PK__Cars] PRIMARY KEY CLUSTERED ([id]))
GO
/*****************************/
/* Create Table GunInventory */
/*****************************/
USE [ConsistencyConcernsAreInAllDBs]
GO
CREATE TABLE GunInventory (id int primary key, Quantity int)
GO
INSERT INTO GunInventory VALUES (1, 1000)