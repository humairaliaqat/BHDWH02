USE [db-au-stage]
GO
/****** Object:  Table [dbo].[penguin_tblTax_aucm]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[penguin_tblTax_aucm](
	[TaxId] [int] NOT NULL,
	[DomainId] [int] NOT NULL,
	[TaxName] [nvarchar](50) NULL,
	[TaxRate] [numeric](18, 5) NULL,
	[TaxTypeId] [int] NULL
) ON [PRIMARY]
GO
