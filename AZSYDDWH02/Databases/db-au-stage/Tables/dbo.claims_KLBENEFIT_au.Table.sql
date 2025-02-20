USE [db-au-stage]
GO
/****** Object:  Table [dbo].[claims_KLBENEFIT_au]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[claims_KLBENEFIT_au](
	[KBSECT_ID] [int] NOT NULL,
	[KBCODE] [varchar](25) NULL,
	[KBDESC] [varchar](200) NULL,
	[KBPROD] [varchar](5) NULL,
	[KBVALIDFROM] [date] NULL,
	[KBVALIDTO] [date] NULL,
	[KBLIMIT] [money] NULL,
	[KBPRINTORDER] [smallint] NULL,
	[KLDOMAINID] [int] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_claims_klbenefit_au_id]    Script Date: 20/02/2025 10:25:22 AM ******/
CREATE NONCLUSTERED INDEX [idx_claims_klbenefit_au_id] ON [dbo].[claims_KLBENEFIT_au]
(
	[KBCODE] ASC,
	[KBPROD] ASC,
	[KBVALIDFROM] ASC,
	[KBVALIDTO] ASC
)
INCLUDE([KBSECT_ID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
