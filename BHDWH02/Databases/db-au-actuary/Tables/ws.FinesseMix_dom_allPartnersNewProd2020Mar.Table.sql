USE [db-au-actuary]
GO
/****** Object:  Table [ws].[FinesseMix_dom_allPartnersNewProd2020Mar]    Script Date: 18/02/2025 12:14:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ws].[FinesseMix_dom_allPartnersNewProd2020Mar](
	[period] [varchar](50) NULL,
	[Sample Number] [varchar](50) NULL,
	[Factor] [varchar](50) NULL,
	[State] [varchar](50) NULL,
	[Destination] [varchar](50) NULL,
	[International Domestic] [varchar](50) NULL,
	[Number of Travellers] [varchar](50) NULL,
	[Travel Group] [varchar](50) NULL,
	[Number of Adults] [varchar](50) NULL,
	[Number of Children] [varchar](50) NULL,
	[Age of oldest adult] [varchar](50) NULL,
	[Age of second oldest adult] [varchar](50) NULL,
	[Age of oldest dependent] [varchar](50) NULL,
	[Age of second oldest dependent] [varchar](50) NULL,
	[Age of third oldest dependent] [varchar](50) NULL,
	[Travel Duration] [varchar](50) NULL,
	[Destination Region] [varchar](50) NULL,
	[Lead Time] [varchar](50) NULL,
	[Profile] [varchar](50) NULL,
	[Travel Group Detailed] [varchar](50) NULL,
	[Age of oldest adult - Band] [varchar](50) NULL,
	[Age of second oldest adult - Band] [varchar](50) NULL,
	[Age of oldest dependent - Band] [varchar](50) NULL,
	[Age of second oldest dependent - Band] [varchar](50) NULL,
	[Age of third oldest dependent - Band] [varchar](50) NULL,
	[Travel Duration - Band] [varchar](50) NULL,
	[Lead time - Band] [varchar](50) NULL,
	[Single Multi Trip] [varchar](50) NULL,
	[Age of oldest adult (Detailed) - Band] [varchar](50) NULL,
	[Age of second oldest adult (Detailed) - Band] [varchar](50) NULL,
	[Travel Duration (Detailed) - Band] [varchar](50) NULL,
	[FYP_SP] [varchar](50) NULL,
	[ICC_SP] [varchar](50) NULL,
	[CMH_SP] [varchar](50) NULL,
	[CBT_SP] [varchar](50) NULL,
	[NRI_SP] [varchar](50) NULL,
	[APC_SP] [varchar](50) NULL,
	[AHM_SP] [varchar](50) NULL,
	[MBC_SP] [varchar](50) NULL,
	[CoViD_SP] [varchar](50) NULL
) ON [PRIMARY]
GO
