USE [db-au-stage]
GO
/****** Object:  Table [dbo].[etl_penCreditCardReconcileTransaction]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[etl_penCreditCardReconcileTransaction](
	[CountryKey] [varchar](2) NULL,
	[CompanyKey] [varchar](5) NULL,
	[DomainKey] [varchar](41) NULL,
	[CreditCardReconcileTransactionKey] [varchar](71) NULL,
	[CreditCardReconcileKey] [varchar](71) NULL,
	[PolicyTransactionKey] [varchar](71) NULL,
	[OutletKey] [varchar](71) NULL,
	[CreditCardReconcileTransactionID] [int] NOT NULL,
	[CreditCardReconcileID] [int] NOT NULL,
	[PolicyTransactionID] [int] NULL,
	[Net] [money] NOT NULL,
	[Commission] [money] NOT NULL,
	[Gross] [money] NOT NULL,
	[AmountType] [varchar](15) NOT NULL,
	[PaymentTypeID] [int] NOT NULL,
	[PaymentTypeName] [varchar](55) NULL,
	[PaymentTypeCode] [varchar](3) NULL,
	[Status] [varchar](15) NOT NULL,
	[OutletID] [int] NOT NULL,
	[AlphaCode] [varchar](20) NOT NULL,
	[CreateDateTime] [datetime] NULL,
	[CreateDateTimeUTC] [datetime] NOT NULL,
	[UpdateDateTime] [datetime] NULL,
	[UpdateDateTimeUTC] [datetime] NOT NULL
) ON [PRIMARY]
GO
