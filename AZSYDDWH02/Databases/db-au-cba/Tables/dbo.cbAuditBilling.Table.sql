USE [db-au-cba]
GO
/****** Object:  Table [dbo].[cbAuditBilling]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cbAuditBilling](
	[BIRowID] [bigint] IDENTITY(1,1) NOT NULL,
	[AuditUser] [nvarchar](255) NULL,
	[AuditDateTime] [datetime] NULL,
	[AuditDateTimeUTC] [datetime] NULL,
	[AuditAction] [nvarchar](10) NULL,
	[CountryKey] [nvarchar](2) NOT NULL,
	[CaseKey] [nvarchar](20) NOT NULL,
	[BillingKey] [nvarchar](20) NOT NULL,
	[AddressKey] [nvarchar](20) NULL,
	[CaseNo] [nvarchar](15) NOT NULL,
	[BillingID] [int] NOT NULL,
	[OpenDate] [datetime] NULL,
	[OpenTimeUTC] [datetime] NULL,
	[SentDate] [datetime] NULL,
	[SentTimeUTC] [datetime] NULL,
	[OpenedByID] [nvarchar](30) NULL,
	[OpenedBy] [nvarchar](55) NULL,
	[ProcessedBy] [nvarchar](30) NULL,
	[BillingTypeCode] [nvarchar](10) NULL,
	[BillingType] [nvarchar](100) NULL,
	[InvoiceNo] [nvarchar](50) NULL,
	[InvoiceDate] [datetime] NULL,
	[BillItem] [nvarchar](20) NULL,
	[Provider] [nvarchar](200) NULL,
	[Details] [nvarchar](1500) NULL,
	[PaymentBy] [nvarchar](50) NULL,
	[PaymentDate] [datetime] NULL,
	[LocalCurrencyCode] [nvarchar](3) NULL,
	[LocalCurrency] [nvarchar](20) NULL,
	[LocalInvoice] [money] NULL,
	[ExchangeRate] [money] NULL,
	[AUDInvoice] [money] NULL,
	[AUDGST] [money] NULL,
	[CostContainmentAgent] [nvarchar](25) NULL,
	[BackFrontEnd] [nvarchar](50) NULL,
	[CCInvoiceAmount] [money] NULL,
	[CCSaving] [money] NULL,
	[CCDiscountedInvoice] [money] NULL,
	[CustomerPayment] [money] NULL,
	[ClientPayment] [money] NULL,
	[PPOFee] [money] NULL,
	[TotalDueCCAgent] [money] NULL,
	[CCFee] [money] NULL,
	[isImported] [bit] NULL,
	[isDeleted] [bit] NULL
) ON [PRIMARY]
GO
/****** Object:  Index [idx_cbAuditBilling_BIRowID]    Script Date: 20/02/2025 10:13:01 AM ******/
CREATE CLUSTERED INDEX [idx_cbAuditBilling_BIRowID] ON [dbo].[cbAuditBilling]
(
	[BIRowID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_cbAuditBilling_AuditDateTime]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_cbAuditBilling_AuditDateTime] ON [dbo].[cbAuditBilling]
(
	[AuditDateTime] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_cbAuditBilling_BillingKey]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_cbAuditBilling_BillingKey] ON [dbo].[cbAuditBilling]
(
	[BillingKey] ASC,
	[AuditDateTime] ASC
)
INCLUDE([AuditDateTimeUTC]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
