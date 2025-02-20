USE [db-au-stage]
GO
/****** Object:  Table [dbo].[carebase_UCO_COUNTRY_aucm]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[carebase_UCO_COUNTRY_aucm](
	[CNTRY_CODE] [varchar](3) NOT NULL,
	[CNTRY_DESC] [nvarchar](25) NULL,
	[DIAL_CODE] [varchar](3) NULL,
	[CNTRY_ID] [numeric](6, 0) NULL,
	[TIME_DIFF] [numeric](3, 0) NULL,
	[AREA] [numeric](10, 0) NULL
) ON [PRIMARY]
GO
