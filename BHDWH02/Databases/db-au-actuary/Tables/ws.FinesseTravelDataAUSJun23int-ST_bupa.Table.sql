USE [db-au-actuary]
GO
/****** Object:  Table [ws].[FinesseTravelDataAUSJun23int-ST_bupa]    Script Date: 18/02/2025 12:14:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ws].[FinesseTravelDataAUSJun23int-ST_bupa](
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
	[Trip Type] [varchar](50) NULL,
	[Travel Duration - Band] [varchar](50) NULL,
	[Travel Duration (Detailed) - Band] [varchar](50) NULL,
	[Bupa IST (Comprehensive) Premium] [varchar](50) NULL,
	[Bupa IST (Essentials) Premium] [varchar](50) NULL
) ON [PRIMARY]
GO
