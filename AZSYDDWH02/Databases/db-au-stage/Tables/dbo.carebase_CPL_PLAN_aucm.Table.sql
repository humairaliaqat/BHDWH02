USE [db-au-stage]
GO
/****** Object:  Table [dbo].[carebase_CPL_PLAN_aucm]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[carebase_CPL_PLAN_aucm](
	[CASE_NO] [varchar](14) NOT NULL,
	[OPEN_AC] [varchar](30) NULL,
	[PLAN] [nvarchar](255) NULL,
	[PLAN1] [varchar](255) NULL,
	[TODO_DATE] [datetime] NULL,
	[COMP_AC] [varchar](30) NULL,
	[COMP_DATE] [datetime] NULL,
	[ACTION_AC] [varchar](30) NULL,
	[CANCEL_AC] [varchar](30) NULL,
	[CREATED_DT] [datetime] NOT NULL,
	[TODO_BY] [datetime] NULL,
	[PRIORITY] [varchar](1) NULL,
	[ALLOCATED_AC] [varchar](30) NULL,
	[ALLOCATED_TIME] [datetime] NULL,
	[ROW_VERSION] [numeric](10, 0) NULL,
	[ORIGINAL_PLAN_ROWID] [varchar](20) NULL,
	[RESCHEDULEREASONID] [numeric](2, 0) NULL,
	[ROWID] [int] NOT NULL
) ON [PRIMARY]
GO
