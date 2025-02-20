USE [db-au-workspace]
GO
/****** Object:  Table [dbo].[recon_ods]    Script Date: 20/02/2025 10:27:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[recon_ods](
	[SUNPeriod] [int] NULL,
	[CountryKey] [varchar](2) NOT NULL,
	[JVCode] [nvarchar](10) NULL,
	[JVDescription] [nvarchar](55) NULL,
	[FinanceProductCode] [nvarchar](12) NULL,
	[PolicyCount] [int] NULL,
	[Premium] [money] NULL,
	[Commission] [money] NULL
) ON [PRIMARY]
GO
