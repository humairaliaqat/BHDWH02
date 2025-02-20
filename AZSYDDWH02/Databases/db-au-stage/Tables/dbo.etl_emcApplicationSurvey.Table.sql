USE [db-au-stage]
GO
/****** Object:  Table [dbo].[etl_emcApplicationSurvey]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[etl_emcApplicationSurvey](
	[CountryKey] [varchar](2) NULL,
	[ApplicationKey] [varchar](15) NULL,
	[ApplicationSurveyKey] [varchar](15) NULL,
	[ApplicationID] [int] NULL,
	[ApplicationSurveyID] [int] NOT NULL,
	[CreateDate] [datetime] NULL,
	[SurveyCategory] [varchar](40) NULL,
	[Question] [varchar](200) NULL,
	[Answer] [varchar](255) NULL
) ON [PRIMARY]
GO
