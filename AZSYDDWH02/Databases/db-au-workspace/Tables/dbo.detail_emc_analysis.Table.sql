USE [db-au-workspace]
GO
/****** Object:  Table [dbo].[detail_emc_analysis]    Script Date: 20/02/2025 10:27:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[detail_emc_analysis](
	[Channel] [nvarchar](100) NULL,
	[QuoteID] [varchar](50) NOT NULL,
	[QuoteDate] [datetime] NULL,
	[QuotePrice] [float] NULL,
	[EMCQuotePrice] [decimal](38, 2) NOT NULL,
	[PolicyNumber] [varchar](50) NULL,
	[SellPrice] [money] NULL,
	[Payment] [money] NULL,
	[EMCRate] [money] NULL,
	[EMCSellPrice] [money] NULL,
	[ClaimValue] [decimal](38, 6) NULL,
	[TravellerCount] [int] NULL,
	[EMCTravellerCount] [int] NULL,
	[AcceptedEMCTravellerCount] [int] NULL,
	[EMCAssessmentCount] [int] NULL,
	[Category] [varchar](63) NOT NULL,
	[EMCOfferStatus] [varchar](12) NOT NULL,
	[PurchasedEMCAddon] [money] NULL
) ON [PRIMARY]
GO
