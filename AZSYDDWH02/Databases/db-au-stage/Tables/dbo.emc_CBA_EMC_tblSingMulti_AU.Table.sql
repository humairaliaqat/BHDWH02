USE [db-au-stage]
GO
/****** Object:  Table [dbo].[emc_CBA_EMC_tblSingMulti_AU]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[emc_CBA_EMC_tblSingMulti_AU](
	[SingMultiID] [tinyint] NOT NULL,
	[SingMulti] [varchar](20) NULL,
	[SortOrder] [int] NULL
) ON [PRIMARY]
GO
