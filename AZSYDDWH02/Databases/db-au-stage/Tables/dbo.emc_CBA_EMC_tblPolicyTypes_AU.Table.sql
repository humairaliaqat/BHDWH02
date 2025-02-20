USE [db-au-stage]
GO
/****** Object:  Table [dbo].[emc_CBA_EMC_tblPolicyTypes_AU]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[emc_CBA_EMC_tblPolicyTypes_AU](
	[PolTypeID] [tinyint] NOT NULL,
	[PolCode] [varchar](3) NULL,
	[PolType] [varchar](100) NULL,
	[SortOrder] [int] NULL,
	[Tripspolcode] [varchar](10) NULL
) ON [PRIMARY]
GO
