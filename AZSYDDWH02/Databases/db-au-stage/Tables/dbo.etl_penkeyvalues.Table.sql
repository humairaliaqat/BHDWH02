USE [db-au-stage]
GO
/****** Object:  Table [dbo].[etl_penkeyvalues]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[etl_penkeyvalues](
	[CountryKey] [varchar](2) NULL,
	[CompanyKey] [varchar](5) NULL,
	[DomainKey] [varchar](41) NULL,
	[PolicyKey] [varchar](71) NULL,
	[PolicyTransactionKey] [varchar](71) NULL,
	[PolicyID] [int] NULL,
	[PolicyTransactionID] [int] NULL,
	[ValueTypeID] [int] NOT NULL,
	[ValueType] [varchar](100) NOT NULL,
	[Value] [nvarchar](255) NULL
) ON [PRIMARY]
GO
