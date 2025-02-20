USE [db-au-stage]
GO
/****** Object:  Table [dbo].[emc_CBA_EMC_Payment_AU]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[emc_CBA_EMC_Payment_AU](
	[Counter] [int] NOT NULL,
	[ClientID] [int] NULL,
	[Excess] [float] NULL,
	[Premium] [float] NULL,
	[Limit] [float] NULL,
	[ResricCond] [varchar](255) NULL,
	[OtherRestrictions] [varchar](255) NULL,
	[Over70] [float] NULL,
	[Comments] [varchar](1000) NULL,
	[Duration] [varchar](10) NULL,
	[Surname] [varchar](22) NULL,
	[CardType] [varchar](6) NULL,
	[PDate] [datetime] NULL,
	[GST] [money] NULL,
	[Merchantid] [varchar](16) NULL,
	[ReceiptNo] [varchar](50) NULL,
	[TxnResponseCode] [varchar](5) NULL,
	[ACQResponseCode] [varchar](50) NULL,
	[Status] [varchar](100) NULL,
	[OrderId] [varchar](50) NULL,
	[MerchantTxRef] [varchar](50) NULL
) ON [PRIMARY]
GO
