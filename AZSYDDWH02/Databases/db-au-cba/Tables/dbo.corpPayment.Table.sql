USE [db-au-cba]
GO
/****** Object:  Table [dbo].[corpPayment]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[corpPayment](
	[CountryKey] [varchar](2) NOT NULL,
	[PaymentKey] [varchar](41) NULL,
	[RegistrationKey] [varchar](41) NULL,
	[PaymentID] [int] NULL,
	[RegistrationID] [int] NULL,
	[OrderID] [varchar](50) NULL,
	[Status] [varchar](100) NULL,
	[Total] [money] NULL,
	[ReceiptNo] [varchar](50) NULL,
	[PaymentDate] [datetime] NULL,
	[CardType] [varchar](20) NULL,
	[MerchantID] [varchar](16) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_corpPayment_PaymentKey]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_corpPayment_PaymentKey] ON [dbo].[corpPayment]
(
	[PaymentKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_corpPayment_RegistrationKey]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_corpPayment_RegistrationKey] ON [dbo].[corpPayment]
(
	[RegistrationKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
