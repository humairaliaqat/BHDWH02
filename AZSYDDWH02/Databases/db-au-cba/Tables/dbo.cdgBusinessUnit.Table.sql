USE [db-au-cba]
GO
/****** Object:  Table [dbo].[cdgBusinessUnit]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cdgBusinessUnit](
	[BIRowID] [int] NOT NULL,
	[BusinessUnitID] [int] NOT NULL,
	[BusinessUnit] [nvarchar](255) NULL,
	[Domain] [nvarchar](255) NULL,
	[Partner] [nvarchar](255) NULL,
	[Currency] [nvarchar](255) NULL
) ON [PRIMARY]
GO
/****** Object:  Index [idx_cdgBusinessUnit_main]    Script Date: 20/02/2025 10:13:01 AM ******/
CREATE CLUSTERED INDEX [idx_cdgBusinessUnit_main] ON [dbo].[cdgBusinessUnit]
(
	[BIRowID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_cdgBusinessUnit_id]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_cdgBusinessUnit_id] ON [dbo].[cdgBusinessUnit]
(
	[BusinessUnitID] ASC
)
INCLUDE([BusinessUnit],[Domain]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
