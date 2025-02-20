USE [db-au-stage]
GO
/****** Object:  Table [dbo].[claims_KLLOCHIST_au]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[claims_KLLOCHIST_au](
	[LH_ID] [int] NOT NULL,
	[LHCLAIM_ID] [int] NULL,
	[LHLOC_ID] [int] NULL,
	[LHCREATEDBY_ID] [int] NULL,
	[LHCREATED] [datetime] NULL,
	[LHNOTE] [nvarchar](50) NULL,
	[LHCorroRecdDt] [datetime] NULL
) ON [PRIMARY]
GO
