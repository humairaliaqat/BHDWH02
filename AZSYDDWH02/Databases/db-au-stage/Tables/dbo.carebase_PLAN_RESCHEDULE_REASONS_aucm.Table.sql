USE [db-au-stage]
GO
/****** Object:  Table [dbo].[carebase_PLAN_RESCHEDULE_REASONS_aucm]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[carebase_PLAN_RESCHEDULE_REASONS_aucm](
	[PRR_ID] [numeric](2, 0) NOT NULL,
	[PLANRESCHREASON] [nvarchar](120) NULL,
	[SORTORDER] [numeric](2, 0) NULL
) ON [PRIMARY]
GO
