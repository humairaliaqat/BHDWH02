USE [db-au-actuary]
GO
/****** Object:  Table [ws].[FinesseTravelDataAUSDec23dom-st]    Script Date: 18/02/2025 12:14:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ws].[FinesseTravelDataAUSDec23dom-st](
	[Period] [varchar](50) NULL,
	[Sample Number] [varchar](50) NULL,
	[State] [varchar](50) NULL,
	[Destination] [varchar](50) NULL,
	[International_Domestic] [varchar](50) NULL,
	[Number_of_Travellers] [varchar](50) NULL,
	[Travel_Group] [varchar](50) NULL,
	[Number_of_Adults] [varchar](50) NULL,
	[Number_of_Children] [varchar](50) NULL,
	[Age_of_oldest_adult] [varchar](50) NULL,
	[Age_of_second_oldest_adult] [varchar](50) NULL,
	[Age_of_oldest_dependent] [varchar](50) NULL,
	[Age_of_second_oldest_dependent] [varchar](50) NULL,
	[Age_of_third_oldest_dependent] [varchar](50) NULL,
	[Travel_Duration] [varchar](50) NULL,
	[Destination_Region] [varchar](50) NULL,
	[Lead_Time] [varchar](50) NULL,
	[Profile] [varchar](50) NULL,
	[Factor] [varchar](50) NULL,
	[Age of second oldest adult - Band] [varchar](50) NULL,
	[Age of oldest adult - Band] [varchar](50) NULL,
	[Age of oldest adult (Detailed) - Band] [varchar](50) NULL,
	[Age of oldest dependent - Band] [varchar](50) NULL,
	[Age of second oldest adult (Detailed) - Band] [varchar](50) NULL,
	[Age of second oldest dependent - Band] [varchar](50) NULL,
	[Age of third oldest dependent - Band] [varchar](50) NULL,
	[Lead time - Band] [varchar](50) NULL,
	[Single Multi Trip - Band] [varchar](50) NULL,
	[Travel Duration - Band] [varchar](50) NULL,
	[Travel Duration (Detailed) - Band] [varchar](50) NULL,
	[1Cover DST (Comprehensive) Premium] [varchar](50) NULL,
	[ahm DST (Domestic Single Trip) Premium] [varchar](50) NULL,
	[Allianz DST (Domestic) Premium] [varchar](50) NULL,
	[AusPost DST (Comprehensive) Premium] [varchar](50) NULL,
	[Budget Direct DST (Domestic) Premium] [varchar](50) NULL,
	[Bupa DST (Domestic) Premium] [varchar](50) NULL,
	[CBA DST (Domestic) Premium] [varchar](50) NULL,
	[CGU DST (Domestic) Premium] [varchar](50) NULL,
	[Chubb DST (Domestic) Premium] [varchar](50) NULL,
	[COTA DST (Australian Travel) Premium] [varchar](50) NULL,
	[COTA DST (Cancellation and Additional Expenses) Premium] [varchar](50) NULL,
	[Cover-More DST (Domestic Basic) Premium] [varchar](50) NULL,
	[Cover-More DST (Domestic Comprehensive +) Premium] [varchar](50) NULL,
	[Cover-More DST (Domestic Comprehensive) Premium] [varchar](50) NULL,
	[Flight Centre DST (YourCover Essentials) Premium] [varchar](50) NULL,
	[Freely DST (Domestic Explorer) Premium] [varchar](50) NULL,
	[Go Insurance DST (Go Basic) Premium] [varchar](50) NULL,
	[Go Insurance DST (Go Plus) Premium] [varchar](50) NULL,
	[HCF DST (Domestic) Premium] [varchar](50) NULL,
	[Insure and Go DST (Bare Essentials Domestic) Premium] [varchar](50) NULL,
	[Insure and Go DST (Gold Domestic) Premium] [varchar](50) NULL,
	[Insure and Go DST (Silver Domestic) Premium] [varchar](50) NULL,
	[Insure4Less DST (Essentials) Premium] [varchar](50) NULL,
	[Insure4Less DST (Excel Plus) Premium] [varchar](50) NULL,
	[Insure4Less DST (Excel) Premium] [varchar](50) NULL,
	[Insure4Less DST (Medical Only) Premium] [varchar](50) NULL,
	[Medibank DST (Domestic Single Trip) Premium] [varchar](50) NULL,
	[National Seniors DST (Australian Travel) Premium] [varchar](50) NULL,
	[National Seniors DST (Cancellation and Additional Expenses) Premium] [varchar](50) NULL,
	[nib DST (Australian Travel) Premium] [varchar](50) NULL,
	[nib DST (Cancellation and Additional Expenses) Premium] [varchar](50) NULL,
	[NRMA DST (Comprehensive Single Trip) Premium] [varchar](50) NULL,
	[NRMA DST (Essentials Single Trip) Premium] [varchar](50) NULL,
	[PassportCard DST (Comprehensive Domestic) Premium] [varchar](50) NULL,
	[Qantas DST (Australian Comprehensive) Premium] [varchar](50) NULL,
	[RAA DST (Domestic Cancellation) Premium] [varchar](50) NULL,
	[RAA DST (Domestic) Premium] [varchar](50) NULL,
	[RAA DST (Rental Car Excess) Premium] [varchar](50) NULL,
	[RAC DST (Comprehensive Domestic) Premium] [varchar](50) NULL,
	[RAC DST (Domestic Cancellation) Premium] [varchar](50) NULL,
	[RAC DST (Rental Car Excess) Premium] [varchar](50) NULL,
	[RACQ DST (Domestic Cancellation) Premium] [varchar](50) NULL,
	[RACQ DST (Domestic) Premium] [varchar](50) NULL,
	[RACQ DST (Rental Car Excess) Premium] [varchar](50) NULL,
	[RACT DST (Domestic Cancellation) Premium] [varchar](50) NULL,
	[RACT DST (Domestic) Premium] [varchar](50) NULL,
	[RACT DST (Rental Car Excess) Premium] [varchar](50) NULL,
	[RACV DST (Domestic Cancellation) Premium] [varchar](50) NULL,
	[RACV DST (Domestic) Premium] [varchar](50) NULL,
	[RACV DST (Rental Car Excess) Premium] [varchar](50) NULL,
	[Ski Insurance DST (Ski Plus Domestic) Premium] [varchar](50) NULL,
	[Southern Cross DST (Holiday in Australia) Premium] [varchar](50) NULL,
	[Teachers Health DST (Domestic) Premium] [varchar](50) NULL,
	[Tick DST (Basic Domestic) Premium] [varchar](50) NULL,
	[Tick DST (Standard Domestic) Premium] [varchar](50) NULL,
	[Tick DST (Top Domestic) Premium] [varchar](50) NULL,
	[TID DST (Domestic) Premium] [varchar](50) NULL,
	[Travel Insurance Saver DST (Australian Travel) Premium] [varchar](50) NULL,
	[Travel Insurance Saver DST (Cancellation and Additional Expenses) Premium] [varchar](50) NULL,
	[Virgin Australia DST (Travel Safe Plus Domestic) Premium] [varchar](50) NULL,
	[Webjet DST (Travel Safe Plus Domestic Cancellation) Premium] [varchar](50) NULL,
	[Webjet DST (Travel Safe Plus Domestic) Premium] [varchar](50) NULL,
	[World2Cover DST (Domestic) Premium] [varchar](50) NULL,
	[Worldcare DST (Domestic) Premium] [varchar](50) NULL
) ON [PRIMARY]
GO
