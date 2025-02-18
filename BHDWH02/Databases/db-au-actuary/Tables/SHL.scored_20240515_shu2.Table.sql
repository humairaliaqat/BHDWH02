USE [db-au-actuary]
GO
/****** Object:  Table [SHL].[scored_20240515_shu2]    Script Date: 18/02/2025 12:14:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SHL].[scored_20240515_shu2](
	[UW_Premium] [float] NULL,
	[PolicyKey] [nvarchar](400) NULL,
	[Domain_Country] [nvarchar](400) NULL,
	[Product_Code] [nvarchar](400) NULL,
	[Segment] [nvarchar](400) NULL,
	[issue_year_month] [datetime2](7) NULL,
	[UW_rating_group] [nvarchar](400) NULL,
	[JV_Description] [nvarchar](400) NULL,
	[Policy_Status] [nvarchar](400) NULL,
	[Segment2] [nvarchar](400) NULL,
	[Additional_UWP] [float] NULL,
	[Large_UWP] [float] NULL,
	[Cancellation_UWP] [float] NULL,
	[Luggage_UWP] [float] NULL,
	[Medical_UWP] [float] NULL,
	[Other_UWP] [float] NULL,
	[Add_and_on_trip_Can_freq_u] [float] NULL,
	[Add_and_On_Trip_can_pred_u] [float] NULL,
	[Add_and_on_trip_Can_Sev_u] [float] NULL,
	[Can_Freq_u] [float] NULL,
	[Can_Pred_u] [float] NULL,
	[Can_Sev_u] [float] NULL,
	[Lug_Freq_u] [float] NULL,
	[Lug_Pred_u] [float] NULL,
	[Lug_Sev_u] [float] NULL,
	[Med_Pred_u] [float] NULL,
	[Med_Freq_u] [float] NULL,
	[Med_Sev_u] [float] NULL,
	[Oth_Freq_u] [float] NULL,
	[Oth_Pred_u] [float] NULL,
	[Oth_Sev_u] [float] NULL,
	[Pred_l] [float] NULL,
	[Pred_ul] [float] NULL
) ON [PRIMARY]
GO
