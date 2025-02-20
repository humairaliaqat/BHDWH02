USE [db-au-stage]
GO
/****** Object:  Table [dbo].[etl_emcMedicalQuestions]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[etl_emcMedicalQuestions](
	[CountryKey] [varchar](2) NULL,
	[MedicalKey] [varchar](15) NULL,
	[MedicalID] [int] NULL,
	[QuestionID] [int] NOT NULL,
	[Question] [varchar](200) NULL,
	[Answer] [varchar](100) NULL
) ON [PRIMARY]
GO
