USE [db-au-cba]
GO
/****** Object:  Table [dbo].[penAUDIT_payment]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[penAUDIT_payment](
	[CountryKey] [varchar](2) NOT NULL,
	[CompanyKey] [varchar](5) NOT NULL,
	[AuditPaymentKey] [varchar](41) NULL,
	[AUDIT_USER] [varchar](255) NULL,
	[AUDIT_DATETIME] [datetime] NULL,
	[AUDIT_DATETIME_UTC] [datetime] NULL,
	[PAYUNIQUE_ID] [int] NOT NULL,
	[PaymentId] [int] NULL,
	[PolicyTransactionId] [int] NULL,
	[PAYMENTREF_ID] [varchar](50) NULL,
	[ORDERID] [varchar](50) NULL,
	[STATUS] [varchar](100) NULL,
	[TOTAL] [money] NULL,
	[CLIENTID] [int] NULL,
	[TTIME] [datetime] NULL,
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
	[Source] [nvarchar](50) NULL,
	[AUDIT_ACTION] [nvarchar](100) NULL,
	[PaymentChannel] [nvarchar](100) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_penAudit_payment_AuditPaymentKey]    Script Date: 20/02/2025 10:13:01 AM ******/
CREATE CLUSTERED INDEX [idx_penAudit_payment_AuditPaymentKey] ON [dbo].[penAUDIT_payment]
(
	[AuditPaymentKey] ASC,
	[AUDIT_DATETIME] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
