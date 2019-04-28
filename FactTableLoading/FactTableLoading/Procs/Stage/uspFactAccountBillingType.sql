CREATE PROCEDURE Stage.uspFactAccountBillingType
AS
BEGIN

SELECT AccountId = DA.AccountId
	, BillingTypeId = DBT.BillingTypeId
	, DateId = DD.DateID

	FROM OLTP.AccountBillingType ABT
	JOIN dbo.DimDate DD
	ON DD.Date BETWEEN ABT.StartDate and ABT.EndDate
	JOIN dbo.DimBillingType DBT
	ON DBT.BillingTypeName = ABT.BillingTypeName
	JOIN dbo.DimAccount DA
	ON DA.NaturalAccountId = ABT.AccountNumber

END
