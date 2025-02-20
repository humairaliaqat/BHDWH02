USE [db-au-cba]
GO
/****** Object:  Table [dbo].[penCreditCardReconcileTransaction]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[penCreditCardReconcileTransaction](
	[CountryKey] [varchar](2) NULL,
	[CompanyKey] [varchar](5) NULL,
	[DomainKey] [varchar](41) NULL,
	[CreditCardReconcileTransactionKey] [varchar](41) NULL,
	[CreditCardReconcileKey] [varchar](41) NULL,
	[PolicyTransactionKey] [varchar](41) NULL,
	[OutletKey] [varchar](41) NULL,
	[CreditCardReconcileTransactionID] [int] NULL,
	[CreditCardReconcileID] [int] NULL,
	[PolicyTransactionID] [int] NULL,
	[Net] [money] NULL,
	[Commission] [money] NULL,
	[Gross] [money] NULL,
	[AmountType] [varchar](15) NULL,
	[PaymentTypeID] [int] NULL,
	[PaymentTypeName] [varchar](55) NULL,
	[PaymentTypeCode] [varchar](3) NULL,
	[Status] [varchar](15) NULL,
	[OutletID] [int] NULL,
	[AlphaCode] [nvarchar](20) NULL,
	[CreateDateTime] [datetime] NULL,
	[CreateDateTimeUTC] [datetime] NULL,
	[UpdateDateTime] [datetime] NULL,
	[UpdateDateTimeUTC] [datetime] NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_penCreditCardReconcileTransaction_CreditCardReconcileTransactionKey]    Script Date: 20/02/2025 10:13:01 AM ******/
CREATE CLUSTERED INDEX [idx_penCreditCardReconcileTransaction_CreditCardReconcileTransactionKey] ON [dbo].[penCreditCardReconcileTransaction]
(
	[CreditCardReconcileTransactionKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_penCreditCardReconcileTransaction_CountryKey]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_penCreditCardReconcileTransaction_CountryKey] ON [dbo].[penCreditCardReconcileTransaction]
(
	[CountryKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_penCreditCardReconcileTransaction_CreditCardReconcileKey]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_penCreditCardReconcileTransaction_CreditCardReconcileKey] ON [dbo].[penCreditCardReconcileTransaction]
(
	[CreditCardReconcileKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_penCreditCardReconcileTransaction_OutletKey]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_penCreditCardReconcileTransaction_OutletKey] ON [dbo].[penCreditCardReconcileTransaction]
(
	[OutletKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_penCreditCardReconcileTransaction_PolicyTransactionKey]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_penCreditCardReconcileTransaction_PolicyTransactionKey] ON [dbo].[penCreditCardReconcileTransaction]
(
	[PolicyTransactionKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
