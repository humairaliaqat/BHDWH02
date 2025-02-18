USE [db-au-actuary]
GO
/****** Object:  Table [dbo].[dimProduct]    Script Date: 18/02/2025 12:14:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dimProduct](
	[ProductSK] [int] NOT NULL,
	[Country] [nvarchar](10) NOT NULL,
	[ProductKey] [nvarchar](200) NULL,
	[ProductCode] [nvarchar](50) NULL,
	[ProductName] [nvarchar](200) NULL,
	[ProductPlan] [nvarchar](200) NULL,
	[ProductType] [nvarchar](200) NULL,
	[ProductGroup] [nvarchar](200) NULL,
	[PolicyType] [nvarchar](100) NULL,
	[ProductClassification] [nvarchar](100) NULL,
	[FinanceProductCode] [nvarchar](50) NULL,
	[FinanceProductCodeOld] [nvarchar](50) NULL,
	[LoadDate] [datetime] NOT NULL,
	[updateDate] [datetime] NULL,
	[LoadID] [int] NOT NULL,
	[updateID] [int] NULL,
	[HashKey] [varbinary](30) NULL,
	[PlanType] [nvarchar](50) NULL,
	[TripType] [nvarchar](50) NULL
) ON [PRIMARY]
GO
/****** Object:  Index [idx_dimproduct_productsk]    Script Date: 18/02/2025 12:14:28 PM ******/
CREATE CLUSTERED INDEX [idx_dimproduct_productsk] ON [dbo].[dimProduct]
(
	[ProductSK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_dimproduct_country]    Script Date: 18/02/2025 12:14:29 PM ******/
CREATE NONCLUSTERED INDEX [idx_dimproduct_country] ON [dbo].[dimProduct]
(
	[Country] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_dimproduct_productcode]    Script Date: 18/02/2025 12:14:29 PM ******/
CREATE NONCLUSTERED INDEX [idx_dimproduct_productcode] ON [dbo].[dimProduct]
(
	[ProductCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_dimproduct_productkey]    Script Date: 18/02/2025 12:14:29 PM ******/
CREATE NONCLUSTERED INDEX [idx_dimproduct_productkey] ON [dbo].[dimProduct]
(
	[ProductKey] ASC
)
INCLUDE([Country],[ProductSK]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
