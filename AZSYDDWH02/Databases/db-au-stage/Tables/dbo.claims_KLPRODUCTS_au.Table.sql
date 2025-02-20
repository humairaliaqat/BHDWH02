USE [db-au-stage]
GO
/****** Object:  Table [dbo].[claims_KLPRODUCTS_au]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[claims_KLPRODUCTS_au](
	[KPProd_ID] [int] NOT NULL,
	[KPProduct] [varchar](5) NOT NULL,
	[KPDescription] [varchar](30) NULL,
	[KPStartDate] [datetime] NULL,
	[KPSuperceed_ID] [int] NULL,
	[KLDOMAINID] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Index [idx_claims_klproducts_au_id]    Script Date: 20/02/2025 10:25:22 AM ******/
CREATE NONCLUSTERED INDEX [idx_claims_klproducts_au_id] ON [dbo].[claims_KLPRODUCTS_au]
(
	[KPProd_ID] ASC
)
INCLUDE([KPProduct]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
