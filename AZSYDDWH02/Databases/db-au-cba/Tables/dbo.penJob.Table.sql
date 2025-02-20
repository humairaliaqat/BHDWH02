USE [db-au-cba]
GO
/****** Object:  Table [dbo].[penJob]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[penJob](
	[CountryKey] [varchar](2) NULL,
	[CompanyKey] [varchar](5) NULL,
	[DomainKey] [varchar](41) NULL,
	[JobKey] [varchar](41) NULL,
	[JobID] [int] NULL,
	[JobName] [varchar](100) NULL,
	[JobCode] [varchar](50) NULL,
	[JobType] [varchar](50) NULL,
	[JobDesc] [varchar](500) NULL,
	[GroupCodes] [varchar](100) NULL,
	[DataQueueType] [varchar](50) NULL,
	[MaxRetryCount] [int] NULL,
	[CodeModule] [varchar](255) NULL,
	[JobData] [xml] NULL,
	[Status] [varchar](15) NULL,
	[CreateDateTime] [datetime] NULL,
	[UpdateDateTime] [datetime] NULL,
	[Company] [varchar](20) NULL,
	[DomainID] [int] NULL,
	[LastRunTime] [datetime] NULL,
	[IsPaused] [bit] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_penJob_JobKey]    Script Date: 20/02/2025 10:13:01 AM ******/
CREATE CLUSTERED INDEX [idx_penJob_JobKey] ON [dbo].[penJob]
(
	[JobKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_penJob_CountryKey]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_penJob_CountryKey] ON [dbo].[penJob]
(
	[CountryKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
