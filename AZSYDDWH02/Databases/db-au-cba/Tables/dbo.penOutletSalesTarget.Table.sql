USE [db-au-cba]
GO
/****** Object:  Table [dbo].[penOutletSalesTarget]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[penOutletSalesTarget](
	[CountryKey] [varchar](2) NOT NULL,
	[CompanyKey] [varchar](5) NOT NULL,
	[DomainKey] [varchar](41) NULL,
	[OutletSalesTargetKey] [varchar](33) NULL,
	[OutletKey] [varchar](33) NULL,
	[OutletAlphaKey] [nvarchar](50) NULL,
	[OutletSalesTargetID] [int] NULL,
	[Month] [int] NULL,
	[GrossSellPriceTarget] [money] NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_penOutletSalesTarget_OutletStoreKey]    Script Date: 20/02/2025 10:13:01 AM ******/
CREATE CLUSTERED INDEX [idx_penOutletSalesTarget_OutletStoreKey] ON [dbo].[penOutletSalesTarget]
(
	[OutletSalesTargetKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_penOutletSalesTarget_OutletKey]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_penOutletSalesTarget_OutletKey] ON [dbo].[penOutletSalesTarget]
(
	[OutletKey] ASC
)
INCLUDE([OutletSalesTargetID],[OutletAlphaKey]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
