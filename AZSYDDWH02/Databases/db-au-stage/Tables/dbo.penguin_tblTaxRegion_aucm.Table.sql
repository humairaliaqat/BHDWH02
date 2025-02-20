USE [db-au-stage]
GO
/****** Object:  Table [dbo].[penguin_tblTaxRegion_aucm]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[penguin_tblTaxRegion_aucm](
	[TaxId] [int] NULL,
	[RegionId] [int] NULL,
	[Rate] [numeric](18, 5) NULL
) ON [PRIMARY]
GO
