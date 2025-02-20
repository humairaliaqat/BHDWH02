USE [db-au-stage]
GO
/****** Object:  Table [dbo].[etl_penOutletStore]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[etl_penOutletStore](
	[CountryKey] [varchar](2) NULL,
	[CompanyKey] [varchar](5) NULL,
	[DomainKey] [varchar](41) NULL,
	[OutletStoreKey] [varchar](71) NULL,
	[OutletKey] [varchar](71) NULL,
	[OutletAlphaKey] [nvarchar](61) NULL,
	[OutletStoreID] [int] NOT NULL,
	[StoreName] [nvarchar](250) NULL,
	[StoreCode] [varchar](10) NOT NULL,
	[DomainID] [int] NOT NULL,
	[OutletID] [int] NOT NULL,
	[StoreStatus] [varchar](15) NOT NULL,
	[CreateDateTime] [datetime] NULL,
	[UpdateDateTime] [datetime] NULL,
	[CreateDateTimeUTC] [datetime] NOT NULL,
	[UpdateDateTimeUTC] [datetime] NOT NULL,
	[StoreType] [nvarchar](200) NULL
) ON [PRIMARY]
GO
