USE [db-au-actuary]
GO
/****** Object:  Table [ws].[FinesseTravelDataAUSSep24int-st_scored_ahm3k]    Script Date: 18/02/2025 12:14:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ws].[FinesseTravelDataAUSSep24int-st_scored_ahm3k](
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
	[AHM_BaseSP] [varchar](50) NULL,
	[AHM_CanxSP] [varchar](50) NULL,
	[AHM_SP] [varchar](50) NULL
) ON [PRIMARY]
GO
