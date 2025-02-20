USE [db-au-stage]
GO
/****** Object:  Table [dbo].[carebase_AUDIT_CLR_CLREPORT_aucm]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[carebase_AUDIT_CLR_CLREPORT_aucm](
	[AUDIT_USERNAME] [varchar](25) NULL,
	[AUDIT_DATETIME] [datetime] NULL,
	[AUDIT_ACTION] [varchar](10) NULL,
	[CASE_NO] [varchar](14) NULL,
	[AC] [varchar](30) NULL,
	[NOTE_DATE] [datetime] NULL,
	[HEADER] [varchar](1) NULL,
	[CANCEL] [varchar](1) NULL,
	[NOTES] [nvarchar](max) NULL,
	[PRINT_DT] [datetime] NULL,
	[CREATED_DT] [datetime] NULL,
	[ROWID] [int] NULL,
	[TYPE] [varchar](2) NULL,
	[CHASE_COVER] [bit] NULL,
	[URGENCY_ID] [int] NULL,
	[REASON] [nvarchar](1000) NULL,
	[EmailDate] [datetime] NULL,
	[IsDeleted] [bit] NULL,
	[EmailDetails] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
