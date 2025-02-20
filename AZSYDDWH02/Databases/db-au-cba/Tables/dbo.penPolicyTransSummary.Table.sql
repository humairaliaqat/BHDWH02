USE [db-au-cba]
GO
/****** Object:  Table [dbo].[penPolicyTransSummary]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[penPolicyTransSummary](
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
	[IssueDate] [date] NOT NULL,
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
	[TripCost] [nvarchar](50) NULL,
	[AllocationNumber] [int] NULL,
	[PaymentDate] [datetime] NULL,
	[TransactionStart] [datetime] NULL,
	[TransactionEnd] [datetime] NULL,
	[TaxAmountSD] [money] NULL,
	[TaxOnAgentCommissionSD] [money] NULL,
	[TaxAmountGST] [money] NULL,
	[TaxOnAgentCommissionGST] [money] NULL,
	[BasePremium] [money] NULL,
	[GrossPremium] [money] NULL,
	[Commission] [money] NULL,
	[DiscountPolicyTrans] [money] NULL,
	[GrossAdminFee] [money] NULL,
	[AdjustedNet] [money] NULL,
	[CommissionRatePolicyPrice] [numeric](15, 9) NULL,
	[DiscountRatePolicyPrice] [numeric](15, 9) NULL,
	[CommissionRateTravellerPrice] [numeric](15, 9) NULL,
	[DiscountRateTravellerPrice] [numeric](15, 9) NULL,
	[CommissionRateTravellerAddOnPrice] [numeric](15, 9) NULL,
	[DiscountRateTravellerAddOnPrice] [numeric](15, 9) NULL,
	[CommissionRateEMCPrice] [numeric](15, 9) NULL,
	[DiscountRateEMCPrice] [numeric](15, 9) NULL,
	[UnAdjBasePremium] [money] NULL,
	[UnAdjGrossPremium] [money] NULL,
	[UnAdjCommission] [money] NULL,
	[UnAdjDiscountPolicyTrans] [money] NULL,
	[UnAdjGrossAdminFee] [money] NULL,
	[UnAdjAdjustedNet] [money] NULL,
	[UnAdjCommissionRatePolicyPrice] [numeric](15, 9) NULL,
	[UnAdjDiscountRatePolicyPrice] [numeric](15, 9) NULL,
	[UnAdjCommissionRateTravellerPrice] [numeric](15, 9) NULL,
	[UnAdjDiscountRateTravellerPrice] [numeric](15, 9) NULL,
	[UnAdjCommissionRateTravellerAddOnPrice] [numeric](15, 9) NULL,
	[UnAdjDiscountRateTravellerAddOnPrice] [numeric](15, 9) NULL,
	[UnAdjCommissionRateEMCPrice] [numeric](15, 9) NULL,
	[UnAdjDiscountRateEMCPrice] [numeric](15, 9) NULL,
	[StoreCode] [varchar](10) NULL,
	[OutletAlphaKey] [nvarchar](50) NULL,
	[OutletSKey] [bigint] NULL,
	[NewPolicyCount] [int] NOT NULL,
	[BasePolicyCount] [int] NOT NULL,
	[AddonPolicyCount] [int] NOT NULL,
	[ExtensionPolicyCount] [int] NOT NULL,
	[CancelledPolicyCount] [int] NOT NULL,
	[CancelledAddonPolicyCount] [int] NOT NULL,
	[CANXPolicyCount] [int] NOT NULL,
	[DomesticPolicyCount] [int] NOT NULL,
	[InternationalPolicyCount] [int] NOT NULL,
	[TravellersCount] [int] NOT NULL,
	[AdultsCount] [int] NOT NULL,
	[ChildrenCount] [int] NOT NULL,
	[ChargedAdultsCount] [int] NOT NULL,
	[DomesticTravellersCount] [int] NOT NULL,
	[DomesticAdultsCount] [int] NOT NULL,
	[DomesticChildrenCount] [int] NOT NULL,
	[DomesticChargedAdultsCount] [int] NOT NULL,
	[InternationalTravellersCount] [int] NOT NULL,
	[InternationalAdultsCount] [int] NOT NULL,
	[InternationalChildrenCount] [int] NOT NULL,
	[InternationalChargedAdultsCount] [int] NOT NULL,
	[NumberofDays] [int] NOT NULL,
	[LuggageCount] [int] NOT NULL,
	[MedicalCount] [int] NOT NULL,
	[MotorcycleCount] [int] NOT NULL,
	[RentalCarCount] [int] NOT NULL,
	[WintersportCount] [int] NOT NULL,
	[AttachmentCount] [int] NOT NULL,
	[EMCCount] [int] NOT NULL,
	[InternationalNewPolicyCount] [int] NOT NULL,
	[InternationalCANXPolicyCount] [int] NOT NULL,
	[ProductCode] [nvarchar](50) NULL,
	[PurchasePath] [nvarchar](50) NULL,
	[SingleFamilyFlag] [int] NULL,
	[isAMT] [bit] NULL,
	[IssueTime] [datetime] NULL,
	[ExternalReference] [nvarchar](100) NULL,
	[UnAdjTaxAmountSD] [money] NULL,
	[UnAdjTaxOnAgentCommissionSD] [money] NULL,
	[UnAdjTaxAmountGST] [money] NULL,
	[UnAdjTaxOnAgentCommissionGST] [money] NULL,
	[DomainKey] [varchar](41) NULL,
	[DomainID] [int] NULL,
	[IssueTimeUTC] [datetime] NULL,
	[PaymentDateUTC] [datetime] NULL,
	[TransactionStartUTC] [datetime] NULL,
	[TransactionEndUTC] [datetime] NULL,
	[CurrencyCode] [varchar](3) NULL,
	[CurrencySymbol] [varchar](10) NULL,
	[YAGOIssueDate] [date] NULL,
	[InboundPolicyCount] [int] NOT NULL,
	[InboundTravellersCount] [int] NOT NULL,
	[InboundAdultsCount] [int] NOT NULL,
	[InboundChildrenCount] [int] NOT NULL,
	[InboundChargedAdultsCount] [int] NOT NULL,
	[ImportDate] [datetime] NULL,
	[PostingDate] [datetime] NULL,
	[YAGOPostingDate] [date] NULL,
	[PostingTime] [datetime] NULL,
	[CompetitorName] [nvarchar](50) NULL,
	[CompetitorPrice] [money] NULL,
	[CanxCover] [int] NULL,
	[PaymentMode] [nvarchar](20) NULL,
	[PointsRedeemed] [money] NULL,
	[GigyaId] [nvarchar](300) NULL,
	[IssuingConsultantID] [int] NULL,
	[LeadTimeDate] [date] NULL,
	[RefundTransactionID] [int] NULL,
	[RefundTransactionKey] [varchar](41) NULL,
	[CancellationReason] [nvarchar](250) NULL
) ON [PRIMARY]
GO
/****** Object:  Index [idx_penPolicyTransSummary_IssueDate]    Script Date: 20/02/2025 10:13:01 AM ******/
CREATE CLUSTERED INDEX [idx_penPolicyTransSummary_IssueDate] ON [dbo].[penPolicyTransSummary]
(
	[IssueDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_penPolicyTransSummary_AccountingPeriod]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_penPolicyTransSummary_AccountingPeriod] ON [dbo].[penPolicyTransSummary]
(
	[OutletAlphaKey] ASC,
	[AccountingPeriod] ASC,
	[PaymentDate] ASC
)
INCLUDE([GrossPremium],[Commission],[GrossAdminFee],[PolicyTransactionKey],[AllocationNumber]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_penPolicyTransSummary_Competitor]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_penPolicyTransSummary_Competitor] ON [dbo].[penPolicyTransSummary]
(
	[CompetitorName] ASC
)
INCLUDE([PolicyTransactionKey],[CompetitorPrice]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_penPolicyTransSummary_ExternalReference]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_penPolicyTransSummary_ExternalReference] ON [dbo].[penPolicyTransSummary]
(
	[ExternalReference] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_penPolicyTransSummary_ImportDate]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_penPolicyTransSummary_ImportDate] ON [dbo].[penPolicyTransSummary]
(
	[ImportDate] ASC
)
INCLUDE([PolicyNumber],[IssueDate],[GrossPremium],[OutletAlphaKey]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_penPolicyTransSummary_OutletAlphaKey]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_penPolicyTransSummary_OutletAlphaKey] ON [dbo].[penPolicyTransSummary]
(
	[OutletAlphaKey] ASC,
	[PaymentDate] ASC
)
INCLUDE([PolicyTransactionKey],[IssueDate],[PostingDate],[AccountingPeriod],[GrossPremium],[Commission],[GrossAdminFee]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_penPolicyTransSummary_OutletSKey]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_penPolicyTransSummary_OutletSKey] ON [dbo].[penPolicyTransSummary]
(
	[OutletSKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_penPolicyTransSummary_PaymentDate]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_penPolicyTransSummary_PaymentDate] ON [dbo].[penPolicyTransSummary]
(
	[PaymentDate] ASC,
	[IssueDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_penPolicyTransSummary_PolicyKey]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_penPolicyTransSummary_PolicyKey] ON [dbo].[penPolicyTransSummary]
(
	[PolicyKey] ASC
)
INCLUDE([PolicyTransactionKey],[PolicyTransactionID],[TransactionStatus],[ParentID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_penPolicyTransSummary_PolicyNumber]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_penPolicyTransSummary_PolicyNumber] ON [dbo].[penPolicyTransSummary]
(
	[PolicyNumber] ASC,
	[CountryKey] ASC
)
INCLUDE([PolicyTransactionKey],[OutletAlphaKey]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_penPolicyTransSummary_PolicyTransactionKey]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_penPolicyTransSummary_PolicyTransactionKey] ON [dbo].[penPolicyTransSummary]
(
	[PolicyTransactionKey] ASC
)
INCLUDE([IssueDate],[PostingDate],[PolicyKey],[PolicyNumber],[ParentID],[OutletAlphaKey],[UnAdjGrossPremium],[UnAdjTaxAmountGST],[UnAdjTaxAmountSD],[UnAdjCommission],[UnAdjGrossAdminFee],[UnAdjTaxOnAgentCommissionGST],[UnAdjTaxOnAgentCommissionSD],[GrossPremium],[TaxAmountGST],[TaxAmountSD],[Commission],[GrossAdminFee],[TaxOnAgentCommissionGST],[TaxOnAgentCommissionSD],[RiskNet]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_penPolicyTransSummary_PostingDate]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_penPolicyTransSummary_PostingDate] ON [dbo].[penPolicyTransSummary]
(
	[PostingDate] ASC,
	[OutletAlphaKey] ASC
)
INCLUDE([PolicyTransactionKey],[IssueDate],[PolicyKey],[UserKey]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_penPolicyTransSummary_UserKey]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_penPolicyTransSummary_UserKey] ON [dbo].[penPolicyTransSummary]
(
	[UserKey] ASC
)
INCLUDE([IssueDate]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_penPolicyTransSummary_YAGOIssueDate]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_penPolicyTransSummary_YAGOIssueDate] ON [dbo].[penPolicyTransSummary]
(
	[YAGOIssueDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_penPolicyTransSummary_YAGOPostingDate]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_penPolicyTransSummary_YAGOPostingDate] ON [dbo].[penPolicyTransSummary]
(
	[YAGOPostingDate] ASC,
	[OutletAlphaKey] ASC
)
INCLUDE([PolicyTransactionKey],[YAGOIssueDate],[PolicyKey],[UserKey]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[penPolicyTransSummary] ADD  DEFAULT ((0)) FOR [NewPolicyCount]
GO
ALTER TABLE [dbo].[penPolicyTransSummary] ADD  DEFAULT ((0)) FOR [BasePolicyCount]
GO
ALTER TABLE [dbo].[penPolicyTransSummary] ADD  DEFAULT ((0)) FOR [AddonPolicyCount]
GO
ALTER TABLE [dbo].[penPolicyTransSummary] ADD  DEFAULT ((0)) FOR [ExtensionPolicyCount]
GO
ALTER TABLE [dbo].[penPolicyTransSummary] ADD  DEFAULT ((0)) FOR [CancelledPolicyCount]
GO
ALTER TABLE [dbo].[penPolicyTransSummary] ADD  DEFAULT ((0)) FOR [CancelledAddonPolicyCount]
GO
ALTER TABLE [dbo].[penPolicyTransSummary] ADD  DEFAULT ((0)) FOR [CANXPolicyCount]
GO
ALTER TABLE [dbo].[penPolicyTransSummary] ADD  DEFAULT ((0)) FOR [DomesticPolicyCount]
GO
ALTER TABLE [dbo].[penPolicyTransSummary] ADD  DEFAULT ((0)) FOR [InternationalPolicyCount]
GO
ALTER TABLE [dbo].[penPolicyTransSummary] ADD  DEFAULT ((0)) FOR [TravellersCount]
GO
ALTER TABLE [dbo].[penPolicyTransSummary] ADD  DEFAULT ((0)) FOR [AdultsCount]
GO
ALTER TABLE [dbo].[penPolicyTransSummary] ADD  DEFAULT ((0)) FOR [ChildrenCount]
GO
ALTER TABLE [dbo].[penPolicyTransSummary] ADD  DEFAULT ((0)) FOR [ChargedAdultsCount]
GO
ALTER TABLE [dbo].[penPolicyTransSummary] ADD  DEFAULT ((0)) FOR [DomesticTravellersCount]
GO
ALTER TABLE [dbo].[penPolicyTransSummary] ADD  DEFAULT ((0)) FOR [DomesticAdultsCount]
GO
ALTER TABLE [dbo].[penPolicyTransSummary] ADD  DEFAULT ((0)) FOR [DomesticChildrenCount]
GO
ALTER TABLE [dbo].[penPolicyTransSummary] ADD  DEFAULT ((0)) FOR [DomesticChargedAdultsCount]
GO
ALTER TABLE [dbo].[penPolicyTransSummary] ADD  DEFAULT ((0)) FOR [InternationalTravellersCount]
GO
ALTER TABLE [dbo].[penPolicyTransSummary] ADD  DEFAULT ((0)) FOR [InternationalAdultsCount]
GO
ALTER TABLE [dbo].[penPolicyTransSummary] ADD  DEFAULT ((0)) FOR [InternationalChildrenCount]
GO
ALTER TABLE [dbo].[penPolicyTransSummary] ADD  DEFAULT ((0)) FOR [InternationalChargedAdultsCount]
GO
ALTER TABLE [dbo].[penPolicyTransSummary] ADD  DEFAULT ((0)) FOR [NumberofDays]
GO
ALTER TABLE [dbo].[penPolicyTransSummary] ADD  DEFAULT ((0)) FOR [LuggageCount]
GO
ALTER TABLE [dbo].[penPolicyTransSummary] ADD  DEFAULT ((0)) FOR [MedicalCount]
GO
ALTER TABLE [dbo].[penPolicyTransSummary] ADD  DEFAULT ((0)) FOR [MotorcycleCount]
GO
ALTER TABLE [dbo].[penPolicyTransSummary] ADD  DEFAULT ((0)) FOR [RentalCarCount]
GO
ALTER TABLE [dbo].[penPolicyTransSummary] ADD  DEFAULT ((0)) FOR [WintersportCount]
GO
ALTER TABLE [dbo].[penPolicyTransSummary] ADD  DEFAULT ((0)) FOR [AttachmentCount]
GO
ALTER TABLE [dbo].[penPolicyTransSummary] ADD  DEFAULT ((0)) FOR [EMCCount]
GO
ALTER TABLE [dbo].[penPolicyTransSummary] ADD  DEFAULT ((0)) FOR [InternationalNewPolicyCount]
GO
ALTER TABLE [dbo].[penPolicyTransSummary] ADD  DEFAULT ((0)) FOR [InternationalCANXPolicyCount]
GO
ALTER TABLE [dbo].[penPolicyTransSummary] ADD  DEFAULT ((0)) FOR [InboundPolicyCount]
GO
ALTER TABLE [dbo].[penPolicyTransSummary] ADD  DEFAULT ((0)) FOR [InboundTravellersCount]
GO
ALTER TABLE [dbo].[penPolicyTransSummary] ADD  DEFAULT ((0)) FOR [InboundAdultsCount]
GO
ALTER TABLE [dbo].[penPolicyTransSummary] ADD  DEFAULT ((0)) FOR [InboundChildrenCount]
GO
ALTER TABLE [dbo].[penPolicyTransSummary] ADD  DEFAULT ((0)) FOR [InboundChargedAdultsCount]
GO
