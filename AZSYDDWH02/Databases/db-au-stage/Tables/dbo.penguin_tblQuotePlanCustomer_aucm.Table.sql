USE [db-au-stage]
GO
/****** Object:  Table [dbo].[penguin_tblQuotePlanCustomer_aucm]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[penguin_tblQuotePlanCustomer_aucm](
	[ID] [int] NOT NULL,
	[QuotePlanID] [int] NOT NULL,
	[QuoteCustomerID] [int] NOT NULL,
	[RateCardID] [int] NULL,
	[ChargeRate] [numeric](9, 2) NULL,
	[NetPremium] [money] NULL
) ON [PRIMARY]
GO
