USE [db-au-stage]
GO
/****** Object:  Table [dbo].[claims_KLSECURITY_au]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[claims_KLSECURITY_au](
	[KS_ID] [int] NOT NULL,
	[KSLIMITS] [money] NULL,
	[KSESTLIMITS] [money] NULL,
	[KSINITS] [varchar](3) NULL,
	[KSNAME] [varchar](30) NULL,
	[KSLOGIN] [varchar](50) NULL,
	[KSPWLAST] [datetime] NULL,
	[KSDOMAINID] [int] NOT NULL,
	[KSDEFAULTDOMAINID] [int] NULL,
	[KSACTIVE] [bit] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Index [idx_claims_klsecurity_au_id]    Script Date: 20/02/2025 10:25:22 AM ******/
CREATE NONCLUSTERED INDEX [idx_claims_klsecurity_au_id] ON [dbo].[claims_KLSECURITY_au]
(
	[KS_ID] ASC
)
INCLUDE([KSNAME]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
