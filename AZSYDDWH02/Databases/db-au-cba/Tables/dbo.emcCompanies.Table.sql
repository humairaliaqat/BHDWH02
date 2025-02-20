USE [db-au-cba]
GO
/****** Object:  Table [dbo].[emcCompanies]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[emcCompanies](
	[CountryKey] [varchar](2) NOT NULL,
	[CompanyKey] [varchar](10) NOT NULL,
	[ParentCompanyID] [int] NULL,
	[CompanyID] [int] NOT NULL,
	[SubCompanyID] [int] NULL,
	[CompanyCode] [varchar](50) NULL,
	[SubCompanyCode] [varchar](50) NULL,
	[ProductCode] [varchar](5) NULL,
	[ParentCompanyName] [varchar](100) NULL,
	[CompanyName] [varchar](50) NULL,
	[SubCompanyName] [varchar](250) NULL,
	[ValidFrom] [datetime] NULL,
	[ValidTo] [datetime] NULL,
	[Phone] [varchar](30) NULL,
	[Fax] [varchar](30) NULL,
	[Email] [varchar](255) NULL,
	[BCC] [varchar](255) NULL,
	[FromEmail] [varchar](255) NULL,
	[isHealixOnly] [bit] NULL,
	[isSubCompanyActive] [bit] NULL,
	[ParentCompanyCode] [varchar](3) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_emcCompanies_CompanyKey]    Script Date: 20/02/2025 10:13:01 AM ******/
CREATE CLUSTERED INDEX [idx_emcCompanies_CompanyKey] ON [dbo].[emcCompanies]
(
	[CompanyKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_emcCompanies_ValidDates]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_emcCompanies_ValidDates] ON [dbo].[emcCompanies]
(
	[ValidFrom] ASC,
	[ValidTo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
