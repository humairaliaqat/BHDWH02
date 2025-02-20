USE [db-au-workspace]
GO
/****** Object:  Table [dbo].[penPolicyDestination]    Script Date: 20/02/2025 10:27:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[penPolicyDestination](
	[CountryKey] [varchar](2) NOT NULL,
	[CompanyKey] [varchar](5) NOT NULL,
	[DomainKey] [varchar](41) NOT NULL,
	[PolicyKey] [varchar](71) NOT NULL,
	[PrimaryCountry] [nvarchar](max) NULL,
	[DestinationOrder] [bigint] NULL,
	[Destination] [nvarchar](100) NULL,
	[Area] [nvarchar](100) NULL,
	[CountryAreaID] [int] NULL,
	[CountryID] [int] NULL,
	[AreaID] [int] NULL,
	[Weighting] [int] NULL,
	[isPrimaryDestination] [bit] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
