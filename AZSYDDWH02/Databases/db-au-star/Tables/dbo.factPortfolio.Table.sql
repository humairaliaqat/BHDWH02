USE [db-au-star]
GO
/****** Object:  Table [dbo].[factPortfolio]    Script Date: 20/02/2025 10:26:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[factPortfolio](
	[BIRowID] [bigint] IDENTITY(1,1) NOT NULL,
	[Date_SK] [int] NOT NULL,
	[Business_Unit_SK] [int] NOT NULL,
	[AgeBandSK] [int] NOT NULL,
	[AreaSK] [int] NOT NULL,
	[DestinationSK] [int] NOT NULL,
	[DomainSK] [int] NOT NULL,
	[DurationSK] [int] NOT NULL,
	[OutletSK] [int] NOT NULL,
	[ProductSK] [int] NOT NULL,
	[ProfitDriverSK] [int] NULL,
	[PortfolioValue] [money] NULL,
	[PolicySK] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Index [idx_factPortfolio_BIRowID]    Script Date: 20/02/2025 10:26:12 AM ******/
CREATE CLUSTERED INDEX [idx_factPortfolio_BIRowID] ON [dbo].[factPortfolio]
(
	[BIRowID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_factPortfolio_Date]    Script Date: 20/02/2025 10:26:12 AM ******/
CREATE NONCLUSTERED INDEX [idx_factPortfolio_Date] ON [dbo].[factPortfolio]
(
	[Date_SK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_factPortfolio_PolicySK]    Script Date: 20/02/2025 10:26:12 AM ******/
CREATE NONCLUSTERED INDEX [idx_factPortfolio_PolicySK] ON [dbo].[factPortfolio]
(
	[PolicySK] ASC
)
INCLUDE([ProfitDriverSK],[PortfolioValue]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_OutletSK]    Script Date: 20/02/2025 10:26:12 AM ******/
CREATE NONCLUSTERED INDEX [idx_OutletSK] ON [dbo].[factPortfolio]
(
	[OutletSK] ASC
)
INCLUDE([BIRowID],[Date_SK],[Business_Unit_SK],[AgeBandSK],[AreaSK],[DestinationSK],[DomainSK],[DurationSK],[ProductSK],[ProfitDriverSK],[PortfolioValue]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[factPortfolio] ADD  DEFAULT ((-1)) FOR [PolicySK]
GO
