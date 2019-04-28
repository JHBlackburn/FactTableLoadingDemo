-- populating dimensions
------------------------------------------------------

MERGE dbo.DimBillingType AS T  
    USING (SELECT DISTINCT 
					BillingTypeName = 'BillingType-' + cast(BillingTypeId as varchar(5))
			FROM OLTP.AccountBillingType
			) AS S
    ON T.BillingTypeName = S.BillingTypeName
WHEN NOT MATCHED THEN  
    INSERT (BillingTypeName)  
    VALUES (S.BillingTypeName)  
    OUTPUT deleted.*, $action, inserted.* ;  



MERGE dbo.DimAccount AS T  
    USING (SELECT DISTINCT 
					AccountNumber = 'AccountNumber#' + cast(AccountId as varchar(5))
			FROM OLTP.AccountBillingType
			) AS S
    ON T.NaturalAccountId = S.AccountNumber
WHEN NOT MATCHED THEN  
    INSERT (NaturalAccountId)  
    VALUES (S.AccountNumber)  
    OUTPUT deleted.*, $action, inserted.* ;  


	
DECLARE @theDate date = @startDate;
DECLARE @maxEndDate as Date = (SELECT MAX(EndDate) FROM OLTP.AccountBillingType)

TRUNCATE TABLE dbo.DimDate

WHILE @theDate < @endDate
BEGIN
	INSERT INTO dbo.DimDate 
		([DateID], [Date], [Year], [Month], [Day])
		Values ( CONVERT(CHAR(8),   @theDate, 112)
				, @theDate
				, DATEPART(YEAR, @startDate)
				, DATEPART(MONTH, @startDate)
				, DATEPART(DAY, @startDate));

	SET @theDate = DateAdd(DAY, 1, @theDate);	
END;