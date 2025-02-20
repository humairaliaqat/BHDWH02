USE [db-au-star]
GO
/****** Object:  Table [dbo].[factCorporate]    Script Date: 20/02/2025 10:26:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[factCorporate](
	[BIRowID] [bigint] IDENTITY(1,1) NOT NULL,
	[DateSK] [int] NOT NULL,
	[DomainSK] [int] NOT NULL,
	[OutletSK] [int] NOT NULL,
	[ProductSK] [int] NOT NULL,
	[AccountingPeriod] [datetime] NULL,
	[IssueDate] [datetime] NULL,
	[QuoteKey] [nvarchar](50) NULL,
	[PolicyKey] [nvarchar](50) NULL,
	[PolicyNumber] [varchar](50) NULL,
	[PolicyStartDate] [datetime] NULL,
	[PolicyExpiryDate] [datetime] NULL,
	[Excess] [decimal](18, 2) NULL,
	[Premium] [float] NULL,
	[SellPrice] [float] NULL,
	[PremiumSD] [float] NULL,
	[PremiumGST] [float] NULL,
	[Commission] [float] NULL,
	[CommissionGST] [float] NULL,
	[PolicyCount] [int] NULL,
	[QuoteCount] [int] NULL,
	[LoadDate] [datetime] NOT NULL,
	[LoadID] [int] NOT NULL,
	[updateDate] [datetime] NULL,
	[updateID] [int] NULL,
	[DurationSK] [int] NULL,
	[UnderwriterCode] [varchar](100) NULL,
	[DepartureDateSK] [date] NULL,
	[ReturnDateSK] [date] NULL,
	[IssueDateSK] [date] NULL
) ON [PRIMARY]
GO
/****** Object:  Index [idx_factCorporate_BIRowID]    Script Date: 20/02/2025 10:26:12 AM ******/
CREATE CLUSTERED INDEX [idx_factCorporate_BIRowID] ON [dbo].[factCorporate]
(
	[BIRowID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_factCorporate_AccountingPeriod]    Script Date: 20/02/2025 10:26:12 AM ******/
CREATE NONCLUSTERED INDEX [idx_factCorporate_AccountingPeriod] ON [dbo].[factCorporate]
(
	[AccountingPeriod] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_factCorporate_DateSK]    Script Date: 20/02/2025 10:26:12 AM ******/
CREATE NONCLUSTERED INDEX [idx_factCorporate_DateSK] ON [dbo].[factCorporate]
(
	[DateSK] ASC,
	[OutletSK] ASC
)
INCLUDE([DomainSK],[Premium],[Commission],[PolicyCount],[QuoteCount]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_factCorporate_DomainSK]    Script Date: 20/02/2025 10:26:12 AM ******/
CREATE NONCLUSTERED INDEX [idx_factCorporate_DomainSK] ON [dbo].[factCorporate]
(
	[DomainSK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_factCorporate_IssueDate]    Script Date: 20/02/2025 10:26:12 AM ******/
CREATE NONCLUSTERED INDEX [idx_factCorporate_IssueDate] ON [dbo].[factCorporate]
(
	[IssueDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_factCorporate_OutletSK]    Script Date: 20/02/2025 10:26:12 AM ******/
CREATE NONCLUSTERED INDEX [idx_factCorporate_OutletSK] ON [dbo].[factCorporate]
(
	[OutletSK] ASC,
	[DateSK] ASC
)
INCLUDE([Premium],[Commission],[PolicyCount],[QuoteCount]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_factCorporate_ProductSK]    Script Date: 20/02/2025 10:26:12 AM ******/
CREATE NONCLUSTERED INDEX [idx_factCorporate_ProductSK] ON [dbo].[factCorporate]
(
	[ProductSK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
