USE [db-au-stage]
GO
/****** Object:  Table [dbo].[carebase_UAT_ADDRTYPE_aucm]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[carebase_UAT_ADDRTYPE_aucm](
	[TYPE] [varchar](5) NOT NULL,
	[DESCRIPTN] [nvarchar](25) NULL,
	[DEF_FLAG] [varchar](1) NULL,
	[AUSTDEFT] [varchar](1) NULL,
	[SEQUENCE] [int] NULL
) ON [PRIMARY]
GO
