USE [db-au-star]
GO
/****** Object:  Table [dbo].[factPolicyTransaction]    Script Date: 20/02/2025 10:26:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[factPolicyTransaction](
	[BIRowID] [bigint] IDENTITY(1,1) NOT NULL,
	[DateSK] [int] NOT NULL,
	[DomainSK] [int] NOT NULL,
	[OutletSK] [int] NOT NULL,
	[PolicySK] [int] NOT NULL,
	[ConsultantSK] [int] NOT NULL,
	[PaymentSK] [int] NOT NULL,
	[AreaSK] [int] NOT NULL,
	[DestinationSK] [int] NOT NULL,
	[DurationSK] [int] NOT NULL,
	[ProductSK] [int] NOT NULL,
	[AgeBandSK] [int] NOT NULL,
	[PromotionSK] [int] NOT NULL,
	[IssueDate] [datetime] NULL,
	[PostingDate] [datetime] NULL,
	[PolicyTransactionKey] [nvarchar](50) NULL,
	[TransactionNumber] [varchar](50) NULL,
	[TransactionType] [nvarchar](50) NULL,
	[TransactionStatus] [nvarchar](50) NULL,
	[isExpo] [nvarchar](1) NULL,
	[isPriceBeat] [nvarchar](1) NULL,
	[isAgentSpecial] [nvarchar](1) NULL,
	[BonusDays] [int] NULL,
	[isClientCall] [nvarchar](1) NULL,
	[AllocationNumber] [int] NULL,
	[RiskNet] [float] NULL,
	[Premium] [float] NULL,
	[BookPremium] [float] NULL,
	[SellPrice] [float] NULL,
	[NetPrice] [float] NULL,
	[PremiumSD] [float] NULL,
	[PremiumGST] [float] NULL,
	[Commission] [float] NULL,
	[CommissionSD] [float] NULL,
	[CommissionGST] [float] NULL,
	[PremiumDiscount] [float] NULL,
	[AdminFee] [float] NULL,
	[AgentPremium] [float] NULL,
	[UnadjustedSellPrice] [float] NULL,
	[UnadjustedNetPrice] [float] NULL,
	[UnadjustedCommission] [float] NULL,
	[UnadjustedAdminFee] [float] NULL,
	[PolicyCount] [int] NULL,
	[AddonPolicyCount] [int] NULL,
	[ExtensionPolicyCount] [int] NULL,
	[CancelledPolicyCount] [int] NULL,
	[CancelledAddonPolicyCount] [int] NULL,
	[CANXPolicyCount] [int] NULL,
	[DomesticPolicyCount] [int] NULL,
	[InternationalPolicyCount] [int] NULL,
	[InboundPolicyCount] [int] NULL,
	[TravellersCount] [int] NULL,
	[AdultsCount] [int] NULL,
	[ChildrenCount] [int] NULL,
	[ChargedAdultsCount] [int] NULL,
	[DomesticTravellersCount] [int] NULL,
	[DomesticAdultsCount] [int] NULL,
	[DomesticChildrenCount] [int] NULL,
	[DomesticChargedAdultsCount] [int] NULL,
	[InboundTravellersCount] [int] NULL,
	[InboundAdultsCount] [int] NULL,
	[InboundChildrenCount] [int] NULL,
	[InboundChargedAdultsCount] [int] NULL,
	[InternationalTravellersCount] [int] NULL,
	[InternationalAdultsCount] [int] NULL,
	[InternationalChildrenCount] [int] NULL,
	[InternationalChargedAdultsCount] [int] NULL,
	[LuggageCount] [int] NULL,
	[MedicalCount] [int] NULL,
	[MotorcycleCount] [int] NULL,
	[RentalCarCount] [int] NULL,
	[WintersportCount] [int] NULL,
	[AttachmentCount] [int] NULL,
	[EMCCount] [int] NULL,
	[LoadDate] [datetime] NOT NULL,
	[LoadID] [int] NOT NULL,
	[updateDate] [datetime] NULL,
	[updateID] [int] NULL,
	[LeadTime] [int] NULL,
	[Duration] [int] NULL,
	[CancellationCover] [money] NULL,
	[PolicyIssueDate] [date] NULL,
	[DepartureDate] [date] NULL,
	[ReturnDate] [date] NULL,
	[UnderwriterCode] [varchar](100) NULL,
	[TransactionTypeStatusSK] [bigint] NULL,
	[DepartureDateSK] [date] NULL,
	[ReturnDateSK] [date] NULL,
	[IssueDateSK] [date] NULL,
	[CancelledTransactionCount] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Index [idx_factPolicyTransaction_BIRowID]    Script Date: 20/02/2025 10:26:11 AM ******/
CREATE CLUSTERED INDEX [idx_factPolicyTransaction_BIRowID] ON [dbo].[factPolicyTransaction]
(
	[BIRowID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_factPolicyTransaction_AgeBandSK]    Script Date: 20/02/2025 10:26:12 AM ******/
CREATE NONCLUSTERED INDEX [idx_factPolicyTransaction_AgeBandSK] ON [dbo].[factPolicyTransaction]
(
	[AgeBandSK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_factPolicyTransaction_AreaSK]    Script Date: 20/02/2025 10:26:12 AM ******/
CREATE NONCLUSTERED INDEX [idx_factPolicyTransaction_AreaSK] ON [dbo].[factPolicyTransaction]
(
	[AreaSK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_factPolicyTransaction_ConsultantSK]    Script Date: 20/02/2025 10:26:12 AM ******/
CREATE NONCLUSTERED INDEX [idx_factPolicyTransaction_ConsultantSK] ON [dbo].[factPolicyTransaction]
(
	[ConsultantSK] ASC
)
INCLUDE([OutletSK],[DateSK]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_factPolicyTransaction_DateSK]    Script Date: 20/02/2025 10:26:12 AM ******/
CREATE NONCLUSTERED INDEX [idx_factPolicyTransaction_DateSK] ON [dbo].[factPolicyTransaction]
(
	[DateSK] ASC,
	[OutletSK] ASC
)
INCLUDE([DomainSK],[Premium],[Commission],[PolicyCount]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_factPolicyTransaction_DestinationSK]    Script Date: 20/02/2025 10:26:12 AM ******/
CREATE NONCLUSTERED INDEX [idx_factPolicyTransaction_DestinationSK] ON [dbo].[factPolicyTransaction]
(
	[DestinationSK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_factPolicyTransaction_DomainSK]    Script Date: 20/02/2025 10:26:12 AM ******/
CREATE NONCLUSTERED INDEX [idx_factPolicyTransaction_DomainSK] ON [dbo].[factPolicyTransaction]
(
	[DomainSK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_factPolicyTransaction_DurationSK]    Script Date: 20/02/2025 10:26:12 AM ******/
CREATE NONCLUSTERED INDEX [idx_factPolicyTransaction_DurationSK] ON [dbo].[factPolicyTransaction]
(
	[DurationSK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_factPolicyTransaction_IssueDate]    Script Date: 20/02/2025 10:26:12 AM ******/
CREATE NONCLUSTERED INDEX [idx_factPolicyTransaction_IssueDate] ON [dbo].[factPolicyTransaction]
(
	[IssueDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_factPolicyTransaction_OutletSK]    Script Date: 20/02/2025 10:26:12 AM ******/
CREATE NONCLUSTERED INDEX [idx_factPolicyTransaction_OutletSK] ON [dbo].[factPolicyTransaction]
(
	[OutletSK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_factPolicyTransaction_PaymentSK]    Script Date: 20/02/2025 10:26:12 AM ******/
CREATE NONCLUSTERED INDEX [idx_factPolicyTransaction_PaymentSK] ON [dbo].[factPolicyTransaction]
(
	[PaymentSK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_factPolicyTransaction_PolicySK]    Script Date: 20/02/2025 10:26:12 AM ******/
CREATE NONCLUSTERED INDEX [idx_factPolicyTransaction_PolicySK] ON [dbo].[factPolicyTransaction]
(
	[PolicySK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_factPolicyTransaction_PostingDate]    Script Date: 20/02/2025 10:26:12 AM ******/
CREATE NONCLUSTERED INDEX [idx_factPolicyTransaction_PostingDate] ON [dbo].[factPolicyTransaction]
(
	[PostingDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_factPolicyTransaction_ProductSK]    Script Date: 20/02/2025 10:26:12 AM ******/
CREATE NONCLUSTERED INDEX [idx_factPolicyTransaction_ProductSK] ON [dbo].[factPolicyTransaction]
(
	[ProductSK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_factPolicyTransaction_PromotionSK]    Script Date: 20/02/2025 10:26:12 AM ******/
CREATE NONCLUSTERED INDEX [idx_factPolicyTransaction_PromotionSK] ON [dbo].[factPolicyTransaction]
(
	[PromotionSK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
