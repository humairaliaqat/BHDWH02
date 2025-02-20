USE [db-au-stage]
GO
/****** Object:  Table [dbo].[etl_penDomainLocalisation]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[etl_penDomainLocalisation](
	[CountryKey] [varchar](2) NULL,
	[CompanyKey] [varchar](2) NOT NULL,
	[DomainKey] [varchar](36) NULL,
	[LocalisationKey] [varchar](36) NULL,
	[LocalisationID] [int] NOT NULL,
	[DomainID] [int] NOT NULL,
	[CultureCode] [nvarchar](10) NOT NULL,
	[LanguageName] [nvarchar](50) NOT NULL,
	[DefaultForCatalyst] [bit] NOT NULL,
	[TableName] [varchar](100) NOT NULL,
	[ColumnName] [varchar](100) NOT NULL,
	[DataId] [int] NOT NULL,
	[StringValue] [nvarchar](max) NULL,
	[UpdateDateTime] [datetime] NOT NULL,
	[DomainLanguageId] [int] NOT NULL,
	[IsDirty] [bit] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
