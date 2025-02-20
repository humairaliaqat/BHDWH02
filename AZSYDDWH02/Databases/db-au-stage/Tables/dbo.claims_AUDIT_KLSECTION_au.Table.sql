USE [db-au-stage]
GO
/****** Object:  Table [dbo].[claims_AUDIT_KLSECTION_au]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[claims_AUDIT_KLSECTION_au](
	[AUDIT_USERNAME] [varchar](255) NULL,
	[AUDIT_DATETIME] [datetime] NULL,
	[AUDIT_ACTION] [varchar](10) NULL,
	[KS_ID] [int] NULL,
	[KSCLAIM_ID] [int] NULL,
	[KSEVENT_ID] [int] NULL,
	[KSSECTCODE] [varchar](25) NULL,
	[KSESTV] [money] NULL,
	[KSREDUND] [bit] NULL,
	[KBSS_ID] [int] NULL,
	[KSSECTDESC] [nvarchar](200) NULL,
	[KSBENEFITLIMIT] [nvarchar](200) NULL,
	[KSRECOVEST] [money] NULL
) ON [PRIMARY]
GO
