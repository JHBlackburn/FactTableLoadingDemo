CREATE PROCEDURE Metric.uspInsertNewRun


AS BEGIN
SET NOCOUNT ON

DECLARE @runId TABLE (RunId INT)

	INSERT INTO Metric.Run
	( RunTitle
	, RunNotes
	)

	OUTPUT Inserted.RunId INTO @runId(RunId)

	VALUES
	(
	'TestingSetup_001'
	, Null
	)

	SELECT RunID FROM @runId

END

