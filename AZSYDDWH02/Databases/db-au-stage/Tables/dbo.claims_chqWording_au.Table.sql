USE [db-au-stage]
GO
/****** Object:  Table [dbo].[claims_chqWording_au]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[claims_chqWording_au](
	[wID] [int] NOT NULL,
	[chqPAYID] [int] NULL,
	[chqBATCH] [int] NULL,
	[chqWORDINGS] [nvarchar](255) NULL,
	[chqWORD1] [nvarchar](25) NULL,
	[chqWORD2] [nvarchar](15) NULL,
	[chqWORD3] [nvarchar](15) NULL
) ON [PRIMARY]
GO
/****** Object:  Index [idx_claims_chqWording_au_id]    Script Date: 20/02/2025 10:25:22 AM ******/
CREATE NONCLUSTERED INDEX [idx_claims_chqWording_au_id] ON [dbo].[claims_chqWording_au]
(
	[chqBATCH] ASC,
	[chqPAYID] ASC
)
INCLUDE([chqWORDINGS]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
