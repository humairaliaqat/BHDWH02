USE [db-au-stage]
GO
/****** Object:  Table [dbo].[carebase_PCL_CLIENT_aucm]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[carebase_PCL_CLIENT_aucm](
	[CLI_CODE] [varchar](2) NOT NULL,
	[CLI_DESC] [nvarchar](100) NULL,
	[DISPLAY] [int] NULL,
	[CSR_type] [int] NOT NULL,
	[DomainCode] [varchar](3) NULL,
	[IsCovermoreClient] [bit] NULL,
	[EMAIL] [nvarchar](100) NULL,
	[DebtorCodeEvac] [varchar](50) NULL,
	[DebtorCodeNonEvac] [varchar](50) NULL,
	[CurrencyCode] [varchar](3) NULL
) ON [PRIMARY]
GO
