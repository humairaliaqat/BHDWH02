USE [db-au-stage]
GO
/****** Object:  Table [dbo].[penguin_tblPolicyTransactionAllocation_aucm]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[penguin_tblPolicyTransactionAllocation_aucm](
	[PolicyAllocationId] [int] NOT NULL,
	[PaymentAllocationId] [int] NOT NULL,
	[PolicyTransactionId] [int] NOT NULL,
	[TripsPolicyNumber] [varchar](25) NULL,
	[Amount] [money] NOT NULL,
	[AllocationAmount] [money] NOT NULL,
	[AmountType] [varchar](15) NOT NULL,
	[Transferred] [bit] NOT NULL,
	[Comments] [varchar](255) NULL,
	[Status] [varchar](15) NOT NULL
) ON [PRIMARY]
GO
