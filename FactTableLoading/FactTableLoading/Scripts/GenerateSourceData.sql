DECLARE @accountId int = 1;
DECLARE @minStartDate date = '2000-01-01';
DECLARE @startDate date;
DECLARE @endDate date;
DECLARE @billingTypeId int;
DECLARE @stringStartDateId varchar(8);
DECLARE @stringEndDateId varchar(8);
DECLARE @msg as Varchar(1000);
DECLARE @maxAccountLifeinDays int = 1000;
DECLARE @numberOfAccounts int = 1000000;

TRUNCATE TABLE OLTP.AccountBillingType

While @accountId <= @numberOfAccounts
	BEGIN
		SET @startDate = DATEADD(DAY, (SELECT CEILING(RAND()*@maxAccountLifeinDays)), @minStartDate) --A Random startDate After January 1st 2000
		SET @endDate = DATEADD(DAY, (SELECT CEILING(RAND()*@maxAccountLifeinDays)), @startDate) --A Random Amount of Days between 1 and 1000
		SET @billingTypeID = (SELECT CEILING(RAND()*10)) --  A Random BillingType 1-10


		INSERT INTO OLTP.AccountBillingType (
		AccountNumber
		, StartDate
		, EndDate
		, BillingTypeName)
		SELECT 
		AccountNumber = 'Account#' + CAST(@accountId as Varchar(5))
		, @startDate
		, @endDate
		, BillingTypeId = 'BillingType-' + CAST(@billingTypeID as Varchar(5))

		SET @accountId = @accountId + 1;
END


SELECT * FROM OLTP.AccountBillingType


-- populating dimensions
------------------------------------------------------
--TRUNCATE TABLE dbo.DimBillingType

MERGE dbo.DimBillingType AS T  
    USING (SELECT DISTINCT 
					BillingTypeName
			FROM OLTP.AccountBillingType
			) AS S
    ON T.BillingTypeName = S.BillingTypeName
WHEN NOT MATCHED THEN  
    INSERT (BillingTypeName)  
    VALUES (S.BillingTypeName)  
WHEN NOT MATCHED BY SOURCE THEN DELETE;

--TRUNCATE TABLE dbo.DimAccount

MERGE dbo.DimAccount AS T  
    USING (SELECT DISTINCT 
					AccountNumber
			FROM OLTP.AccountBillingType
			) AS S
    ON T.NaturalAccountId = S.AccountNumber
WHEN NOT MATCHED THEN  
    INSERT (NaturalAccountId)  
    VALUES (S.AccountNumber)  ;


	
DECLARE @theDate date = @minStartDate;
DECLARE @maxEndDate as Date = (SELECT MAX(EndDate) FROM OLTP.AccountBillingType)

TRUNCATE TABLE dbo.DimDate

WHILE @theDate <= @maxEndDate
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