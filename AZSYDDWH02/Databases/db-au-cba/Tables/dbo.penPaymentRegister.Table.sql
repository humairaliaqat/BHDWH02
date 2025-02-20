USE [db-au-cba]
GO
/****** Object:  Table [dbo].[penPaymentRegister]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[penPaymentRegister](
	[CountryKey] [varchar](2) NULL,
	[CompanyKey] [varchar](5) NULL,
	[DomainKey] [varchar](41) NULL,
	[PaymentRegisterKey] [varchar](41) NULL,
	[OutletKey] [varchar](41) NULL,
	[CRMUserKey] [varchar](41) NULL,
	[BankAccountKey] [varchar](41) NULL,
	[PaymentRegisterID] [int] NULL,
	[OutletID] [int] NULL,
	[CRMUserID] [int] NULL,
	[BankAccountID] [int] NULL,
	[PaymentStatus] [varchar](15) NULL,
	[PaymentTypeID] [int] NULL,
	[PaymentType] [varchar](55) NULL,
	[PaymentCode] [varchar](3) NULL,
	[PaymentSource] [varchar](50) NULL,
	[Comment] [varchar](500) NULL,
	[PaymentCreateDateTime] [datetime] NULL,
	[PaymentUpdateDateTime] [datetime] NULL,
	[PaymentCreateDateTimeUTC] [datetime] NULL,
	[PaymentUpdateDateTimeUTC] [datetime] NULL,
	[DomainID] [int] NULL,
	[TripsAccount] [varchar](4) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_penPaymentRegister_PaymentRegisterKey]    Script Date: 20/02/2025 10:13:01 AM ******/
CREATE CLUSTERED INDEX [idx_penPaymentRegister_PaymentRegisterKey] ON [dbo].[penPaymentRegister]
(
	[PaymentRegisterKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_penPaymentRegister_BankAccountKey]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_penPaymentRegister_BankAccountKey] ON [dbo].[penPaymentRegister]
(
	[BankAccountKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_penPaymentRegister_CountryKey]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_penPaymentRegister_CountryKey] ON [dbo].[penPaymentRegister]
(
	[CountryKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_penPaymentRegister_CRMUserKey]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_penPaymentRegister_CRMUserKey] ON [dbo].[penPaymentRegister]
(
	[CRMUserKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_penPaymentRegister_OutletKey]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_penPaymentRegister_OutletKey] ON [dbo].[penPaymentRegister]
(
	[OutletKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
