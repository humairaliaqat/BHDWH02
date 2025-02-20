USE [db-au-stage]
GO
/****** Object:  Table [dbo].[claims_KLTAX_au]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[claims_KLTAX_au](
	[TaxId] [int] NOT NULL,
	[DomainId] [int] NOT NULL,
	[TaxName] [nvarchar](50) NULL,
	[TaxRate] [numeric](18, 5) NULL
) ON [PRIMARY]
GO
