USE [db-au-cba]
GO
/****** Object:  Table [dbo].[cisCallData]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cisCallData](
	[BIRowID] [bigint] NOT NULL,
	[SessionKey] [nvarchar](50) NOT NULL,
	[SessionID] [numeric](18, 0) NOT NULL,
	[AgentKey] [nvarchar](50) NOT NULL,
	[CSQKey] [nvarchar](50) NOT NULL,
	[Disposition] [char](20) NOT NULL,
	[CallStartDateTime] [datetime2](7) NOT NULL,
	[CallEndDateTime] [datetime2](7) NOT NULL,
	[OriginatorNumber] [nvarchar](30) NOT NULL,
	[DestinationNumber] [nvarchar](30) NOT NULL,
	[CalledNumber] [nvarchar](30) NOT NULL,
	[OrigCalledNumber] [nvarchar](30) NOT NULL,
	[CallsPresented] [int] NOT NULL,
	[CallsHandled] [int] NOT NULL,
	[CallsAbandoned] [int] NOT NULL,
	[RingTime] [int] NOT NULL,
	[TalkTime] [int] NOT NULL,
	[HoldTime] [int] NOT NULL,
	[WorkTime] [int] NOT NULL,
	[WrapUpTime] [int] NOT NULL,
	[QueueTime] [int] NOT NULL,
	[MetServiceLevel] [bit] NOT NULL,
	[Transfer] [bit] NOT NULL,
	[Redirect] [bit] NOT NULL,
	[Conference] [bit] NOT NULL,
	[CreateBatchID] [int] NULL,
	[UpdateBatchID] [int] NULL,
	[EmployeeKey] [int] NULL,
	[OrganisationKey] [int] NULL,
	[Team] [varchar](50) NULL,
	[Agent] [varchar](50) NULL,
	[LoginID] [varchar](50) NULL,
	[SupervisorFlag] [bit] NULL,
	[ApplicationID] [int] NULL,
	[ApplicationName] [varchar](30) NULL,
	[ContactType] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Index [idx_cisCallData_BIRowID]    Script Date: 20/02/2025 10:13:01 AM ******/
CREATE CLUSTERED INDEX [idx_cisCallData_BIRowID] ON [dbo].[cisCallData]
(
	[BIRowID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_cisCallData_CallTimes]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_cisCallData_CallTimes] ON [dbo].[cisCallData]
(
	[CallStartDateTime] ASC,
	[CallEndDateTime] ASC
)
INCLUDE([SessionID],[AgentKey],[CSQKey],[Disposition],[OriginatorNumber],[DestinationNumber],[CalledNumber],[OrigCalledNumber],[CallsPresented],[CallsHandled],[CallsAbandoned],[RingTime],[TalkTime],[HoldTime],[WorkTime],[WrapUpTime],[QueueTime],[MetServiceLevel],[Transfer],[Redirect],[Conference],[EmployeeKey],[OrganisationKey],[ApplicationName],[ContactType]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_cisCallData_LoginID]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_cisCallData_LoginID] ON [dbo].[cisCallData]
(
	[LoginID] ASC,
	[CallStartDateTime] DESC
)
INCLUDE([CallEndDateTime],[OriginatorNumber],[SessionID],[SessionKey],[Transfer],[CalledNumber],[OrigCalledNumber]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_cisCallData_OriginatorNumber]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_cisCallData_OriginatorNumber] ON [dbo].[cisCallData]
(
	[OriginatorNumber] ASC,
	[CallStartDateTime] DESC
)
INCLUDE([CallEndDateTime],[LoginID],[SessionID],[SessionKey]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_cisCallData_SessionKey]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_cisCallData_SessionKey] ON [dbo].[cisCallData]
(
	[SessionKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
