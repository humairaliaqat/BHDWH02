USE [db-au-cba]
GO
/****** Object:  Table [dbo].[cdgRegion]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cdgRegion](
	[BIRowID] [int] NOT NULL,
	[RegionID] [int] NOT NULL,
	[Region] [nvarchar](4000) NULL
) ON [PRIMARY]
GO
/****** Object:  Index [idx_cdgRegion_main]    Script Date: 20/02/2025 10:13:01 AM ******/
CREATE CLUSTERED INDEX [idx_cdgRegion_main] ON [dbo].[cdgRegion]
(
	[BIRowID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_cdgRegion_id]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_cdgRegion_id] ON [dbo].[cdgRegion]
(
	[RegionID] ASC
)
INCLUDE([Region]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
