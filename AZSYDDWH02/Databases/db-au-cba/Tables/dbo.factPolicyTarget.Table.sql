USE [db-au-cba]
GO
/****** Object:  Table [dbo].[factPolicyTarget]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[factPolicyTarget](
	[DateSK] [int] NULL,
	[DomainSK] [int] NOT NULL,
	[OutletSK] [int] NOT NULL,
	[AlphaCode] [nvarchar](20) NULL,
	[BudgetAmount] [float] NULL,
	[AcceleratorAmount] [float] NULL,
	[LoadDate] [datetime] NOT NULL,
	[updateDate] [int] NULL,
	[LoadID] [int] NULL,
	[updateID] [int] NULL,
	[ProductSK] [bigint] NULL,
	[BIRoowID] [bigint] NOT NULL
) ON [PRIMARY]
GO
