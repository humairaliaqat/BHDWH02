USE [db-au-stage]
GO
/****** Object:  Table [dbo].[penguin_tblDomainLanguage_aucm]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[penguin_tblDomainLanguage_aucm](
	[Id] [int] NOT NULL,
	[DomainId] [int] NOT NULL,
	[Code] [nvarchar](10) NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[DefaultForCatalyst] [bit] NOT NULL,
	[CreateDateTime] [datetime] NOT NULL,
	[UpdateDateTime] [datetime] NOT NULL,
	[Status] [nvarchar](15) NOT NULL
) ON [PRIMARY]
GO
