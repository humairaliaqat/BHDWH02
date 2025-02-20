USE [db-au-cba]
GO
/****** Object:  Table [dbo].[clmClaimBalance]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[clmClaimBalance](
	[BIRowID] [int] IDENTITY(1,1) NOT NULL,
	[ClaimKey] [varchar](41) NOT NULL,
	[OpeningDate] [date] NOT NULL,
	[EstimateOpening] [money] NULL,
	[ActiveOpening] [smallint] NULL
) ON [PRIMARY]
GO
/****** Object:  Index [idx_clmClaimBalance_BIRowID]    Script Date: 20/02/2025 10:13:01 AM ******/
CREATE CLUSTERED INDEX [idx_clmClaimBalance_BIRowID] ON [dbo].[clmClaimBalance]
(
	[BIRowID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_clmClaimBalance_ClaimKey]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_clmClaimBalance_ClaimKey] ON [dbo].[clmClaimBalance]
(
	[ClaimKey] ASC,
	[OpeningDate] ASC
)
INCLUDE([EstimateOpening],[ActiveOpening]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_clmClaimBalance_Date]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_clmClaimBalance_Date] ON [dbo].[clmClaimBalance]
(
	[OpeningDate] ASC,
	[ClaimKey] ASC
)
INCLUDE([EstimateOpening],[ActiveOpening]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
