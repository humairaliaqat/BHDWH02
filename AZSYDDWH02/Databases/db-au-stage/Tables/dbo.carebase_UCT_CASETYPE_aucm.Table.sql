USE [db-au-stage]
GO
/****** Object:  Table [dbo].[carebase_UCT_CASETYPE_aucm]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[carebase_UCT_CASETYPE_aucm](
	[CT_ID] [int] NOT NULL,
	[CT_DESCRIPTION] [nvarchar](30) NULL,
	[CHARGEABLE] [bit] NULL,
	[FIXED_CHARGE] [bit] NULL
) ON [PRIMARY]
GO
