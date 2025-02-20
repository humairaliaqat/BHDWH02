USE [db-au-star]
GO
/****** Object:  Table [dbo].[factClaimEstimateMovement]    Script Date: 20/02/2025 10:26:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[factClaimEstimateMovement](
	[BIRowID] [bigint] IDENTITY(1,1) NOT NULL,
	[AccountingDate] [date] NOT NULL,
	[UnderwritingDate] [date] NOT NULL,
	[DevelopmentDay] [bigint] NOT NULL,
	[DomainSK] [int] NOT NULL,
	[OutletSK] [int] NOT NULL,
	[AreaSK] [int] NOT NULL,
	[ProductSK] [int] NOT NULL,
	[ClaimSK] [bigint] NOT NULL,
	[ClaimEventSK] [bigint] NOT NULL,
	[BenefitSK] [bigint] NOT NULL,
	[ClaimKey] [varchar](40) NULL,
	[PolicyTransactionKey] [varchar](41) NULL,
	[SectionKey] [varchar](40) NOT NULL,
	[ClaimSizeType] [varchar](20) NULL,
	[EstimateGroup] [varchar](50) NULL,
	[EstimateCategory] [varchar](50) NULL,
	[PaymentEstimateMovement] [money] NOT NULL,
	[RecoveryEstimateMovement] [money] NOT NULL,
	[CreateBatchID] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Index [idx_factClaimEstimateMovement_BIRowID]    Script Date: 20/02/2025 10:26:11 AM ******/
CREATE CLUSTERED INDEX [idx_factClaimEstimateMovement_BIRowID] ON [dbo].[factClaimEstimateMovement]
(
	[BIRowID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_factClaimEstimateMovement_ClaimKey]    Script Date: 20/02/2025 10:26:12 AM ******/
CREATE NONCLUSTERED INDEX [idx_factClaimEstimateMovement_ClaimKey] ON [dbo].[factClaimEstimateMovement]
(
	[ClaimKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[factClaimEstimateMovement] ADD  DEFAULT ((0)) FOR [PaymentEstimateMovement]
GO
ALTER TABLE [dbo].[factClaimEstimateMovement] ADD  DEFAULT ((0)) FOR [RecoveryEstimateMovement]
GO
