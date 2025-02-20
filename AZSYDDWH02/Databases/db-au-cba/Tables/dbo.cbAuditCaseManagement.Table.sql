USE [db-au-cba]
GO
/****** Object:  Table [dbo].[cbAuditCaseManagement]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cbAuditCaseManagement](
	[BIRowID] [bigint] IDENTITY(1,1) NOT NULL,
	[AuditUser] [nvarchar](255) NULL,
	[AuditDateTime] [datetime] NULL,
	[AuditDateTimeUTC] [datetime] NULL,
	[AuditAction] [nvarchar](10) NULL,
	[CountryKey] [nvarchar](2) NOT NULL,
	[CaseKey] [nvarchar](20) NOT NULL,
	[CaseManagementKey] [nvarchar](20) NULL,
	[CaseNo] [nvarchar](15) NOT NULL,
	[CaseManagementID] [int] NOT NULL,
	[CSIData] [nvarchar](max) NOT NULL,
	[TemplateName] [nvarchar](200) NULL,
	[CSIText] [nvarchar](max) NULL,
	[CSIConverted] [bit] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Index [idx_cbAuditCaseManagement_BIRowID]    Script Date: 20/02/2025 10:13:01 AM ******/
CREATE CLUSTERED INDEX [idx_cbAuditCaseManagement_BIRowID] ON [dbo].[cbAuditCaseManagement]
(
	[BIRowID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_casemanagementkey]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_casemanagementkey] ON [dbo].[cbAuditCaseManagement]
(
	[CaseManagementKey] ASC,
	[AuditDateTime] ASC
)
INCLUDE([CSIText],[CSIConverted]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_cbAuditCaseManagement_AuditDateTime]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_cbAuditCaseManagement_AuditDateTime] ON [dbo].[cbAuditCaseManagement]
(
	[AuditDateTime] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_cbAuditCaseManagement_CaseKey]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_cbAuditCaseManagement_CaseKey] ON [dbo].[cbAuditCaseManagement]
(
	[CaseKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_dirtycrap]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_dirtycrap] ON [dbo].[cbAuditCaseManagement]
(
	[CSIConverted] ASC
)
INCLUDE([BIRowID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cbAuditCaseManagement] ADD  CONSTRAINT [DF_cbAuditCaseManagement_CSIConverted]  DEFAULT ((0)) FOR [CSIConverted]
GO
