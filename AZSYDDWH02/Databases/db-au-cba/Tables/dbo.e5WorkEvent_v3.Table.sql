USE [db-au-cba]
GO
/****** Object:  Table [dbo].[e5WorkEvent_v3]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[e5WorkEvent_v3](
	[BIRowID] [bigint] IDENTITY(1,1) NOT NULL,
	[Domain] [varchar](5) NULL,
	[Work_ID] [varchar](50) NULL,
	[Original_Work_Id] [uniqueidentifier] NOT NULL,
	[Id] [bigint] NOT NULL,
	[EventDate] [datetime] NOT NULL,
	[Event_Id] [int] NOT NULL,
	[EventName] [nvarchar](50) NULL,
	[EventUserID] [nvarchar](100) NULL,
	[EventUser] [nvarchar](455) NULL,
	[Status_Id] [int] NOT NULL,
	[StatusName] [nvarchar](100) NULL,
	[Detail] [nvarchar](200) NULL,
	[Allocation] [varchar](20) NULL,
	[ResumeEventId] [int] NULL,
	[ResumeEventStatusName] [nvarchar](100) NULL,
	[BookmarkId] [uniqueidentifier] NULL,
	[ProcessStatus_Id] [int] NULL,
	[ProcessStatus] [nvarchar](100) NULL,
	[ResumeEventDetail] [nvarchar](200) NULL,
	[CreateBatchID] [int] NULL,
	[UpdateBatchID] [int] NULL,
	[DeleteBatchID] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Index [idx_e5WorkEvent_v3_BIRowID]    Script Date: 20/02/2025 10:13:01 AM ******/
CREATE CLUSTERED INDEX [idx_e5WorkEvent_v3_BIRowID] ON [dbo].[e5WorkEvent_v3]
(
	[BIRowID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_e5WorkEvent_v3_EventDate]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_e5WorkEvent_v3_EventDate] ON [dbo].[e5WorkEvent_v3]
(
	[EventDate] ASC
)
INCLUDE([Id],[Domain],[EventName],[Work_ID],[Event_Id],[EventUser],[StatusName]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_e5WorkEvent_v3_EventName]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_e5WorkEvent_v3_EventName] ON [dbo].[e5WorkEvent_v3]
(
	[EventName] ASC,
	[StatusName] ASC,
	[EventDate] ASC
)
INCLUDE([Id],[Domain],[Work_ID],[Detail]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_e5WorkEvent_v3_Id]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_e5WorkEvent_v3_Id] ON [dbo].[e5WorkEvent_v3]
(
	[Id] ASC,
	[Domain] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_e5WorkEvent_v3_WorkID]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_e5WorkEvent_v3_WorkID] ON [dbo].[e5WorkEvent_v3]
(
	[Work_ID] ASC,
	[EventDate] ASC,
	[EventName] ASC
)
INCLUDE([Domain],[Id],[StatusName],[EventUser],[Detail]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
