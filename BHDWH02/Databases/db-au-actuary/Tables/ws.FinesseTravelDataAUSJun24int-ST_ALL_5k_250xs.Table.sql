USE [db-au-actuary]
GO
/****** Object:  Table [ws].[FinesseTravelDataAUSJun24int-ST_ALL_5k_250xs]    Script Date: 18/02/2025 12:14:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ws].[FinesseTravelDataAUSJun24int-ST_ALL_5k_250xs](
	[Period] [varchar](50) NULL,
	[Sample Number] [varchar](50) NULL,
	[State] [varchar](50) NULL,
	[Destination] [varchar](50) NULL,
	[GeoZone] [varchar](50) NULL,
	[International Domestic] [varchar](50) NULL,
	[Number_of_Travellers] [varchar](50) NULL,
	[Travel_Group] [varchar](50) NULL,
	[Number_of_Adults] [varchar](50) NULL,
	[Number_of_Children] [varchar](50) NULL,
	[Age_of_oldest_adult] [varchar](50) NULL,
	[Age_of_second_oldest_adult] [varchar](50) NULL,
	[Age_of_oldest_dependent] [varchar](50) NULL,
	[Age_of_second_oldest_dependent] [varchar](50) NULL,
	[Age_of_third_oldest_dependent] [varchar](50) NULL,
	[age0order] [varchar](50) NULL,
	[age1order] [varchar](50) NULL,
	[age2order] [varchar](50) NULL,
	[age3order] [varchar](50) NULL,
	[age4order] [varchar](50) NULL,
	[Travel_Duration] [varchar](50) NULL,
	[Destination_Region] [varchar](50) NULL,
	[Lead_Time] [varchar](50) NULL,
	[Profile] [varchar](50) NULL,
	[Travel Duration - Band] [varchar](50) NULL,
	[Lead time - Band] [varchar](50) NULL,
	[Single Multi Trip - Band] [varchar](50) NULL,
	[FYP_BaseSP] [varchar](50) NULL,
	[FYP_CanxSP] [varchar](50) NULL,
	[FYP_SP] [varchar](50) NULL,
	[FYE_BaseSP] [varchar](50) NULL,
	[FYE_CanxSP] [varchar](50) NULL,
	[FYE_SP] [varchar](50) NULL,
	[ICC_BaseSP] [float] NULL,
	[ICC_CanxSP] [float] NULL,
	[ICC_SP] [float] NULL,
	[IEC_BaseSP] [float] NULL,
	[IEC_CanxSP] [float] NULL,
	[IEC_SP] [float] NULL,
	[CBI_BaseSP] [varchar](50) NULL,
	[CBI_CanxSP] [varchar](50) NULL,
	[CBI_SP] [varchar](50) NULL,
	[CPCm_BaseSP] [varchar](50) NULL,
	[CPCm_CanxSP] [varchar](50) NULL,
	[CPCm_SP] [varchar](50) NULL,
	[CPCp_BaseSP] [varchar](50) NULL,
	[CPCp_CanxSP] [varchar](50) NULL,
	[CPCp_SP] [varchar](50) NULL,
	[MBC_BaseSP] [varchar](50) NULL,
	[MBC_CanxSP] [varchar](50) NULL,
	[MBC_SP] [varchar](50) NULL,
	[AHM_BaseSP] [varchar](50) NULL,
	[AHM_CanxSP] [varchar](50) NULL,
	[AHM_SP] [varchar](50) NULL,
	[APC_BaseSP] [varchar](50) NULL,
	[APC_CanxSP] [varchar](50) NULL,
	[APC_SP] [varchar](50) NULL,
	[CBT_BaseSP] [varchar](50) NULL,
	[CBT_CanxSP] [varchar](50) NULL,
	[CBT_SP] [varchar](50) NULL,
	[CBTe_BaseSP] [varchar](50) NULL,
	[CBTe_CanxSP] [varchar](50) NULL,
	[CBTe_SP] [varchar](50) NULL,
	[NRI_BaseSP] [varchar](50) NULL,
	[NRI_CanxSP] [varchar](50) NULL,
	[NRI_SP] [varchar](50) NULL,
	[NRIe_BaseSP] [varchar](50) NULL,
	[NRIe_CanxSP] [varchar](50) NULL,
	[NRIe_SP] [varchar](50) NULL,
	[WJP_BaseSP] [varchar](50) NULL,
	[WJP_CanxSP] [varchar](50) NULL,
	[WJP_SP] [varchar](50) NULL,
	[NPP_BaseSP] [varchar](50) NULL,
	[NPP_CanxSP] [varchar](50) NULL,
	[NPP_SP] [varchar](50) NULL,
	[NPG_BaseSP] [varchar](50) NULL,
	[NPG_CanxSP] [varchar](50) NULL,
	[NPG_SP] [varchar](50) NULL,
	[MTPk_BaseSP] [varchar](50) NULL,
	[MTPk_CanxSP] [varchar](50) NULL,
	[MTPk_SP] [varchar](50) NULL,
	[MTEk_BaseSP] [varchar](50) NULL,
	[MTEk_CanxSP] [varchar](50) NULL,
	[MTEk_SP] [varchar](50) NULL,
	[MTPb_BaseSP] [varchar](50) NULL,
	[MTPb_CanxSP] [varchar](50) NULL,
	[MTPb_SP] [varchar](50) NULL,
	[MTEb_BaseSP] [varchar](50) NULL,
	[MTEb_CanxSP] [varchar](50) NULL,
	[MTEb_SP] [varchar](50) NULL,
	[BDC_BaseSP] [varchar](50) NULL,
	[BDC_CanxSP] [varchar](50) NULL,
	[BDC_SP] [varchar](50) NULL,
	[BDCe_BaseSP] [varchar](50) NULL,
	[BDCe_CanxSP] [varchar](50) NULL,
	[BDCeE_SP] [varchar](50) NULL,
	[1Cover IST (Comprehensive) Premium] [varchar](50) NULL,
	[1Cover IST (Medical Only) Premium] [varchar](50) NULL,
	[ahm IST (International Comprehensive) Premium] [varchar](50) NULL,
	[ahm IST (International Medical Only) Premium] [varchar](50) NULL,
	[Allianz IST (Basic) Premium] [varchar](50) NULL,
	[Allianz IST (Comprehensive) Premium] [varchar](50) NULL,
	[AusPost IST (Basic) Premium] [varchar](50) NULL,
	[AusPost IST (Comprehensive) Premium] [varchar](50) NULL,
	[Battleface IST (Comprehensive) Premium] [varchar](50) NULL,
	[Battleface IST (Covid Essentials) Premium] [varchar](50) NULL,
	[Budget Direct IST (Basic) Premium] [varchar](50) NULL,
	[Budget Direct IST (Comprehensive) Premium] [varchar](50) NULL,
	[Budget Direct IST (Essential) Premium] [varchar](50) NULL,
	[Bupa IST (International Essentials) Premium] [varchar](50) NULL,
	[Bupa IST(International Plus) Premium] [varchar](50) NULL,
	[CBA IST (Comprehensive) Premium] [varchar](50) NULL,
	[CBA IST (Essentials) Premium] [varchar](50) NULL,
	[CBA IST (Medical Only) Premium] [varchar](50) NULL,
	[Chubb IST (Comprehensive) Premium] [varchar](50) NULL,
	[Chubb IST (Essentials) Premium] [varchar](50) NULL,
	[Chubb IST (Prestige) Premium] [varchar](50) NULL,
	[COTA IST (Basic) Premium] [varchar](50) NULL,
	[COTA IST (Comprehensive) Premium] [varchar](50) NULL,
	[Cover-More IST (International Basic) Premium] [varchar](50) NULL,
	[Cover-More IST (International Comprehensive +) Premium] [varchar](50) NULL,
	[Cover-More IST (International Comprehensive) Premium] [varchar](50) NULL,
	[Flight Centre IST (YourCover Essentials) Premium] [varchar](50) NULL,
	[Flight Centre IST (YourCover Plus) Premium] [varchar](50) NULL,
	[Freely IST (Overseas Explorer) Premium] [varchar](50) NULL,
	[Go Insurance IST (Go Basic) Premium] [varchar](50) NULL,
	[Go Insurance IST (Go Plus) Premium] [varchar](50) NULL,
	[HCF IST (Comprehensive) Premium] [varchar](50) NULL,
	[HCF IST (Essentials) Premium] [varchar](50) NULL,
	[Insure and Go IST (Bare Essentials) Premium] [varchar](50) NULL,
	[Insure and Go IST (Gold) Premium] [varchar](50) NULL,
	[Insure and Go IST (Silver) Premium] [varchar](50) NULL,
	[Insure4Less IST (Essentials) Premium] [varchar](50) NULL,
	[Insure4Less IST (Excel Plus) Premium] [varchar](50) NULL,
	[Insure4Less IST (Excel) Premium] [varchar](50) NULL,
	[Insure4Less IST (Medical Only) Premium] [varchar](50) NULL,
	[Medibank IST (International Comprehensive Single Trip) Premium] [varchar](50) NULL,
	[Medibank IST (International Medical Only Single Trip) Premium] [varchar](50) NULL,
	[National Seniors IST (Comprehensive) Premium] [varchar](50) NULL,
	[National Seniors IST (Essentials) Premium] [varchar](50) NULL,
	[nib IST (Comprehensive) Premium] [varchar](50) NULL,
	[nib IST (Essentials) Premium] [varchar](50) NULL,
	[NRMA IST (Comprehensive Single Trip) Premium] [varchar](50) NULL,
	[NRMA IST (Essentials Single Trip) Premium] [varchar](50) NULL,
	[PassportCard IST (Basic International) Premium] [varchar](50) NULL,
	[PassportCard IST (Comprehensive International) Premium] [varchar](50) NULL,
	[Qantas IST (International Comprehensive) Premium] [varchar](50) NULL,
	[RAA IST (Basic) Premium] [varchar](50) NULL,
	[RAA IST (Essentials) Premium] [varchar](50) NULL,
	[RAA IST (Premium) Premium] [varchar](50) NULL,
	[RAC IST (Comprehensive) Premium] [varchar](50) NULL,
	[RAC IST (Essentials) Premium] [varchar](50) NULL,
	[RAC IST (Medical Only) Premium] [varchar](50) NULL,
	[RACQ IST (Premium) Premium] [varchar](50) NULL,
	[RACQ IST (Saver) Premium] [varchar](50) NULL,
	[RACQ IST (Standard) Premium] [varchar](50) NULL,
	[RACT IST (Comprehensive) Premium] [varchar](50) NULL,
	[RACT IST (Essentials) Premium] [varchar](50) NULL,
	[RACT IST (Saver) Premium] [varchar](50) NULL,
	[RACV IST (Basic) Premium] [varchar](50) NULL,
	[RACV IST (Comprehensive) Premium] [varchar](50) NULL,
	[RACV IST (Essentials) Premium] [varchar](50) NULL,
	[Ski Insurance IST (Ski Plus) Premium] [varchar](50) NULL,
	[Southern Cross IST (Comprehensive Single Trip) Premium] [varchar](50) NULL,
	[Southern Cross IST (International Medical) Premium] [varchar](50) NULL,
	[Teachers Health IST (Comprehensive) Premium] [varchar](50) NULL,
	[Teachers Health IST (Essentials) Premium] [varchar](50) NULL,
	[Tick IST (Basic) Premium] [varchar](50) NULL,
	[Tick IST (Budget) Premium] [varchar](50) NULL,
	[Tick IST (Standard) Premium] [varchar](50) NULL,
	[Tick IST (Top) Premium] [varchar](50) NULL,
	[TID IST (The Basics) Premium] [varchar](50) NULL,
	[TID IST (The Works) Premium] [varchar](50) NULL,
	[Travel Insurance Saver IST (Bare Essentials) Premium] [varchar](50) NULL,
	[Travel Insurance Saver IST (Comprehensive) Premium] [varchar](50) NULL,
	[Travel Insurance Saver IST (Essentials) Premium] [varchar](50) NULL,
	[Travel Insuranz IST (Classic) Premium] [varchar](50) NULL,
	[Travel Insuranz IST (Deluxe) Premium] [varchar](50) NULL,
	[Travel Insuranz IST (Premier Plus) Premium] [varchar](50) NULL,
	[Travel Insuranz IST (Premier) Premium] [varchar](50) NULL,
	[Virgin Australia IST (Travel Safe International) Premium] [varchar](50) NULL,
	[Virgin Australia IST (Travel Safe Plus International) Premium] [varchar](50) NULL,
	[Webjet IST (Travel Safe International) Premium] [varchar](50) NULL,
	[Webjet IST (Travel Safe Plus International) Premium] [varchar](50) NULL,
	[World Nomads IST (Explorer Plan) Premium] [varchar](50) NULL,
	[World Nomads IST (Standard Plan) Premium] [varchar](50) NULL,
	[World2Cover IST (Basics Cover) Premium] [varchar](50) NULL,
	[World2Cover IST (Essentials Cover) Premium] [varchar](50) NULL,
	[World2Cover IST (Top Cover) Premium] [varchar](50) NULL,
	[Worldcare IST (Comprehensive) Premium] [varchar](50) NULL,
	[Worldcare IST (Essentials) Premium] [varchar](50) NULL
) ON [PRIMARY]
GO
