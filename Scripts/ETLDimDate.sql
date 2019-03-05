DECLARE @dayFromStart int = 0
DECLARE @date date;
DECLARE @dateId int;
DECLARE @yearId int;
DECLARE @monthId int;
DECLARE @dayId int;



While @dayFromStart <= 1000
	BEGIN
		SET @date = DATEADD(DAY, @dayFromStart, cast('2000-01-01' as date))
		SET @yearId = CAST(DATEPART(YEAR, @date)  as int)
		SET @monthId = CAST(DATEPART(YEAR, @date)  as int)
		SET @dayId = CAST(DATEPART(YEAR, @date)  as int)
		SET @dateId = CAST(CONCAT(CAST(@yearId as varchar(4))
						, CAST(@monthId as varchar(2))
						, CAST(@dayId as varchar(2) )
						) as int)


		INSERT INTO dbo.DimDate (
		DateID
		, [Date]
		, [Year]
		, [Month]
		, [Day])
		SELECT 
		DateID = @dateId
		,[Date] = @date
		,[Year] = @yearId
		, [Month] = @monthId
		, [Day] = @dayId 

		SET @dayFromStart = @dayFromStart + 1;
		print @dayFromStart
END


SELECT * FROM dbo.DimDate
