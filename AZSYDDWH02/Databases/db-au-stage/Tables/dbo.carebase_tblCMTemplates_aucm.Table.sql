USE [db-au-stage]
GO
/****** Object:  Table [dbo].[carebase_tblCMTemplates_aucm]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[carebase_tblCMTemplates_aucm](
	[TemplateID] [int] NOT NULL,
	[TemplateName] [nvarchar](100) NOT NULL,
	[TemplateData] [nvarchar](max) NULL,
	[IsDeleted] [bit] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
