USE [db-au-stage]
GO
/****** Object:  Table [dbo].[carebase_tblClientProtocolTemplate_aucm]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[carebase_tblClientProtocolTemplate_aucm](
	[Client_Protocol_ID] [int] NOT NULL,
	[Cli_code] [varchar](2) NULL,
	[Protocol] [varchar](25) NULL,
	[TemplateID] [int] NULL
) ON [PRIMARY]
GO
