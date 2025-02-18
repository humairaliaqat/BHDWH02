USE [db-au-actuary]
GO
/****** Object:  Table [ws].[FinesseTravelDataAUSJun23dom-ST_CMrescored3k]    Script Date: 18/02/2025 12:14:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ws].[FinesseTravelDataAUSJun23dom-ST_CMrescored3k](
	[Sample_Number] [float] NOT NULL,
	[Factor] [nvarchar](50) NOT NULL,
	[State] [nvarchar](50) NOT NULL,
	[Destination] [nvarchar](50) NOT NULL,
	[International_Domestic] [nvarchar](50) NOT NULL,
	[Number_of_Travellers] [tinyint] NOT NULL,
	[Travel_Group] [nvarchar](50) NOT NULL,
	[Number_of_Adults] [tinyint] NOT NULL,
	[Number_of_Children] [tinyint] NOT NULL,
	[Age_of_oldest_adult] [tinyint] NOT NULL,
	[Age_of_second_oldest_adult] [smallint] NOT NULL,
	[Age_of_oldest_dependent] [smallint] NOT NULL,
	[Age_of_second_oldest_dependent] [smallint] NOT NULL,
	[Age_of_third_oldest_dependent] [smallint] NOT NULL,
	[age0order] [tinyint] NOT NULL,
	[age1order] [smallint] NOT NULL,
	[age2order] [smallint] NOT NULL,
	[age3order] [smallint] NOT NULL,
	[age4order] [smallint] NOT NULL,
	[Travel_Duration] [tinyint] NOT NULL,
	[Destination_Region] [nvarchar](50) NOT NULL,
	[Lead_Time] [smallint] NOT NULL,
	[Profile] [nvarchar](50) NOT NULL,
	[Travel_Group_Detailed] [nvarchar](50) NOT NULL,
	[Age_of_oldest_adult_Band] [nvarchar](50) NOT NULL,
	[Age_of_second_oldest_adult_Band] [nvarchar](50) NULL,
	[Age_of_oldest_dependent_Band] [nvarchar](50) NULL,
	[Age_of_second_oldest_dependent_Band] [nvarchar](50) NULL,
	[Age_of_third_oldest_dependent_Band] [nvarchar](50) NULL,
	[Travel_Duration_Band] [nvarchar](50) NOT NULL,
	[Lead_time_Band] [nvarchar](50) NOT NULL,
	[Single_Multi_Trip_Band] [nvarchar](50) NOT NULL,
	[Age_of_oldest_adult_Detailed_Band] [nvarchar](50) NOT NULL,
	[Age_of_second_oldest_adult_Detailed_Band] [nvarchar](50) NULL,
	[Travel_Duration_Detailed_Band] [nvarchar](50) NOT NULL,
	[FYP_SP] [float] NOT NULL,
	[ICC_SP] [float] NOT NULL,
	[CBI_SP] [float] NOT NULL,
	[CPCm_SP] [float] NOT NULL,
	[CPCp_SP] [float] NOT NULL,
	[MBC_SP] [float] NOT NULL,
	[AHM_SP] [smallint] NOT NULL,
	[APC_SP] [smallint] NOT NULL,
	[CBT_SP] [float] NOT NULL,
	[NRI_SP] [float] NOT NULL,
	[WJP_SP] [float] NOT NULL,
	[NPP_SP] [float] NOT NULL
) ON [PRIMARY]
GO
