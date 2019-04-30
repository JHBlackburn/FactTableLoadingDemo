CREATE PROCEDURE Metric.uspInsertNewRun
				@runTitle VARCHAR(200)
				, @runNotes VARCHAR(MAX)


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
	@runTitle
	, @runNotes
	)

	SELECT TOP 1 RunID FROM @runId;

END

