CREATE PROCEDURE Metric.uspPollRowCount_FactAccountBillingType

AS BEGIN
SET NOCOUNT ON

INSERT INTO Metric.TableRowCount
		(
		TableName
		, Count_Rows
		)

SELECT	
		TableName = 'Stage.FactAccountBillingType'
		, Count_Rows =  COUNT(*) 

	FROM Stage.FactAccountBillingType	with(NOLOCK)


INSERT INTO Metric.TableRowCount
		(
		TableName
		, Count_Rows
		)

SELECT	
		TableName = 'dbo.FactAccountBillingType'
		, Count_Rows =  COUNT(*) 

	FROM dbo.FactAccountBillingType	with(NOLOCK)

END