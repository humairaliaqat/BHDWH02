USE [db-au-stage]
GO
/****** Object:  Table [dbo].[penguin_tblTaxType_aucm]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[penguin_tblTaxType_aucm](
	[TaxTypeId] [int] NOT NULL,
	[DomainId] [int] NULL,
	[TaxType] [nvarchar](50) NULL,
	[IncludedInNet] [bit] NOT NULL,
	[ApplicationOrder] [int] NOT NULL
) ON [PRIMARY]
GO
