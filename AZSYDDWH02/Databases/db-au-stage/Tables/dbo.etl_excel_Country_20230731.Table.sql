USE [db-au-stage]
GO
/****** Object:  Table [dbo].[etl_excel_Country_20230731]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[etl_excel_Country_20230731](
	[Continent] [nvarchar](255) NULL,
	[SubContinent] [nvarchar](255) NULL,
	[Country] [nvarchar](255) NULL,
	[ISO2Code] [nvarchar](255) NULL,
	[ABSCountry] [nvarchar](255) NULL,
	[ABSArea] [nvarchar](255) NULL
) ON [PRIMARY]
GO
