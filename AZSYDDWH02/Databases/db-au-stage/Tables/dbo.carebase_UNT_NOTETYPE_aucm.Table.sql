USE [db-au-stage]
GO
/****** Object:  Table [dbo].[carebase_UNT_NOTETYPE_aucm]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[carebase_UNT_NOTETYPE_aucm](
	[CODE] [varchar](2) NOT NULL,
	[DESCRIPTION] [nvarchar](20) NULL,
	[ACTIVE] [bit] NOT NULL
) ON [PRIMARY]
GO
