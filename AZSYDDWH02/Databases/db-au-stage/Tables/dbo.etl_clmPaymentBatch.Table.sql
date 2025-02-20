USE [db-au-stage]
GO
/****** Object:  Table [dbo].[etl_clmPaymentBatch]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[etl_clmPaymentBatch](
	[CountryKey] [varchar](2) NULL,
	[PaymentBatchKey] [varchar](33) NULL,
	[ClaimKey] [varchar](33) NULL,
	[NameKey] [varchar](64) NULL,
	[PaymentBatchID] [int] NOT NULL,
	[ClaimNo] [int] NULL,
	[PaymentID] [int] NULL,
	[PayeeID] [int] NULL,
	[AddresseeID] [int] NULL,
	[AccountID] [int] NULL,
	[BatchNo] [int] NULL,
	[BatchStatus] [varchar](4) NULL,
	[ChequeNo] [bigint] NULL,
	[isDeleted] [bit] NULL,
	[isSullied] [bit] NOT NULL,
	[Pseudo] [int] NULL,
	[StartClaimNo] [int] NULL,
	[EndClaimNo] [int] NULL,
	[StartAccountingPeriod] [date] NULL,
	[EndAccountingPeriod] [date] NULL,
	[PaymentDate] [date] NULL,
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
	[AccountName] [nvarchar](100) NULL,
	[BSB] [varchar](15) NULL,
	[BankName] [nvarchar](50) NULL,
	[OfficerID] [int] NULL,
	[OfficerName] [varchar](30) NULL,
	[PaymentModifiedDate] [datetime] NULL,
	[AuthorisedDate] [datetime] NULL,
	[SecondaryAuthorisedDate] [datetime] NULL,
	[PaymentModifiedDateTimeUTC] [datetime] NULL,
	[AuthorisedDateTimeUTC] [datetime] NULL,
	[SecondaryAuthorisedDateTimeUTC] [datetime] NULL,
	[isAuthorised] [bit] NOT NULL,
	[AuthorisedValue] [varchar](20) NULL,
	[AuthorisedOfficerID] [int] NULL,
	[AuthorisedOfficerName] [varchar](30) NULL,
	[SecondaryAuthorisedOfficerID] [int] NULL,
	[SecondaryAuthorisedOfficerName] [varchar](30) NULL,
	[ChequeWording] [nvarchar](255) NULL
) ON [PRIMARY]
GO
