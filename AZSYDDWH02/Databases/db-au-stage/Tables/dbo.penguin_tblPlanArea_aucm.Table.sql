USE [db-au-stage]
GO
/****** Object:  Table [dbo].[penguin_tblPlanArea_aucm]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[penguin_tblPlanArea_aucm](
	[PlanAreaID] [int] NOT NULL,
	[PlanID] [int] NOT NULL,
	[AreaID] [int] NOT NULL,
	[PlanCode] [nvarchar](50) NULL,
	[AMTUpsellAreaId] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Index [idx_penguin_tblPlanArea_aucm_PlanID]    Script Date: 20/02/2025 10:25:22 AM ******/
CREATE CLUSTERED INDEX [idx_penguin_tblPlanArea_aucm_PlanID] ON [dbo].[penguin_tblPlanArea_aucm]
(
	[PlanID] ASC,
	[AreaID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
