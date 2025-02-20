USE [db-au-star]
GO
/****** Object:  Table [dbo].[dimDemography]    Script Date: 20/02/2025 10:26:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dimDemography](
	[DemographySK] [int] IDENTITY(1,1) NOT NULL,
	[PolicyKey] [varchar](41) NULL,
	[CustomerID] [bigint] NULL,
	[RiskProfile] [varchar](50) NULL,
	[EmailDomain] [nvarchar](255) NULL,
	[AgeGroup] [varchar](50) NULL,
	[ProductPreference] [varchar](50) NULL,
	[ChannelPreference] [varchar](50) NULL,
	[BrandAffiliation] [varchar](50) NULL,
	[TravelPattern] [varchar](50) NULL,
	[TravelGroup] [varchar](50) NULL,
	[DestinationGroup] [varchar](50) NULL,
	[LocationProfile] [varchar](50) NULL,
	[OwnershipProfile] [varchar](50) NULL,
	[SuburbRank] [decimal](18, 0) NULL,
	[Suburb] [nvarchar](50) NULL,
	[PostCode] [nvarchar](50) NULL,
	[State] [nvarchar](100) NULL,
	[UpdateBatchID] [bigint] NULL,
	[PolicySK] [bigint] NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_dimDemography_PolicyKey]    Script Date: 20/02/2025 10:26:12 AM ******/
CREATE NONCLUSTERED INDEX [idx_dimDemography_PolicyKey] ON [dbo].[dimDemography]
(
	[PolicyKey] ASC
)
INCLUDE([DemographySK]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [ccsi_dimDemography]    Script Date: 20/02/2025 10:26:12 AM ******/
CREATE CLUSTERED COLUMNSTORE INDEX [ccsi_dimDemography] ON [dbo].[dimDemography] WITH (DROP_EXISTING = OFF, COMPRESSION_DELAY = 0, DATA_COMPRESSION = COLUMNSTORE) ON [PRIMARY]
GO
