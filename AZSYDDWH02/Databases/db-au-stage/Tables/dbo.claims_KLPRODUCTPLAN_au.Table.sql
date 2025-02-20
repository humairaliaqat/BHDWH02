USE [db-au-stage]
GO
/****** Object:  Table [dbo].[claims_KLPRODUCTPLAN_au]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[claims_KLPRODUCTPLAN_au](
	[KLPlan_ID] [int] NOT NULL,
	[KLProduct_ID] [int] NULL,
	[KLPlanCode] [varchar](10) NULL,
	[KLDescription] [varchar](200) NULL,
	[KLDisplayOrder] [int] NULL
) ON [PRIMARY]
GO
