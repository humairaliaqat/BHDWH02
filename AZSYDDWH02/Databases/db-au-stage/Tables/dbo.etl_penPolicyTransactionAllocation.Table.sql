USE [db-au-stage]
GO
/****** Object:  Table [dbo].[etl_penPolicyTransactionAllocation]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[etl_penPolicyTransactionAllocation](
	[CountryKey] [varchar](2) NULL,
	[CompanyKey] [varchar](5) NULL,
	[DomainKey] [varchar](41) NULL,
	[PolicyAllocationKey] [varchar](41) NULL,
	[PaymentAllocationKey] [varchar](41) NULL,
	[PolicyTransactionKey] [varchar](41) NULL,
	[PolicyAllocationID] [int] NOT NULL,
	[PaymentAllocationID] [int] NOT NULL,
	[PolicyTransactionID] [int] NOT NULL,
	[PolicyNumber] [varchar](25) NULL,
	[Amount] [money] NOT NULL,
	[AllocationAmount] [money] NOT NULL,
	[AmountType] [varchar](15) NOT NULL,
	[Comments] [varchar](255) NULL,
	[Status] [varchar](15) NOT NULL
) ON [PRIMARY]
GO
