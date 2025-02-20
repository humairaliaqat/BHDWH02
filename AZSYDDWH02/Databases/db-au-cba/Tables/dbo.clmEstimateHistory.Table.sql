USE [db-au-cba]
GO
/****** Object:  Table [dbo].[clmEstimateHistory]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[clmEstimateHistory](
	[CountryKey] [varchar](2) NOT NULL,
	[EstimateHistoryKey] [varchar](40) NOT NULL,
	[EstimateHistoryID] [int] NOT NULL,
	[EHSectionID] [int] NULL,
	[EHEstimateValue] [money] NULL,
	[EHCreateDate] [datetime] NULL,
	[EHCreatedByID] [int] NULL,
	[ClaimKey] [varchar](40) NULL,
	[SectionKey] [varchar](40) NULL,
	[EHCreatedBy] [nvarchar](150) NULL,
	[EHRecoveryEstimateValue] [money] NULL,
	[BIRowID] [int] IDENTITY(1,1) NOT NULL,
	[CreateBatchID] [int] NULL,
	[UpdateBatchID] [int] NULL,
	[EHCreateDateTimeUTC] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Index [idx_clmEstimateHistory_BIRowID]    Script Date: 20/02/2025 10:13:01 AM ******/
CREATE CLUSTERED INDEX [idx_clmEstimateHistory_BIRowID] ON [dbo].[clmEstimateHistory]
(
	[BIRowID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_clmEstimateHistory_ClaimKey]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_clmEstimateHistory_ClaimKey] ON [dbo].[clmEstimateHistory]
(
	[ClaimKey] ASC
)
INCLUDE([SectionKey],[EHCreateDate],[EHEstimateValue]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_clmEstimateHistory_EHCreateDate]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_clmEstimateHistory_EHCreateDate] ON [dbo].[clmEstimateHistory]
(
	[EHCreateDate] ASC
)
INCLUDE([CountryKey],[ClaimKey],[SectionKey],[EstimateHistoryID],[EHCreatedBy],[EHEstimateValue],[EHRecoveryEstimateValue]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_clmEstimateHistory_SectionKey]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_clmEstimateHistory_SectionKey] ON [dbo].[clmEstimateHistory]
(
	[SectionKey] ASC,
	[EHCreateDate] ASC
)
INCLUDE([CountryKey],[ClaimKey],[EstimateHistoryID],[EHCreatedBy],[EHEstimateValue],[EHRecoveryEstimateValue],[EHCreateDateTimeUTC]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
