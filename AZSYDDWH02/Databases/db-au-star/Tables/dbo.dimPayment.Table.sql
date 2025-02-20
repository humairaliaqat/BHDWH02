USE [db-au-star]
GO
/****** Object:  Table [dbo].[dimPayment]    Script Date: 20/02/2025 10:26:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dimPayment](
	[PaymentSK] [int] IDENTITY(1,1) NOT NULL,
	[Country] [nvarchar](10) NOT NULL,
	[PaymentKey] [nvarchar](50) NOT NULL,
	[PolicyTransactionKey] [nvarchar](50) NULL,
	[PaymentRefID] [nvarchar](50) NULL,
	[OrderID] [nvarchar](50) NULL,
	[Status] [nvarchar](100) NULL,
	[PaymentAmount] [money] NULL,
	[ClientID] [int] NULL,
	[TransactionDate] [datetime] NULL,
	[TransactionDateUTC] [datetime] NULL,
	[MerchantID] [nvarchar](100) NULL,
	[ReceiptNo] [nvarchar](50) NULL,
	[ResponseDescription] [nvarchar](50) NULL,
	[TransactionNo] [nvarchar](50) NULL,
	[AuthoriseID] [nvarchar](50) NULL,
	[CardType] [nvarchar](50) NULL,
	[BatchNo] [nvarchar](20) NULL,
	[PaymentGatewayID] [nvarchar](50) NULL,
	[PaymentMerchantID] [int] NULL,
	[PaymentMethod] [nvarchar](50) NULL,
	[LoadDate] [datetime] NOT NULL,
	[updateDate] [datetime] NULL,
	[LoadID] [int] NOT NULL,
	[updateID] [int] NULL,
	[HashKey] [varbinary](30) NULL
) ON [PRIMARY]
GO
/****** Object:  Index [idx_dimPayment_PaymentSK]    Script Date: 20/02/2025 10:26:12 AM ******/
CREATE CLUSTERED INDEX [idx_dimPayment_PaymentSK] ON [dbo].[dimPayment]
(
	[PaymentSK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_dimPayment_Country]    Script Date: 20/02/2025 10:26:12 AM ******/
CREATE NONCLUSTERED INDEX [idx_dimPayment_Country] ON [dbo].[dimPayment]
(
	[Country] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_dimPayment_HashKey]    Script Date: 20/02/2025 10:26:12 AM ******/
CREATE NONCLUSTERED INDEX [idx_dimPayment_HashKey] ON [dbo].[dimPayment]
(
	[HashKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_dimPayment_PaymentGatewayID]    Script Date: 20/02/2025 10:26:12 AM ******/
CREATE NONCLUSTERED INDEX [idx_dimPayment_PaymentGatewayID] ON [dbo].[dimPayment]
(
	[PaymentGatewayID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_dimPayment_PaymentKey]    Script Date: 20/02/2025 10:26:12 AM ******/
CREATE NONCLUSTERED INDEX [idx_dimPayment_PaymentKey] ON [dbo].[dimPayment]
(
	[PaymentKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_dimPayment_PaymentMethod]    Script Date: 20/02/2025 10:26:12 AM ******/
CREATE NONCLUSTERED INDEX [idx_dimPayment_PaymentMethod] ON [dbo].[dimPayment]
(
	[PaymentMethod] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_dimPayment_PolicyTransactionKey]    Script Date: 20/02/2025 10:26:12 AM ******/
CREATE NONCLUSTERED INDEX [idx_dimPayment_PolicyTransactionKey] ON [dbo].[dimPayment]
(
	[PolicyTransactionKey] ASC
)
INCLUDE([PaymentSK],[Country]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_dimPayment_TransactionDate]    Script Date: 20/02/2025 10:26:12 AM ******/
CREATE NONCLUSTERED INDEX [idx_dimPayment_TransactionDate] ON [dbo].[dimPayment]
(
	[TransactionDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
