USE [db-au-stage]
GO
/****** Object:  Table [dbo].[penguin_tblOutletPlanSelectionSettings_aucm]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[penguin_tblOutletPlanSelectionSettings_aucm](
	[Id] [int] NOT NULL,
	[OutletOTCId] [int] NOT NULL,
	[AccordianView] [int] NULL
) ON [PRIMARY]
GO
