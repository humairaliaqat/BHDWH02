USE [db-au-cba]
GO
/****** Object:  Table [dbo].[emcAuditPayment]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[emcAuditPayment](
	[CountryKey] [varchar](2) NOT NULL,
	[ApplicationKey] [varchar](15) NOT NULL,
	[AuditPaymentKey] [varchar](15) NOT NULL,
	[ApplicationID] [int] NOT NULL,
	[AuditPaymentID] [int] NOT NULL,
	[OrderID] [varchar](50) NULL,
	[AuditDate] [datetime] NULL,
	[AuditUserLogin] [varchar](50) NULL,
	[AuditUser] [varchar](255) NULL,
	[AuditAction] [varchar](5) NULL,
	[PaymentDate] [datetime] NULL,
	[EMCPremium] [decimal](18, 2) NOT NULL,
	[AgePremium] [decimal](18, 2) NOT NULL,
	[Excess] [decimal](18, 2) NOT NULL,
	[GeneralLimit] [decimal](18, 2) NOT NULL,
	[PaymentDuration] [varchar](15) NULL,
	[RestrictedConditions] [varchar](255) NULL,
	[OtherRestrictions] [varchar](255) NULL,
	[PaymentComments] [varchar](1000) NULL,
	[Surname] [varchar](22) NULL,
	[CardType] [varchar](6) NULL,
	[GST] [decimal](18, 2) NOT NULL,
	[MerchantID] [varchar](16) NULL,
	[ReceiptNo] [varchar](50) NULL,
	[TransactionResponseCode] [varchar](5) NULL,
	[ACQResponseCode] [varchar](50) NULL,
	[TransactionStatus] [varchar](100) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_emcAuditPayment_ApplicationID]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_emcAuditPayment_ApplicationID] ON [dbo].[emcAuditPayment]
(
	[ApplicationID] ASC,
	[CountryKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_emcAuditPayment_ApplicationKey]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_emcAuditPayment_ApplicationKey] ON [dbo].[emcAuditPayment]
(
	[ApplicationKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_emcAuditPayment_AuditDate]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_emcAuditPayment_AuditDate] ON [dbo].[emcAuditPayment]
(
	[AuditDate] ASC,
	[CountryKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_emcAuditPayment_AuditPaymentID]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_emcAuditPayment_AuditPaymentID] ON [dbo].[emcAuditPayment]
(
	[AuditPaymentID] ASC,
	[CountryKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_emcAuditPayment_CountryKey]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_emcAuditPayment_CountryKey] ON [dbo].[emcAuditPayment]
(
	[CountryKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_emcAuditPayment_OrderID]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_emcAuditPayment_OrderID] ON [dbo].[emcAuditPayment]
(
	[OrderID] ASC,
	[CountryKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_emcAuditPayment_PaymentDate]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_emcAuditPayment_PaymentDate] ON [dbo].[emcAuditPayment]
(
	[PaymentDate] ASC,
	[CountryKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
