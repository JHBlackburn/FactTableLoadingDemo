SET NOCOUNT ON;

DECLARE @dayFromStart int = 0
DECLARE @date date;
DECLARE @dateId int;
DECLARE @yearId int;
DECLARE @monthId int;
DECLARE @dayId int;


truncate table dbo.DimDate

While @dayFromStart <= 1000
	BEGIN
		SET @date = DATEADD(DAY, @dayFromStart, cast('2000-01-01' as date))
		SET @yearId = CAST(DATEPART(YEAR, @date)  as int)
		SET @monthId = CAST(DATEPART(MONTH, @date)  as int)
		SET @dayId = CAST(DATEPART(DAY, @date)  as int)
		SET @dateId = 10000 * @yearId + 100 * @monthId + @dayId


		INSERT INTO dbo.DimDate (
		DateID
		, [Date]
		, [Year]
		, [Month]
		, [Day])

		SELECT 
		DateID = @dateId
		, [Date] = @date
		, [Year] = @yearId
		, [Month] = @monthId
		, [Day] = @dayId 

		SET @dayFromStart = @dayFromStart + 1;

END


