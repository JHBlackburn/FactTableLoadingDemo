DECLARE @accountId int = 1;
DECLARE @startDate date;
DECLARE @endDate date;
DECLARE @billingTypeId int;
DECLARE @stringStartDateId varchar(8);
DECLARE @stringEndDateId varchar(8);
DECLARE @msg as Varchar(1000);

TRUNCATE TABLE OLTP.AccountBillingType

While @accountId <= 1000
	BEGIN
		SET @startDate = DATEADD(DAY, (SELECT CEILING(RAND()*1000)), '2015-01-01') --A Random startDate After January 1st 2000
		SET @endDate = DATEADD(DAY, (SELECT CEILING(RAND()*1000)), @startDate) --A Random Amount of Days between 1 and 1000
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
;
with dateUnfiltered as ( 
Select startDate = Min(StartDate),endDate = Max(EndDate)
FROM OLTP.AccountBillingType 
)

select * from dateUnfiltered




