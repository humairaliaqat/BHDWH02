USE [db-au-cba]
GO
/****** Object:  Table [dbo].[clmAudit]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[clmAudit](
	[CountryKey] [varchar](2) NOT NULL,
	[AuditKey] [varchar](40) NULL,
	[ClaimKey] [varchar](40) NULL,
	[AuditID] [int] NOT NULL,
	[ClaimNo] [int] NULL,
	[Item] [int] NULL,
	[PayID] [int] NULL,
	[PayeeID] [int] NULL,
	[AccountID] [int] NULL,
	[OfficerID] [int] NULL,
	[BatchNo] [int] NULL,
	[isDeleted] [bit] NULL,
	[isSullied] [bit] NOT NULL,
	[ProductCode] [varchar](4) NULL,
	[SectionCode] [varchar](25) NULL,
	[SectionDesc] [varchar](200) NULL,
	[LossDate] [datetime] NULL,
	[Pseudo] [int] NULL,
	[ChequeNo] [bigint] NULL,
	[PolAct] [datetime] NULL,
	[PayeeName] [varchar](80) NULL,
	[InsuredName] [varchar](80) NULL,
	[LetName] [varchar](80) NULL,
	[LetTitle] [varchar](100) NULL,
	[LetInitial] [varchar](15) NULL,
	[Street] [varchar](100) NULL,
	[Suburb] [varchar](20) NULL,
	[State] [varchar](5) NULL,
	[Postcode] [varchar](8) NULL,
	[WordingID] [int] NULL,
	[WordVar1] [varchar](25) NULL,
	[WordVar2] [varchar](15) NULL,
	[WordVar3] [varchar](15) NULL,
	[Wording] [varchar](255) NULL,
	[BillAmount] [money] NULL,
	[CurrencyCode] [varchar](4) NULL,
	[ForeignExchangeRate] [float] NULL,
	[AUDAmount] [money] NULL,
	[Excess] [money] NULL,
	[DEPV] [money] NULL,
	[Other] [money] NULL,
	[GST] [money] NULL,
	[Value] [money] NULL,
	[ModifyDateTime] [datetime] NULL,
	[PayMethod] [varchar](4) NULL,
	[AddresseeID] [int] NULL,
	[DFTPayeeID] [int] NULL,
	[DFTPayee] [varchar](50) NULL,
	[StartClaimNo] [int] NULL,
	[EndClaimNo] [int] NULL,
	[StartAccountingPeriod] [datetime] NULL,
	[EndAccountingPeriod] [datetime] NULL,
	[ChqTempID] [int] NULL,
	[IssuedDate] [datetime] NULL,
	[PayDate] [datetime] NULL,
	[isDirectCredit] [bit] NULL,
	[AccountNo] [varchar](20) NULL,
	[AccountName] [char](80) NULL,
	[BSB] [varchar](15) NULL,
	[isForeign] [bit] NULL,
	[BusinessName] [varchar](30) NULL,
	[isEmailOK] [bit] NULL,
	[EmailAddress] [varchar](60) NULL,
	[isThirdParty] [bit] NULL,
	[isAuthorised] [bit] NULL,
	[AuthorisedValue] [varchar](20) NULL,
	[BatchStatus] [varchar](4) NULL,
	[InvoiceNo] [varchar](100) NULL,
	[PayStatus] [varchar](4) NULL,
	[isFileCreated] [bit] NULL,
	[EncryptAccountNo] [varbinary](256) NULL,
	[EncryptBSB] [varbinary](256) NULL,
	[isProvider] [bit] NULL,
	[isSelect] [bit] NULL,
	[ITCAdj] [money] NULL,
	[AuthorisedDate] [datetime] NULL,
	[AuthorisedOfficerID] [int] NULL,
	[AuthorisedOfficerLevel] [varchar](1) NULL,
	[SecondaryAuthorisedDate] [datetime] NULL,
	[SecondaryAuthorisedOfficerID] [int] NULL,
	[SecondaryAuthorisedOfficerLevel] [varchar](1) NULL
) ON [PRIMARY]
GO
/****** Object:  Index [idx_clmAudit_AuditID]    Script Date: 20/02/2025 10:13:01 AM ******/
CREATE CLUSTERED INDEX [idx_clmAudit_AuditID] ON [dbo].[clmAudit]
(
	[AuditID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_clmAudit_AuditKey]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_clmAudit_AuditKey] ON [dbo].[clmAudit]
(
	[AuditKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_clmAudit_ClaimKey]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_clmAudit_ClaimKey] ON [dbo].[clmAudit]
(
	[ClaimKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
