USE [db-au-stage]
GO
/****** Object:  Table [dbo].[emc_CBA_EMC_Companies_AU]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[emc_CBA_EMC_Companies_AU](
	[Compid] [smallint] NOT NULL,
	[ProdCode] [varchar](3) NULL,
	[Product] [varchar](50) NULL,
	[ValidFrom] [datetime] NULL,
	[ValidTo] [datetime] NULL,
	[EmailTemplate] [varchar](255) NULL,
	[Phone] [varchar](30) NULL,
	[BCC] [varchar](255) NULL,
	[Email] [varchar](255) NULL,
	[FromEmail] [varchar](255) NULL,
	[Fax] [varchar](30) NULL,
	[Logo] [varchar](255) NULL,
	[Color] [varchar](10) NULL,
	[CompanyCode] [varchar](50) NULL,
	[HealixBaseURL] [varchar](200) NULL,
	[ParentCompanyid] [int] NULL,
	[HealixOnly] [int] NULL,
	[Domainid] [int] NULL
) ON [PRIMARY]
GO
