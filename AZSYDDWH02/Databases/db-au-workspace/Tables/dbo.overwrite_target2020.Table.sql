USE [db-au-workspace]
GO
/****** Object:  Table [dbo].[overwrite_target2020]    Script Date: 20/02/2025 10:27:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[overwrite_target2020](
	[country] [nvarchar](10) NOT NULL,
	[date] [smalldatetime] NOT NULL,
	[jv] [nvarchar](20) NULL,
	[channel] [nvarchar](100) NULL,
	[financeproductcode] [nvarchar](50) NULL,
	[newvalue] [float] NULL,
	[newcount] [numeric](38, 21) NULL
) ON [PRIMARY]
GO
