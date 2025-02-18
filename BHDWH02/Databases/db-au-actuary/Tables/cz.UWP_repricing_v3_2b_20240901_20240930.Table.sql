USE [db-au-actuary]
GO
/****** Object:  Table [cz].[UWP_repricing_v3_2b_20240901_20240930]    Script Date: 18/02/2025 12:14:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cz].[UWP_repricing_v3_2b_20240901_20240930](
	[UW_Premium] [float] NULL,
	[PolicyKey] [nvarchar](400) NULL,
	[Domain_Country] [nvarchar](400) NULL,
	[Product_Code] [nvarchar](400) NULL,
	[Segment] [nvarchar](400) NULL,
	[issue_year_month] [datetime2](7) NULL,
	[UW_rating_group] [nvarchar](400) NULL,
	[JV_Description] [nvarchar](400) NULL,
	[Policy_Status] [nvarchar](400) NULL,
	[Product_Name] [nvarchar](400) NULL,
	[Segment2] [nvarchar](400) NULL,
	[JV_Group] [nvarchar](400) NULL,
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
	[Pred_l] [float] NULL
) ON [PRIMARY]
GO
