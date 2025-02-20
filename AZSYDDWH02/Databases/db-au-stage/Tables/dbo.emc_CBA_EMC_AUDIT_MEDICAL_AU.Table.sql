USE [db-au-stage]
GO
/****** Object:  Table [dbo].[emc_CBA_EMC_AUDIT_MEDICAL_AU]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[emc_CBA_EMC_AUDIT_MEDICAL_AU](
	[AUDIT_USERNAME] [varchar](255) NULL,
	[AUDIT_DATETIME] [datetime] NULL,
	[AUDIT_ACTION] [varchar](10) NULL,
	[Counter] [int] NOT NULL,
	[ClientID] [int] NULL,
	[Condition] [varchar](50) NULL,
	[DeniedAccepted] [varchar](1) NULL,
	[CONDCODE] [varchar](1) NULL,
	[AssessorID] [int] NULL,
	[DiagnosisDate] [datetime] NULL,
	[Meds_Dose_Freq] [varchar](2000) NULL,
	[MedsChanged] [bit] NULL,
	[OnlineCondition] [varchar](2000) NULL
) ON [PRIMARY]
GO
