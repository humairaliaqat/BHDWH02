USE [db-au-stage]
GO
/****** Object:  Table [dbo].[etl_penPolicyDestination]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[etl_penPolicyDestination](
	[CountryKey] [varchar](2) NULL,
	[CompanyKey] [varchar](5) NULL,
	[DomainKey] [varchar](41) NULL,
	[PolicyKey] [varchar](71) NULL,
	[PrimaryCountry] [nvarchar](max) NULL,
	[Area] [nvarchar](100) NULL,
	[AreaCode] [nvarchar](3) NULL,
	[DestinationOrder] [bigint] NULL,
	[Destination] [nvarchar](max) NULL,
	[CountryAreaID] [int] NULL,
	[CountryID] [int] NULL,
	[AreaID] [int] NULL,
	[Weighting] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
