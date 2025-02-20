USE [db-au-stage]
GO
/****** Object:  Table [dbo].[emc_CBA_EMC_tblSurveyQuestions_AU]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[emc_CBA_EMC_tblSurveyQuestions_AU](
	[SQ_ID] [int] NOT NULL,
	[SurveyID] [int] NOT NULL,
	[QuesID] [int] NOT NULL,
	[Question] [varchar](200) NULL
) ON [PRIMARY]
GO
