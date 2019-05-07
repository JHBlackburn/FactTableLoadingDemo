CREATE PROCEDURE Metric.uspGetTableRowCountDataByRunId
				@runId INT 

AS BEGIN
				
	SELECT 
		RunId
		, TableName
		, DateTime 
		, TimeInMinutes 
		, Count_Rows
		, [Velocity Rows/Min] = CAST(Delta_Count_Rows / NULLIF(Delta_TimeInMinutes, 0) as INT)

		FROM (
			SELECT 
				RunId
				, TableName
				, DateTime 
				, TimeInMinutes
				, Delta_TimeInMinutes = TimeInMinutes - LAG(TimeInMinutes, 1) OVER(ORDER BY DateTime)
				, Count_Rows
				, Delta_Count_Rows
				FROM (
						SELECT 
							RunId
							, TableName
							, DateTime 
							, TimeInMinutes = ISNULL(CAST(CAST(DATEDIFF(SECOND,  MIN(DateTime) OVER(), DateTime) as DECIMAL(18,6))/ 60.00 as DECIMAL(18,6)),0)
							, Count_Rows
							, Delta_Count_Rows = (Count_Rows - LAG(Count_Rows, 1) OVER(ORDER BY DateTime))
								FROM Metric.TableRowCount TRC
								WHERE TRC.RunId = @runId
						) as X
			) as Y

END