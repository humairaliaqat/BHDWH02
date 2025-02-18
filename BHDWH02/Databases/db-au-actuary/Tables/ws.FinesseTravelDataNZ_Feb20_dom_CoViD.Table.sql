USE [db-au-actuary]
GO
/****** Object:  Table [ws].[FinesseTravelDataNZ_Feb20_dom_CoViD]    Script Date: 18/02/2025 12:14:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ws].[FinesseTravelDataNZ_Feb20_dom_CoViD](
	[Period] [varchar](50) NULL,
	[Sample Number] [varchar](50) NULL,
	[State] [varchar](50) NULL,
	[Destination] [varchar](50) NULL,
	[Travel group] [varchar](50) NULL,
	[Number of travellers] [varchar](50) NULL,
	[Number of Adults] [varchar](50) NULL,
	[Number of children] [varchar](50) NULL,
	[Age 1] [varchar](50) NULL,
	[Age 2] [varchar](50) NULL,
	[Age 3] [varchar](50) NULL,
	[Age 4] [varchar](50) NULL,
	[Age 5] [varchar](50) NULL,
	[Age of oldest adult] [varchar](50) NULL,
	[Age of second oldest adult] [varchar](50) NULL,
	[Age of youngest] [varchar](50) NULL,
	[Travel Duration] [varchar](50) NULL,
	[Lead Time] [varchar](50) NULL,
	[Age - Band] [varchar](50) NULL,
	[Travel duration (days) - Band] [varchar](50) NULL,
	[1Cover Premium] [varchar](50) NULL,
	[AA Premium] [varchar](50) NULL,
	[AA - Essential Premium] [varchar](50) NULL,
	[Air New Zealand Premium] [varchar](50) NULL,
	[CoverMore Premium] [varchar](50) NULL,
	[Flight Centre Premium] [varchar](50) NULL,
	[Holiday Rescue Premium] [varchar](50) NULL,
	[Kiwi Premium] [varchar](50) NULL,
	[Kiwi - Basic Premium] [varchar](50) NULL,
	[StateNZ Premium] [varchar](50) NULL,
	[ExcessCoViD] [varchar](50) NULL,
	[ExcessNZO] [varchar](50) NULL,
	[ExcessYTI] [varchar](50) NULL,
	[CanxDom_STCoViD] [varchar](50) NULL,
	[CanxDom_STNZO] [varchar](50) NULL,
	[CanxDom_STYTI] [varchar](50) NULL,
	[YTI_SP] [varchar](50) NULL,
	[NZO_SP] [varchar](50) NULL,
	[CoViD_SP] [varchar](50) NULL
) ON [PRIMARY]
GO
