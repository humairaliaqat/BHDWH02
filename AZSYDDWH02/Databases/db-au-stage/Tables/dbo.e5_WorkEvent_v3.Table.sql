USE [db-au-stage]
GO
/****** Object:  Table [dbo].[e5_WorkEvent_v3]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[e5_WorkEvent_v3](
	[Work_Id] [uniqueidentifier] NOT NULL,
	[Id] [bigint] NOT NULL,
	[EventDate] [datetime] NOT NULL,
	[Event_Id] [int] NOT NULL,
	[EventUser] [uniqueidentifier] NOT NULL,
	[Status_Id] [int] NOT NULL,
	[Detail] [nvarchar](200) NULL,
	[Allocation] [varchar](20) NOT NULL,
	[ResumeEventId] [int] NULL,
	[BookmarkId] [uniqueidentifier] NULL,
	[ProcessStatus] [tinyint] NULL,
	[ResumeEventDetail] [nvarchar](200) NULL,
	[Metadata] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
