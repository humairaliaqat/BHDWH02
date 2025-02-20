USE [db-au-cba]
GO
/****** Object:  Table [dbo].[clmSection]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[clmSection](
	[CountryKey] [varchar](2) NOT NULL,
	[ClaimKey] [varchar](40) NOT NULL,
	[SectionKey] [varchar](40) NOT NULL,
	[EventKey] [varchar](40) NOT NULL,
	[SectionID] [int] NOT NULL,
	[ClaimNo] [int] NULL,
	[EventID] [int] NULL,
	[SectionCode] [varchar](25) NULL,
	[EstimateValue] [money] NULL,
	[Redundant] [bit] NOT NULL,
	[BenefitSectionKey] [varchar](40) NULL,
	[BenefitSectionID] [int] NULL,
	[OriginalBenefitSectionID] [int] NULL,
	[BenefitSubSectionID] [int] NULL,
	[SectionDescription] [nvarchar](200) NULL,
	[BenefitLimit] [nvarchar](200) NULL,
	[RecoveryEstimateValue] [money] NULL,
	[isDeleted] [bit] NOT NULL,
	[BIRowID] [int] IDENTITY(1,1) NOT NULL,
	[CreateBatchID] [int] NULL,
	[UpdateBatchID] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Index [idx_clmSection_BIRowID]    Script Date: 20/02/2025 10:13:01 AM ******/
CREATE CLUSTERED INDEX [idx_clmSection_BIRowID] ON [dbo].[clmSection]
(
	[BIRowID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_clmSection_ClaimKey]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_clmSection_ClaimKey] ON [dbo].[clmSection]
(
	[ClaimKey] ASC
)
INCLUDE([CountryKey],[SectionKey],[SectionID],[BenefitSectionKey],[EstimateValue],[RecoveryEstimateValue],[isDeleted],[SectionCode],[SectionDescription]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_clmSection_CountryKey]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_clmSection_CountryKey] ON [dbo].[clmSection]
(
	[CountryKey] ASC,
	[SectionID] ASC
)
INCLUDE([SectionKey]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_clmSection_EventKey]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_clmSection_EventKey] ON [dbo].[clmSection]
(
	[EventKey] ASC,
	[isDeleted] ASC
)
INCLUDE([CountryKey],[SectionKey],[SectionID],[BenefitSectionKey],[EstimateValue],[RecoveryEstimateValue],[SectionCode],[SectionDescription]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_clmSection_SectionKey]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_clmSection_SectionKey] ON [dbo].[clmSection]
(
	[SectionKey] ASC
)
INCLUDE([SectionCode],[SectionDescription],[EstimateValue],[RecoveryEstimateValue],[BenefitSectionKey]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[clmSection] ADD  DEFAULT ((0)) FOR [isDeleted]
GO
