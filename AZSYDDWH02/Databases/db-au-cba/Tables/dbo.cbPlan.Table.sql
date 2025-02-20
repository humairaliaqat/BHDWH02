USE [db-au-cba]
GO
/****** Object:  Table [dbo].[cbPlan]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cbPlan](
	[BIRowID] [bigint] IDENTITY(1,1) NOT NULL,
	[CountryKey] [nvarchar](2) NOT NULL,
	[CaseKey] [nvarchar](20) NOT NULL,
	[PlanKey] [nvarchar](20) NOT NULL,
	[OriginalPlanKey] [nvarchar](20) NULL,
	[CaseNo] [nvarchar](15) NOT NULL,
	[PlanID] [int] NOT NULL,
	[PlanVersion] [int] NULL,
	[OriginalPlanID] [nvarchar](20) NULL,
	[OpenedByID] [nvarchar](30) NULL,
	[OpenedBy] [nvarchar](55) NULL,
	[CompletedByID] [nvarchar](30) NULL,
	[CompletedBy] [nvarchar](55) NULL,
	[ActionLevel] [nvarchar](30) NULL,
	[CancelledByID] [nvarchar](30) NULL,
	[CancelledBy] [nvarchar](55) NULL,
	[AllocatedToID] [nvarchar](30) NULL,
	[AllocatedTo] [nvarchar](55) NULL,
	[CreateDate] [datetime] NULL,
	[CreateTimeUTC] [datetime] NULL,
	[TodoDate] [datetime] NULL,
	[TodoTime] [datetime] NULL,
	[TodoTimeUTC] [datetime] NULL,
	[AllocatedDate] [datetime] NULL,
	[AllocatedTimeUTC] [datetime] NULL,
	[CompletionDate] [datetime] NULL,
	[CompletionTime] [datetime] NULL,
	[CompletionTimeUTC] [datetime] NULL,
	[PlanDetail] [nvarchar](255) NULL,
	[AdditionalDetail] [nvarchar](255) NULL,
	[IsPriority] [bit] NULL,
	[RescheduleReason] [nvarchar](120) NULL,
	[IsRescheduled] [bit] NULL,
	[IsCompleted] [bit] NULL,
	[IsCancelled] [bit] NULL
) ON [PRIMARY]
GO
/****** Object:  Index [idx_cbPlan_BIRowID]    Script Date: 20/02/2025 10:13:01 AM ******/
CREATE CLUSTERED INDEX [idx_cbPlan_BIRowID] ON [dbo].[cbPlan]
(
	[BIRowID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_cbPlan_CaseKey]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_cbPlan_CaseKey] ON [dbo].[cbPlan]
(
	[CaseKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_cbPlan_CreateDate]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_cbPlan_CreateDate] ON [dbo].[cbPlan]
(
	[CreateDate] ASC,
	[OpenedBy] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
