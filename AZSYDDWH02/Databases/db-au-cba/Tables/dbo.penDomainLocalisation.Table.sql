USE [db-au-cba]
GO
/****** Object:  Table [dbo].[penDomainLocalisation]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[penDomainLocalisation](
	[BIRowID] [bigint] IDENTITY(1,1) NOT NULL,
	[CountryKey] [varchar](2) NOT NULL,
	[CompanyKey] [varchar](5) NOT NULL,
	[DomainKey] [varchar](41) NULL,
	[LocalisationKey] [varchar](41) NULL,
	[LocalisationID] [int] NULL,
	[DomainID] [int] NULL,
	[DomainLanguageId] [int] NULL,
	[CultureCode] [nvarchar](20) NULL,
	[LanguageName] [nvarchar](100) NULL,
	[DefaultForCatalyst] [bit] NULL,
	[TableName] [varchar](100) NULL,
	[ColumnName] [varchar](100) NULL,
	[DataId] [int] NULL,
	[StringValue] [nvarchar](max) NULL,
	[UpdateDateTime] [datetime] NULL,
	[IsDirty] [bit] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Index [idx_penDomain_BIRowID]    Script Date: 20/02/2025 10:13:01 AM ******/
CREATE CLUSTERED INDEX [idx_penDomain_BIRowID] ON [dbo].[penDomainLocalisation]
(
	[BIRowID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_penDomain_DomainKey]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_penDomain_DomainKey] ON [dbo].[penDomainLocalisation]
(
	[DomainKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_penDomain_Translation]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_penDomain_Translation] ON [dbo].[penDomainLocalisation]
(
	[DataId] ASC,
	[DomainKey] ASC
)
INCLUDE([DomainID],[CultureCode],[LanguageName],[TableName],[ColumnName],[StringValue]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
