USE [db-au-stage]
GO
/****** Object:  Table [dbo].[penguin_tblExpo_aucm]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[penguin_tblExpo_aucm](
	[ExpoID] [int] NOT NULL,
	[Name] [varchar](250) NOT NULL,
	[ActiveFrom] [datetime] NOT NULL,
	[ActiveTo] [datetime] NOT NULL,
	[DomainId] [int] NOT NULL
) ON [PRIMARY]
GO
