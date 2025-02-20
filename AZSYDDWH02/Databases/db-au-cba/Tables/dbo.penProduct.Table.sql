USE [db-au-cba]
GO
/****** Object:  Table [dbo].[penProduct]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[penProduct](
	[CountryKey] [varchar](2) NOT NULL,
	[CompanyKey] [varchar](5) NOT NULL,
	[DomainKey] [varchar](41) NULL,
	[ProductKey] [varchar](33) NULL,
	[ProductID] [int] NULL,
	[PurchasePathID] [int] NULL,
	[PurchasePathName] [nvarchar](50) NULL,
	[ProductCode] [nvarchar](50) NULL,
	[ProductName] [nvarchar](50) NULL,
	[ProductDisplayName] [nvarchar](50) NULL,
	[isCancellation] [bit] NULL,
	[DomainID] [int] NULL,
	[FinanceProductID] [int] NULL,
	[FinanceProductCode] [nvarchar](10) NULL,
	[FinanceProductName] [nvarchar](125) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_penProduct_ProductKey]    Script Date: 20/02/2025 10:13:01 AM ******/
CREATE CLUSTERED INDEX [idx_penProduct_ProductKey] ON [dbo].[penProduct]
(
	[ProductKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_penProduct_CountryKey]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_penProduct_CountryKey] ON [dbo].[penProduct]
(
	[CountryKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_penProduct_ProductCode]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_penProduct_ProductCode] ON [dbo].[penProduct]
(
	[ProductCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
