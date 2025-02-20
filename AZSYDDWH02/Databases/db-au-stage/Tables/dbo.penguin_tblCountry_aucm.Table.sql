USE [db-au-stage]
GO
/****** Object:  Table [dbo].[penguin_tblCountry_aucm]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[penguin_tblCountry_aucm](
	[CountryId] [int] NOT NULL,
	[Country] [nvarchar](50) NOT NULL,
	[ISO3Code] [char](3) NULL,
	[ISO2Code] [char](2) NULL,
	[Is_Part_Of_ISO_Standard] [bit] NULL
) ON [PRIMARY]
GO
