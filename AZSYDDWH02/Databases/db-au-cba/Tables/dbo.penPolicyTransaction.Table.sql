USE [db-au-cba]
GO
/****** Object:  Table [dbo].[penPolicyTransaction]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[penPolicyTransaction](
	[CountryKey] [varchar](2) NOT NULL,
	[CompanyKey] [varchar](5) NOT NULL,
	[PolicyTransactionKey] [varchar](41) NOT NULL,
	[PolicyKey] [varchar](41) NULL,
	[PolicyNoKey] [varchar](100) NULL,
	[UserKey] [varchar](41) NULL,
	[UserSKey] [bigint] NULL,
	[PolicyTransactionID] [int] NOT NULL,
	[PolicyID] [int] NOT NULL,
	[PolicyNumber] [varchar](50) NULL,
	[TransactionTypeID] [int] NOT NULL,
	[TransactionType] [varchar](50) NULL,
	[GrossPremium] [money] NOT NULL,
	[IssueDate] [datetime] NOT NULL,
	[AccountingPeriod] [datetime] NOT NULL,
	[CRMUserID] [int] NULL,
	[CRMUserName] [nvarchar](100) NULL,
	[TransactionStatusID] [int] NOT NULL,
	[TransactionStatus] [nvarchar](50) NULL,
	[Transferred] [bit] NOT NULL,
	[UserComments] [nvarchar](1000) NULL,
	[CommissionTier] [varchar](50) NULL,
	[VolumeCommission] [numeric](18, 9) NULL,
	[Discount] [numeric](18, 9) NULL,
	[isExpo] [bit] NOT NULL,
	[isPriceBeat] [bit] NOT NULL,
	[NoOfBonusDaysApplied] [int] NULL,
	[isAgentSpecial] [bit] NOT NULL,
	[ParentID] [int] NULL,
	[ConsultantID] [int] NULL,
	[isClientCall] [bit] NULL,
	[RiskNet] [money] NULL,
	[AutoComments] [nvarchar](2000) NULL,
	[TripCost] [varchar](50) NULL,
	[AllocationNumber] [int] NULL,
	[PaymentDate] [datetime] NULL,
	[TransactionStart] [datetime] NULL,
	[TransactionEnd] [datetime] NULL,
	[StoreCode] [varchar](10) NULL,
	[DomainKey] [varchar](41) NULL,
	[DomainID] [int] NULL,
	[IssueDateUTC] [datetime] NULL,
	[PaymentDateUTC] [datetime] NULL,
	[TransactionStartUTC] [datetime] NULL,
	[TransactionEndUTC] [datetime] NULL,
	[ImportDate] [datetime] NULL,
	[TransactionDateTime] [datetime] NULL,
	[TotalCommission] [money] NULL,
	[TotalNet] [money] NULL,
	[PaymentMode] [nvarchar](20) NULL,
	[PointsRedeemed] [money] NULL,
	[RedemptionReference] [nvarchar](255) NULL,
	[GigyaId] [nvarchar](300) NULL,
	[IssuingConsultantID] [int] NULL,
	[LeadTimeDate] [date] NULL,
	[RefundTransactionID] [int] NULL,
	[RefundTransactionKey] [varchar](41) NULL,
	[CancellationReason] [nvarchar](250) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_penPolicyTransaction_PolicyKey]    Script Date: 20/02/2025 10:13:01 AM ******/
CREATE CLUSTERED INDEX [idx_penPolicyTransaction_PolicyKey] ON [dbo].[penPolicyTransaction]
(
	[PolicyKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_penPolicyTransaction_IssueDate]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_penPolicyTransaction_IssueDate] ON [dbo].[penPolicyTransaction]
(
	[IssueDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_penPolicyTransaction_PaymentDate]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_penPolicyTransaction_PaymentDate] ON [dbo].[penPolicyTransaction]
(
	[PaymentDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_penPolicyTransaction_PolicyID]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_penPolicyTransaction_PolicyID] ON [dbo].[penPolicyTransaction]
(
	[PolicyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_penPolicyTransaction_PolicyNumber]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_penPolicyTransaction_PolicyNumber] ON [dbo].[penPolicyTransaction]
(
	[PolicyNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_penPolicyTransaction_PolicyTransactionID]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_penPolicyTransaction_PolicyTransactionID] ON [dbo].[penPolicyTransaction]
(
	[PolicyTransactionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_penPolicyTransaction_PolicyTransactionKey]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_penPolicyTransaction_PolicyTransactionKey] ON [dbo].[penPolicyTransaction]
(
	[PolicyTransactionKey] ASC
)
INCLUDE([PolicyNumber],[PolicyKey],[TransactionType]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_penPolicyTransaction_UserKey]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_penPolicyTransaction_UserKey] ON [dbo].[penPolicyTransaction]
(
	[UserKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_penPolicyTransaction_UserSKey]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_penPolicyTransaction_UserSKey] ON [dbo].[penPolicyTransaction]
(
	[UserSKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
