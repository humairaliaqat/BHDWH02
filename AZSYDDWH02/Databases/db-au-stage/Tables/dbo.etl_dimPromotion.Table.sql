USE [db-au-stage]
GO
/****** Object:  Table [dbo].[etl_dimPromotion]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[etl_dimPromotion](
	[Country] [nvarchar](20) NOT NULL,
	[PromotionKey] [varchar](41) NULL,
	[PromotionCode] [nvarchar](10) NULL,
	[PromotionName] [nvarchar](250) NULL,
	[PromotionType] [nvarchar](50) NULL,
	[LoadDate] [datetime] NULL,
	[updateDate] [datetime] NULL,
	[LoadID] [int] NULL,
	[updateID] [int] NULL,
	[HashKey] [varbinary](30) NULL
) ON [PRIMARY]
GO
