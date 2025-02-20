USE [db-au-stage]
GO
/****** Object:  Table [dbo].[penguin_tblJointVenture_aucm]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[penguin_tblJointVenture_aucm](
	[JointVentureId] [int] NOT NULL,
	[Name] [varchar](55) NOT NULL,
	[Code] [varchar](10) NOT NULL,
	[Status] [varchar](15) NOT NULL,
	[SortOrder] [int] NULL
) ON [PRIMARY]
GO
