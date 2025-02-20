USE [db-au-star]
GO
/****** Object:  Table [dbo].[factActivity]    Script Date: 20/02/2025 10:26:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[factActivity](
	[BIRowID] [int] IDENTITY(1,1) NOT NULL,
	[DateSK] [int] NOT NULL,
	[EmployeeSK] [int] NOT NULL,
	[SupervisorSK] [int] NOT NULL,
	[TeamSK] [int] NOT NULL,
	[ActivitySK] [int] NOT NULL,
	[ActualActivityTime] [float] NOT NULL,
	[ScheduledActivityTime] [float] NOT NULL,
	[ApprovedExceptionDuration] [int] NOT NULL,
	[UnapprovedExceptionDuration] [int] NOT NULL,
	[CreateBatchID] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Index [idx_factActivity_BIRowID]    Script Date: 20/02/2025 10:26:12 AM ******/
CREATE CLUSTERED INDEX [idx_factActivity_BIRowID] ON [dbo].[factActivity]
(
	[BIRowID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_factActivity_DateSK]    Script Date: 20/02/2025 10:26:12 AM ******/
CREATE NONCLUSTERED INDEX [idx_factActivity_DateSK] ON [dbo].[factActivity]
(
	[DateSK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
