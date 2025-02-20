USE [db-au-star]
GO
/****** Object:  Table [dbo].[dimProduct]    Script Date: 20/02/2025 10:26:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dimProduct](
	[ProductSK] [int] IDENTITY(1,1) NOT NULL,
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
/****** Object:  Index [idx_dimProduct_ProductSK]    Script Date: 20/02/2025 10:26:11 AM ******/
CREATE CLUSTERED INDEX [idx_dimProduct_ProductSK] ON [dbo].[dimProduct]
(
	[ProductSK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_dimProduct_Country]    Script Date: 20/02/2025 10:26:12 AM ******/
CREATE NONCLUSTERED INDEX [idx_dimProduct_Country] ON [dbo].[dimProduct]
(
	[Country] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_dimProduct_FinanceProducCode]    Script Date: 20/02/2025 10:26:12 AM ******/
CREATE NONCLUSTERED INDEX [idx_dimProduct_FinanceProducCode] ON [dbo].[dimProduct]
(
	[ProductCode] ASC,
	[Country] ASC
)
INCLUDE([ProductSK]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_dimProduct_HashKey]    Script Date: 20/02/2025 10:26:12 AM ******/
CREATE NONCLUSTERED INDEX [idx_dimProduct_HashKey] ON [dbo].[dimProduct]
(
	[HashKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_dimProduct_lookup]    Script Date: 20/02/2025 10:26:12 AM ******/
CREATE NONCLUSTERED INDEX [idx_dimProduct_lookup] ON [dbo].[dimProduct]
(
	[ProductSK] ASC
)
INCLUDE([ProductCode],[ProductName],[ProductPlan],[ProductType],[ProductGroup],[PolicyType],[PlanType],[TripType],[ProductClassification],[FinanceProductCode]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_dimProduct_ProducCode]    Script Date: 20/02/2025 10:26:12 AM ******/
CREATE NONCLUSTERED INDEX [idx_dimProduct_ProducCode] ON [dbo].[dimProduct]
(
	[ProductCode] ASC,
	[ProductPlan] ASC
)
INCLUDE([ProductSK],[ProductName],[ProductType],[ProductGroup],[PolicyType],[PlanType],[TripType],[ProductClassification],[FinanceProductCode]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_dimProduct_ProductKey]    Script Date: 20/02/2025 10:26:12 AM ******/
CREATE NONCLUSTERED INDEX [idx_dimProduct_ProductKey] ON [dbo].[dimProduct]
(
	[ProductKey] ASC
)
INCLUDE([Country],[ProductSK],[FinanceProductCode],[FinanceProductCodeOld]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
