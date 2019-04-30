CREATE PROCEDURE Metric.uspGetAverageRowVelocityByRunId
				@runId INT

AS BEGIN

SELECT 
	[Average RowVelocity (Rows/Min)] = CAST((C.FinalRowCount - C.StartingRowCount) 
									/ CAST(NULLIF(CAST(DATEDIFF(SECOND, StartingDT, FinalDT) as DECIMAL(18,6))/ 60.00, 0) as DECIMAL(18,6)) as DECIMAL(18,0))

	FROM (
		SELECT DISTINCT
			
			StartingRowCount = FIRST_VALUE(Count_Rows) OVER(Partition BY RunId ORDER BY DateTime ASC)
			, FinalRowCount = FIRST_VALUE(Count_Rows)  OVER(Partition BY RunId ORDER BY DateTime DESC)
			, StartingDT = FIRST_VALUE(DateTime) OVER(Partition BY RunId ORDER BY DateTime ASC)
			, FinalDT = FIRST_VALUE(DateTime) OVER(Partition BY RunId ORDER BY DateTime DESC)

		FROM Metric.TableRowCount TRC
		where TRC.RunId = @runId
		) as C

END