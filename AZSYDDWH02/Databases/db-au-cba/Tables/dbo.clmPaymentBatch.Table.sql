USE [db-au-cba]
GO
/****** Object:  Table [dbo].[clmPaymentBatch]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[clmPaymentBatch](
	[BIRowID] [int] IDENTITY(1,1) NOT NULL,
	[CountryKey] [varchar](2) NOT NULL,
	[PaymentBatchKey] [varchar](40) NULL,
	[ClaimKey] [varchar](40) NULL,
	[NameKey] [varchar](40) NULL,
	[PaymentBatchID] [int] NULL,
	[ClaimNo] [int] NULL,
	[PaymentID] [int] NULL,
	[PayeeID] [int] NULL,
	[AddresseeID] [int] NULL,
	[AccountID] [int] NULL,
	[BatchNo] [int] NULL,
	[BatchStatus] [varchar](4) NULL,
	[ChequeNo] [bigint] NULL,
	[isDeleted] [bit] NULL,
	[isSullied] [bit] NULL,
	[Pseudo] [int] NULL,
	[StartClaimNo] [int] NULL,
	[EndClaimNo] [int] NULL,
	[StartAccountingPeriod] [datetime] NULL,
	[EndAccountingPeriod] [datetime] NULL,
	[PaymentDate] [datetime] NULL,
	[PaymentModifiedDate] [datetime] NULL,
	[PaymentMethod] [varchar](4) NULL,
	[PaymentStatus] [varchar](4) NULL,
	[CurrencyCode] [varchar](4) NULL,
	[ForeignExchangeRate] [float] NULL,
	[BillAmount] [money] NULL,
	[AUDAmount] [money] NULL,
	[Excess] [money] NULL,
	[DepreciationValue] [money] NULL,
	[Other] [money] NULL,
	[GST] [money] NULL,
	[ITCAdjustment] [money] NULL,
	[TotalValue] [money] NULL,
	[AccountNo] [varchar](20) NULL,
	[AccountName] [varchar](100) NULL,
	[BankName] [nvarchar](50) NULL,
	[BSB] [varchar](15) NULL,
	[OfficerID] [int] NULL,
	[OfficerName] [nvarchar](150) NULL,
	[isAuthorised] [bit] NULL,
	[AuthorisedValue] [varchar](20) NULL,
	[AuthorisedDate] [datetime] NULL,
	[AuthorisedOfficerID] [int] NULL,
	[AuthorisedOfficerName] [nvarchar](150) NULL,
	[SecondaryAuthorisedDate] [datetime] NULL,
	[SecondaryAuthorisedOfficerID] [int] NULL,
	[SecondaryAuthorisedOfficerName] [nvarchar](150) NULL,
	[CreateBatchID] [int] NULL,
	[UpdateBatchID] [int] NULL,
	[PaymentModifiedDateTimeUTC] [datetime] NULL,
	[AuthorisedDateTimeUTC] [datetime] NULL,
	[SecondaryAuthorisedDateTimeUTC] [datetime] NULL,
	[ChequeWording] [nvarchar](255) NULL
) ON [PRIMARY]
GO
/****** Object:  Index [idx_clmPaymentBatch_BIRowID]    Script Date: 20/02/2025 10:13:01 AM ******/
CREATE CLUSTERED INDEX [idx_clmPaymentBatch_BIRowID] ON [dbo].[clmPaymentBatch]
(
	[BIRowID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_clmPaymentBatch_ClaimKey]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_clmPaymentBatch_ClaimKey] ON [dbo].[clmPaymentBatch]
(
	[ClaimKey] ASC,
	[BatchNo] ASC,
	[PaymentID] ASC
)
INCLUDE([NameKey],[BatchStatus],[ChequeNo],[StartAccountingPeriod],[EndAccountingPeriod],[AuthorisedDate],[AuthorisedOfficerName],[SecondaryAuthorisedOfficerName]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_clmPaymentBatch_PaymentBatchKey]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_clmPaymentBatch_PaymentBatchKey] ON [dbo].[clmPaymentBatch]
(
	[PaymentBatchKey] ASC,
	[ClaimKey] ASC,
	[PaymentID] ASC
)
INCLUDE([BatchStatus],[BatchNo]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
