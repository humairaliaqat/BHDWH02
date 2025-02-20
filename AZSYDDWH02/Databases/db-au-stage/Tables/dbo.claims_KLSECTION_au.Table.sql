USE [db-au-stage]
GO
/****** Object:  Table [dbo].[claims_KLSECTION_au]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[claims_KLSECTION_au](
	[KS_ID] [int] NOT NULL,
	[KSCLAIM_ID] [int] NULL,
	[KSEVENT_ID] [int] NULL,
	[KSSECTCODE] [varchar](25) NULL,
	[KSESTV] [money] NULL,
	[KSREDUND] [bit] NOT NULL,
	[KBSS_ID] [int] NULL,
	[KSSECTDESC] [nvarchar](200) NULL,
	[KSBENEFITLIMIT] [nvarchar](200) NULL,
	[KSRECOVEST] [money] NULL
) ON [PRIMARY]
GO
