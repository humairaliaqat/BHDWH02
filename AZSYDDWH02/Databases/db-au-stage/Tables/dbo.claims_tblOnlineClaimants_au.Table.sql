USE [db-au-stage]
GO
/****** Object:  Table [dbo].[claims_tblOnlineClaimants_au]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[claims_tblOnlineClaimants_au](
	[ClaimantId] [int] NOT NULL,
	[PPMULT_ID] [int] NULL,
	[PreferredContact] [nvarchar](10) NULL,
	[Email] [nvarchar](255) NULL,
	[Street] [nvarchar](100) NULL,
	[Suburb] [nvarchar](50) NULL,
	[Postcode] [nvarchar](50) NULL,
	[State] [nvarchar](100) NULL,
	[Phone] [nvarchar](50) NULL,
	[WPhone] [nvarchar](50) NULL,
	[Fax] [varchar](30) NULL,
	[PreferredPayment] [nvarchar](20) NULL,
	[AccountName] [nvarchar](100) NULL,
	[DateBooked] [date] NULL,
	[DateDeparted] [date] NULL,
	[DateReturned] [date] NULL,
	[bitPastClaim] [bit] NULL,
	[bitHasCreditCard] [bit] NULL,
	[bitPurchaseOnCard] [bit] NULL,
	[bitOtherSourceClaim] [bit] NULL,
	[bitITC] [bit] NULL,
	[ITCRate] [numeric](5, 2) NULL,
	[ABN] [varchar](11) NULL,
	[OnlineClaimId] [int] NULL,
	[AccountNumberEncrypt] [varbinary](256) NULL,
	[BSBEncrypt] [varbinary](256) NULL,
	[bitHCInsurance] [bit] NULL,
	[HCInsurancer] [nvarchar](200) NULL,
	[bitHCClaim] [bit] NULL,
	[BankName] [nvarchar](50) NULL,
	[Country] [nvarchar](max) NULL,
	[NameOfbank] [nvarchar](100) NULL,
	[BranchStrtAddress] [nvarchar](max) NULL,
	[AccHolderAddress] [nvarchar](max) NULL,
	[FiscaleCode] [nvarchar](20) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Index [idx_claims_tblOnlineClaimants_au_id]    Script Date: 20/02/2025 10:25:21 AM ******/
CREATE CLUSTERED INDEX [idx_claims_tblOnlineClaimants_au_id] ON [dbo].[claims_tblOnlineClaimants_au]
(
	[OnlineClaimId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
