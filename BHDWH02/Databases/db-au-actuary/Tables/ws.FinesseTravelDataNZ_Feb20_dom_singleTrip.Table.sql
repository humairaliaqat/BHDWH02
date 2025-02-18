USE [db-au-actuary]
GO
/****** Object:  Table [ws].[FinesseTravelDataNZ_Feb20_dom_singleTrip]    Script Date: 18/02/2025 12:14:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ws].[FinesseTravelDataNZ_Feb20_dom_singleTrip](
	[Period] [varchar](50) NULL,
	[Sample Number] [varchar](50) NULL,
	[State] [varchar](50) NULL,
	[Factor] [varchar](50) NULL,
	[Destination] [varchar](50) NULL,
	[Travel group] [varchar](50) NULL,
	[Number of travellers] [varchar](50) NULL,
	[Number of adults] [varchar](50) NULL,
	[Number of children] [varchar](50) NULL,
	[Age 1] [varchar](50) NULL,
	[Age 2] [varchar](50) NULL,
	[Age 3] [varchar](50) NULL,
	[Age 4] [varchar](50) NULL,
	[Age 5] [varchar](50) NULL,
	[Age of oldest] [varchar](50) NULL,
	[Age of youngest] [varchar](50) NULL,
	[Travel duration] [varchar](50) NULL,
	[Lead time] [varchar](50) NULL,
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
	[StateNZ Premium] [varchar](50) NULL
) ON [PRIMARY]
GO
