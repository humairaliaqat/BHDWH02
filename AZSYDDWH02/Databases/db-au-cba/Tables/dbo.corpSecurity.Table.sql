USE [db-au-cba]
GO
/****** Object:  Table [dbo].[corpSecurity]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[corpSecurity](
	[CountryKey] [varchar](2) NOT NULL,
	[SecurityKey] [varchar](10) NULL,
	[SecurityID] [int] NULL,
	[Login] [varchar](15) NULL,
	[Password] [varchar](15) NULL,
	[FullName] [varchar](50) NULL,
	[SecurityLevel] [varchar](50) NULL,
	[JobDesc] [varchar](50) NULL,
	[Signature] [image] NULL,
	[isSuperAdmin] [bit] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_corpSecurity_SecurityKey]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_corpSecurity_SecurityKey] ON [dbo].[corpSecurity]
(
	[SecurityKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
