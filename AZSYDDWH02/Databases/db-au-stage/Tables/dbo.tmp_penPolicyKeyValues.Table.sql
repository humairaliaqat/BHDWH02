USE [db-au-stage]
GO
/****** Object:  Table [dbo].[tmp_penPolicyKeyValues]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tmp_penPolicyKeyValues](
	[BIRowID] [bigint] NOT NULL,
	[CountryKey] [varchar](2) NOT NULL,
	[CompanyKey] [varchar](5) NOT NULL,
	[DomainKey] [varchar](41) NOT NULL,
	[PolicyKey] [varchar](41) NULL,
	[PolicyTransactionKey] [varchar](41) NULL,
	[PolicyID] [int] NULL,
	[PolicyTransactionID] [int] NULL,
	[ValueTypeID] [int] NULL,
	[ValueType] [nvarchar](100) NULL,
	[KeyValue] [nvarchar](255) NULL
) ON [PRIMARY]
GO
