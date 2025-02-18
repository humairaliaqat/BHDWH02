USE [db-au-actuary]
GO
/****** Object:  Table [ws].[FinesseAUAug21_scored_TT-ST-250xs_2k]    Script Date: 18/02/2025 12:14:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ws].[FinesseAUAug21_scored_TT-ST-250xs_2k](
	[Sample Number] [varchar](50) NULL,
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
	[Lead Time] [varchar](50) NULL,
	[Travel Group Detailed] [varchar](50) NULL,
	[Age of oldest adult - Band] [varchar](50) NULL,
	[Age of second oldest adult - Band] [varchar](50) NULL,
	[Age of oldest dependent - Band] [varchar](50) NULL,
	[Age of second oldest dependent - Band] [varchar](50) NULL,
	[Age of third oldest dependent - Band] [varchar](50) NULL,
	[Travel Duration - Band] [varchar](50) NULL,
	[Lead time - Band] [varchar](50) NULL,
	[Age of oldest adult (Detailed) - Band] [varchar](50) NULL,
	[Age of second oldest adult (Detailed) - Band] [varchar](50) NULL,
	[Travel Duration (Detailed) - Band] [varchar](50) NULL,
	[Excess] [varchar](50) NULL,
	[Dest] [varchar](50) NULL,
	[CanxInt_STCMH] [varchar](50) NULL,
	[CanxInt_STFYP] [varchar](50) NULL,
	[CanxInt_STNPP] [varchar](50) NULL,
	[FYP_BaseSP] [varchar](50) NULL,
	[FYP_CanxSP] [varchar](50) NULL,
	[FYP_SP] [varchar](50) NULL,
	[CMH_BaseSP] [varchar](50) NULL,
	[CMH_CanxSP] [varchar](50) NULL,
	[CMH_SP] [varchar](50) NULL,
	[NPP_BaseSP] [varchar](50) NULL,
	[NPP_CanxSP] [varchar](50) NULL,
	[NPP_SP] [varchar](50) NULL
) ON [PRIMARY]
GO
