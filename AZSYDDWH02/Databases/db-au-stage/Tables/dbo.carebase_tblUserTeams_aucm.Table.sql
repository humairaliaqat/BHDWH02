USE [db-au-stage]
GO
/****** Object:  Table [dbo].[carebase_tblUserTeams_aucm]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[carebase_tblUserTeams_aucm](
	[UserTeamID] [int] NOT NULL,
	[TEAM_ID] [varchar](10) NOT NULL,
	[USERID] [varchar](30) NOT NULL
) ON [PRIMARY]
GO
