USE [db-au-stage]
GO
/****** Object:  Table [dbo].[claims_KLCURRENCY_au]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[claims_KLCURRENCY_au](
	[ID] [int] NOT NULL,
	[Code] [varchar](3) NULL,
	[Country] [varchar](255) NULL,
	[Currency] [varchar](255) NULL,
	[Symbol] [varchar](255) NULL,
	[Subdivision] [varchar](255) NULL,
	[ISO4217Code] [varchar](255) NULL,
	[Regime] [varchar](255) NULL,
	[Active] [bit] NULL,
	[Name] [varchar](100) NULL
) ON [PRIMARY]
GO
