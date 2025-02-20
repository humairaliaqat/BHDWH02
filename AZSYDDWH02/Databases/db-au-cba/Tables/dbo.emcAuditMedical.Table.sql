USE [db-au-cba]
GO
/****** Object:  Table [dbo].[emcAuditMedical]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[emcAuditMedical](
	[CountryKey] [varchar](2) NOT NULL,
	[ApplicationKey] [varchar](15) NOT NULL,
	[AuditMedicalKey] [varchar](15) NOT NULL,
	[ApplicationID] [int] NOT NULL,
	[AuditMedicalID] [int] NOT NULL,
	[AuditDate] [datetime] NULL,
	[AuditUserLogin] [varchar](50) NULL,
	[AuditUser] [varchar](255) NULL,
	[AuditAction] [varchar](5) NULL,
	[AssessorID] [int] NULL,
	[Condition] [varchar](250) NULL,
	[DiagnosisDate] [datetime] NULL,
	[ConditionStatus] [varchar](20) NULL,
	[Medication] [varchar](2000) NULL,
	[OnlineCondition] [varchar](2000) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_emcAuditMedical_ApplicationKey]    Script Date: 20/02/2025 10:13:01 AM ******/
CREATE CLUSTERED INDEX [idx_emcAuditMedical_ApplicationKey] ON [dbo].[emcAuditMedical]
(
	[ApplicationKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_emcAuditMedical_AuditDate]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_emcAuditMedical_AuditDate] ON [dbo].[emcAuditMedical]
(
	[AuditDate] ASC,
	[CountryKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_emcAuditMedical_AuditMedicalID]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_emcAuditMedical_AuditMedicalID] ON [dbo].[emcAuditMedical]
(
	[AuditMedicalID] ASC,
	[CountryKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_emcAuditMedical_AuditMedicalKey]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_emcAuditMedical_AuditMedicalKey] ON [dbo].[emcAuditMedical]
(
	[AuditMedicalKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_emcAuditMedical_CountryKey]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_emcAuditMedical_CountryKey] ON [dbo].[emcAuditMedical]
(
	[CountryKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
