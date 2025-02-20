USE [db-au-cba]
GO
/****** Object:  Table [dbo].[clmOnlineClaim]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[clmOnlineClaim](
	[BIRowID] [bigint] IDENTITY(1,1) NOT NULL,
	[CountryKey] [varchar](2) NOT NULL,
	[ClaimKey] [varchar](40) NULL,
	[OnlineClaimKey] [varchar](40) NOT NULL,
	[OnlineClaimID] [int] NOT NULL,
	[ClaimNo] [int] NULL,
	[PrimaryClaimantID] [int] NULL,
	[ClaimCauseID] [int] NULL,
	[DeclarationID] [int] NULL,
	[LatestStep] [int] NULL,
	[PreferredContact] [nvarchar](50) NULL,
	[Email] [nvarchar](255) NULL,
	[Street] [nvarchar](255) NULL,
	[Suburb] [nvarchar](100) NULL,
	[Postcode] [nvarchar](50) NULL,
	[State] [nvarchar](100) NULL,
	[Country] [nvarchar](255) NULL,
	[Phone] [nvarchar](50) NULL,
	[WorkPhone] [nvarchar](50) NULL,
	[Fax] [varchar](50) NULL,
	[PreferredPayment] [nvarchar](50) NULL,
	[BankName] [nvarchar](50) NULL,
	[AccountName] [nvarchar](255) NULL,
	[AccountNumberEncrypt] [varbinary](256) NULL,
	[BSBEncrypt] [varbinary](256) NULL,
	[DateBooked] [date] NULL,
	[DateDeparted] [date] NULL,
	[DateReturned] [date] NULL,
	[hasPastClaim] [bit] NULL,
	[PastClaimDetail] [nvarchar](max) NULL,
	[hasCreditCard] [bit] NULL,
	[isPurchaseOnCard] [bit] NULL,
	[hasOtherSourceClaim] [bit] NULL,
	[OtherSourceClaimDetail] [nvarchar](max) NULL,
	[hasITC] [bit] NULL,
	[ITCRate] [numeric](18, 0) NULL,
	[ABN] [varchar](50) NULL,
	[SelectedSections] [varchar](100) NULL,
	[isDeclared] [bit] NULL,
	[isSelfDeclared] [bit] NULL,
	[OnbehalfName] [nvarchar](255) NULL,
	[OnbehalfEmail] [nvarchar](255) NULL,
	[CreateDateTime] [datetime] NULL,
	[UpdateDateTime] [datetime] NULL,
	[UserID] [int] NULL,
	[AlphaCode] [nvarchar](20) NULL,
	[ConsultantName] [nvarchar](50) NULL,
	[UpdatedBy] [nvarchar](255) NULL,
	[MoreDocument] [bit] NULL,
	[DocumentDescription] [varchar](max) NULL,
	[PolicyNumber] [varchar](50) NULL,
	[FirstName] [nvarchar](100) NULL,
	[LastName] [nvarchar](100) NULL,
	[DOB] [date] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Index [idx_clmOnlineClaim_BIRowID]    Script Date: 20/02/2025 10:13:01 AM ******/
CREATE CLUSTERED INDEX [idx_clmOnlineClaim_BIRowID] ON [dbo].[clmOnlineClaim]
(
	[BIRowID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_clmOnlineClaim_ClaimKey]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_clmOnlineClaim_ClaimKey] ON [dbo].[clmOnlineClaim]
(
	[ClaimKey] ASC
)
INCLUDE([BIRowID],[CreateDateTime],[OnbehalfEmail],[AlphaCode],[ConsultantName]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_clmOnlineClaim_OnlineClaimKey]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_clmOnlineClaim_OnlineClaimKey] ON [dbo].[clmOnlineClaim]
(
	[OnlineClaimKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
