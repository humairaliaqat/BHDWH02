USE [db-au-stage]
GO
/****** Object:  Table [dbo].[etl_penAddon]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[etl_penAddon](
	[CountryKey] [varchar](2) NULL,
	[CompanyKey] [varchar](5) NULL,
	[DomainKey] [varchar](41) NULL,
	[AddOnKey] [varchar](71) NULL,
	[AddOnID] [int] NOT NULL,
	[DomainID] [int] NULL,
	[AddOnTypeID] [int] NULL,
	[AddOnCode] [nvarchar](50) NULL,
	[AddOnName] [nvarchar](50) NULL,
	[AllowMultiple] [bit] NULL,
	[DisplayName] [nvarchar](100) NULL,
	[isRateCardBased] [bit] NOT NULL,
	[AddOnGroupID] [int] NULL,
	[ControlLabel] [nvarchar](500) NULL,
	[Description] [nvarchar](500) NULL,
	[AddOnControlTypeID] [int] NULL,
	[DefaultValue] [nvarchar](50) NULL,
	[isMandatory] [bit] NOT NULL
) ON [PRIMARY]
GO
