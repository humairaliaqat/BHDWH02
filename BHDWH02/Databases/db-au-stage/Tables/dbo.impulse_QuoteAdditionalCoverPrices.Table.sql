USE [db-au-stage]
GO
/****** Object:  Table [dbo].[impulse_QuoteAdditionalCoverPrices]    Script Date: 18/02/2025 11:53:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[impulse_QuoteAdditionalCoverPrices](
	[SrcRowID] [bigint] IDENTITY(0,1) NOT NULL,
	[quoteID] [nvarchar](50) NULL,
	[sessionID] [nvarchar](50) NULL,
	[code] [nvarchar](50) NULL,
	[grossPrice] [nvarchar](50) NULL,
	[baseNetPrice] [nvarchar](50) NULL,
	[isDiscount] [nvarchar](50) NULL,
	[displayPrice] [nvarchar](50) NULL,
	[unroundedGross] [nvarchar](50) NULL,
	[transactionTime] [datetime] NULL,
	[batchID] [int] NULL
) ON [PRIMARY]
GO
