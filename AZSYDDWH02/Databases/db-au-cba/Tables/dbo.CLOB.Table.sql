USE [db-au-cba]
GO
/****** Object:  Table [dbo].[CLOB]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CLOB](
	[string] [varchar](max) NULL,
	[xmlstring] [xml] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
