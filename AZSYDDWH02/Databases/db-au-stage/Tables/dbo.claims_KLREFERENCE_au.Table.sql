USE [db-au-stage]
GO
/****** Object:  Table [dbo].[claims_KLREFERENCE_au]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[claims_KLREFERENCE_au](
	[ID] [int] NOT NULL,
	[ENTITY] [nvarchar](100) NOT NULL,
	[CODE] [nvarchar](50) NOT NULL,
	[DESCRIPTION] [nvarchar](100) NULL,
	[ISACTIVE] [bit] NOT NULL,
	[SORTORDER] [int] NULL
) ON [PRIMARY]
GO
