USE [db-au-cba]
GO
/****** Object:  Table [dbo].[penMonthEndProcessBatchTransaction]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[penMonthEndProcessBatchTransaction](
	[CountryKey] [varchar](2) NOT NULL,
	[CompanyKey] [varchar](5) NOT NULL,
	[DomainKey] [varchar](41) NOT NULL,
	[BatchKey] [varchar](41) NOT NULL,
	[BatchTransactionKey] [varchar](41) NOT NULL,
	[PaymentAllocationKey] [varchar](41) NULL,
	[OutletKey] [varchar](41) NOT NULL,
	[BatchID] [int] NULL,
	[BatchTransactionID] [int] NULL,
	[PaymentAllocationID] [int] NULL,
	[AlphaCode] [varchar](20) NULL,
	[CreateDateTime] [datetime] NULL,
	[UpdateDateTime] [datetime] NULL,
	[Amount] [money] NULL,
	[AllocationAmount] [money] NULL,
	[AmountType] [varchar](15) NULL,
	[Email] [varchar](255) NULL,
	[IsProcessed] [bit] NULL
) ON [PRIMARY]
GO
/****** Object:  Index [idx_penMonthEndProcessBatchTransaction_BatchTransactionID]    Script Date: 20/02/2025 10:13:01 AM ******/
CREATE CLUSTERED INDEX [idx_penMonthEndProcessBatchTransaction_BatchTransactionID] ON [dbo].[penMonthEndProcessBatchTransaction]
(
	[BatchTransactionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_penMonthEndProcessBatchTransaction_AlphaCode]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_penMonthEndProcessBatchTransaction_AlphaCode] ON [dbo].[penMonthEndProcessBatchTransaction]
(
	[AlphaCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_penMonthEndProcessBatchTransaction_BatchID]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_penMonthEndProcessBatchTransaction_BatchID] ON [dbo].[penMonthEndProcessBatchTransaction]
(
	[BatchID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_penMonthEndProcessBatchTransaction_BatchKey]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_penMonthEndProcessBatchTransaction_BatchKey] ON [dbo].[penMonthEndProcessBatchTransaction]
(
	[BatchKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_penMonthEndProcessBatchTransaction_CountryKey]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_penMonthEndProcessBatchTransaction_CountryKey] ON [dbo].[penMonthEndProcessBatchTransaction]
(
	[CountryKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_penMonthEndProcessBatchTransaction_CreateDateTime]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_penMonthEndProcessBatchTransaction_CreateDateTime] ON [dbo].[penMonthEndProcessBatchTransaction]
(
	[CreateDateTime] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
