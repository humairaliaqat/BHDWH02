USE [db-au-stage]
GO
/****** Object:  Table [dbo].[etl_dimPayment]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[etl_dimPayment](
	[PaymentKey] [varchar](41) NULL,
	[Country] [nvarchar](20) NOT NULL,
	[PolicyTransactionKey] [varchar](41) NULL,
	[PaymentRefID] [varchar](50) NULL,
	[OrderID] [varchar](50) NULL,
	[Status] [varchar](100) NULL,
	[PaymentAmount] [money] NULL,
	[ClientID] [int] NULL,
	[TransactionDate] [datetime] NULL,
	[TransactionDateUTC] [datetime] NULL,
	[MerchantID] [varchar](100) NULL,
	[ReceiptNo] [varchar](50) NULL,
	[ResponseDescription] [varchar](34) NULL,
	[TransactionNo] [varchar](50) NULL,
	[AuthoriseID] [varchar](50) NULL,
	[CardType] [varchar](50) NULL,
	[BatchNo] [varchar](20) NOT NULL,
	[PaymentGatewayID] [varchar](50) NULL,
	[PaymentMerchantID] [int] NULL,
	[PaymentMethod] [varchar](15) NOT NULL,
	[LoadDate] [datetime] NULL,
	[updateDate] [datetime] NULL,
	[LoadID] [int] NULL,
	[updateID] [int] NULL,
	[HashKey] [varbinary](30) NULL
) ON [PRIMARY]
GO
