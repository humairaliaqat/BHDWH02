USE [db-au-cba]
GO
/****** Object:  Table [dbo].[cbClientReport]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cbClientReport](
	[BIRowID] [bigint] IDENTITY(1,1) NOT NULL,
	[CountryKey] [nvarchar](2) NOT NULL,
	[CaseKey] [nvarchar](20) NOT NULL,
	[ClientReportKey] [nvarchar](20) NOT NULL,
	[CaseNo] [nvarchar](15) NOT NULL,
	[ClientReportID] [int] NOT NULL,
	[CreatedByID] [nvarchar](30) NULL,
	[CreatedBy] [nvarchar](55) NULL,
	[CreateDate] [datetime] NULL,
	[CreateTimeUTC] [datetime] NULL,
	[NoteDate] [datetime] NULL,
	[NoteTime] [datetime] NULL,
	[NoteTimeUTC] [datetime] NULL,
	[NoteType] [nvarchar](15) NULL,
	[Notes] [nvarchar](max) NULL,
	[IsChaseCover] [bit] NULL,
	[IsHeader] [bit] NULL,
	[IsCancelled] [bit] NULL,
	[UrgencyID] [int] NULL,
	[Urgency] [nvarchar](100) NULL,
	[Reason] [nvarchar](2000) NULL,
	[EmailDate] [datetime] NULL,
	[IsDeleted] [bit] NULL,
	[EmailDetails] [nvarchar](max) NULL,
	[ApproximateDeleteDate] [datetime] NULL,
	[isInitialCR] [bit] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Index [idx_cbClientReport_BIRowID]    Script Date: 20/02/2025 10:13:01 AM ******/
CREATE CLUSTERED INDEX [idx_cbClientReport_BIRowID] ON [dbo].[cbClientReport]
(
	[BIRowID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_cbClientReport_ApproxDelete]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_cbClientReport_ApproxDelete] ON [dbo].[cbClientReport]
(
	[ApproximateDeleteDate] ASC
)
INCLUDE([CaseKey]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_cbClientReport_CaseKey]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_cbClientReport_CaseKey] ON [dbo].[cbClientReport]
(
	[CaseKey] ASC
)
INCLUDE([ClientReportKey],[CreatedBy],[CreateTimeUTC],[EmailDate],[isInitialCR],[IsDeleted]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_cbClientReport_CaseNo]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_cbClientReport_CaseNo] ON [dbo].[cbClientReport]
(
	[CaseNo] ASC,
	[CountryKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cbClientReport] ADD  CONSTRAINT [DF_cbClientReport_isInitialCR]  DEFAULT ((0)) FOR [isInitialCR]
GO
