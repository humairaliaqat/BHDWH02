USE [db-au-stage]
GO
/****** Object:  Table [dbo].[carebase_tblServiceType_aucm]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[carebase_tblServiceType_aucm](
	[ID] [int] NOT NULL,
	[Name] [nvarchar](250) NULL,
	[DomainID] [int] NULL
) ON [PRIMARY]
GO
