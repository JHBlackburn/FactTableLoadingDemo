

/*******************************************SQL SATURDAY DEMO**********************************/
/******************************************* 05.04.2019****************************************/


--1
/*****************************************NO INDEX, NO FK**************************************/

--SETUP EXPERIMENT HERE:
EXEC dbo.FactAccountBillingType_DropAllConstraintAndIndex

ALTER DATABASE FactTableLoading  
SET RECOVERY SIMPLE;  
GO  
-- Shrink the log file to 1 MB.  
DBCC SHRINKFILE (FactTableLoading_log, 1);  
GO  
-- Shrink the Data file to 1 MB.  
DBCC SHRINKFILE (FactTableLoading, 1);  
GO  

ALTER DATABASE FactTableLoading  
SET RECOVERY FULL;  
GO 

--------------------------------------------------------------------------------------------------
--Testing Code, Change Comments for Documentation
DECLARE @runIdTable TABLE(RunId INT);
DECLARE @RowCountTableData 
		TABLE(
			 RunId INT
			, RunTitle VARCHAR(200)
			, TableName VARCHAR(200)
			, DateTime DATETIME
			, TimeInMinutes Decimal(18,6)
			, Count_Rows INT
			, [Velocity Rows/Min] INT
			);
INSERT INTO @runIdTable(RunId) 
EXEC Metric.uspInsertNewRun 
						'Heap Table, On Disk, One File Not-PreGrown, SSIS' 
						, 'No Primary Key, No Foreign Keys, No Indexes, One File, File NOT PreGrown to expected size, Increment = 64 MB, Log Not Pregrown, Increment = 64MB, Polling Rate = 1 s + CountTime, MaxPollingTime = 60s. Computer = Lenovo LocalHost'
DECLARE @runId INT = (SELECT TOP 1 RunId FROm @runIdTable ORDER BY RunId DESC)

EXEC Metric.uspPollRowCount_FactAccountBillingType
					@runId
					, 1 --Period of Polling in sec	
					, 60 --Duration of Polling in sec

/* RESULTS*/
SELECT RunTitle
		, RunNotes

	FROM Metric.Run R
	WHERE R.RunId = @runId

EXEC Metric.uspGetAverageRowVelocityByRunId @runId
EXEC Metric.uspGetTableRowCountDataByRunId @runId


--2
/*****************************************NO INDEX, NO FK**************************************/

--SETUP EXPERIMENT HERE:
--------------------------------------------------------------------------------------------------

EXEC dbo.FactAccountBillingType_DropAllConstraintAndIndex

ALTER DATABASE FactTableLoading
MODIFY FILE
(NAME = FactTableLoading,
SIZE = 10500MB); --Determined experimentally
GO


ALTER DATABASE FactTableLoading
MODIFY FILE
(NAME = FactTableLoading_log,
SIZE = 1000MB); --More than enough
GO
--------------------------------------------------------------------------------------------------
--Testing Code, Change Comments for Documentation
DECLARE @runIdTable TABLE(RunId INT);
DECLARE @RowCountTableData 
		TABLE(
			 RunId INT
			, RunTitle VARCHAR(200)
			, TableName VARCHAR(200)
			, DateTime DATETIME
			, TimeInMinutes Decimal(18,6)
			, Count_Rows INT
			, [Velocity Rows/Min] INT
			);
INSERT INTO @runIdTable(RunId) 
EXEC Metric.uspInsertNewRun 
						'Heap Table, On Disk, One File PreGrown, SSIS' 
						, 'No Primary Key, No Foreign Keys, No Indexes, One File, File WERE PreGrown to expected size (10.5 GB), Increment = 64 MB, Log Not Pregrown, Increment = 64MB, Polling Rate = 1 s + CountTime, MaxPollingTime = 60s. Computer = Lenovo LocalHost'
DECLARE @runId INT = (SELECT TOP 1 RunId FROm @runIdTable ORDER BY RunId DESC)

EXEC Metric.uspPollRowCount_FactAccountBillingType
					@runId
					, 1 --Period of Polling in sec	
					, 60 --Duration of Polling in sec

/* RESULTS*/
SELECT RunTitle
		, RunNotes

	FROM Metric.Run R
	WHERE R.RunId = @runId

EXEC Metric.uspGetAverageRowVelocityByRunId @runId
EXEC Metric.uspGetTableRowCountDataByRunId @runId


--3
/*****************************************WITH PK_RowStore, WITH No FK*******************************/

--SETUP EXPERIMENT HERE:
--------------------------------------------------------------------------------------------------
EXEC dbo.FactAccountBillingType_DropAllConstraintAndIndex


ALTER TABLE dbo.FactAccountBillingType
ADD CONSTRAINT PC_FactAccountBillingType_ThreeColumn 
PRIMARY KEY CLUSTERED (AccountId, BillingTypeId, DateID) 
GO

--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--Testing Code, Change Comments for Documentation
DECLARE @runIdTable TABLE(RunId INT);
DECLARE @RowCountTableData 
		TABLE(
			 RunId INT
			, RunTitle VARCHAR(200)
			, TableName VARCHAR(200)
			, DateTime DATETIME
			, TimeInMinutes Decimal(18,6)
			, Count_Rows INT
			, [Velocity Rows/Min] INT
			);
INSERT INTO @runIdTable(RunId) 
EXEC Metric.uspInsertNewRun 
						'Three Col PK, no FK, On Disk, One File PreGrown, SSIS' 
						, 'Primary Key on three columns (AccountId, BillingTypeId, DateId), No FKs, One File, File WERE PreGrown to expected size (10.5 GB), Increment = 64 MB, Log Not Pregrown, Increment = 64MB, Polling Rate = 1 s + CountTime, MaxPollingTime = 60s. Computer = Lenovo LocalHost'
DECLARE @runId INT = (SELECT TOP 1 RunId FROm @runIdTable ORDER BY RunId DESC)

EXEC Metric.uspPollRowCount_FactAccountBillingType
					@runId
					, 1 --Period of Polling in sec	
					, 60 --Duration of Polling in sec

/* RESULTS*/
SELECT RunTitle
		, RunNotes

	FROM Metric.Run R
	WHERE R.RunId = @runId

EXEC Metric.uspGetAverageRowVelocityByRunId @runId
EXEC Metric.uspGetTableRowCountDataByRunId @runId




--4a
/*****************************************PK, Clustered INDEX, WITH One FK*********************/

--SETUP EXPERIMENT HERE:
EXEC dbo.FactAccountBillingType_DropAllConstraintAndIndex

ALTER TABLE dbo.FactAccountBillingType
ADD CONSTRAINT PC_FactAccountBillingType_ThreeColumn 
PRIMARY KEY CLUSTERED (AccountId, BillingTypeId, DateID) 
GO

ALTER TABLE dbo.FactAccountBillingType
ADD CONSTRAINT FK_FactAccountBillingType_DateId_DimDate_DateID 
FOREIGN KEY  (DateID)  REFERENCES dbo.DimDate(DateId) 
GO

--------------------------------------------------------------------------------------------------
--Testing Code, Change Comments for Documentation
DECLARE @runIdTable TABLE(RunId INT);
DECLARE @RowCountTableData 
		TABLE(
			 RunId INT
			, RunTitle VARCHAR(200)
			, TableName VARCHAR(200)
			, DateTime DATETIME
			, TimeInMinutes Decimal(18,6)
			, Count_Rows INT
			, [Velocity Rows/Min] INT
			);
INSERT INTO @runIdTable(RunId) 
EXEC Metric.uspInsertNewRun 
						'PK, Clustered INDEX, WITH One FK, On Disk, One File PreGrown, SSIS' 
						, 'Primary Key, Added 1 Foreign Key (DimDate), One File, File WAS PreGrown to expected size (10.5 GB), Increment = 64 MB, Log WAS Pregrown, Increment = 64MB, Polling Rate = 1 s + CountTime, MaxPollingTime = 60s. Computer = Lenovo LocalHost'
DECLARE @runId INT = (SELECT TOP 1 RunId FROm @runIdTable ORDER BY RunId DESC)

EXEC Metric.uspPollRowCount_FactAccountBillingType
					@runId
					, 1 --Period of Polling in sec	
					, 60 --Duration of Polling in sec

/* RESULTS*/
SELECT RunTitle
		, RunNotes

	FROM Metric.Run R
	WHERE R.RunId = @runId

EXEC Metric.uspGetAverageRowVelocityByRunId @runId
EXEC Metric.uspGetTableRowCountDataByRunId @runId


--4b
/*****************************************PK, Clustered INDEX, WITH Two FK*********************/

--SETUP EXPERIMENT HERE:
--------------------------------------------------------------------------------------------------
EXEC dbo.FactAccountBillingType_DropAllConstraintAndIndex

ALTER TABLE dbo.FactAccountBillingType
ADD CONSTRAINT PC_FactAccountBillingType_ThreeColumn 
PRIMARY KEY CLUSTERED (AccountId, BillingTypeId, DateID) 
GO

ALTER TABLE dbo.FactAccountBillingType
ADD CONSTRAINT FK_FactAccountBillingType_DateId_DimDate_DateID 
FOREIGN KEY  (DateID)  REFERENCES dbo.DimDate(DateId) 
GO

ALTER TABLE dbo.FactAccountBillingType
ADD CONSTRAINT FK_FactAccountBillingType_BillingTypeId_DimBillingType_BillingTypeId
FOREIGN KEY  (BillingTypeId)  REFERENCES dbo.DimBillingType (BillingTypeId) 
GO

--------------------------------------------------------------------------------------------------
--Testing Code, Change Comments for Documentation
DECLARE @runIdTable TABLE(RunId INT);
DECLARE @RowCountTableData 
		TABLE(
			 RunId INT
			, RunTitle VARCHAR(200)
			, TableName VARCHAR(200)
			, DateTime DATETIME
			, TimeInMinutes Decimal(18,6)
			, Count_Rows INT
			, [Velocity Rows/Min] INT
			);
INSERT INTO @runIdTable(RunId) 
EXEC Metric.uspInsertNewRun 
						'PK, Clustered INDEX, With Two FK (DateId, BillingTypeId), On Disk, One File PreGrown, SSIS' 
						, 'Primary Key, Added 1 Foreign Key (DimDate), One File, File WAS PreGrown to expected size (10.5 GB), Increment = 64 MB, Log WAS Pregrown, Increment = 64MB, Polling Rate = 1 s + CountTime, MaxPollingTime = 60s. Computer = Lenovo LocalHost'
DECLARE @runId INT = (SELECT TOP 1 RunId FROm @runIdTable ORDER BY RunId DESC)

EXEC Metric.uspPollRowCount_FactAccountBillingType
					@runId
					, 1 --Period of Polling in sec	
					, 60 --Duration of Polling in sec

/* RESULTS*/
SELECT RunTitle
		, RunNotes

	FROM Metric.Run R
	WHERE R.RunId = @runId

EXEC Metric.uspGetAverageRowVelocityByRunId @runId
EXEC Metric.uspGetTableRowCountDataByRunId @runId



--4c
/*****************************************PK, Clustered INDEX, WITH three FK*********************/

--SETUP EXPERIMENT HERE:
EXEC dbo.FactAccountBillingType_DropAllConstraintAndIndex

--ADD
ALTER TABLE dbo.FactAccountBillingType
ADD CONSTRAINT PC_FactAccountBillingType_ThreeColumn 
PRIMARY KEY CLUSTERED (AccountId, BillingTypeId, DateID) 
GO

ALTER TABLE dbo.FactAccountBillingType
ADD CONSTRAINT FK_FactAccountBillingType_DateId_DimDate_DateID 
FOREIGN KEY  (DateID)  REFERENCES dbo.DimDate(DateId) 
GO

ALTER TABLE dbo.FactAccountBillingType
ADD CONSTRAINT FK_FactAccountBillingType_BillingTypeId_DimBillingType_BillingTypeId
FOREIGN KEY  (BillingTypeId)  REFERENCES dbo.DimBillingType (BillingTypeId) 
GO

ALTER TABLE dbo.FactAccountBillingType
ADD CONSTRAINT FK_FactAccountBillingType_AccountId_DimAccount_AccountId
FOREIGN KEY  (AccountId)  REFERENCES dbo.DimAccount (AccountId) 
GO

--------------------------------------------------------------------------------------------------
--Testing Code, Change Comments for Documentation
DECLARE @runIdTable TABLE(RunId INT);
DECLARE @RowCountTableData 
		TABLE(
			 RunId INT
			, RunTitle VARCHAR(200)
			, TableName VARCHAR(200)
			, DateTime DATETIME
			, TimeInMinutes Decimal(18,6)
			, Count_Rows INT
			, [Velocity Rows/Min] INT
			);
INSERT INTO @runIdTable(RunId) 
EXEC Metric.uspInsertNewRun 
						'PK, Clustered INDEX, With Three FK (DateId, BillingTypeId, AccountId), On Disk, One File PreGrown, SSIS' 
						, 'Primary Key, Added 1 Foreign Key (DimDate), One File, File WAS PreGrown to expected size (10.5 GB), Increment = 64 MB, Log WAS Pregrown, Increment = 64MB, Polling Rate = 1 s + CountTime, MaxPollingTime = 60s. Computer = Lenovo LocalHost'
DECLARE @runId INT = (SELECT TOP 1 RunId FROm @runIdTable ORDER BY RunId DESC)

EXEC Metric.uspPollRowCount_FactAccountBillingType
					@runId
					, 1 --Period of Polling in sec	
					, 60 --Duration of Polling in sec

/* RESULTS*/
SELECT RunTitle
		, RunNotes

	FROM Metric.Run R
	WHERE R.RunId = @runId

EXEC Metric.uspGetAverageRowVelocityByRunId @runId
EXEC Metric.uspGetTableRowCountDataByRunId @runId



--5
/**************************WITH CLUSTERED COLUMN STORE INDEX ONLY, NO FK*****************************/

--SETUP EXPERIMENT HERE:
--------------------------------------------------------------------------------------------------
EXEC dbo.FactAccountBillingType_DropAllConstraintAndIndex


CREATE CLUSTERED COLUMNSTORE INDEX [cci_FactAccountBillingType] ON dbo.FactAccountBillingType
GO

--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--Testing Code, Change Comments for Documentation
DECLARE @runIdTable TABLE(RunId INT);
DECLARE @RowCountTableData 
		TABLE(
			 RunId INT
			, RunTitle VARCHAR(200)
			, TableName VARCHAR(200)
			, DateTime DATETIME
			, TimeInMinutes Decimal(18,6)
			, Count_Rows INT
			, [Velocity Rows/Min] INT
			);
INSERT INTO @runIdTable(RunId) 
EXEC Metric.uspInsertNewRun 
						'ColumnStore Index, One FK, On Disk, One File PreGrown, SSIS' 
						, 'Primary Key on three columns (AccountId, BillingTypeId, DateId), Added 1 Foreign Key (REF DimDate), One File, File WERE PreGrown to expected size (10.5 GB), Increment = 64 MB, Log WAS Pregrown, Increment = 64MB, Polling Rate = 1 s + CountTime, MaxPollingTime = 300s. Computer = Lenovo LocalHost'
DECLARE @runId INT = (SELECT TOP 1 RunId FROm @runIdTable ORDER BY RunId DESC)

EXEC Metric.uspPollRowCount_FactAccountBillingType
					@runId
					, 1 --Period of Polling in sec	
					, 60 --Duration of Polling in sec

/* RESULTS*/
SELECT RunTitle
		, RunNotes

	FROM Metric.Run R
	WHERE R.RunId = @runId

EXEC Metric.uspGetAverageRowVelocityByRunId @runId
EXEC Metric.uspGetTableRowCountDataByRunId @runId




--6
/**************************WITH CLUSTERED COLUMN STORE INDEX, NonClustered RowStore, NO FK*****************************/

--SETUP EXPERIMENT HERE:
--------------------------------------------------------------------------------------------------
EXEC dbo.FactAccountBillingType_DropAllConstraintAndIndex


CREATE CLUSTERED COLUMNSTORE INDEX [cci_FactAccountBillingType] ON dbo.FactAccountBillingType
GO

CREATE NONCLUSTERED INDEX [nci_FactAccountBillingType_AccountId] On dbo.FactAccountBillingType (AccountId)

--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--Testing Code, Change Comments for Documentation
DECLARE @runIdTable TABLE(RunId INT);
DECLARE @RowCountTableData 
		TABLE(
			 RunId INT
			, RunTitle VARCHAR(200)
			, TableName VARCHAR(200)
			, DateTime DATETIME
			, TimeInMinutes Decimal(18,6)
			, Count_Rows INT
			, [Velocity Rows/Min] INT
			);
INSERT INTO @runIdTable(RunId) 
EXEC Metric.uspInsertNewRun 
						'ColumnStore Index with NonClustered RowStoreIndex, Three FK, On Disk, One File PreGrown, SSIS' 
						, 'Clustered ColumnStore, One File, File WERE PreGrown to expected size (10.5 GB), Increment = 64 MB, Log WAS Pregrown, Increment = 64MB, Polling Rate = 1 s + CountTime, MaxPollingTime = 300s. Computer = Lenovo LocalHost'
DECLARE @runId INT = (SELECT TOP 1 RunId FROm @runIdTable ORDER BY RunId DESC)

EXEC Metric.uspPollRowCount_FactAccountBillingType
					@runId
					, 1 --Period of Polling in sec	
					, 60 --Duration of Polling in sec

/* RESULTS*/
SELECT RunTitle
		, RunNotes

	FROM Metric.Run R
	WHERE R.RunId = @runId

EXEC Metric.uspGetAverageRowVelocityByRunId @runId
EXEC Metric.uspGetTableRowCountDataByRunId @runId


--7
/**************************WITH CLUSTERED COLUMN STORE INDEX, NonClustered RowStore, NO FK*****************************/

--SETUP EXPERIMENT HERE:
--------------------------------------------------------------------------------------------------
EXEC dbo.FactAccountBillingType_DropAllConstraintAndIndex


CREATE CLUSTERED COLUMNSTORE INDEX [cci_FactAccountBillingType] ON dbo.FactAccountBillingType
GO

CREATE NONCLUSTERED INDEX [nci_FactAccountBillingType_AccountId] On dbo.FactAccountBillingType (AccountId)
INCLUDE (DateId, BillingTypeId)

--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--Testing Code, Change Comments for Documentation
DECLARE @runIdTable TABLE(RunId INT);
DECLARE @RowCountTableData 
		TABLE(
			 RunId INT
			, RunTitle VARCHAR(200)
			, TableName VARCHAR(200)
			, DateTime DATETIME
			, TimeInMinutes Decimal(18,6)
			, Count_Rows INT
			, [Velocity Rows/Min] INT
			);
INSERT INTO @runIdTable(RunId) 
EXEC Metric.uspInsertNewRun 
						'ColumnStore Index with NonClustered RowStoreIndex other columns included, No FK, On Disk, One File PreGrown, SSIS' 
						, 'Clustered ColumnStore, one nonclustered RowStore Index on AccountId includes Other Two Columns,  One File, File WERE PreGrown to expected size (10.5 GB), Increment = 64 MB, Log WAS Pregrown, Increment = 64MB, Polling Rate = 1 s + CountTime, MaxPollingTime = 60s. Computer = Lenovo LocalHost'
DECLARE @runId INT = (SELECT TOP 1 RunId FROm @runIdTable ORDER BY RunId DESC)

EXEC Metric.uspPollRowCount_FactAccountBillingType
					@runId
					, 1 --Period of Polling in sec	
					, 60 --Duration of Polling in sec

/* RESULTS*/
SELECT RunTitle
		, RunNotes

	FROM Metric.Run R
	WHERE R.RunId = @runId

EXEC Metric.uspGetAverageRowVelocityByRunId @runId
EXEC Metric.uspGetTableRowCountDataByRunId @runId


--8
/**************************WITH CLUSTERED COLUMN STORE INDEX, NonClustered RowStore, NO FK*****************************/

--SETUP EXPERIMENT HERE:
--------------------------------------------------------------------------------------------------
EXEC dbo.FactAccountBillingType_DropAllConstraintAndIndex


CREATE CLUSTERED COLUMNSTORE INDEX [cci_FactAccountBillingType] ON dbo.FactAccountBillingType
GO

CREATE NONCLUSTERED INDEX [nci_FactAccountBillingType_AccountId] On dbo.FactAccountBillingType (AccountId)

CREATE NONCLUSTERED INDEX [nci_FactAccountBillingType_DateId] On dbo.FactAccountBillingType (DateId)

--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--Testing Code, Change Comments for Documentation
DECLARE @runIdTable TABLE(RunId INT);
DECLARE @RowCountTableData 
		TABLE(
			 RunId INT
			, RunTitle VARCHAR(200)
			, TableName VARCHAR(200)
			, DateTime DATETIME
			, TimeInMinutes Decimal(18,6)
			, Count_Rows INT
			, [Velocity Rows/Min] INT
			);
INSERT INTO @runIdTable(RunId) 
EXEC Metric.uspInsertNewRun 
						'ColumnStore Index with 2 NonClustered RowStoreIndex, No FK, On Disk, One File PreGrown, SSIS' 
						, 'Clustered ColumnStore, one nonclustered RowStore Index on AccountId includes Other Two Columns,  One File, File WERE PreGrown to expected size (10.5 GB), Increment = 64 MB, Log WAS Pregrown, Increment = 64MB, Polling Rate = 1 s + CountTime, MaxPollingTime = 60s. Computer = Lenovo LocalHost'
DECLARE @runId INT = (SELECT TOP 1 RunId FROm @runIdTable ORDER BY RunId DESC)

EXEC Metric.uspPollRowCount_FactAccountBillingType
					@runId
					, 1 --Period of Polling in sec	
					, 60 --Duration of Polling in sec

/* RESULTS*/
SELECT RunTitle
		, RunNotes

	FROM Metric.Run R
	WHERE R.RunId = @runId

EXEC Metric.uspGetAverageRowVelocityByRunId @runId
EXEC Metric.uspGetTableRowCountDataByRunId @runId