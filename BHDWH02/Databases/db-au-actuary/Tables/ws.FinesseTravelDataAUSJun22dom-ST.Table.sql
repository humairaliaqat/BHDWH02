USE [db-au-actuary]
GO
/****** Object:  Table [ws].[FinesseTravelDataAUSJun22dom-ST]    Script Date: 18/02/2025 12:14:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ws].[FinesseTravelDataAUSJun22dom-ST](
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
	[ahm Comprehensive Premium] [varchar](50) NULL,
	[ahm Domestic Single Trip Premium] [varchar](50) NULL,
	[Allianz Domestic Premium] [varchar](50) NULL,
	[AusPost Comprehensive Premium] [varchar](50) NULL,
	[CGU Domestic Premium] [varchar](50) NULL,
	[CoverMore Basic Premium] [varchar](50) NULL,
	[CoverMore Comprehensive Premium] [varchar](50) NULL,
	[CoverMore Comprehensive Plus Premium] [varchar](50) NULL,
	[Flight Centre Domestic Premium] [varchar](50) NULL,
	[Flight Centre Domestic Cancellation Premium] [varchar](50) NULL,
	[Insure and Go Bare Essentials Premium] [varchar](50) NULL,
	[Insure and Go Gold Premium] [varchar](50) NULL,
	[Insure and Go Silver Premium] [varchar](50) NULL,
	[Medibank Comprehensive Premium] [varchar](50) NULL,
	[National Seniors Premium] [varchar](50) NULL,
	[nib Domestic Premium] [varchar](50) NULL,
	[nib Domestic Cancellation Premium] [varchar](50) NULL,
	[NRMA Comprehensive Single Trip Premium] [varchar](50) NULL,
	[NRMA Essentials Premium] [varchar](50) NULL,
	[Qantas Australian Comprehensive Premium] [varchar](50) NULL,
	[RAA Cancellation Premium] [varchar](50) NULL,
	[RAA Essentials Premium] [varchar](50) NULL,
	[RAA Rental Car Excess Premium] [varchar](50) NULL,
	[RAC Cancellation Premium] [varchar](50) NULL,
	[RAC Essentials Premium] [varchar](50) NULL,
	[RAC Rental Car Excess Premium] [varchar](50) NULL,
	[RACQ Cancellation Premium] [varchar](50) NULL,
	[RACQ Rental Car Excess Premium] [varchar](50) NULL,
	[RACQ Standard Premium] [varchar](50) NULL,
	[RACV Cancellation Premium] [varchar](50) NULL,
	[RACV Essentials Premium] [varchar](50) NULL,
	[RACV Rental Car Excess Premium] [varchar](50) NULL,
	[Ski Insurance Premium] [varchar](50) NULL,
	[TID Basics Premium] [varchar](50) NULL,
	[TID The Works Premium] [varchar](50) NULL,
	[Virgin Australia Comprehensive Premium] [varchar](50) NULL,
	[Virgin Australia Domestic Premium] [varchar](50) NULL,
	[Webjet Travel Safe Plus Domestic Premium] [varchar](50) NULL,
	[Webjet Travel Safe Plus Domestic Cancellation Premium] [varchar](50) NULL,
	[World2Cover Essentials Premium] [varchar](50) NULL,
	[Worldcare Australia Only Premium] [varchar](50) NULL
) ON [PRIMARY]
GO
