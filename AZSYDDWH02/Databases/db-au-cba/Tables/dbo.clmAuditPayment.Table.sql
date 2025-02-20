USE [db-au-cba]
GO
/****** Object:  Table [dbo].[clmAuditPayment]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[clmAuditPayment](
	[CountryKey] [varchar](2) NOT NULL,
	[AuditKey] [varchar](50) NOT NULL,
	[ClaimKey] [varchar](40) NOT NULL,
	[AuditUserName] [nvarchar](150) NULL,
	[AuditDateTime] [datetime] NOT NULL,
	[AuditAction] [char](1) NOT NULL,
	[PaymentKey] [varchar](40) NULL,
	[EventKey] [varchar](40) NULL,
	[SectionKey] [varchar](40) NULL,
	[PaymentID] [int] NOT NULL,
	[ClaimNo] [int] NULL,
	[AddresseeID] [int] NULL,
	[ProviderID] [int] NULL,
	[ChequeID] [int] NULL,
	[EventID] [int] NULL,
	[SectionID] [int] NULL,
	[InvoiceID] [int] NULL,
	[AuthorisedID] [int] NULL,
	[CheckedOfficerID] [int] NULL,
	[AuthorisedOfficerName] [nvarchar](150) NULL,
	[CheckedOfficerName] [nvarchar](150) NULL,
	[WordingID] [int] NULL,
	[Method] [varchar](3) NULL,
	[CreatedByID] [int] NULL,
	[CreatedByName] [nvarchar](150) NULL,
	[Number] [smallint] NULL,
	[BillAmount] [money] NULL,
	[CurrencyCode] [varchar](3) NULL,
	[Rate] [float] NULL,
	[AUDAmount] [money] NULL,
	[DEPR] [float] NULL,
	[DEPV] [money] NULL,
	[Other] [money] NULL,
	[OtherDesc] [nvarchar](50) NULL,
	[PaymentStatus] [varchar](4) NULL,
	[GST] [money] NULL,
	[MaxPay] [money] NULL,
	[PaymentAmount] [money] NULL,
	[Payee] [nvarchar](200) NULL,
	[ModifiedByName] [nvarchar](150) NULL,
	[ModifiedDate] [datetime] NULL,
	[PropDate] [datetime] NULL,
	[PayeeID] [int] NULL,
	[BatchNo] [int] NULL,
	[DFTPayeeID] [int] NULL,
	[GSTAdjustedAmount] [money] NULL,
	[ExcessAmount] [money] NULL,
	[CreatedDate] [datetime] NULL,
	[GoodServ] [varchar](1) NULL,
	[TPLoc] [varchar](3) NULL,
	[GSTInc] [bit] NOT NULL,
	[PayeeType] [varchar](1) NULL,
	[ChequeNo] [bigint] NULL,
	[ChequeStatus] [varchar](4) NULL,
	[BankRef] [int] NULL,
	[DAMOutcome] [money] NULL,
	[ITCOutcome] [money] NULL,
	[ITCAdjustedAmount] [money] NULL,
	[Supply] [int] NULL,
	[Invoice] [nvarchar](100) NULL,
	[Taxable] [bit] NULL,
	[GSTOutcome] [money] NULL,
	[PayMethod_ID] [int] NULL,
	[GSTPercentage] [numeric](18, 0) NULL,
	[FirstOccurrenceIndicator] [bit] NULL,
	[ValidTransactionsIndicator] [bit] NULL,
	[PayeeKey] [varchar](40) NULL,
	[ChequeKey] [varchar](40) NULL,
	[BIRowID] [int] IDENTITY(1,1) NOT NULL,
	[CreateBatchID] [int] NULL,
	[UpdateBatchID] [int] NULL,
	[AuditDateTimeUTC] [datetime] NULL,
	[ModifiedDateTimeUTC] [datetime] NULL,
	[PropDateTimeUTC] [datetime] NULL,
	[CreatedDateTimeUTC] [datetime] NULL,
	[UTRNumber] [varchar](16) NULL,
	[CHQDate] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Index [idx_clmAuditPayment_BIRowID]    Script Date: 20/02/2025 10:13:01 AM ******/
CREATE CLUSTERED INDEX [idx_clmAuditPayment_BIRowID] ON [dbo].[clmAuditPayment]
(
	[BIRowID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_clmAuditPayment_AuditDateTime]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_clmAuditPayment_AuditDateTime] ON [dbo].[clmAuditPayment]
(
	[AuditDateTime] ASC
)
INCLUDE([CountryKey],[ClaimKey],[PayeeID],[PaymentKey],[PayeeKey]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_clmAuditPayment_AuditKey]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_clmAuditPayment_AuditKey] ON [dbo].[clmAuditPayment]
(
	[AuditKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_clmAuditPayment_ClaimKey]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_clmAuditPayment_ClaimKey] ON [dbo].[clmAuditPayment]
(
	[ClaimKey] ASC
)
INCLUDE([CountryKey],[ClaimNo],[PayeeID],[PayeeKey],[BatchNo],[PaymentID],[PaymentKey],[PaymentStatus],[FirstOccurrenceIndicator],[ValidTransactionsIndicator]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_clmAuditPayment_PaymentKey]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_clmAuditPayment_PaymentKey] ON [dbo].[clmAuditPayment]
(
	[PaymentKey] ASC,
	[AuditDateTime] ASC
)
INCLUDE([CountryKey],[ClaimNo],[ClaimKey],[PayeeID],[PayeeKey],[BatchNo],[PaymentID],[PaymentStatus],[FirstOccurrenceIndicator],[ValidTransactionsIndicator],[AuditKey],[AuditAction]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
