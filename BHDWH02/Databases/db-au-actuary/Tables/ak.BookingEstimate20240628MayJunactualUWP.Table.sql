USE [db-au-actuary]
GO
/****** Object:  Table [ak].[BookingEstimate20240628MayJunactualUWP]    Script Date: 18/02/2025 12:14:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ak].[BookingEstimate20240628MayJunactualUWP](
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
	[JV_Group] [nvarchar](400) NULL
) ON [PRIMARY]
GO
