USE [db-au-stage]
GO
/****** Object:  Table [dbo].[penguin_tblAirport_aucm]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[penguin_tblAirport_aucm](
	[AirportId] [int] NOT NULL,
	[CountryId] [int] NOT NULL,
	[AirportCode] [nvarchar](50) NOT NULL,
	[Airport] [nvarchar](255) NOT NULL
) ON [PRIMARY]
GO
