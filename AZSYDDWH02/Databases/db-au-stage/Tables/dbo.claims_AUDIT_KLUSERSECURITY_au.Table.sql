USE [db-au-stage]
GO
/****** Object:  Table [dbo].[claims_AUDIT_KLUSERSECURITY_au]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[claims_AUDIT_KLUSERSECURITY_au](
	[AUDIT_USERNAME] [varchar](255) NULL,
	[AUDIT_DATETIME] [datetime] NULL,
	[AUDIT_ACTION] [varchar](10) NULL,
	[ID] [int] NULL,
	[KLUSERID] [int] NULL,
	[KLSECURITYLEVEL] [int] NULL,
	[KLSIGNLEVEL1] [nvarchar](50) NULL,
	[KLSIGNLEVEL2] [nvarchar](50) NULL,
	[KLSIGNLEVEL3] [nvarchar](50) NULL
) ON [PRIMARY]
GO
