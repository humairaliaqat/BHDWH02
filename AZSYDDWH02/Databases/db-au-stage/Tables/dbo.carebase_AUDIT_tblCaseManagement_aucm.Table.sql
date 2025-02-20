USE [db-au-stage]
GO
/****** Object:  Table [dbo].[carebase_AUDIT_tblCaseManagement_aucm]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[carebase_AUDIT_tblCaseManagement_aucm](
	[AUDIT_USERNAME] [varchar](255) NULL,
	[AUDIT_DATETIME] [datetime] NULL,
	[AUDIT_ACTION] [varchar](10) NULL,
	[CaseMgtID] [int] NULL,
	[Case_No] [varchar](50) NULL,
	[CSIData] [nvarchar](max) NULL,
	[TemplateID] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
