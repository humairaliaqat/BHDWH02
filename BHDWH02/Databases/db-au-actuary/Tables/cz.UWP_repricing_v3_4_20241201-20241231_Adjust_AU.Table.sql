USE [db-au-actuary]
GO
/****** Object:  Table [cz].[UWP_repricing_v3_4_20241201-20241231_Adjust_AU]    Script Date: 18/02/2025 12:14:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cz].[UWP_repricing_v3_4_20241201-20241231_Adjust_AU](
	[Premium] [float] NULL,
	[UW_Premium] [float] NULL,
	[Adjust_UW_Premium] [float] NULL,
	[Rate change Dec 24] [float] NULL,
	[INDEX] [nvarchar](255) NULL,
	[PolicyKey] [nvarchar](255) NULL,
	[Domain_Country] [nvarchar](255) NULL,
	[Product_Code] [nvarchar](255) NULL,
	[Segment] [nvarchar](255) NULL,
	[issue_year_month] [nvarchar](255) NULL,
	[UW_rating_group] [nvarchar](255) NULL,
	[JV_Description] [nvarchar](255) NULL,
	[Policy_Status] [nvarchar](255) NULL,
	[Product_Name] [nvarchar](255) NULL,
	[Segment2] [nvarchar](255) NULL,
	[JV_Group] [nvarchar](255) NULL,
	[add_and_on_trip_can_freq_u] [float] NULL,
	[add_and_on_trip_can_pred_u] [float] NULL,
	[add_and_on_trip_can_sev_u] [float] NULL,
	[can_freq_u] [float] NULL,
	[can_pred_u] [float] NULL,
	[can_sev_u] [float] NULL,
	[lug_freq_u] [float] NULL,
	[lug_pred_u] [float] NULL,
	[lug_sev_u] [float] NULL,
	[med_freq_u] [float] NULL,
	[med_pred_u] [float] NULL,
	[med_sev_u] [float] NULL,
	[oth_freq_u] [float] NULL,
	[oth_pred_u] [float] NULL,
	[oth_sev_u] [float] NULL,
	[Pred_l] [float] NULL,
	[Segment_New] [nvarchar](255) NULL,
	[Traveller Count_New] [nvarchar](255) NULL,
	[Trip Duration_New] [nvarchar](255) NULL,
	[Region_New] [nvarchar](255) NULL
) ON [PRIMARY]
GO
