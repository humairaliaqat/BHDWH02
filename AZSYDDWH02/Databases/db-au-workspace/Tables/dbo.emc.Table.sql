USE [db-au-workspace]
GO
/****** Object:  Table [dbo].[emc]    Script Date: 20/02/2025 10:27:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[emc](
	[Category] [varchar](62) NULL,
	[QuoteID] [varchar](50) NOT NULL,
	[QuoteDate] [datetime] NULL,
	[QuotePrice] [float] NULL,
	[EMCQuotePrice] [decimal](38, 2) NOT NULL,
	[PolicyNumber] [varchar](50) NULL,
	[SellPrice] [money] NULL,
	[Payment] [money] NULL,
	[EMCRate] [money] NULL,
	[EMCSellPrice] [money] NULL,
	[TravellerCount] [int] NULL,
	[EMCTravellerCount] [int] NULL,
	[AcceptedEMCTravellerCount] [int] NULL,
	[EMCAssessmentCount] [int] NULL,
	[AddEMCSellPrice] [money] NULL,
	[AddEMCRate] [money] NULL,
	[AddEMCAssessmentCount] [int] NULL,
	[AddPayment] [money] NULL
) ON [PRIMARY]
GO
