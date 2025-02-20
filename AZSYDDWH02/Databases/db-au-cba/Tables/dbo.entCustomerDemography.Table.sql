USE [db-au-cba]
GO
/****** Object:  Table [dbo].[entCustomerDemography]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[entCustomerDemography](
	[BIRowID] [bigint] IDENTITY(1,1) NOT NULL,
	[CustomerID] [bigint] NOT NULL,
	[RiskProfile] [varchar](50) NULL,
	[AgeGroup] [varchar](50) NULL,
	[ProductPreference] [varchar](50) NULL,
	[ChannelPreference] [varchar](50) NULL,
	[BrandAffiliation] [varchar](50) NULL,
	[TravelPattern] [varchar](50) NULL,
	[TravelGroup] [varchar](50) NULL,
	[DestinationGroup] [varchar](50) NULL,
	[LocationProfile] [varchar](50) NULL,
	[OwnershipProfile] [varchar](50) NULL,
	[SuburbRank] [decimal](4, 2) NULL,
	[UpdateBatchID] [bigint] NULL
) ON [PRIMARY]
GO
/****** Object:  Index [idx_cluster]    Script Date: 20/02/2025 10:13:01 AM ******/
CREATE UNIQUE CLUSTERED INDEX [idx_cluster] ON [dbo].[entCustomerDemography]
(
	[BIRowID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_customer]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_customer] ON [dbo].[entCustomerDemography]
(
	[CustomerID] ASC
)
INCLUDE([RiskProfile],[AgeGroup],[ProductPreference],[ChannelPreference],[BrandAffiliation],[TravelPattern],[TravelGroup],[DestinationGroup],[LocationProfile],[OwnershipProfile],[SuburbRank]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
