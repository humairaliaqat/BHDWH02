USE [db-au-stage]
GO
/****** Object:  Table [dbo].[impulse_TravellerCostStatement]    Script Date: 18/02/2025 11:53:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[impulse_TravellerCostStatement](
	[SrcRowID] [bigint] IDENTITY(0,1) NOT NULL,
	[quoteID] [nvarchar](50) NULL,
	[sessionID] [nvarchar](50) NULL,
	[identifier] [nvarchar](50) NULL,
	[ordinal] [nvarchar](50) NULL,
	[lineTitle] [nvarchar](50) NULL,
	[lineGrossPrice] [nvarchar](50) NULL,
	[lineActualGross] [nvarchar](50) NULL,
	[lineCategoryCode] [nvarchar](50) NULL,
	[lineDiscountPercent] [nvarchar](50) NULL,
	[lineDiscountedGross] [nvarchar](50) NULL,
	[lineFormattedActualGross] [nvarchar](50) NULL,
	[transactionTime] [datetime] NULL,
	[batchID] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Index [idx_impulse_TravellerCostStatement_SrcRowID]    Script Date: 18/02/2025 11:53:55 AM ******/
CREATE CLUSTERED INDEX [idx_impulse_TravellerCostStatement_SrcRowID] ON [dbo].[impulse_TravellerCostStatement]
(
	[SrcRowID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_impulse_TravellerCostStatement]    Script Date: 18/02/2025 11:53:55 AM ******/
CREATE NONCLUSTERED INDEX [idx_impulse_TravellerCostStatement] ON [dbo].[impulse_TravellerCostStatement]
(
	[quoteID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
GO
