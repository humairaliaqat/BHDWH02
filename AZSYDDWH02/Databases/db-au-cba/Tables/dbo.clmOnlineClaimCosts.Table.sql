USE [db-au-cba]
GO
/****** Object:  Table [dbo].[clmOnlineClaimCosts]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[clmOnlineClaimCosts](
	[BIRowID] [bigint] IDENTITY(1,1) NOT NULL,
	[CountryKey] [varchar](2) NOT NULL,
	[ClaimKey] [varchar](40) NULL,
	[OnlineClaimKey] [varchar](40) NOT NULL,
	[ClaimNo] [int] NULL,
	[OnlineClaimID] [int] NOT NULL,
	[ExpenseType] [varchar](50) NULL,
	[isActual] [bit] NULL,
	[ExpenseDate] [date] NULL,
	[CostDescription] [varchar](max) NULL,
	[CostReason] [varchar](max) NULL,
	[Amount] [money] NULL,
	[AmountRefunded] [money] NULL,
	[AmountClaimable] [money] NULL,
	[AmendmentCosts] [money] NULL,
	[Currency] [varchar](50) NULL,
	[Excess] [money] NULL,
	[ExcessCurrency] [varchar](50) NULL,
	[Paid] [bit] NULL,
	[TravelAgentLiaise] [bit] NULL,
	[TravelAgent] [varchar](max) NULL,
	[PlaceOfPurchase] [varchar](max) NULL,
	[ProofAttached] [bit] NULL,
	[Replaced] [bit] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Index [idx_clmOnlineClaimCosts_BIRowID]    Script Date: 20/02/2025 10:13:01 AM ******/
CREATE CLUSTERED INDEX [idx_clmOnlineClaimCosts_BIRowID] ON [dbo].[clmOnlineClaimCosts]
(
	[BIRowID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_clmOnlineClaimCosts_ClaimKey]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_clmOnlineClaimCosts_ClaimKey] ON [dbo].[clmOnlineClaimCosts]
(
	[ClaimKey] ASC
)
INCLUDE([BIRowID],[ExpenseType],[CostReason],[CostDescription],[ExpenseDate],[isActual],[ProofAttached],[Amount]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_clmOnlineClaimCosts_ExpenseDate]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_clmOnlineClaimCosts_ExpenseDate] ON [dbo].[clmOnlineClaimCosts]
(
	[ExpenseDate] ASC,
	[ExpenseType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_clmOnlineClaimCosts_ExpenseType]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_clmOnlineClaimCosts_ExpenseType] ON [dbo].[clmOnlineClaimCosts]
(
	[ExpenseType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_clmOnlineClaimCosts_OnlineClaimKey]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_clmOnlineClaimCosts_OnlineClaimKey] ON [dbo].[clmOnlineClaimCosts]
(
	[OnlineClaimKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
