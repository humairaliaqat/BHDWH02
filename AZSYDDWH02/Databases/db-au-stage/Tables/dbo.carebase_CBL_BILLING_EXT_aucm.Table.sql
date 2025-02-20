USE [db-au-stage]
GO
/****** Object:  Table [dbo].[carebase_CBL_BILLING_EXT_aucm]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[carebase_CBL_BILLING_EXT_aucm](
	[RECID] [int] NOT NULL,
	[CASE_NO] [varchar](14) NULL,
	[DIAGNOSIS] [varchar](30) NULL,
	[PPO_US_STATE] [varchar](30) NULL,
	[NET_SAVING] [float] NULL,
	[CBL_EXT_ID] [int] NOT NULL,
	[MOD_DT] [datetime] NULL
) ON [PRIMARY]
GO
