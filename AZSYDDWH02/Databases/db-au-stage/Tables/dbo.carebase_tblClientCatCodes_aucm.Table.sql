USE [db-au-stage]
GO
/****** Object:  Table [dbo].[carebase_tblClientCatCodes_aucm]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[carebase_tblClientCatCodes_aucm](
	[CATCODE_ID] [int] NOT NULL,
	[CLI_CODE] [nvarchar](2) NOT NULL,
	[CAT_CODE] [nvarchar](50) NOT NULL
) ON [PRIMARY]
GO
