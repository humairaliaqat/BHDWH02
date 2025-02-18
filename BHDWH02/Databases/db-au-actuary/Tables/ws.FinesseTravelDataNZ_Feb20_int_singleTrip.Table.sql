USE [db-au-actuary]
GO
/****** Object:  Table [ws].[FinesseTravelDataNZ_Feb20_int_singleTrip]    Script Date: 18/02/2025 12:14:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ws].[FinesseTravelDataNZ_Feb20_int_singleTrip](
	[Period] [varchar](50) NULL,
	[Sample Number] [varchar](50) NULL,
	[State] [varchar](50) NULL,
	[Destination] [varchar](50) NULL,
	[Factor] [varchar](50) NULL,
	[Travel group] [varchar](50) NULL,
	[Number of travellers] [varchar](50) NULL,
	[Number of Adults] [varchar](50) NULL,
	[Number of Children] [varchar](50) NULL,
	[Age 1] [varchar](50) NULL,
	[Age 2] [varchar](50) NULL,
	[Age 3] [varchar](50) NULL,
	[Age 4] [varchar](50) NULL,
	[Age 5] [varchar](50) NULL,
	[Age of oldest] [varchar](50) NULL,
	[Age of youngest] [varchar](50) NULL,
	[Travel duration] [varchar](50) NULL,
	[Destination Region] [varchar](50) NULL,
	[Lead time] [varchar](50) NULL,
	[Age - Band] [varchar](50) NULL,
	[Travel duration (days) - Band] [varchar](50) NULL,
	[1Cover Premium] [varchar](50) NULL,
	[1Cover Medical Only Premium] [varchar](50) NULL,
	[AA Premium] [varchar](50) NULL,
	[AA - Essential Premium] [varchar](50) NULL,
	[Air New Zealand Premium] [varchar](50) NULL,
	[Air New Zealand - Business Premium] [varchar](50) NULL,
	[ANZ NZ Premium] [varchar](50) NULL,
	[Cigna Premium] [varchar](50) NULL,
	[CoverMore Premium] [varchar](50) NULL,
	[CoverMore - Essential Premium] [varchar](50) NULL,
	[Flight Centre Premium] [varchar](50) NULL,
	[Flight Centre - Essential Premium] [varchar](50) NULL,
	[Holiday Rescue Premium] [varchar](50) NULL,
	[Holiday Rescue Essentials Premium] [varchar](50) NULL,
	[House of Travel Premium] [varchar](50) NULL,
	[House of Travel - Basic Premium] [varchar](50) NULL,
	[Kiwi Premium] [varchar](50) NULL,
	[Kiwi - Basic Premium] [varchar](50) NULL,
	[Kiwi - Medical & Liability Premium] [varchar](50) NULL,
	[NIB Premium] [varchar](50) NULL,
	[Southern Cross Premium] [varchar](50) NULL,
	[StateNZ Premium] [varchar](50) NULL,
	[Tower Premium] [varchar](50) NULL,
	[Westpac Premium] [varchar](50) NULL,
	[Worldcare Premium] [varchar](50) NULL,
	[Worldcare Budget Premium] [varchar](50) NULL
) ON [PRIMARY]
GO
