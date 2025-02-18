USE [db-au-actuary]
GO
/****** Object:  Table [SHL].[Policy_Summ_Temp_AirNZ]    Script Date: 18/02/2025 12:14:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SHL].[Policy_Summ_Temp_AirNZ](
	[Domain Country] [varchar](2) NULL,
	[Outlet Super Group] [nvarchar](255) NULL,
	[Area Name] [nvarchar](150) NULL,
	[Excess] [int] NULL,
	[Trip Type] [nvarchar](50) NULL,
	[Product Plan] [nvarchar](100) NULL,
	[Product Classification] [nvarchar](100) NULL,
	[Max_EMC_Score_ROUNDED] [numeric](18, 2) NULL,
	[Trip Cost] [int] NULL,
	[UW Rating Group] [nvarchar](50) NULL,
	[Product Code] [nvarchar](50) NULL,
	[UW_Mth] [varchar](25) NOT NULL,
	[oldest_age_band] [varchar](17) NOT NULL,
	[trip_duration_band] [varchar](16) NOT NULL,
	[lead_time_band] [varchar](17) NOT NULL,
	[travel_group] [varchar](19) NOT NULL,
	[Traveller Count] [int] NULL,
	[Oldest Age] [int] NULL,
	[Base_base_premium] [money] NULL,
	[base_premium] [money] NULL,
	[Canx_Premium] [money] NULL,
	[Premium] [money] NULL,
	[Sell_Price] [money] NULL,
	[Policy Count] [int] NULL,
	[UW_Premium] [float] NULL,
	[UW_Premium_COVID19] [float] NULL,
	[Sum Traveller Count] [int] NULL
) ON [PRIMARY]
GO
