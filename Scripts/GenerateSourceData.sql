DECLARE @accountId int = 1;
DECLARE @startDate date;
DECLARE @endDate date;
DECLARE @billingTypeId int;
DECLARE @stringStartDateId varchar(8);
DECLARE @stringEndDateId varchar(8);
DECLARE @msg as Varchar(1000);

While @accountId <= 1000
	BEGIN
		SET @startDate = DATEADD(DAY, (SELECT CEILING(RAND()*1000)), '2000-01-01') --A Random startDate After January 1st 2000
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
