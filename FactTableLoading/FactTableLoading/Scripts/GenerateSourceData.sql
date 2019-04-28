DECLARE @accountId int = 1;
DECLARE @startDate date;
DECLARE @endDate date;
DECLARE @billingTypeId int;
DECLARE @stringStartDateId varchar(8);
DECLARE @stringEndDateId varchar(8);
DECLARE @msg as Varchar(1000);
DECLARE @maxAccountLifeinDays as int = 1000;

TRUNCATE TABLE OLTP.AccountBillingType

While @accountId <= 1000
	BEGIN
		SET @startDate = DATEADD(DAY, (SELECT CEILING(RAND()*@maxAccountLifeinDays)), '2000-01-01') --A Random startDate After January 1st 2000
		SET @endDate = DATEADD(DAY, (SELECT CEILING(RAND()*@maxAccountLifeinDays)), @startDate) --A Random Amount of Days between 1 and 1000
		SET @billingTypeID = (SELECT CEILING(RAND()*10)) --  A Random BillingType 1-10

		print @startDate
		print @endDate

		INSERT INTO OLTP.AccountBillingType (
		AccountID
		, StartDate
		, EndDate
		, BillingTypeId)
		SELECT 
		AccountID = @accountId
		, @startDate
		, @endDate
		, BillingTypeId = @billingTypeID

		SET @accountId = @accountId + 1;
END


SELECT * FROM OLTP.AccountBillingType


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



SELECT * FROM dbo.DimDate
ORDER BY DateID