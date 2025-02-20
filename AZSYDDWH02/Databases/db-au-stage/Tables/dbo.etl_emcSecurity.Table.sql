USE [db-au-stage]
GO
/****** Object:  Table [dbo].[etl_emcSecurity]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[etl_emcSecurity](
	[CountryKey] [varchar](2) NOT NULL,
	[UserKey] [varchar](10) NULL,
	[UserID] [int] NOT NULL,
	[Login] [varchar](15) NULL,
	[FullName] [varchar](50) NULL,
	[Initial] [char](2) NULL,
	[SecurityLevel] [varchar](5) NULL,
	[Phone] [varchar](15) NULL,
	[Email] [varchar](50) NULL,
	[ValidFrom] [datetime] NULL,
	[ValidTo] [datetime] NULL
) ON [PRIMARY]
GO
