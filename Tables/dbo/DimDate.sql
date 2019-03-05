CREATE TABLE dbo.DimDate
(
	DateID int not null Primary Key,
	[Date] date not null,
	[Year] int not null,
	[Month] int not null,
	[Day] int not null
)