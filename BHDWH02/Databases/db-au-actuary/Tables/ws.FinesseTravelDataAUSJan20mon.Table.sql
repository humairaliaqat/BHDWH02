USE [db-au-actuary]
GO
/****** Object:  Table [ws].[FinesseTravelDataAUSJan20mon]    Script Date: 18/02/2025 12:14:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ws].[FinesseTravelDataAUSJan20mon](
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
	[Age of oldest adult (Detailed) - Band] [varchar](50) NULL,
	[Age of oldest dependent - Band] [varchar](50) NULL,
	[Age of second oldest adult - Band] [varchar](50) NULL,
	[Age of second oldest adult (Detailed) - Band] [varchar](50) NULL,
	[Age of second oldest dependent - Band] [varchar](50) NULL,
	[Age of third oldest dependent - Band] [varchar](50) NULL,
	[Lead time - Band] [varchar](50) NULL,
	[Single Multi Trip - Band] [varchar](50) NULL,
	[Travel Duration - Band] [varchar](50) NULL,
	[Travel Duration (Detailed) - Band] [varchar](50) NULL,
	[1Cover Comprehensive Premium] [varchar](50) NULL,
	[1Cover Comprehensive Timestamp] [varchar](50) NULL,
	[AAMI Premium] [varchar](50) NULL,
	[AAMI Timestamp] [varchar](50) NULL,
	[Allianz Budget Premium] [varchar](50) NULL,
	[Allianz Budget Timestamp] [varchar](50) NULL,
	[Allianz Comprehensive Premium] [varchar](50) NULL,
	[Allianz Comprehensive Timestamp] [varchar](50) NULL,
	[AusPost Basic Premium] [varchar](50) NULL,
	[AusPost Basic Timestamp] [varchar](50) NULL,
	[AusPost Comprehensive Premium] [varchar](50) NULL,
	[AusPost Comprehensive Timestamp] [varchar](50) NULL,
	[Chubb Comprehensive Premium] [varchar](50) NULL,
	[Chubb Comprehensive Timestamp] [varchar](50) NULL,
	[Chubb Essential Premium] [varchar](50) NULL,
	[Chubb Essential Timestamp] [varchar](50) NULL,
	[Chubb Prestige Premium] [varchar](50) NULL,
	[Chubb Prestige Timestamp] [varchar](50) NULL,
	[CoverMore Single Trip Premium Premium] [varchar](50) NULL,
	[CoverMore Single Trip Premium Timestamp] [varchar](50) NULL,
	[Insure and Go Gold Premium] [varchar](50) NULL,
	[Insure and Go Gold Timestamp] [varchar](50) NULL,
	[Insure and Go Silver Premium] [varchar](50) NULL,
	[Insure and Go Silver Timestamp] [varchar](50) NULL,
	[Online Travel Insurance Comprehensive Premium] [varchar](50) NULL,
	[Online Travel Insurance Comprehensive Timestamp] [varchar](50) NULL,
	[Online Travel Insurance Essentials Premium] [varchar](50) NULL,
	[Online Travel Insurance Essentials Timestamp] [varchar](50) NULL,
	[Southern Cross Premium] [varchar](50) NULL,
	[Southern Cross Timestamp] [varchar](50) NULL,
	[Teachers Health Premium] [varchar](50) NULL,
	[Teachers Health Timestamp] [varchar](50) NULL,
	[TID Basics Premium] [varchar](50) NULL,
	[TID Basics Timestamp] [varchar](50) NULL,
	[TID The Works Premium] [varchar](50) NULL,
	[TID The Works Timestamp] [varchar](50) NULL,
	[Travel Insuranz Deluxe Premium] [varchar](50) NULL,
	[Travel Insuranz Deluxe Timestamp] [varchar](50) NULL,
	[Travel Insuranz Premier Premium] [varchar](50) NULL,
	[Travel Insuranz Premier Timestamp] [varchar](50) NULL,
	[Westpac Premium] [varchar](50) NULL,
	[Westpac Timestamp] [varchar](50) NULL,
	[Worldcare Australia Only Premium] [varchar](50) NULL,
	[Worldcare Australia Only Timestamp] [varchar](50) NULL,
	[Worldcare Basic Premium] [varchar](50) NULL,
	[Worldcare Basic Timestamp] [varchar](50) NULL,
	[Worldcare Comprehensive Premium] [varchar](50) NULL,
	[Worldcare Comprehensive Timestamp] [varchar](50) NULL,
	[Worldcare Essential Premium] [varchar](50) NULL,
	[Worldcare Essential Timestamp] [varchar](50) NULL
) ON [PRIMARY]
GO
