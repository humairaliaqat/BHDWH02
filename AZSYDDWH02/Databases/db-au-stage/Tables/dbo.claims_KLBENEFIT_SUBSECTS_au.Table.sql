USE [db-au-stage]
GO
/****** Object:  Table [dbo].[claims_KLBENEFIT_SUBSECTS_au]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[claims_KLBENEFIT_SUBSECTS_au](
	[KBSS_ID] [int] NOT NULL,
	[KBSECT_ID] [int] NULL,
	[KBSS_DESC] [varchar](50) NULL,
	[Limit] [money] NULL,
	[ValidFrom] [date] NULL,
	[ValidTo] [date] NULL,
	[comments] [varchar](255) NULL
) ON [PRIMARY]
GO
