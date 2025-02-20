USE [db-au-cba]
GO
/****** Object:  Table [dbo].[clmClaimEstimateBalance]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[clmClaimEstimateBalance](
	[BIRowID] [int] IDENTITY(1,1) NOT NULL,
	[CountryKey] [varchar](2) NOT NULL,
	[Date] [date] NOT NULL,
	[BenefitCategory] [varchar](35) NOT NULL,
	[SectionCode] [varchar](25) NULL,
	[EstimateBalance] [money] NULL,
	[RecoveryEstimateBalance] [money] NULL
) ON [PRIMARY]
GO
/****** Object:  Index [idx_clmClaimEstimateBalance_BIRowID]    Script Date: 20/02/2025 10:13:01 AM ******/
CREATE CLUSTERED INDEX [idx_clmClaimEstimateBalance_BIRowID] ON [dbo].[clmClaimEstimateBalance]
(
	[BIRowID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_clmClaimEstimateBalance_Date]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_clmClaimEstimateBalance_Date] ON [dbo].[clmClaimEstimateBalance]
(
	[Date] ASC,
	[CountryKey] ASC
)
INCLUDE([BenefitCategory],[SectionCode],[EstimateBalance],[RecoveryEstimateBalance]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
