USE [db-au-stage]
GO
/****** Object:  Table [dbo].[etl_claims_payment]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[etl_claims_payment](
	[CountryKey] [varchar](2) NULL,
	[ClaimKey] [varchar](33) NULL,
	[PaymentKey] [varchar](126) NULL,
	[AddresseeKey] [varchar](64) NULL,
	[ProviderKey] [varchar](64) NULL,
	[EventKey] [varchar](64) NULL,
	[SectionKey] [varchar](95) NULL,
	[PayeeKey] [varchar](64) NULL,
	[ChequeKey] [varchar](64) NULL,
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
	[AuthorisedOfficerName] [varchar](30) NULL,
	[CheckedOfficerName] [varchar](30) NULL,
	[WordingID] [int] NULL,
	[Method] [varchar](3) NULL,
	[CreatedByID] [int] NULL,
	[CreatedByName] [varchar](30) NULL,
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
	[ModifiedByName] [varchar](30) NULL,
	[ModifiedDate] [datetime] NULL,
	[PropDate] [datetime] NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedDateTimeUTC] [datetime] NULL,
	[PropDateTimeUTC] [datetime] NULL,
	[CreatedDateTimeUTC] [datetime] NULL,
	[PayeeID] [int] NULL,
	[BatchNo] [int] NULL,
	[DFTPayeeID] [int] NULL,
	[GSTAdjustedAmount] [money] NULL,
	[ExcessAmount] [money] NULL,
	[GoodServ] [varchar](1) NULL,
	[TPLoc] [varchar](3) NULL,
	[GSTInc] [bit] NOT NULL,
	[PayeeType] [varchar](1) NULL,
	[ChequeNo] [bigint] NULL,
	[ChequeStatus] [varchar](4) NULL,
	[DAMOutcome] [money] NULL,
	[ITCOutcome] [money] NULL,
	[ITCAdjustedAmount] [money] NULL,
	[Supply] [int] NULL,
	[Invoice] [nvarchar](100) NULL,
	[Taxable] [bit] NULL,
	[GSTOutcome] [money] NULL,
	[PayMethod_ID] [int] NULL,
	[GSTPercentage] [numeric](18, 0) NULL,
	[UTRNumber] [int] NULL,
	[CHQDate] [int] NULL
) ON [PRIMARY]
GO
