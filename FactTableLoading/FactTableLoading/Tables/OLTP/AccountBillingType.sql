CREATE TABLE OLTP.AccountBillingType(
	AccountBillingTypeID int primary key Identity(1,1),
	AccountNumber Varchar(20) NOT NULL,
	StartDate Date NOT NULL,
	EndDate Date NOT NULL,
	BillingTypeName Varchar(20) NOT NULL
)



