USE [db-au-stage]
GO
/****** Object:  Table [dbo].[emc_CBA_EMC_tblAppSurveys_AU]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[emc_CBA_EMC_tblAppSurveys_AU](
	[SAH_ID] [int] NOT NULL,
	[SurveyID] [int] NULL,
	[QuesID] [int] NULL,
	[AnsID] [int] NULL,
	[ClientID] [int] NULL,
	[CreatedDt] [datetime] NULL,
	[Login] [varchar](15) NULL
) ON [PRIMARY]
GO
