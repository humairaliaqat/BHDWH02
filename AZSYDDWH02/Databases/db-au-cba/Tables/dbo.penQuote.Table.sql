USE [db-au-cba]
GO
/****** Object:  Table [dbo].[penQuote]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[penQuote](
	[CountryKey] [varchar](2) NOT NULL,
	[CompanyKey] [varchar](5) NOT NULL,
	[QuoteKey] [varchar](30) NULL,
	[QuoteCountryKey] [varchar](41) NULL,
	[PolicyKey] [varchar](41) NULL,
	[OutletSKey] [bigint] NULL,
	[OutletAlphaKey] [nvarchar](50) NULL,
	[QuoteID] [int] NULL,
	[SessionID] [nvarchar](255) NULL,
	[AgencyCode] [nvarchar](60) NULL,
	[ConsultantName] [nvarchar](101) NULL,
	[UserName] [nvarchar](100) NULL,
	[CreateDate] [datetime] NULL,
	[CreateTime] [datetime] NULL,
	[Area] [nvarchar](100) NULL,
	[Destination] [nvarchar](max) NULL,
	[DepartureDate] [datetime] NULL,
	[ReturnDate] [datetime] NULL,
	[IsExpo] [bit] NULL,
	[IsAgentSpecial] [bit] NULL,
	[PromoCode] [nvarchar](60) NULL,
	[CanxFlag] [bit] NULL,
	[PolicyNo] [varchar](50) NULL,
	[NumberOfChildren] [int] NULL,
	[NumberOfAdults] [int] NULL,
	[NumberOfPersons] [int] NULL,
	[Duration] [int] NULL,
	[IsSaved] [bit] NULL,
	[SaveStep] [int] NULL,
	[AgentReference] [nvarchar](100) NULL,
	[UpdateTime] [datetime] NULL,
	[StoreCode] [varchar](10) NULL,
	[QuotedPrice] [numeric](19, 4) NULL,
	[ProductCode] [nvarchar](50) NULL,
	[DomainKey] [varchar](41) NULL,
	[DomainID] [int] NULL,
	[CreateDateUTC] [datetime] NULL,
	[CreateTimeUTC] [datetime] NULL,
	[UpdateTimeUTC] [datetime] NULL,
	[YAGOCreateDate] [datetime] NULL,
	[PurchasePath] [nvarchar](50) NULL,
	[QuoteSaveDate] [datetime] NULL,
	[QuoteSaveDateUTC] [datetime] NULL,
	[CRMUserName] [nvarchar](100) NULL,
	[CRMFullName] [nvarchar](101) NULL,
	[PreviousPolicyNumber] [varchar](50) NULL,
	[QuoteImportDateUTC] [datetime] NULL,
	[CurrencyCode] [varchar](3) NULL,
	[AreaCode] [nvarchar](3) NULL,
	[CultureCode] [nvarchar](20) NULL,
	[ProductName] [nvarchar](50) NULL,
	[PlanID] [int] NULL,
	[PlanName] [nvarchar](50) NULL,
	[PlanCode] [nvarchar](50) NULL,
	[PlanType] [nvarchar](50) NULL,
	[IsUpSell] [bit] NULL,
	[Excess] [money] NULL,
	[IsDefaultExcess] [bit] NULL,
	[PolicyStart] [datetime] NULL,
	[PolicyEnd] [datetime] NULL,
	[DaysCovered] [int] NULL,
	[MaxDuration] [int] NULL,
	[GrossPremium] [money] NOT NULL,
	[PDSUrl] [varchar](100) NULL,
	[SortOrder] [int] NULL,
	[PlanDisplayName] [nvarchar](100) NULL,
	[RiskNet] [money] NULL,
	[PlanProductPricingTierID] [int] NULL,
	[VolumeCommission] [decimal](18, 9) NULL,
	[Discount] [decimal](18, 9) NULL,
	[CommissionTier] [varchar](50) NULL,
	[COI] [varchar](100) NULL,
	[UniquePlanID] [int] NULL,
	[TripCost] [nvarchar](100) NULL,
	[PolicyID] [int] NULL,
	[IsPriceBeat] [bit] NULL,
	[CancellationValueText] [nvarchar](50) NULL,
	[ProductDisplayName] [nvarchar](50) NULL,
	[AreaID] [int] NULL,
	[AgeBandID] [int] NULL,
	[DurationID] [int] NULL,
	[ExcessID] [int] NULL,
	[LeadTimeID] [int] NULL,
	[RateCardID] [int] NULL,
	[IsSelected] [bit] NULL,
	[ParentQuoteID] [int] NULL,
	[MultiDestination] [nvarchar](max) NULL,
	[IsNoClaimBonus] [bit] NULL,
	[LeadTimeDate] [date] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Index [idx_penQuote_CreateDate]    Script Date: 20/02/2025 10:13:01 AM ******/
CREATE CLUSTERED INDEX [idx_penQuote_CreateDate] ON [dbo].[penQuote]
(
	[CreateDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_penQuote_AgencyCode]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_penQuote_AgencyCode] ON [dbo].[penQuote]
(
	[AgencyCode] ASC,
	[CompanyKey] ASC,
	[CountryKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_penQuote_OutletAlphaKey]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_penQuote_OutletAlphaKey] ON [dbo].[penQuote]
(
	[OutletAlphaKey] ASC,
	[UpdateTime] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_penQuote_PolicyKey]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_penQuote_PolicyKey] ON [dbo].[penQuote]
(
	[PolicyKey] ASC
)
INCLUDE([QuoteID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_penQuote_QuoteCountryKey]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_penQuote_QuoteCountryKey] ON [dbo].[penQuote]
(
	[QuoteCountryKey] ASC
)
INCLUDE([PolicyKey],[OutletAlphaKey],[QuoteID],[CreateDate],[IsSaved]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_penQuote_YAGOCreateDate]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_penQuote_YAGOCreateDate] ON [dbo].[penQuote]
(
	[YAGOCreateDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
