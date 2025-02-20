USE [db-au-cba]
GO
/****** Object:  Table [dbo].[corpBankPayment]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[corpBankPayment](
	[CountryKey] [varchar](2) NOT NULL,
	[PaymentKey] [varchar](10) NULL,
	[BankRecordKey] [varchar](10) NULL,
	[PendingRecordKey] [varchar](10) NULL,
	[PaymentID] [int] NOT NULL,
	[BankRecord] [int] NULL,
	[PendingRecord] [int] NULL,
	[PayType] [varchar](5) NULL,
	[Payer] [varchar](50) NULL,
	[BSB] [int] NULL,
	[ChequeNo] [float] NULL,
	[CreditCardType] [varchar](15) NULL,
	[CreditCardNo] [varchar](50) NULL,
	[CreditCardExpiryDate] [datetime] NULL,
	[Amount] [money] NULL,
	[Comment] [varchar](100) NULL,
	[isPartPayment] [bit] NULL,
	[IncludeCommission] [bit] NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_corpBankPayment_BankRecordKey]    Script Date: 20/02/2025 10:13:01 AM ******/
CREATE CLUSTERED INDEX [idx_corpBankPayment_BankRecordKey] ON [dbo].[corpBankPayment]
(
	[BankRecordKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
