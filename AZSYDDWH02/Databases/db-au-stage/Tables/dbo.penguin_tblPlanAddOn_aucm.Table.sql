USE [db-au-stage]
GO
/****** Object:  Table [dbo].[penguin_tblPlanAddOn_aucm]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[penguin_tblPlanAddOn_aucm](
	[PlanAddOnID] [int] NOT NULL,
	[PlanID] [int] NOT NULL,
	[AddOnID] [int] NOT NULL
) ON [PRIMARY]
GO
