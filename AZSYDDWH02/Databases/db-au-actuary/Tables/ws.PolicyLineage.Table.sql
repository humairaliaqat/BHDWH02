USE [db-au-actuary]
GO
/****** Object:  Table [ws].[PolicyLineage]    Script Date: 20/02/2025 10:01:19 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ws].[PolicyLineage](
	[BIRowID] [bigint] NOT NULL,
	[CountryKey] [varchar](2) NULL,
	[AncestorPolicyKey] [varchar](41) NULL,
	[AncestorPolicyNo] [int] NULL,
	[AncestorCustomerKey] [varchar](41) NULL,
	[ParentPolicyKey] [varchar](41) NULL,
	[ParentPolicyNo] [int] NULL,
	[PolicyKey] [varchar](41) NULL,
	[PolicyNo] [int] NULL,
	[CustomerKey] [varchar](41) NULL,
	[Depth] [int] NULL
) ON [PRIMARY]
GO
