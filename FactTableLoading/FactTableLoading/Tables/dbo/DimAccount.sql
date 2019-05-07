CREATE TABLE [dbo].[DimAccount]
(
	[AccountId] INT NOT NULL PRIMARY KEY identity(1,1),
	[NaturalAccountId] varchar(100) NOT NULL
)
