USE [db-au-stage]
GO
/****** Object:  Table [dbo].[emc_CBA_EMC_tblEmcPenguinAreaMapping_AU]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[emc_CBA_EMC_tblEmcPenguinAreaMapping_AU](
	[AreaMappingID] [int] NOT NULL,
	[AreaName] [nvarchar](100) NULL,
	[HealixRegionID] [int] NULL,
	[CompID] [int] NULL,
	[AreaCode] [varchar](50) NULL,
	[CreateDate] [datetime] NULL,
	[UpdateDate] [datetime] NULL,
	[Status] [varchar](50) NOT NULL,
	[SortOrder] [int] NULL
) ON [PRIMARY]
GO
