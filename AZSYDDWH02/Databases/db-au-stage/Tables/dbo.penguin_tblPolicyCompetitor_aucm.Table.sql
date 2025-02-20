USE [db-au-stage]
GO
/****** Object:  Table [dbo].[penguin_tblPolicyCompetitor_aucm]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[penguin_tblPolicyCompetitor_aucm](
	[Id] [int] NOT NULL,
	[CompetitorId] [int] NOT NULL,
	[PolicyId] [int] NOT NULL,
	[CompetitorPrice] [money] NOT NULL,
	[CreateDateTime] [datetime] NOT NULL,
	[UpdateDateTime] [datetime] NOT NULL
) ON [PRIMARY]
GO
