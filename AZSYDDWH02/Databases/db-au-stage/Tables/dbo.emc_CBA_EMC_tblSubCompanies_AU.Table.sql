USE [db-au-stage]
GO
/****** Object:  Table [dbo].[emc_CBA_EMC_tblSubCompanies_AU]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[emc_CBA_EMC_tblSubCompanies_AU](
	[SubCompid] [int] NOT NULL,
	[Compid] [smallint] NOT NULL,
	[SubCompCode] [varchar](50) NULL,
	[SubCompDesc] [varchar](250) NULL,
	[active] [int] NULL,
	[isWeb] [bit] NOT NULL,
	[Premium] [numeric](10, 5) NULL,
	[GstPerc] [numeric](10, 5) NULL
) ON [PRIMARY]
GO
