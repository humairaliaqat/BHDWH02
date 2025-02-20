USE [db-au-cba]
GO
/****** Object:  Table [dbo].[cbNote]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cbNote](
	[BIRowID] [bigint] IDENTITY(1,1) NOT NULL,
	[CountryKey] [nvarchar](2) NOT NULL,
	[CaseKey] [nvarchar](20) NOT NULL,
	[UserKey] [nvarchar](35) NULL,
	[NoteKey] [nvarchar](20) NOT NULL,
	[CaseNo] [nvarchar](15) NULL,
	[UserID] [nvarchar](30) NULL,
	[NoteID] [int] NOT NULL,
	[UserName] [nvarchar](55) NULL,
	[CreateDate] [datetime] NULL,
	[CreateTime] [datetime] NULL,
	[CreateTimeUTC] [datetime] NULL,
	[NoteType] [nvarchar](20) NULL,
	[IsIncluded] [bit] NULL,
	[IsMBFSent] [bit] NULL,
	[Notes] [nvarchar](max) NULL,
	[NoteCode] [nvarchar](5) NULL,
	[IsDeleted] [bit] NULL,
	[NoteTime] [datetime] NULL,
	[NoteTimeUTC] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Index [idx_cbNote_BIRowID]    Script Date: 20/02/2025 10:13:01 AM ******/
CREATE CLUSTERED INDEX [idx_cbNote_BIRowID] ON [dbo].[cbNote]
(
	[BIRowID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_cbNote_CaseKey]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_cbNote_CaseKey] ON [dbo].[cbNote]
(
	[CaseKey] ASC
)
INCLUDE([NoteCode],[NoteKey],[CreateDate],[CreateTime],[NoteTime]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_cbNote_CreateTimeUTC]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_cbNote_CreateTimeUTC] ON [dbo].[cbNote]
(
	[CreateTimeUTC] ASC
)
INCLUDE([NoteKey],[UserID],[UserName],[CreateDate],[NoteType]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_cbNote_NoteCode]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_cbNote_NoteCode] ON [dbo].[cbNote]
(
	[NoteCode] ASC,
	[CaseNo] ASC
)
INCLUDE([UserID],[UserName],[CreateDate],[CreateTimeUTC],[CaseKey],[CreateTime]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_cbNote_NoteType]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_cbNote_NoteType] ON [dbo].[cbNote]
(
	[NoteType] ASC,
	[CaseNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
