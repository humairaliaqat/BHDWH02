USE [db-au-stage]
GO
/****** Object:  Table [dbo].[penguin_tblOutletFinancialInfo_aucm]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[penguin_tblOutletFinancialInfo_aucm](
	[OutletID] [int] NOT NULL,
	[Title] [nvarchar](50) NULL,
	[AcctOfficerFirstName] [nvarchar](50) NULL,
	[AcctOfficerLastName] [nvarchar](50) NULL,
	[AcctOfficerEmail] [nvarchar](100) NULL,
	[PaymentTypeID] [int] NULL,
	[AccountName] [nvarchar](100) NULL,
	[BSB] [nvarchar](50) NULL,
	[AccountsEmail] [nvarchar](100) NULL,
	[CCSaleOnly] [int] NULL,
	[AccountNumber] [varbinary](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Index [idx_penguin_tblOutletFinancialInfo_aucm_OutletID]    Script Date: 20/02/2025 10:25:22 AM ******/
CREATE CLUSTERED INDEX [idx_penguin_tblOutletFinancialInfo_aucm_OutletID] ON [dbo].[penguin_tblOutletFinancialInfo_aucm]
(
	[OutletID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
