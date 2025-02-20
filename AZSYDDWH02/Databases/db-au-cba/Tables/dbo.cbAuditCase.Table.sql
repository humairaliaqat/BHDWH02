USE [db-au-cba]
GO
/****** Object:  Table [dbo].[cbAuditCase]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cbAuditCase](
	[BIRowID] [bigint] IDENTITY(1,1) NOT NULL,
	[AuditUser] [nvarchar](255) NULL,
	[AuditDateTime] [datetime] NULL,
	[AuditDateTimeUTC] [datetime] NULL,
	[AuditAction] [nvarchar](10) NULL,
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
	[isClosed] [bit] NULL,
	[isReopened] [bit] NULL,
	[isCaseTypeChanged] [bit] NULL,
	[isTotalEstimateChanged] [bit] NULL,
	[isProtocolChanged] [bit] NULL,
	[isIncidentTypeChanged] [bit] NULL,
	[isUWCoverChanged] [bit] NULL,
	[PreviousEstimate] [int] NULL,
	[PreviousCaseType] [nvarchar](255) NULL,
	[PreviousProtocol] [nvarchar](10) NULL,
	[PreviousIncidentType] [nvarchar](60) NULL,
	[PreviousUWCoverStatus] [nvarchar](100) NULL,
	[CultureCode] [nvarchar](10) NULL,
	[CaseFee] [money] NULL,
	[HasReviewCheck] [bit] NULL,
	[HasReviewCompleted] [bit] NULL,
	[HasSoughtMedicalCare] [bit] NULL,
	[IsCustomerHospitalised] [bit] NULL,
	[HasMedicalSteerageOccured] [bit] NULL,
	[isMedicalSteerageChanged] [bit] NULL,
	[PreviousSoughtMedicalCare] [bit] NULL,
	[PreviousCustomerHospitalised] [bit] NULL,
	[PreviousMedicalSteerageOccured] [bit] NULL,
	[isCaseFeeChanged] [bit] NULL,
	[PreviousCaseFee] [money] NULL
) ON [PRIMARY]
GO
/****** Object:  Index [idx_cbAuditCase_BIRowID]    Script Date: 20/02/2025 10:13:01 AM ******/
CREATE CLUSTERED INDEX [idx_cbAuditCase_BIRowID] ON [dbo].[cbAuditCase]
(
	[BIRowID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_cbAuditCase_AuditDateTime]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_cbAuditCase_AuditDateTime] ON [dbo].[cbAuditCase]
(
	[AuditDateTime] ASC,
	[CaseKey] ASC
)
INCLUDE([AuditDateTimeUTC],[IsDeleted],[isClosed],[isReopened],[isCaseTypeChanged],[isTotalEstimateChanged],[isProtocolChanged],[isIncidentTypeChanged],[isUWCoverChanged],[BIRowID],[AuditAction],[ClientCode],[AuditUser],[TotalEstimate],[UWCoverStatus],[RiskLevel],[RiskReason],[CaseStatus],[Location],[Country],[CaseNo]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_cbAuditCase_CaseKey]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_cbAuditCase_CaseKey] ON [dbo].[cbAuditCase]
(
	[CaseKey] ASC,
	[AuditDateTime] ASC
)
INCLUDE([IsDeleted],[isClosed],[isReopened],[isCaseTypeChanged],[isTotalEstimateChanged],[isProtocolChanged],[isIncidentTypeChanged],[BIRowID],[AuditUser],[CreateDate],[UWCoverStatus],[TotalEstimate],[isUWCoverChanged],[RiskLevel],[RiskReason],[CaseStatus],[Location],[Country],[CaseNo]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
