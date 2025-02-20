USE [db-au-stage]
GO
/****** Object:  Table [dbo].[claims_KLESTHIST_au]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[claims_KLESTHIST_au](
	[EH_ID] [int] NOT NULL,
	[EHIS_ID] [int] NULL,
	[EHESTIMATE] [money] NULL,
	[EHCREATED] [datetime] NULL,
	[EHCREATEDBY_ID] [int] NULL,
	[EHRECOVEST] [money] NULL
) ON [PRIMARY]
GO
