CREATE TABLE OLTP.AccountBillingType(
	AccountBillingTypeID int primary key Identity(1,1),
	AccountID int NOT NULL,
	StartDate Date NOT NULL,
	EndDate Date NOT NULL,
	BillingTypeId int NOT NULL
)



