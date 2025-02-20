USE [db-au-star]
GO
/****** Object:  Table [dbo].[dimIntegratdOutlet]    Script Date: 20/02/2025 10:26:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dimIntegratdOutlet](
	[BIRowID] [bigint] IDENTITY(1,1) NOT NULL,
	[OutletSK] [bigint] NULL
) ON [PRIMARY]
GO
/****** Object:  Index [cidx]    Script Date: 20/02/2025 10:26:11 AM ******/
CREATE UNIQUE CLUSTERED INDEX [cidx] ON [dbo].[dimIntegratdOutlet]
(
	[BIRowID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx]    Script Date: 20/02/2025 10:26:12 AM ******/
CREATE NONCLUSTERED INDEX [idx] ON [dbo].[dimIntegratdOutlet]
(
	[OutletSK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
