USE [db-au-stage]
GO
/****** Object:  Table [dbo].[claims_AUDIT_KLSECURITY_au]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[claims_AUDIT_KLSECURITY_au](
	[AUDIT_ID] [int] NULL,
	[AUDIT_USERNAME] [varchar](255) NULL,
	[AUDIT_DATETIME] [datetime] NULL,
	[AUDIT_ACTION] [varchar](10) NULL,
	[KS_ID] [int] NULL,
	[KSLIMITS] [money] NULL,
	[KSESTLIMITS] [money] NULL,
	[KSINITS] [varchar](3) NULL,
	[KSNAME] [varchar](30) NULL,
	[KSLOGIN] [varchar](50) NULL,
	[KSPWLAST] [datetime] NULL,
	[KSDOMAINID] [int] NULL,
	[KSDEFAULTDOMAINID] [int] NULL,
	[KSACTIVE] [bit] NULL
) ON [PRIMARY]
GO
