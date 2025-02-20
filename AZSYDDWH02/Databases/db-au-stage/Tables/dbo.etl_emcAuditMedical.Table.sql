USE [db-au-stage]
GO
/****** Object:  Table [dbo].[etl_emcAuditMedical]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[etl_emcAuditMedical](
	[CountryKey] [varchar](2) NULL,
	[ApplicationKey] [varchar](15) NULL,
	[AuditMedicalKey] [varchar](15) NULL,
	[ApplicationID] [int] NULL,
	[AuditMedicalID] [int] NOT NULL,
	[AuditDate] [datetime] NULL,
	[AuditUserLogin] [varchar](255) NULL,
	[AuditUser] [varchar](50) NULL,
	[AuditAction] [varchar](10) NULL,
	[AssessorID] [int] NULL,
	[Condition] [varchar](50) NULL,
	[DiagnosisDate] [datetime] NULL,
	[ConditionStatus] [varchar](19) NULL,
	[Medication] [varchar](2000) NULL,
	[OnlineCondition] [varchar](2000) NULL
) ON [PRIMARY]
GO
