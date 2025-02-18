USE [db-au-actuary]
GO
/****** Object:  Table [ws].[FinesseTravelDataAUSDec22int-st]    Script Date: 18/02/2025 12:14:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ws].[FinesseTravelDataAUSDec22int-st](
	[Period] [varchar](50) NULL,
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
	[1Cover Medical Only Premium] [varchar](50) NULL,
	[ahm Comprehensive Premium] [varchar](50) NULL,
	[ahm Medical Only Premium] [varchar](50) NULL,
	[Allianz Budget Premium] [varchar](50) NULL,
	[Allianz Comprehensive Premium] [varchar](50) NULL,
	[AusPost Basic Premium] [varchar](50) NULL,
	[AusPost Comprehensive Premium] [varchar](50) NULL,
	[CBA Medical Only Premium] [varchar](50) NULL,
	[CGU Essentials Premium] [varchar](50) NULL,
	[CGU Platinum Premium] [varchar](50) NULL,
	[CGU Premium Premium] [varchar](50) NULL,
	[Chubb Comprehensive Premium] [varchar](50) NULL,
	[Chubb Essential Premium] [varchar](50) NULL,
	[Chubb Prestige Premium] [varchar](50) NULL,
	[CoverMore Basic Premium] [varchar](50) NULL,
	[CoverMore Comprehensive Premium] [varchar](50) NULL,
	[CoverMore Comprehensive Plus Premium] [varchar](50) NULL,
	[Flight Centre YourCover Essentials Premium] [varchar](50) NULL,
	[Flight Centre YourCover Plus Premium] [varchar](50) NULL,
	[Insure and Go Bare Essentials Premium] [varchar](50) NULL,
	[Insure and Go Gold Premium] [varchar](50) NULL,
	[Insure and Go Silver Premium] [varchar](50) NULL,
	[Medibank Comprehensive Premium] [varchar](50) NULL,
	[Medibank Medical Only Premium] [varchar](50) NULL,
	[National Seniors Premium] [varchar](50) NULL,
	[nib Comprehensive Premium] [varchar](50) NULL,
	[nib Essentials Premium] [varchar](50) NULL,
	[NRMA (SA, WA, NT) Essentials Premium] [varchar](50) NULL,
	[NRMA (SA, WA, NT) Platinum Premium] [varchar](50) NULL,
	[NRMA (SA, WA, NT) Premium Premium] [varchar](50) NULL,
	[NRMA Comprehensive Single Trip Premium] [varchar](50) NULL,
	[NRMA Essentials Premium] [varchar](50) NULL,
	[Qantas International Comprehensive Premium] [varchar](50) NULL,
	[RAA Basics Premium] [varchar](50) NULL,
	[RAA Essentials Premium] [varchar](50) NULL,
	[RAA Premium Premium] [varchar](50) NULL,
	[RAC Comprehensive Premium] [varchar](50) NULL,
	[RAC Essentials Premium] [varchar](50) NULL,
	[RAC Medical Only Premium] [varchar](50) NULL,
	[RACQ Premium Premium] [varchar](50) NULL,
	[RACQ Saver Premium] [varchar](50) NULL,
	[RACQ Standard Premium] [varchar](50) NULL,
	[RACV Basics Premium] [varchar](50) NULL,
	[RACV Comprehensive Premium] [varchar](50) NULL,
	[RACV Essentials Premium] [varchar](50) NULL,
	[Ski Insurance Premium] [varchar](50) NULL,
	[Southern Cross Premium] [varchar](50) NULL,
	[Teachers Health Premium] [varchar](50) NULL,
	[Teachers Health Essentials Premium] [varchar](50) NULL,
	[TID Basics Premium] [varchar](50) NULL,
	[TID The Works Premium] [varchar](50) NULL,
	[Travel Insuranz Classic Premium] [varchar](50) NULL,
	[Travel Insuranz Deluxe Premium] [varchar](50) NULL,
	[Travel Insuranz Premier Premium] [varchar](50) NULL,
	[Virgin Australia Comprehensive Premium] [varchar](50) NULL,
	[Virgin Australia Essential Premium] [varchar](50) NULL,
	[Webjet Travel Safe International Premium] [varchar](50) NULL,
	[Webjet Travel Safe Plus International Premium] [varchar](50) NULL,
	[World Nomads Explorer Premium] [varchar](50) NULL,
	[World Nomads Standard Premium] [varchar](50) NULL,
	[World2Cover Basics Premium] [varchar](50) NULL,
	[World2Cover Essentials Premium] [varchar](50) NULL,
	[World2Cover Top Premium] [varchar](50) NULL,
	[Worldcare Comprehensive Premium] [varchar](50) NULL,
	[Worldcare Essential Premium] [varchar](50) NULL
) ON [PRIMARY]
GO
