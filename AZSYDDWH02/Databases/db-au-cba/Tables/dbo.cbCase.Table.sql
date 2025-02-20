USE [db-au-cba]
GO
/****** Object:  Table [dbo].[cbCase]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cbCase](
	[BIRowID] [bigint] IDENTITY(1,1) NOT NULL,
	[CountryKey] [nvarchar](2) NOT NULL,
	[CaseKey] [nvarchar](20) NOT NULL,
	[LinkedCaseKey] [nvarchar](20) NULL,
	[OpenedByKey] [nvarchar](35) NULL,
	[ClosedByKey] [nvarchar](35) NULL,
	[CaseNo] [nvarchar](15) NOT NULL,
	[LinkedCaseNo] [nvarchar](15) NULL,
	[CreateDate] [datetime] NULL,
	[CreateTimeUTC] [datetime] NULL,
	[OpenDate] [datetime] NULL,
	[OpenTime] [datetime] NULL,
	[OpenTimeUTC] [datetime] NULL,
	[CloseDate] [datetime] NULL,
	[CloseTimeUTC] [datetime] NULL,
	[FirstCloseDate] [datetime] NULL,
	[FirstCloseTimeUTC] [datetime] NULL,
	[FirstClosedByID] [nvarchar](30) NULL,
	[FirstClosedBy] [nvarchar](55) NULL,
	[OpenedByID] [nvarchar](30) NULL,
	[OpenedBy] [nvarchar](55) NULL,
	[ClosedByID] [nvarchar](30) NULL,
	[ClosedBy] [nvarchar](55) NULL,
	[TimeInCase] [numeric](9, 3) NULL,
	[Team] [nvarchar](50) NULL,
	[CaseStatus] [nvarchar](10) NULL,
	[CaseType] [nvarchar](255) NULL,
	[CaseCode] [nvarchar](5) NULL,
	[CaseDescription] [nvarchar](4000) NULL,
	[TotalEstimate] [int] NULL,
	[IsDeleted] [bit] NULL,
	[DisorderType] [nvarchar](100) NULL,
	[DisorderSubType] [nvarchar](100) NULL,
	[MedicalCode] [nvarchar](10) NULL,
	[DiagnosticCategory] [nvarchar](250) NULL,
	[ARDRGRange] [nvarchar](15) NULL,
	[MedicalSurgical] [nvarchar](10) NOT NULL,
	[ResearchSpecific] [nvarchar](100) NULL,
	[DisasterDate] [datetime] NULL,
	[Disaster] [nvarchar](100) NULL,
	[DisasterCountry] [nvarchar](25) NULL,
	[FirstName] [nvarchar](100) NULL,
	[Surname] [nvarchar](100) NULL,
	[Sex] [nvarchar](1) NULL,
	[DOB] [varbinary](100) NULL,
	[Location] [nvarchar](200) NULL,
	[CountryCode] [nvarchar](3) NULL,
	[Country] [nvarchar](25) NULL,
	[ProtocolCode] [nvarchar](1) NULL,
	[Protocol] [nvarchar](10) NOT NULL,
	[ClientCode] [nvarchar](2) NULL,
	[ClientName] [nvarchar](100) NULL,
	[ProgramCode] [nvarchar](2) NULL,
	[Program] [nvarchar](35) NULL,
	[IncidentType] [nvarchar](60) NULL,
	[ClaimNo] [nvarchar](40) NULL,
	[Catastrophe] [nvarchar](50) NULL,
	[UWCoverID] [int] NULL,
	[UWCoverStatus] [nvarchar](100) NULL,
	[RiskLevel] [nvarchar](50) NULL,
	[RiskReason] [nvarchar](100) NULL,
	[CultureCode] [nvarchar](10) NULL,
	[CaseFee] [money] NULL,
	[HasReviewCheck] [bit] NULL,
	[HasReviewCompleted] [bit] NULL,
	[HasSoughtMedicalCare] [bit] NULL,
	[IsCustomerHospitalised] [bit] NULL,
	[HasMedicalSteerageOccured] [bit] NULL,
	[CustomerID] [bigint] NULL
) ON [PRIMARY]
GO
/****** Object:  Index [idx_cbCase_BIRowID]    Script Date: 20/02/2025 10:13:01 AM ******/
CREATE CLUSTERED INDEX [idx_cbCase_BIRowID] ON [dbo].[cbCase]
(
	[BIRowID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_cbCase_CaseKey]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_cbCase_CaseKey] ON [dbo].[cbCase]
(
	[CaseKey] ASC
)
INCLUDE([ClientCode],[Protocol],[CreateDate],[CountryKey],[CaseNo],[CaseType]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_cbCase_CaseNo]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_cbCase_CaseNo] ON [dbo].[cbCase]
(
	[CaseNo] ASC,
	[CountryKey] ASC,
	[CreateDate] ASC
)
INCLUDE([OpenDate],[OpenTimeUTC],[CloseDate],[CloseTimeUTC],[FirstCloseDate],[FirstCloseTimeUTC],[CaseKey]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_cbCase_CaseStatus]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_cbCase_CaseStatus] ON [dbo].[cbCase]
(
	[CaseStatus] ASC,
	[IsDeleted] ASC
)
INCLUDE([CaseKey],[CaseNo]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_cbCase_ClaimNo]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_cbCase_ClaimNo] ON [dbo].[cbCase]
(
	[ClaimNo] ASC
)
INCLUDE([CaseKey],[CaseNo],[ClientCode]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_cbCase_ClientCode]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_cbCase_ClientCode] ON [dbo].[cbCase]
(
	[ClientCode] ASC
)
INCLUDE([ClientName]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_cbCase_Customer]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_cbCase_Customer] ON [dbo].[cbCase]
(
	[FirstName] ASC,
	[CreateDate] ASC
)
INCLUDE([CaseKey],[CaseNo],[Surname],[DOB]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_cbCase_CustomerID]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_cbCase_CustomerID] ON [dbo].[cbCase]
(
	[CustomerID] ASC
)
INCLUDE([BIRowID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_cbCase_FirstCloseDate]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_cbCase_FirstCloseDate] ON [dbo].[cbCase]
(
	[FirstCloseDate] ASC,
	[IsDeleted] ASC
)
INCLUDE([CaseKey],[CaseNo],[ClientCode],[ClientName],[FirstCloseTimeUTC],[OpenDate],[OpenTimeUTC],[CloseDate],[CloseTimeUTC]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_cbCase_OpenDate]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_cbCase_OpenDate] ON [dbo].[cbCase]
(
	[OpenDate] ASC,
	[IsDeleted] ASC
)
INCLUDE([OpenTimeUTC],[CaseKey],[ClientCode],[ClientName],[CloseDate],[CloseTimeUTC],[FirstCloseDate],[FirstCloseTimeUTC]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_cbCase_RiskLevel]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_cbCase_RiskLevel] ON [dbo].[cbCase]
(
	[RiskLevel] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_cbCase_UWCoverStatus]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_cbCase_UWCoverStatus] ON [dbo].[cbCase]
(
	[UWCoverStatus] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
