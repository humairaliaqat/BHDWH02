USE [db-au-stage]
GO
/****** Object:  Table [dbo].[impulse_TravellerAddons]    Script Date: 18/02/2025 11:53:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[impulse_TravellerAddons](
	[SrcRowID] [bigint] IDENTITY(0,1) NOT NULL,
	[quoteID] [nvarchar](50) NULL,
	[sessionID] [nvarchar](50) NULL,
	[identifier] [nvarchar](50) NULL,
	[code] [nvarchar](50) NULL,
	[label] [nvarchar](50) NULL,
	[description] [nvarchar](255) NULL,
	[amount] [nvarchar](50) NULL,
	[transactionTime] [datetime] NULL,
	[batchID] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Index [idx_impulse_TravellerAddons_SrcRowID]    Script Date: 18/02/2025 11:53:55 AM ******/
CREATE CLUSTERED INDEX [idx_impulse_TravellerAddons_SrcRowID] ON [dbo].[impulse_TravellerAddons]
(
	[SrcRowID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_impulse_TravellerAddons]    Script Date: 18/02/2025 11:53:55 AM ******/
CREATE NONCLUSTERED INDEX [idx_impulse_TravellerAddons] ON [dbo].[impulse_TravellerAddons]
(
	[quoteID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
GO
