USE [db-au-stage]
GO
/****** Object:  Table [dbo].[emc_CBA_EMC_tblMedicalConditionQuestionAnswer_AU]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[emc_CBA_EMC_tblMedicalConditionQuestionAnswer_AU](
	[Counter] [int] NOT NULL,
	[MedicalID] [int] NULL,
	[Question] [varchar](200) NULL,
	[Answer] [varchar](100) NULL,
	[CreateDate] [datetime] NULL,
	[UpdateDate] [datetime] NULL,
	[Status] [varchar](50) NULL
) ON [PRIMARY]
GO
