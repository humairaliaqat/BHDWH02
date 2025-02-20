USE [db-au-cba]
GO
/****** Object:  Table [dbo].[penPaymentAllocation]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[penPaymentAllocation](
	[CountryKey] [varchar](2) NULL,
	[CompanyKey] [varchar](5) NULL,
	[DomainKey] [varchar](41) NULL,
	[PaymentAllocationKey] [varchar](41) NULL,
	[OutletKey] [varchar](41) NULL,
	[CRMUserKey] [varchar](41) NULL,
	[PaymentAllocationID] [int] NOT NULL,
	[OutletID] [int] NOT NULL,
	[AlphaCode] [varchar](20) NOT NULL,
	[AccountingPeriod] [datetime] NULL,
	[AccountingPeriodUTC] [date] NOT NULL,
	[PaymentAmount] [money] NOT NULL,
	[AmountType] [varchar](15) NOT NULL,
	[Comments] [varchar](255) NULL,
	[Status] [varchar](15) NOT NULL,
	[Source] [varchar](50) NOT NULL,
	[CreateDateTime] [datetime] NULL,
	[UpdateDateTime] [datetime] NULL,
	[CreateDateTimeUTC] [datetime] NOT NULL,
	[UpdateDateTimeUTC] [datetime] NOT NULL,
	[PolicyAmount] [money] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_penPaymentAllocation_PaymentAllocationKey]    Script Date: 20/02/2025 10:13:01 AM ******/
CREATE CLUSTERED INDEX [idx_penPaymentAllocation_PaymentAllocationKey] ON [dbo].[penPaymentAllocation]
(
	[PaymentAllocationKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_penPaymentAllocation_CMRUserKey]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_penPaymentAllocation_CMRUserKey] ON [dbo].[penPaymentAllocation]
(
	[CRMUserKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_penPaymentAllocation_CountryKey]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_penPaymentAllocation_CountryKey] ON [dbo].[penPaymentAllocation]
(
	[CountryKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_penPaymentAllocation_OutletKey]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_penPaymentAllocation_OutletKey] ON [dbo].[penPaymentAllocation]
(
	[OutletKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
