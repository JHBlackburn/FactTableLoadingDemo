

/*******************************************SQL SATURDAY DEMO**********************************/
/******************************************* 05.04.2019****************************************/

--1
/*****************************************NO INDEX, NO FK**************************************/

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
						'No Ixs, No FK'
						, 'Removed all Foreign Keys and Indexes from Table'
DECLARE @runId INT = (SELECT TOP 1 RunId FROm @runIdTable)

EXEC Metric.uspPollRowCount_FactAccountBillingType
					@runId
					, 1 --Period of Polling in sec
					, 15 --Duration of Polling in sec

/* RESULTS*/
SELECT RunTitle
		, RunNotes

	FROM Metric.Run R
	WHERE R.RunId = @runId

EXEC Metric.uspGetAverageRowVelocityByRunId @runId
EXEC Metric.uspGetTableRowCountDataByRunId @runId







