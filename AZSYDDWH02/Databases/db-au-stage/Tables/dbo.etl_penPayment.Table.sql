USE [db-au-stage]
GO
/****** Object:  Table [dbo].[etl_penPayment]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[etl_penPayment](
	[CountryKey] [varchar](2) NULL,
	[CompanyKey] [varchar](5) NULL,
	[DomainKey] [varchar](41) NULL,
	[PaymentKey] [varchar](41) NULL,
	[PolicyTransactionKey] [varchar](41) NULL,
	[DomainID] [int] NOT NULL,
	[PaymentID] [int] NOT NULL,
	[PolicyTransactionID] [int] NULL,
	[PaymentRefID] [varchar](50) NULL,
	[OrderId] [varchar](50) NULL,
	[Status] [varchar](100) NULL,
	[Total] [money] NULL,
	[ClientID] [int] NULL,
	[TransTime] [datetime] NULL,
	[TransTimeUTC] [datetime] NULL,
	[MerchantID] [varchar](60) NULL,
	[ReceiptNo] [varchar](50) NULL,
	[ResponseDescription] [varchar](34) NULL,
	[ACQResponseCode] [varchar](50) NULL,
	[TransactionNo] [varchar](50) NULL,
	[AuthoriseID] [varchar](50) NULL,
	[CardType] [varchar](50) NULL,
	[BatchNo] [varchar](20) NULL,
	[TxnResponseCode] [varchar](5) NULL,
	[PaymentGatewayID] [varchar](50) NULL,
	[PaymentMerchantID] [int] NULL,
	[CreateDateTime] [datetime] NULL,
	[UpdateDateTime] [datetime] NULL,
	[Source] [nvarchar](50) NULL
) ON [PRIMARY]
GO
