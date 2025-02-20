USE [db-au-stage]
GO
/****** Object:  Table [dbo].[claims_KLSTATUS_au]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[claims_KLSTATUS_au](
	[KT_ID] [int] NOT NULL,
	[KTTABLE] [varchar](20) NULL,
	[KTFIELD] [varchar](20) NULL,
	[KTSTATUS] [varchar](4) NULL,
	[KTDESC] [varchar](50) NULL,
	[ISACTIVE] [bit] NULL,
	[KLDOMAINID] [int] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_claims_klstatus_au_id]    Script Date: 20/02/2025 10:25:22 AM ******/
CREATE NONCLUSTERED INDEX [idx_claims_klstatus_au_id] ON [dbo].[claims_KLSTATUS_au]
(
	[KT_ID] ASC,
	[KTTABLE] ASC
)
INCLUDE([KTSTATUS],[KTDESC]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
