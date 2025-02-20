USE [db-au-cba]
GO
/****** Object:  Table [dbo].[penOutletTradingHistory]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[penOutletTradingHistory](
	[BIRowID] [bigint] IDENTITY(1,1) NOT NULL,
	[OutletKey] [varchar](41) NULL,
	[StatusChangeDate] [datetime] NULL,
	[OldTradingStatus] [nvarchar](40) NULL,
	[NewTradingStatus] [nvarchar](40) NULL
) ON [PRIMARY]
GO
/****** Object:  Index [idx_penOutletTradingHistory_BIRowID]    Script Date: 20/02/2025 10:13:01 AM ******/
CREATE CLUSTERED INDEX [idx_penOutletTradingHistory_BIRowID] ON [dbo].[penOutletTradingHistory]
(
	[BIRowID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_penOutletTradingHistory_OutletKey]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_penOutletTradingHistory_OutletKey] ON [dbo].[penOutletTradingHistory]
(
	[OutletKey] ASC,
	[StatusChangeDate] DESC
)
INCLUDE([OldTradingStatus],[NewTradingStatus]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_penOutletTradingHistory_StatusChangeDate]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_penOutletTradingHistory_StatusChangeDate] ON [dbo].[penOutletTradingHistory]
(
	[StatusChangeDate] ASC
)
INCLUDE([OutletKey],[OldTradingStatus],[NewTradingStatus]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
