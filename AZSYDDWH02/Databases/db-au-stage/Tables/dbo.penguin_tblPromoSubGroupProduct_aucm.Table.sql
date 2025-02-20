USE [db-au-stage]
GO
/****** Object:  Table [dbo].[penguin_tblPromoSubGroupProduct_aucm]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[penguin_tblPromoSubGroupProduct_aucm](
	[PromoID] [int] NOT NULL,
	[SubGroupID] [int] NOT NULL,
	[ProductID] [int] NOT NULL,
	[Status] [varchar](15) NOT NULL,
	[CreateDateTime] [datetime] NOT NULL,
	[UpdateDateTime] [datetime] NOT NULL,
	[ID] [int] NOT NULL,
	[SelectAllPlans] [bit] NOT NULL,
	[SelectAllAlphas] [bit] NOT NULL
) ON [PRIMARY]
GO
