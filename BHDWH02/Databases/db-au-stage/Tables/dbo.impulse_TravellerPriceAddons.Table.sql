USE [db-au-stage]
GO
/****** Object:  Table [dbo].[impulse_TravellerPriceAddons]    Script Date: 18/02/2025 11:53:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[impulse_TravellerPriceAddons](
	[SrcRowID] [bigint] IDENTITY(0,1) NOT NULL,
	[quoteID] [nvarchar](50) NULL,
	[sessionID] [nvarchar](50) NULL,
	[identifier] [nvarchar](50) NULL,
	[code] [nvarchar](50) NULL,
	[label] [nvarchar](50) NULL,
	[amount] [nvarchar](50) NULL,
	[transactionTime] [datetime] NULL,
	[batchID] [int] NULL
) ON [PRIMARY]
GO
