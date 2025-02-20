USE [db-au-stage]
GO
/****** Object:  Table [dbo].[emc_CBA_EMC_tblMedicalExtraQuestionDetails_AU]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[emc_CBA_EMC_tblMedicalExtraQuestionDetails_AU](
	[ExtraQidDts] [int] NOT NULL,
	[ClientId] [int] NULL,
	[QId] [tinyint] NULL,
	[QVal] [bit] NULL,
	[RXTypeID] [tinyint] NULL
) ON [PRIMARY]
GO
