USE [db-au-workspace]
GO
/****** Object:  Table [dbo].[EMCGroupScore_240207]    Script Date: 20/02/2025 10:27:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EMCGroupScore_240207](
	[BIRowID] [bigint] IDENTITY(1,1) NOT NULL,
	[SourceSystem] [varchar](15) NULL,
	[SourceKey] [varchar](100) NULL,
	[Max EMC Score] [numeric](6, 2) NULL,
	[Total EMC Score] [numeric](6, 2) NULL,
	[Max EMC Score No Filter] [numeric](6, 2) NULL,
	[Total EMC Score No Filter] [numeric](6, 2) NULL
) ON [PRIMARY]
GO
