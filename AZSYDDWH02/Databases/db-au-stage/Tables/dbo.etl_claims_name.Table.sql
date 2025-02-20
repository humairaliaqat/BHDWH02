USE [db-au-stage]
GO
/****** Object:  Table [dbo].[etl_claims_name]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[etl_claims_name](
	[CountryKey] [varchar](2) NULL,
	[NameKey] [varchar](64) NULL,
	[ClaimKey] [varchar](33) NULL,
	[NameID] [int] NOT NULL,
	[ClaimNo] [int] NULL,
	[Num] [smallint] NULL,
	[Surname] [nvarchar](100) NULL,
	[Firstname] [nvarchar](100) NULL,
	[Title] [nvarchar](50) NULL,
	[DOB] [date] NULL,
	[AddressStreet] [nvarchar](100) NULL,
	[AddressSuburb] [nvarchar](50) NULL,
	[AddressState] [nvarchar](100) NULL,
	[AddressCountry] [nvarchar](100) NULL,
	[AddressPostCode] [nvarchar](50) NULL,
	[HomePhone] [nvarchar](50) NULL,
	[WorkPhone] [nvarchar](50) NULL,
	[Fax] [varchar](20) NULL,
	[Email] [nvarchar](255) NULL,
	[isDirectCredit] [bit] NOT NULL,
	[AccountNo] [varchar](9) NULL,
	[AccountName] [nvarchar](200) NULL,
	[BSB] [varchar](6) NULL,
	[isPrimary] [bit] NOT NULL,
	[isThirdParty] [bit] NOT NULL,
	[isForeign] [bit] NOT NULL,
	[ProviderID] [int] NULL,
	[BusinessName] [varchar](30) NULL,
	[isEmailOK] [bit] NULL,
	[PaymentMethodID] [int] NULL,
	[EMC] [nvarchar](100) NULL,
	[ITC] [bit] NULL,
	[ITCPCT] [float] NULL,
	[isGST] [bit] NULL,
	[GSTPercentage] [float] NULL,
	[GoodsSupplier] [bit] NULL,
	[ServiceProvider] [bit] NULL,
	[SupplyBy] [int] NULL,
	[EncryptAccount] [varbinary](256) NULL,
	[EncryptBSB] [varbinary](256) NULL,
	[isPayer] [bit] NULL,
	[BankName] [nvarchar](50) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_primary]    Script Date: 20/02/2025 10:25:22 AM ******/
CREATE NONCLUSTERED INDEX [idx_primary] ON [dbo].[etl_claims_name]
(
	[ClaimKey] ASC
)
INCLUDE([NameKey],[NameID],[isPrimary],[isThirdParty]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
