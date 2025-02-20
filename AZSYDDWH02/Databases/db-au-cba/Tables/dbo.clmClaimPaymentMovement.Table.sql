USE [db-au-cba]
GO
/****** Object:  Table [dbo].[clmClaimPaymentMovement]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[clmClaimPaymentMovement](
	[BIRowID] [int] IDENTITY(1,1) NOT NULL,
	[ClaimKey] [varchar](40) NOT NULL,
	[SectionKey] [varchar](40) NOT NULL,
	[PaymentKey] [varchar](40) NOT NULL,
	[BenefitCategory] [varchar](35) NOT NULL,
	[SectionCode] [varchar](25) NULL,
	[FirstPayment] [bit] NOT NULL,
	[FirstMonthPayment] [bit] NOT NULL,
	[PaymentStatus] [varchar](4) NULL,
	[PaymentDate] [date] NULL,
	[PaymentDateUTC] [date] NULL,
	[AllMovement] [money] NULL,
	[PaymentMovement] [money] NULL,
	[RecoveryPaymentMovement] [money] NULL,
	[BatchID] [int] NULL,
	[PaymentDateTime] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Index [idx_clmClaimPaymentMovement_BIRowID]    Script Date: 20/02/2025 10:13:01 AM ******/
CREATE CLUSTERED INDEX [idx_clmClaimPaymentMovement_BIRowID] ON [dbo].[clmClaimPaymentMovement]
(
	[BIRowID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_clmClaimPaymentMovement_ClaimKey]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_clmClaimPaymentMovement_ClaimKey] ON [dbo].[clmClaimPaymentMovement]
(
	[ClaimKey] ASC,
	[PaymentDate] ASC
)
INCLUDE([SectionKey],[FirstPayment],[FirstMonthPayment],[BenefitCategory],[PaymentStatus],[PaymentMovement],[RecoveryPaymentMovement],[AllMovement],[PaymentDateTime]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_clmClaimPaymentMovement_ClaimKeyUTC]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_clmClaimPaymentMovement_ClaimKeyUTC] ON [dbo].[clmClaimPaymentMovement]
(
	[ClaimKey] ASC,
	[PaymentDateUTC] ASC
)
INCLUDE([FirstPayment],[FirstMonthPayment],[BenefitCategory],[PaymentStatus],[PaymentMovement],[RecoveryPaymentMovement]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_clmClaimPaymentMovement_PaymentDate]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_clmClaimPaymentMovement_PaymentDate] ON [dbo].[clmClaimPaymentMovement]
(
	[PaymentDate] ASC,
	[PaymentDateTime] ASC
)
INCLUDE([ClaimKey],[SectionKey],[PaymentMovement],[RecoveryPaymentMovement],[AllMovement]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_clmClaimPaymentMovement_SectionKey]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_clmClaimPaymentMovement_SectionKey] ON [dbo].[clmClaimPaymentMovement]
(
	[SectionKey] ASC,
	[PaymentDate] ASC
)
INCLUDE([FirstPayment],[FirstMonthPayment],[BenefitCategory],[PaymentStatus],[PaymentMovement],[RecoveryPaymentMovement],[PaymentDateTime],[ClaimKey]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
