USE [db-au-stage]
GO
/****** Object:  Table [dbo].[carebase_tblBillingType_aucm]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[carebase_tblBillingType_aucm](
	[BillingType_ID] [int] NOT NULL,
	[Code] [varchar](10) NOT NULL,
	[Description] [nvarchar](100) NOT NULL
) ON [PRIMARY]
GO
