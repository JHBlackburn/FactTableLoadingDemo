CREATE PROCEDURE Metric.uspPollRowCount_FactAccountBillingType
			@runId INT,
			@waitIntervalInSeconds INT,
			@pollForThisManySeconds INT



AS BEGIN
SET NOCOUNT ON

DECLARE @startDateTime DATETIME = GETDATE();
DECLARE @waitTimeInSecondsFormatted varchar(10) = '00:00:' + CAST(@waitIntervalInSeconds as VARCHAR(5));

WHILE EXISTS(SELECT * FROM Metric.Run WHERE EndDT IS NULL AND RunId = @runId)
BEGIN

	INSERT INTO Metric.TableRowCount
			(
			TableName
			, RunId
			, Count_Rows
			, DateTime
			)

	SELECT	
			TableName = 'dbo.FactAccountBillingType'
			, @runId as RunId
			, Count_Rows =  COUNT(*)
			, DateTime = GETDATE()

		FROM dbo.FactAccountBillingType	with(NOLOCK);


WAITFOR DELAY @waitTimeInSecondsFormatted

IF DATEDIFF(SECOND, @startDateTime, GETDATE()) > @pollForThisManySeconds
BREAK;

END

END