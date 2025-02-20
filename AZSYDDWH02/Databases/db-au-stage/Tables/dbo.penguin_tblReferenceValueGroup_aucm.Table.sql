USE [db-au-stage]
GO
/****** Object:  Table [dbo].[penguin_tblReferenceValueGroup_aucm]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[penguin_tblReferenceValueGroup_aucm](
	[ID] [int] NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[IsSystemDefined] [bit] NULL,
	[DomainId] [int] NOT NULL
) ON [PRIMARY]
GO
