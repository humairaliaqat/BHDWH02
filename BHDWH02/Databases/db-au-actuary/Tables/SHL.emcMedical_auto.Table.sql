USE [db-au-actuary]
GO
/****** Object:  Table [SHL].[emcMedical_auto]    Script Date: 18/02/2025 12:14:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SHL].[emcMedical_auto](
	[CountryKey] [varchar](2) NOT NULL,
	[ApplicationKey] [varchar](15) NULL,
	[AssessorKey] [varchar](10) NULL,
	[MedicalKey] [varchar](15) NULL,
	[ApplicationID] [int] NULL,
	[MedicalID] [int] NOT NULL,
	[GroupID] [int] NULL,
	[CreateDate] [datetime] NULL,
	[IsMedicationsChanged] [bit] NULL,
	[HowMedicationsChanged] [varchar](4000) NULL,
	[Assessor] [varchar](50) NULL,
	[Condition] [varchar](50) NULL,
	[DiagnosisDate] [datetime] NULL,
	[ConditionStatus] [varchar](19) NULL,
	[GroupStatus] [varchar](19) NULL,
	[Medication] [varchar](2000) NULL,
	[OnlineCondition] [varchar](2000) NULL,
	[MedicalScore] [numeric](18, 2) NULL,
	[GroupScore] [numeric](18, 2) NULL
) ON [PRIMARY]
GO
