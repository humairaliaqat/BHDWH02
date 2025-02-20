USE [db-au-cba]
GO
/****** Object:  Table [dbo].[clmEvent]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[clmEvent](
	[CountryKey] [varchar](2) NOT NULL,
	[ClaimKey] [varchar](40) NOT NULL,
	[EventKey] [varchar](40) NOT NULL,
	[EventID] [int] NOT NULL,
	[ClaimNo] [int] NULL,
	[EMCID] [int] NULL,
	[PerilCode] [varchar](3) NULL,
	[PerilDesc] [nvarchar](65) NULL,
	[EventCountryCode] [varchar](3) NULL,
	[EventCountryName] [nvarchar](45) NULL,
	[EventDate] [datetime] NULL,
	[EventDesc] [nvarchar](100) NULL,
	[CreateDate] [datetime] NULL,
	[CreatedBy] [nvarchar](150) NULL,
	[CaseID] [varchar](15) NULL,
	[CatastropheCode] [varchar](3) NULL,
	[CatastropheShortDesc] [nvarchar](20) NULL,
	[CatastropheLongDesc] [nvarchar](60) NULL,
	[BIRowID] [int] IDENTITY(1,1) NOT NULL,
	[CreateBatchID] [int] NULL,
	[UpdateBatchID] [int] NULL,
	[EventDateTimeUTC] [datetime] NULL,
	[CreateDateTimeUTC] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Index [idx_clmEvent_BIRowID]    Script Date: 20/02/2025 10:13:01 AM ******/
CREATE CLUSTERED INDEX [idx_clmEvent_BIRowID] ON [dbo].[clmEvent]
(
	[BIRowID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_clmEvent_CatastropheCode]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_clmEvent_CatastropheCode] ON [dbo].[clmEvent]
(
	[CatastropheCode] ASC
)
INCLUDE([ClaimKey],[EventKey],[EventCountryCode],[EventCountryName],[EventDate],[EventDesc],[CatastropheShortDesc]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_clmEvent_ClaimKey]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_clmEvent_ClaimKey] ON [dbo].[clmEvent]
(
	[ClaimKey] ASC
)
INCLUDE([EventKey],[EventCountryCode],[EventDate],[EventDesc],[CaseID],[CatastropheCode],[EventCountryName]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_clmEvent_ClaimNo]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_clmEvent_ClaimNo] ON [dbo].[clmEvent]
(
	[ClaimNo] ASC
)
INCLUDE([CountryKey],[ClaimKey],[EventKey]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_clmEvent_EventKey]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_clmEvent_EventKey] ON [dbo].[clmEvent]
(
	[EventKey] ASC
)
INCLUDE([ClaimKey],[EventCountryCode],[EventCountryName],[EventDate],[EventDesc],[CaseID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_clmEvent_PerilCode]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_clmEvent_PerilCode] ON [dbo].[clmEvent]
(
	[PerilCode] ASC
)
INCLUDE([ClaimKey],[EventKey],[EventCountryCode],[EventCountryName],[EventDate],[EventDesc],[PerilDesc]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
