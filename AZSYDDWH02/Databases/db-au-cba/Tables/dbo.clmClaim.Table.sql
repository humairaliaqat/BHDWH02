USE [db-au-cba]
GO
/****** Object:  Table [dbo].[clmClaim]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[clmClaim](
	[CountryKey] [varchar](2) NOT NULL,
	[ClaimKey] [varchar](40) NOT NULL,
	[PolicyKey] [varchar](55) NULL,
	[AgencyKey] [varchar](50) NULL,
	[ClaimNo] [int] NOT NULL,
	[CreatedBy] [varchar](30) NULL,
	[CreateDate] [datetime] NULL,
	[OfficerName] [varchar](30) NULL,
	[StatusCode] [varchar](4) NULL,
	[StatusDesc] [varchar](50) NULL,
	[ReceivedDate] [datetime] NULL,
	[Authorisation] [varchar](1) NULL,
	[ActionDate] [datetime] NULL,
	[ActionCode] [int] NULL,
	[FinalisedDate] [datetime] NULL,
	[ArchiveBox] [varchar](20) NULL,
	[PolicyID] [int] NULL,
	[PolicyNo] [varchar](50) NULL,
	[PolicyProduct] [varchar](4) NULL,
	[AgencyCode] [varchar](7) NULL,
	[PolicyPlanCode] [varchar](50) NULL,
	[IntDom] [varchar](3) NULL,
	[Excess] [money] NULL,
	[SingleFamily] [varchar](1) NULL,
	[PolicyIssuedDate] [datetime] NULL,
	[AccountingDate] [datetime] NULL,
	[DepartureDate] [datetime] NULL,
	[ArrivalDate] [datetime] NULL,
	[NumberOfDays] [int] NULL,
	[ITCPremium] [float] NULL,
	[EMCApprovalNo] [varchar](15) NULL,
	[GroupPolicy] [tinyint] NULL,
	[LuggageFlag] [tinyint] NULL,
	[HRisk] [tinyint] NULL,
	[CaseNo] [varchar](14) NULL,
	[Comment] [ntext] NULL,
	[ClaimProduct] [varchar](5) NULL,
	[ClaimPlan] [varchar](50) NULL,
	[RecoveryType] [tinyint] NULL,
	[RecoveryOutcome] [tinyint] NULL,
	[OnlineClaim] [bit] NULL,
	[RecoveryTypeDesc] [varchar](255) NULL,
	[RecoveryOutcomeDesc] [varchar](255) NULL,
	[OnlineConsultant] [varchar](50) NULL,
	[OnlineAlpha] [varchar](20) NULL,
	[CultureCode] [nvarchar](10) NULL,
	[ClaimGroupCode] [varchar](20) NULL,
	[PolicyTransactionKey] [varchar](41) NULL,
	[OutletKey] [varchar](41) NULL,
	[DomainID] [int] NULL,
	[BIRowID] [int] IDENTITY(1,1) NOT NULL,
	[CreateBatchID] [int] NULL,
	[UpdateBatchID] [int] NULL,
	[CreateDateTimeUTC] [datetime] NULL,
	[ReceivedDateTimeUTC] [datetime] NULL,
	[ActionDateTimeUTC] [datetime] NULL,
	[FinalisedDateTimeUTC] [datetime] NULL,
	[PolicyOffline] [bit] NULL,
	[MasterPolicyNumber] [varchar](20) NULL,
	[GroupName] [nvarchar](200) NULL,
	[AgencyName] [nvarchar](200) NULL,
	[FirstNilDate] [date] NULL,
	[CaseKey] [nvarchar](20) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Index [idx_clmClaim_BIRowID]    Script Date: 20/02/2025 10:13:01 AM ******/
CREATE CLUSTERED INDEX [idx_clmClaim_BIRowID] ON [dbo].[clmClaim]
(
	[BIRowID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_clmClaim_AgencyKey]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_clmClaim_AgencyKey] ON [dbo].[clmClaim]
(
	[AgencyKey] ASC
)
INCLUDE([ClaimKey],[CountryKey]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_clmClaim_CaseKey]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_clmClaim_CaseKey] ON [dbo].[clmClaim]
(
	[CaseKey] ASC
)
INCLUDE([ClaimKey]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_clmClaim_ClaimKey]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_clmClaim_ClaimKey] ON [dbo].[clmClaim]
(
	[ClaimKey] ASC
)
INCLUDE([CountryKey],[ReceivedDate],[CreateDate],[FinalisedDate],[ClaimNo],[PolicyNo],[PolicyTransactionKey],[AgencyCode],[OutletKey],[FirstNilDate],[CaseKey]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_clmClaim_ClaimNo]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_clmClaim_ClaimNo] ON [dbo].[clmClaim]
(
	[ClaimNo] ASC
)
INCLUDE([ClaimKey],[CountryKey],[PolicyNo]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_clmClaim_CreateDate]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_clmClaim_CreateDate] ON [dbo].[clmClaim]
(
	[CreateDate] ASC,
	[CountryKey] ASC
)
INCLUDE([ReceivedDate],[FinalisedDate],[ClaimKey],[ClaimNo],[PolicyNo],[PolicyTransactionKey],[AgencyCode],[OutletKey]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_clmClaim_FinalisedDate]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_clmClaim_FinalisedDate] ON [dbo].[clmClaim]
(
	[FinalisedDate] ASC,
	[CountryKey] ASC
)
INCLUDE([ReceivedDate],[CreateDate],[ClaimKey],[ClaimNo],[PolicyNo],[PolicyTransactionKey],[AgencyCode],[OutletKey]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_clmClaim_FirstNilDate]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_clmClaim_FirstNilDate] ON [dbo].[clmClaim]
(
	[FirstNilDate] ASC,
	[CountryKey] ASC
)
INCLUDE([ClaimKey],[ClaimNo]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_clmClaim_OutletKey]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_clmClaim_OutletKey] ON [dbo].[clmClaim]
(
	[OutletKey] ASC
)
INCLUDE([ClaimKey],[CountryKey],[ReceivedDate],[CreateDate],[FinalisedDate],[ClaimNo],[PolicyNo],[PolicyTransactionKey],[AgencyCode]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_clmClaim_PolicyIssueDate]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_clmClaim_PolicyIssueDate] ON [dbo].[clmClaim]
(
	[PolicyIssuedDate] ASC,
	[CountryKey] ASC
)
INCLUDE([ReceivedDate],[CreateDate],[ClaimKey],[PolicyNo],[ClaimNo],[PolicyTransactionKey]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_clmClaim_PolicyKey]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_clmClaim_PolicyKey] ON [dbo].[clmClaim]
(
	[PolicyKey] ASC,
	[PolicyProduct] ASC
)
INCLUDE([ClaimKey],[ClaimNo],[CreateDate],[ReceivedDate],[PolicyNo],[CountryKey]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_clmClaim_PolicyTransactionKey]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_clmClaim_PolicyTransactionKey] ON [dbo].[clmClaim]
(
	[PolicyTransactionKey] ASC
)
INCLUDE([ClaimKey],[CountryKey],[ReceivedDate],[CreateDate],[FinalisedDate],[ClaimNo],[PolicyNo],[AgencyCode],[OutletKey]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_clmClaim_ReceivedDate]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_clmClaim_ReceivedDate] ON [dbo].[clmClaim]
(
	[ReceivedDate] ASC,
	[CountryKey] ASC
)
INCLUDE([CreateDate],[FinalisedDate],[ClaimKey],[ClaimNo],[PolicyNo],[PolicyTransactionKey],[AgencyCode],[OutletKey]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
