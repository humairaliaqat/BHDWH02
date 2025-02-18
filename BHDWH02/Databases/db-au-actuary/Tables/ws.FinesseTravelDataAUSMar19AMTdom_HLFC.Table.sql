USE [db-au-actuary]
GO
/****** Object:  Table [ws].[FinesseTravelDataAUSMar19AMTdom_HLFC]    Script Date: 18/02/2025 12:14:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ws].[FinesseTravelDataAUSMar19AMTdom_HLFC](
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
	[1Cover Comprehensive Timestamp] [varchar](50) NULL,
	[1Cover Comprehensive Notes] [varchar](50) NULL,
	[1Cover Frequent Traveller Premium] [varchar](50) NULL,
	[1Cover Frequent Traveller Timestamp] [varchar](50) NULL,
	[1Cover Frequent Traveller Notes] [varchar](50) NULL,
	[1Cover Medical Only Premium] [varchar](50) NULL,
	[1Cover Medical Only Timestamp] [varchar](50) NULL,
	[1Cover Medical Only Notes] [varchar](50) NULL,
	[AAMI Premium] [varchar](50) NULL,
	[AAMI Timestamp] [varchar](50) NULL,
	[AAMI Notes] [varchar](50) NULL,
	[ACE Annual Multi Trip Premium] [varchar](50) NULL,
	[ACE Annual Multi Trip Timestamp] [varchar](50) NULL,
	[ACE Annual Multi Trip Notes] [varchar](50) NULL,
	[ACE Elite Premium] [varchar](50) NULL,
	[ACE Elite Timestamp] [varchar](50) NULL,
	[ACE Elite Notes] [varchar](50) NULL,
	[ACE Essentials Premium] [varchar](50) NULL,
	[ACE Essentials Timestamp] [varchar](50) NULL,
	[ACE Essentials Notes] [varchar](50) NULL,
	[ACE Premium Premium] [varchar](50) NULL,
	[ACE Premium Timestamp] [varchar](50) NULL,
	[ACE Premium Notes] [varchar](50) NULL,
	[ahm Annual Multi Trip Premium] [varchar](50) NULL,
	[ahm Annual Multi Trip Timestamp] [varchar](50) NULL,
	[ahm Annual Multi Trip Notes] [varchar](50) NULL,
	[ahm Comprehensive Premium] [varchar](50) NULL,
	[ahm Comprehensive Timestamp] [varchar](50) NULL,
	[ahm Comprehensive Notes] [varchar](50) NULL,
	[ahm Domestic Premium] [varchar](50) NULL,
	[ahm Domestic Timestamp] [varchar](50) NULL,
	[ahm Domestic Notes] [varchar](50) NULL,
	[ahm Medical Only Premium] [varchar](50) NULL,
	[ahm Medical Only Timestamp] [varchar](50) NULL,
	[ahm Medical Only Notes] [varchar](50) NULL,
	[Allianz Budget Premium] [varchar](50) NULL,
	[Allianz Budget Timestamp] [varchar](50) NULL,
	[Allianz Budget Notes] [varchar](50) NULL,
	[Allianz Comprehensive Premium] [varchar](50) NULL,
	[Allianz Comprehensive Timestamp] [varchar](50) NULL,
	[Allianz Comprehensive Notes] [varchar](50) NULL,
	[Allianz FI NAB Comprehensive Premium] [varchar](50) NULL,
	[Allianz FI NAB Comprehensive Timestamp] [varchar](50) NULL,
	[Allianz FI NAB Comprehensive Notes] [varchar](50) NULL,
	[Allianz FI NAB Domestic Premium] [varchar](50) NULL,
	[Allianz FI NAB Domestic Timestamp] [varchar](50) NULL,
	[Allianz FI NAB Essentials Premium] [varchar](50) NULL,
	[Allianz FI NAB Essentials Timestamp] [varchar](50) NULL,
	[Allianz FI NAB Essentials Notes] [varchar](50) NULL,
	[Allianz FI NAB Frequent Traveller Premium] [varchar](50) NULL,
	[Allianz FI NAB Frequent Traveller Timestamp] [varchar](50) NULL,
	[Allianz FI NAB Frequent Traveller Notes] [varchar](50) NULL,
	[Allianz Frequent Traveller Premium] [varchar](50) NULL,
	[Allianz Frequent Traveller Timestamp] [varchar](50) NULL,
	[Allianz Frequent Traveller Notes] [varchar](50) NULL,
	[ANZ Premium] [varchar](50) NULL,
	[ANZ Timestamp] [varchar](50) NULL,
	[ANZ Notes] [varchar](50) NULL,
	[AusPost Basic Premium] [varchar](50) NULL,
	[AusPost Basic Timestamp] [varchar](50) NULL,
	[AusPost Basic Notes] [varchar](50) NULL,
	[AusPost Comprehensive Premium] [varchar](50) NULL,
	[AusPost Comprehensive Timestamp] [varchar](50) NULL,
	[AusPost Comprehensive Notes] [varchar](50) NULL,
	[AusPost Frequent Traveller Basic Premium] [varchar](50) NULL,
	[AusPost Frequent Traveller Basic Timestamp] [varchar](50) NULL,
	[AusPost Frequent Traveller Basic Notes] [varchar](50) NULL,
	[AusPost Frequent Traveller Comprehensive Premium] [varchar](50) NULL,
	[AusPost Frequent Traveller Comprehensive Timestamp] [varchar](50) NULL,
	[AusPost Frequent Traveller Comprehensive Notes] [varchar](50) NULL,
	[Aussie Basic Premium] [varchar](50) NULL,
	[Aussie Basic Timestamp] [varchar](50) NULL,
	[Aussie Basic Notes] [varchar](50) NULL,
	[Aussie Budget Premium] [varchar](50) NULL,
	[Aussie Budget Timestamp] [varchar](50) NULL,
	[Aussie Budget Notes] [varchar](50) NULL,
	[Aussie Mid Premium] [varchar](50) NULL,
	[Aussie Mid Timestamp] [varchar](50) NULL,
	[Aussie Mid Notes] [varchar](50) NULL,
	[Aussie Top Premium] [varchar](50) NULL,
	[Aussie Top Timestamp] [varchar](50) NULL,
	[Aussie Top Notes] [varchar](50) NULL,
	[Aussie Top Plus Premium] [varchar](50) NULL,
	[Aussie Top Plus Timestamp] [varchar](50) NULL,
	[Aussie Top Plus Notes] [varchar](50) NULL,
	[CGU Economy Premium] [varchar](50) NULL,
	[CGU Economy Timestamp] [varchar](50) NULL,
	[CGU Economy Notes] [varchar](50) NULL,
	[CGU Standard Premium] [varchar](50) NULL,
	[CGU Standard Timestamp] [varchar](50) NULL,
	[CGU Standard Notes] [varchar](50) NULL,
	[CGU Super Premium] [varchar](50) NULL,
	[CGU Super Timestamp] [varchar](50) NULL,
	[CGU Super Notes] [varchar](50) NULL,
	[CGU Super Plus Premium] [varchar](50) NULL,
	[CGU Super Plus Timestamp] [varchar](50) NULL,
	[CGU Super Plus Notes] [varchar](50) NULL,
	[CHI Basic Premium] [varchar](50) NULL,
	[CHI Basic Timestamp] [varchar](50) NULL,
	[CHI Basic Notes] [varchar](50) NULL,
	[CHI Budget Premium] [varchar](50) NULL,
	[CHI Budget Timestamp] [varchar](50) NULL,
	[CHI Budget Notes] [varchar](50) NULL,
	[CHI Mid Premium] [varchar](50) NULL,
	[CHI Mid Timestamp] [varchar](50) NULL,
	[CHI Mid Notes] [varchar](50) NULL,
	[CHI Top Premium] [varchar](50) NULL,
	[CHI Top Timestamp] [varchar](50) NULL,
	[CHI Top Notes] [varchar](50) NULL,
	[CHI Top Plus Premium] [varchar](50) NULL,
	[CHI Top Plus Timestamp] [varchar](50) NULL,
	[CHI Top Plus Notes] [varchar](50) NULL,
	[Chubb Annual Multi Trip Premium] [varchar](50) NULL,
	[Chubb Annual Multi Trip Timestamp] [varchar](50) NULL,
	[Chubb Annual Multi Trip Notes] [varchar](50) NULL,
	[Chubb Comprehensive Premium] [varchar](50) NULL,
	[Chubb Comprehensive Timestamp] [varchar](50) NULL,
	[Chubb Comprehensive Notes] [varchar](50) NULL,
	[Chubb Essential Premium] [varchar](50) NULL,
	[Chubb Essential Timestamp] [varchar](50) NULL,
	[Chubb Essential Notes] [varchar](50) NULL,
	[Chubb Prestige Premium] [varchar](50) NULL,
	[Chubb Prestige Timestamp] [varchar](50) NULL,
	[Chubb Prestige Notes] [varchar](50) NULL,
	[Coles TID Premium] [varchar](50) NULL,
	[Coles TID Timestamp] [varchar](50) NULL,
	[Coles TID Notes] [varchar](50) NULL,
	[CoverMore Multi Trip Medical Premium] [varchar](50) NULL,
	[CoverMore Multi Trip Medical Timestamp] [varchar](50) NULL,
	[CoverMore Multi Trip Medical Notes] [varchar](50) NULL,
	[CoverMore Multi Trip Premium Premium] [varchar](50) NULL,
	[CoverMore Multi Trip Premium Timestamp] [varchar](50) NULL,
	[CoverMore Multi Trip Premium Notes] [varchar](50) NULL,
	[CoverMore Single Trip Medical Premium] [varchar](50) NULL,
	[CoverMore Single Trip Medical Timestamp] [varchar](50) NULL,
	[CoverMore Single Trip Medical Notes] [varchar](50) NULL,
	[CoverMore Single Trip Premium Premium] [varchar](50) NULL,
	[CoverMore Single Trip Premium Timestamp] [varchar](50) NULL,
	[CoverMore Single Trip Premium Notes] [varchar](50) NULL,
	[Flight Centre Multi Trip OptionsPlan I Premium] [varchar](50) NULL,
	[Flight Centre Multi Trip OptionsPlan I Timestamp] [varchar](50) NULL,
	[Flight Centre Multi Trip OptionsPlan I Notes] [varchar](50) NULL,
	[Flight Centre Multi Trip TravelsurePlan TI Premium] [varchar](50) NULL,
	[Flight Centre Multi Trip TravelsurePlan TI Timestamp] [varchar](50) NULL,
	[Flight Centre Multi Trip TravelsurePlan TI Notes] [varchar](50) NULL,
	[Flight Centre OptionsPlan I Premium] [varchar](50) NULL,
	[Flight Centre OptionsPlan I Timestamp] [varchar](50) NULL,
	[Flight Centre OptionsPlan I Notes] [varchar](50) NULL,
	[Flight Centre TravelsurePlan TI Premium] [varchar](50) NULL,
	[Flight Centre TravelsurePlan TI Timestamp] [varchar](50) NULL,
	[Flight Centre TravelsurePlan TI Notes] [varchar](50) NULL,
	[Good 2 Go Essentials Premium] [varchar](50) NULL,
	[Good 2 Go Essentials Timestamp] [varchar](50) NULL,
	[Good 2 Go Essentials Notes] [varchar](50) NULL,
	[Good 2 Go Mature Age Premium] [varchar](50) NULL,
	[Good 2 Go Mature Age Timestamp] [varchar](50) NULL,
	[Good 2 Go Mature Age Notes] [varchar](50) NULL,
	[Good 2 Go The Works Premium] [varchar](50) NULL,
	[Good 2 Go The Works Timestamp] [varchar](50) NULL,
	[Good 2 Go The Works Notes] [varchar](50) NULL,
	[HBF Economy Premium] [varchar](50) NULL,
	[HBF Economy Timestamp] [varchar](50) NULL,
	[HBF Economy Notes] [varchar](50) NULL,
	[HBF Standard Premium] [varchar](50) NULL,
	[HBF Standard Timestamp] [varchar](50) NULL,
	[HBF Standard Notes] [varchar](50) NULL,
	[HBF Super Premium] [varchar](50) NULL,
	[HBF Super Timestamp] [varchar](50) NULL,
	[HBF Super Notes] [varchar](50) NULL,
	[HBF Super Plus Premium] [varchar](50) NULL,
	[HBF Super Plus Timestamp] [varchar](50) NULL,
	[HBF Super Plus Notes] [varchar](50) NULL,
	[Insure and Go Bare Essentials Premium] [varchar](50) NULL,
	[Insure and Go Bare Essentials Timestamp] [varchar](50) NULL,
	[Insure and Go Bare Essentials Notes] [varchar](50) NULL,
	[Insure and Go Gold Premium] [varchar](50) NULL,
	[Insure and Go Gold Timestamp] [varchar](50) NULL,
	[Insure and Go Gold Notes] [varchar](50) NULL,
	[Insure and Go Silver Premium] [varchar](50) NULL,
	[Insure and Go Silver Timestamp] [varchar](50) NULL,
	[Insure and Go Silver Notes] [varchar](50) NULL,
	[Itrek Adventurer Premium] [varchar](50) NULL,
	[Itrek Adventurer Timestamp] [varchar](50) NULL,
	[Itrek Adventurer Notes] [varchar](50) NULL,
	[Itrek Comprehensive Premium] [varchar](50) NULL,
	[Itrek Comprehensive Timestamp] [varchar](50) NULL,
	[Itrek Comprehensive Notes] [varchar](50) NULL,
	[Itrek Essentials Premium] [varchar](50) NULL,
	[Itrek Essentials Timestamp] [varchar](50) NULL,
	[Itrek Essentials Notes] [varchar](50) NULL,
	[Itrek Medical Only Premium] [varchar](50) NULL,
	[Itrek Medical Only Timestamp] [varchar](50) NULL,
	[Itrek Medical Only Notes] [varchar](50) NULL,
	[Itrek Pioneer Premium] [varchar](50) NULL,
	[Itrek Pioneer Timestamp] [varchar](50) NULL,
	[Itrek Pioneer Notes] [varchar](50) NULL,
	[Itrek Trekker Premium] [varchar](50) NULL,
	[Itrek Trekker Timestamp] [varchar](50) NULL,
	[Itrek Trekker Notes] [varchar](50) NULL,
	[Itrek Wanderer Premium] [varchar](50) NULL,
	[Itrek Wanderer Timestamp] [varchar](50) NULL,
	[Itrek Wanderer Notes] [varchar](50) NULL,
	[JetSet Premium] [varchar](50) NULL,
	[JetSet Timestamp] [varchar](50) NULL,
	[JetSet Notes] [varchar](50) NULL,
	[Jetstar Essential Premium] [varchar](50) NULL,
	[Jetstar Essential Timestamp] [varchar](50) NULL,
	[Jetstar Essential Notes] [varchar](50) NULL,
	[Jetstar Essential Plus Premium] [varchar](50) NULL,
	[Jetstar Essential Plus Timestamp] [varchar](50) NULL,
	[Jetstar Essential Plus Notes] [varchar](50) NULL,
	[Jetstar Premium Premium] [varchar](50) NULL,
	[Jetstar Premium Timestamp] [varchar](50) NULL,
	[Jetstar Premium Notes] [varchar](50) NULL,
	[Kango Annual (Excludes Wintersports) Premium] [varchar](50) NULL,
	[Kango Annual (Excludes Wintersports) Timestamp] [varchar](50) NULL,
	[Kango Annual (Excludes Wintersports) Notes] [varchar](50) NULL,
	[Kango Annual (Includes Wintersports) Premium] [varchar](50) NULL,
	[Kango Annual (Includes Wintersports) Timestamp] [varchar](50) NULL,
	[Kango Annual (Includes Wintersports) Notes] [varchar](50) NULL,
	[Kango Big Red Premium] [varchar](50) NULL,
	[Kango Big Red Timestamp] [varchar](50) NULL,
	[Kango Big Red Notes] [varchar](50) NULL,
	[Kango Budget Premium] [varchar](50) NULL,
	[Kango Budget Timestamp] [varchar](50) NULL,
	[Kango Budget Notes] [varchar](50) NULL,
	[Kango Comprehensive Premium] [varchar](50) NULL,
	[Kango Comprehensive Timestamp] [varchar](50) NULL,
	[Kango Comprehensive Notes] [varchar](50) NULL,
	[Kango Eastern Grey Premium] [varchar](50) NULL,
	[Kango Eastern Grey Timestamp] [varchar](50) NULL,
	[Kango Eastern Grey Notes] [varchar](50) NULL,
	[Kango Essentials Premium] [varchar](50) NULL,
	[Kango Essentials Timestamp] [varchar](50) NULL,
	[Kango Essentials Notes] [varchar](50) NULL,
	[Kango Frequent Traveller Premium] [varchar](50) NULL,
	[Kango Frequent Traveller Timestamp] [varchar](50) NULL,
	[Kango Frequent Traveller Notes] [varchar](50) NULL,
	[Kango Joey Premium] [varchar](50) NULL,
	[Kango Joey Timestamp] [varchar](50) NULL,
	[Kango Joey Notes] [varchar](50) NULL,
	[Kango Rock Wallaby Premium] [varchar](50) NULL,
	[Kango Rock Wallaby Timestamp] [varchar](50) NULL,
	[Kango Rock Wallaby Notes] [varchar](50) NULL,
	[Kango Wallaby Premium] [varchar](50) NULL,
	[Kango Wallaby Timestamp] [varchar](50) NULL,
	[Kango Wallaby Notes] [varchar](50) NULL,
	[Kogan Basic Premium] [varchar](50) NULL,
	[Kogan Basic Timestamp] [varchar](50) NULL,
	[Kogan Basic Notes] [varchar](50) NULL,
	[Kogan Comprehensive Premium] [varchar](50) NULL,
	[Kogan Comprehensive Timestamp] [varchar](50) NULL,
	[Kogan Comprehensive Notes] [varchar](50) NULL,
	[Medibank Comprehensive Premium] [varchar](50) NULL,
	[Medibank Comprehensive Timestamp] [varchar](50) NULL,
	[Medibank Comprehensive Notes] [varchar](50) NULL,
	[Medibank Medical Only Premium] [varchar](50) NULL,
	[Medibank Medical Only Timestamp] [varchar](50) NULL,
	[Medibank Medical Only Notes] [varchar](50) NULL,
	[Medibank Multi Trip Comprehensive Premium] [varchar](50) NULL,
	[Medibank Multi Trip Comprehensive Timestamp] [varchar](50) NULL,
	[Medibank Multi Trip Comprehensive Notes] [varchar](50) NULL,
	[National Seniors Premium] [varchar](50) NULL,
	[National Seniors Timestamp] [varchar](50) NULL,
	[National Seniors Notes] [varchar](50) NULL,
	[NRMA Comprehensive Multi Trip Premium] [varchar](50) NULL,
	[NRMA Comprehensive Multi Trip Timestamp] [varchar](50) NULL,
	[NRMA Comprehensive Multi Trip Notes] [varchar](50) NULL,
	[NRMA Comprehensive Single Trip Premium] [varchar](50) NULL,
	[NRMA Comprehensive Single Trip Timestamp] [varchar](50) NULL,
	[NRMA Comprehensive Single Trip Notes] [varchar](50) NULL,
	[NRMA Essentials Premium] [varchar](50) NULL,
	[NRMA Essentials Timestamp] [varchar](50) NULL,
	[NRMA Essentials Notes] [varchar](50) NULL,
	[Online Travel Insurance Basic Premium] [varchar](50) NULL,
	[Online Travel Insurance Basic Timestamp] [varchar](50) NULL,
	[Online Travel Insurance Basic Notes] [varchar](50) NULL,
	[Online Travel Insurance Comprehensive Premium] [varchar](50) NULL,
	[Online Travel Insurance Comprehensive Timestamp] [varchar](50) NULL,
	[Online Travel Insurance Comprehensive Notes] [varchar](50) NULL,
	[Online Travel Insurance Domestic Premium] [varchar](50) NULL,
	[Online Travel Insurance Domestic Timestamp] [varchar](50) NULL,
	[Online Travel Insurance Essentials Premium] [varchar](50) NULL,
	[Online Travel Insurance Essentials Timestamp] [varchar](50) NULL,
	[Online Travel Insurance Essentials Notes] [varchar](50) NULL,
	[Online Travel Insurance Multi Trip Premium] [varchar](50) NULL,
	[Online Travel Insurance Multi Trip Timestamp] [varchar](50) NULL,
	[Online Travel Insurance Multi Trip Notes] [varchar](50) NULL,
	[Qantas Annual Multi Trip Premium] [varchar](50) NULL,
	[Qantas Annual Multi Trip Timestamp] [varchar](50) NULL,
	[Qantas Annual Multi Trip Notes] [varchar](50) NULL,
	[Qantas Aus Cancellation Baggage Premium] [varchar](50) NULL,
	[Qantas Aus Cancellation Baggage Timestamp] [varchar](50) NULL,
	[Qantas Aus Cancellation Baggage Notes] [varchar](50) NULL,
	[Qantas Aus Cancellation Baggage Excess Premium] [varchar](50) NULL,
	[Qantas Aus Cancellation Baggage Excess Timestamp] [varchar](50) NULL,
	[Qantas Aus Cancellation Baggage Excess Notes] [varchar](50) NULL,
	[Qantas Australian Comprehensive Premium] [varchar](50) NULL,
	[Qantas Australian Comprehensive Timestamp] [varchar](50) NULL,
	[Qantas Australian Comprehensive Notes] [varchar](50) NULL,
	[Qantas International Comprehensive Premium] [varchar](50) NULL,
	[Qantas International Comprehensive Timestamp] [varchar](50) NULL,
	[Qantas International Comprehensive Notes] [varchar](50) NULL,
	[QBE Premium] [varchar](50) NULL,
	[QBE Timestamp] [varchar](50) NULL,
	[QBE Notes] [varchar](50) NULL,
	[QBE Annual Multi Trip Premium] [varchar](50) NULL,
	[QBE Annual Multi Trip Timestamp] [varchar](50) NULL,
	[QBE Annual Multi Trip Notes] [varchar](50) NULL,
	[QBE Australian Cancellation Premium] [varchar](50) NULL,
	[QBE Australian Cancellation Timestamp] [varchar](50) NULL,
	[QBE Australian Cancellation Notes] [varchar](50) NULL,
	[QBE Australian Comprehensive Premium] [varchar](50) NULL,
	[QBE Australian Comprehensive Timestamp] [varchar](50) NULL,
	[QBE Australian Comprehensive Notes] [varchar](50) NULL,
	[QBE Budget Premium] [varchar](50) NULL,
	[QBE Budget Timestamp] [varchar](50) NULL,
	[QBE Budget Notes] [varchar](50) NULL,
	[QBE International Comprehensive Premium] [varchar](50) NULL,
	[QBE International Comprehensive Timestamp] [varchar](50) NULL,
	[QBE International Comprehensive Notes] [varchar](50) NULL,
	[RAA Premium] [varchar](50) NULL,
	[RAA Timestamp] [varchar](50) NULL,
	[RAA Notes] [varchar](50) NULL,
	[RAA Basics Premium] [varchar](50) NULL,
	[RAA Basics Timestamp] [varchar](50) NULL,
	[RAA Basics Notes] [varchar](50) NULL,
	[RAA Cancellation Premium] [varchar](50) NULL,
	[RAA Cancellation Timestamp] [varchar](50) NULL,
	[RAA Cancellation Notes] [varchar](50) NULL,
	[RAA Essentials Premium] [varchar](50) NULL,
	[RAA Essentials Timestamp] [varchar](50) NULL,
	[RAA Essentials Notes] [varchar](50) NULL,
	[RAA Multi Trip Premium] [varchar](50) NULL,
	[RAA Multi Trip Timestamp] [varchar](50) NULL,
	[RAA Multi Trip Notes] [varchar](50) NULL,
	[RAA Premium Premium] [varchar](50) NULL,
	[RAA Premium Timestamp] [varchar](50) NULL,
	[RAA Premium Notes] [varchar](50) NULL,
	[RAA Rental Car Excess Premium] [varchar](50) NULL,
	[RAA Rental Car Excess Timestamp] [varchar](50) NULL,
	[RAA Rental Car Excess Notes] [varchar](50) NULL,
	[RAC Annual Multi Trip Premium] [varchar](50) NULL,
	[RAC Annual Multi Trip Timestamp] [varchar](50) NULL,
	[RAC Annual Multi Trip Notes] [varchar](50) NULL,
	[RAC Cancellation Premium] [varchar](50) NULL,
	[RAC Cancellation Timestamp] [varchar](50) NULL,
	[RAC Cancellation Notes] [varchar](50) NULL,
	[RAC Comprehensive Premium] [varchar](50) NULL,
	[RAC Comprehensive Timestamp] [varchar](50) NULL,
	[RAC Comprehensive Notes] [varchar](50) NULL,
	[RAC Essentials Premium] [varchar](50) NULL,
	[RAC Essentials Timestamp] [varchar](50) NULL,
	[RAC Essentials Notes] [varchar](50) NULL,
	[RAC Medical Only Premium] [varchar](50) NULL,
	[RAC Medical Only Timestamp] [varchar](50) NULL,
	[RAC Medical Only Notes] [varchar](50) NULL,
	[RAC Rental Car Excess Premium] [varchar](50) NULL,
	[RAC Rental Car Excess Timestamp] [varchar](50) NULL,
	[RAC Rental Car Excess Notes] [varchar](50) NULL,
	[RACQ Annual Multi Premium] [varchar](50) NULL,
	[RACQ Annual Multi Timestamp] [varchar](50) NULL,
	[RACQ Annual Multi Notes] [varchar](50) NULL,
	[RACQ Cancellation Premium] [varchar](50) NULL,
	[RACQ Cancellation Timestamp] [varchar](50) NULL,
	[RACQ Cancellation Notes] [varchar](50) NULL,
	[RACQ Premium Premium] [varchar](50) NULL,
	[RACQ Premium Timestamp] [varchar](50) NULL,
	[RACQ Premium Notes] [varchar](50) NULL,
	[RACQ Rental Car Excess Premium] [varchar](50) NULL,
	[RACQ Rental Car Excess Timestamp] [varchar](50) NULL,
	[RACQ Rental Car Excess Notes] [varchar](50) NULL,
	[RACQ Saver Premium] [varchar](50) NULL,
	[RACQ Saver Timestamp] [varchar](50) NULL,
	[RACQ Saver Notes] [varchar](50) NULL,
	[RACQ Standard Premium] [varchar](50) NULL,
	[RACQ Standard Timestamp] [varchar](50) NULL,
	[RACQ Standard Notes] [varchar](50) NULL,
	[RACQ Under 30 Annual Multi Premium] [varchar](50) NULL,
	[RACQ Under 30 Annual Multi Timestamp] [varchar](50) NULL,
	[RACQ Under 30 Annual Multi Notes] [varchar](50) NULL,
	[RACQ Under 30 Single Trip Premium] [varchar](50) NULL,
	[RACQ Under 30 Single Trip Timestamp] [varchar](50) NULL,
	[RACQ Under 30 Single Trip Notes] [varchar](50) NULL,
	[RACV Annual Multi Trip Premium] [varchar](50) NULL,
	[RACV Annual Multi Trip Timestamp] [varchar](50) NULL,
	[RACV Annual Multi Trip Notes] [varchar](50) NULL,
	[RACV Extra Travel Care Premium] [varchar](50) NULL,
	[RACV Extra Travel Care Timestamp] [varchar](50) NULL,
	[RACV Extra Travel Care Notes] [varchar](50) NULL,
	[RACV Premium Premium] [varchar](50) NULL,
	[RACV Premium Timestamp] [varchar](50) NULL,
	[RACV Premium Notes] [varchar](50) NULL,
	[RACV Rental Car Excess Premium] [varchar](50) NULL,
	[RACV Rental Car Excess Timestamp] [varchar](50) NULL,
	[RACV Rental Car Excess Notes] [varchar](50) NULL,
	[RACV Total Travel Care Premium] [varchar](50) NULL,
	[RACV Total Travel Care Timestamp] [varchar](50) NULL,
	[RACV Total Travel Care Notes] [varchar](50) NULL,
	[RACV Travel Care Premium] [varchar](50) NULL,
	[RACV Travel Care Timestamp] [varchar](50) NULL,
	[RACV Travel Care Notes] [varchar](50) NULL,
	[Ski Insurance Premium] [varchar](50) NULL,
	[Ski Insurance Timestamp] [varchar](50) NULL,
	[Ski Insurance Notes] [varchar](50) NULL,
	[Southern Cross Premium] [varchar](50) NULL,
	[Southern Cross Timestamp] [varchar](50) NULL,
	[Southern Cross Notes] [varchar](50) NULL,
	[Sure Save Premium] [varchar](50) NULL,
	[Sure Save Timestamp] [varchar](50) NULL,
	[Sure Save Notes] [varchar](50) NULL,
	[Teachers Health Comprehensive Premium] [varchar](50) NULL,
	[Teachers Health Comprehensive Timestamp] [varchar](50) NULL,
	[Teachers Health Comprehensive Notes] [varchar](50) NULL,
	[Teachers Health Essentials Premium] [varchar](50) NULL,
	[Teachers Health Essentials Timestamp] [varchar](50) NULL,
	[Teachers Health Essentials Notes] [varchar](50) NULL,
	[TID Basics Premium] [varchar](50) NULL,
	[TID Basics Timestamp] [varchar](50) NULL,
	[TID Basics Notes] [varchar](50) NULL,
	[TID The Works Premium] [varchar](50) NULL,
	[TID The Works Timestamp] [varchar](50) NULL,
	[TID The Works Notes] [varchar](50) NULL,
	[Travel Insuranz Classic Premium] [varchar](50) NULL,
	[Travel Insuranz Classic Timestamp] [varchar](50) NULL,
	[Travel Insuranz Classic Notes] [varchar](50) NULL,
	[Travel Insuranz Deluxe Premium] [varchar](50) NULL,
	[Travel Insuranz Deluxe Timestamp] [varchar](50) NULL,
	[Travel Insuranz Deluxe Notes] [varchar](50) NULL,
	[Travel Insuranz Premier Premium] [varchar](50) NULL,
	[Travel Insuranz Premier Timestamp] [varchar](50) NULL,
	[Travel Insuranz Premier Notes] [varchar](50) NULL,
	[Under 30 Premium] [varchar](50) NULL,
	[Under 30 Timestamp] [varchar](50) NULL,
	[Under 30 Notes] [varchar](50) NULL,
	[Vero Premium] [varchar](50) NULL,
	[Vero Timestamp] [varchar](50) NULL,
	[Vero Notes] [varchar](50) NULL,
	[Virgin Australia Comprehensive Premium] [varchar](50) NULL,
	[Virgin Australia Comprehensive Timestamp] [varchar](50) NULL,
	[Virgin Australia Comprehensive Notes] [varchar](50) NULL,
	[Virgin Australia Domestic Premium] [varchar](50) NULL,
	[Virgin Australia Domestic Timestamp] [varchar](50) NULL,
	[Virgin Australia Domestic Notes] [varchar](50) NULL,
	[Virgin Australia Essential Premium] [varchar](50) NULL,
	[Virgin Australia Essential Timestamp] [varchar](50) NULL,
	[Virgin Australia Essential Notes] [varchar](50) NULL,
	[Virgin Australia Multi Trip Premium] [varchar](50) NULL,
	[Virgin Australia Multi Trip Timestamp] [varchar](50) NULL,
	[Virgin Australia Multi Trip Notes] [varchar](50) NULL,
	[Virgin Money Comprehensive Premium] [varchar](50) NULL,
	[Virgin Money Comprehensive Timestamp] [varchar](50) NULL,
	[Virgin Money Comprehensive Notes] [varchar](50) NULL,
	[Virgin Money Essentials Premium] [varchar](50) NULL,
	[Virgin Money Essentials Timestamp] [varchar](50) NULL,
	[Virgin Money Essentials Notes] [varchar](50) NULL,
	[Virgin Money Frequent Traveller Premium] [varchar](50) NULL,
	[Virgin Money Frequent Traveller Timestamp] [varchar](50) NULL,
	[Virgin Money Frequent Traveller Notes] [varchar](50) NULL,
	[Virgin Money Medical Only Premium] [varchar](50) NULL,
	[Virgin Money Medical Only Timestamp] [varchar](50) NULL,
	[Virgin Money Medical Only Notes] [varchar](50) NULL,
	[Webjet Basic Premium] [varchar](50) NULL,
	[Webjet Basic Timestamp] [varchar](50) NULL,
	[Webjet Basic Notes] [varchar](50) NULL,
	[Webjet Cancellation And Luggage Premium] [varchar](50) NULL,
	[Webjet Cancellation And Luggage Timestamp] [varchar](50) NULL,
	[Webjet Cancellation And Luggage Notes] [varchar](50) NULL,
	[Webjet Comprehensive Premium] [varchar](50) NULL,
	[Webjet Comprehensive Timestamp] [varchar](50) NULL,
	[Webjet Comprehensive Notes] [varchar](50) NULL,
	[Webjet Essentials Premium] [varchar](50) NULL,
	[Webjet Essentials Timestamp] [varchar](50) NULL,
	[Webjet Essentials Notes] [varchar](50) NULL,
	[Webjet Multi Trip Premium] [varchar](50) NULL,
	[Webjet Multi Trip Timestamp] [varchar](50) NULL,
	[Webjet Multi Trip Notes] [varchar](50) NULL,
	[Westpac Premium] [varchar](50) NULL,
	[Westpac Timestamp] [varchar](50) NULL,
	[Westpac Notes] [varchar](50) NULL,
	[Woolworths Basic Premium] [varchar](50) NULL,
	[Woolworths Basic Timestamp] [varchar](50) NULL,
	[Woolworths Basic Notes] [varchar](50) NULL,
	[Woolworths Comprehensive Premium] [varchar](50) NULL,
	[Woolworths Comprehensive Timestamp] [varchar](50) NULL,
	[Woolworths Comprehensive Notes] [varchar](50) NULL,
	[Woolworths Saver Premium] [varchar](50) NULL,
	[Woolworths Saver Timestamp] [varchar](50) NULL,
	[Woolworths Saver Notes] [varchar](50) NULL,
	[World Nomads Explorer Premium] [varchar](50) NULL,
	[World Nomads Explorer Timestamp] [varchar](50) NULL,
	[World Nomads Explorer Notes] [varchar](50) NULL,
	[World Nomads Standard Premium] [varchar](50) NULL,
	[World Nomads Standard Timestamp] [varchar](50) NULL,
	[World Nomads Standard Notes] [varchar](50) NULL,
	[World2Cover Basics Premium] [varchar](50) NULL,
	[World2Cover Basics Timestamp] [varchar](50) NULL,
	[World2Cover Basics Notes] [varchar](50) NULL,
	[World2Cover Essentials Premium] [varchar](50) NULL,
	[World2Cover Essentials Timestamp] [varchar](50) NULL,
	[World2Cover Essentials Notes] [varchar](50) NULL,
	[World2Cover Top Premium] [varchar](50) NULL,
	[World2Cover Top Timestamp] [varchar](50) NULL,
	[World2Cover Top Notes] [varchar](50) NULL,
	[Worldcare Australia Only Premium] [varchar](50) NULL,
	[Worldcare Australia Only Timestamp] [varchar](50) NULL,
	[Worldcare Basic Premium] [varchar](50) NULL,
	[Worldcare Basic Timestamp] [varchar](50) NULL,
	[Worldcare Basic Notes] [varchar](50) NULL,
	[Worldcare Comprehensive Premium] [varchar](50) NULL,
	[Worldcare Comprehensive Timestamp] [varchar](50) NULL,
	[Worldcare Comprehensive Notes] [varchar](50) NULL,
	[Worldcare Essential Premium] [varchar](50) NULL,
	[Worldcare Essential Timestamp] [varchar](50) NULL,
	[Worldcare Essential Notes] [varchar](50) NULL,
	[Worldcare Frequent Premium] [varchar](50) NULL,
	[Worldcare Frequent Timestamp] [varchar](50) NULL,
	[Worldcare Frequent Notes] [varchar](50) NULL,
	[ExcessFYP] [varchar](50) NULL,
	[ExcessICC] [varchar](50) NULL,
	[CanxDom_AMT_FFYP] [varchar](50) NULL,
	[CanxDom_AMT_SFYP] [varchar](50) NULL,
	[CanxDom_AMT_FICC] [varchar](50) NULL,
	[CanxDom_AMT_SICC] [varchar](50) NULL,
	[FYP_SP_amt] [varchar](50) NULL,
	[ICC_SP_amt] [varchar](50) NULL
) ON [PRIMARY]
GO
