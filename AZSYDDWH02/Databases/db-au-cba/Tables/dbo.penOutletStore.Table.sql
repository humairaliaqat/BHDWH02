USE [db-au-cba]
GO
/****** Object:  Table [dbo].[penOutletStore]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[penOutletStore](
	[CountryKey] [varchar](2) NOT NULL,
	[CompanyKey] [varchar](5) NOT NULL,
	[DomainKey] [varchar](41) NULL,
	[OutletStoreKey] [varchar](33) NULL,
	[OutletKey] [varchar](33) NULL,
	[OutletAlphaKey] [nvarchar](50) NULL,
	[OutletStoreID] [int] NULL,
	[StoreName] [nvarchar](250) NULL,
	[StoreCode] [varchar](10) NULL,
	[DomainID] [int] NULL,
	[OutletID] [int] NULL,
	[StoreStatus] [varchar](15) NULL,
	[CreateDateTime] [datetime] NULL,
	[UpdateDateTime] [datetime] NULL,
	[CreateDateTimeUTC] [datetime] NULL,
	[UpdateDateTimeUTC] [datetime] NULL,
	[StoreType] [varchar](50) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_penOutletStore_OutletStoreKey]    Script Date: 20/02/2025 10:13:01 AM ******/
CREATE CLUSTERED INDEX [idx_penOutletStore_OutletStoreKey] ON [dbo].[penOutletStore]
(
	[OutletStoreKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_penOutletStore_OutletAlphaKey]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_penOutletStore_OutletAlphaKey] ON [dbo].[penOutletStore]
(
	[OutletAlphaKey] ASC
)
INCLUDE([OutletStoreID],[StoreName],[StoreCode],[StoreStatus],[StoreType]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_penOutletStore_OutletKey]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_penOutletStore_OutletKey] ON [dbo].[penOutletStore]
(
	[OutletKey] ASC
)
INCLUDE([OutletStoreID],[StoreName],[StoreCode],[StoreStatus],[StoreType]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
