USE [db-au-actuary]
GO
/****** Object:  Table [ws].[FinesseAUAug21_scored_TT-ST-250xs_2k_ext]    Script Date: 18/02/2025 12:14:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ws].[FinesseAUAug21_scored_TT-ST-250xs_2k_ext](
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
	[Single Multi Trip - Band] [varchar](50) NULL,
	[Age of oldest adult (Detailed) - Band] [varchar](50) NULL,
	[Age of second oldest adult (Detailed) - Band] [varchar](50) NULL,
	[Travel Duration (Detailed) - Band] [varchar](50) NULL,
	[1Cover Comprehensive Premium] [varchar](50) NULL,
	[Allianz Comprehensive Premium] [varchar](50) NULL,
	[CGU Platinum Premium] [varchar](50) NULL,
	[CoverMore Single Trip Premium Premium] [varchar](50) NULL,
	[nib Comprehensive Premium] [varchar](50) NULL,
	[Qantas International Comprehensive Premium] [varchar](50) NULL,
	[RACQ Premium Premium] [varchar](50) NULL,
	[RACV Total Travel Care Premium] [varchar](50) NULL,
	[Southern Cross Premium] [varchar](50) NULL,
	[World2Cover Top Premium] [varchar](50) NULL,
	[Worldcare Comprehensive Premium] [varchar](50) NULL,
	[FYP_SP] [varchar](50) NULL,
	[NPP_SP] [varchar](50) NULL,
	[CMH_SP] [varchar](50) NULL
) ON [PRIMARY]
GO
