--------------------------------------------------------------------------------------------------
CREATE PROCEDURE dbo.FactAccountBillingType_DropAllConstraintAndIndex

AS BEGIN

DBCC FREEPROCCACHE

TRUNCATE TABLE [dbo].[FactAccountBillingType]


ALTER TABLE [dbo].[FactAccountBillingType] DROP CONSTRAINT IF EXISTS [FK_FactAccountBillingType_DateId_DimDate_DateID]

ALTER TABLE [dbo].[FactAccountBillingType] DROP CONSTRAINT IF EXISTS [FK_FactAccountBillingType_BillingTypeId_DimBillingType_BillingTypeId]

ALTER TABLE [dbo].[FactAccountBillingType] DROP CONSTRAINT IF EXISTS FK_FactAccountBillingType_AccountId_DimAccount_AccountId

ALTER TABLE [dbo].[FactAccountBillingType] DROP CONSTRAINT IF EXISTS  [PC_FactAccountBillingType_ThreeColumn]

DROP INDEX IF EXISTS [cci_FactAccountBillingType] on dbo.FactAccountBillingType

DROP INDEX IF EXISTS [nci_FactAccountBillingType_AccountId] on dbo.FactAccountBillingType

DROP INDEX IF EXISTS [nci_FactAccountBillingType_DateId] on dbo.FactAccountBillingType

DROP INDEX IF EXISTS [nci_FactAccountBillingType_BillingTypeId] on dbo.FactAccountBillingType

END


