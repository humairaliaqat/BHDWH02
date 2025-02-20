USE [db-au-workspace]
GO
/****** Object:  Table [dbo].[recon_gl]    Script Date: 20/02/2025 10:27:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[recon_gl](
	[Period] [int] NULL,
	[CountryKey] [varchar](2) NULL,
	[JVCode] [varchar](50) NULL,
	[JVDescription] [nvarchar](255) NULL,
	[ProductCode] [varchar](50) NULL,
	[PolicyCount] [numeric](38, 3) NULL,
	[Commission] [numeric](38, 3) NULL,
	[Premium] [numeric](38, 3) NULL
) ON [PRIMARY]
GO
