USE [db-au-actuary]
GO
/****** Object:  Table [DR].[cf_intl_fac]    Script Date: 18/02/2025 12:14:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DR].[cf_intl_fac](
	[row_unique] [bigint] NULL,
	[Has EMC] [varchar](1) NULL,
	[product code] [nvarchar](50) NULL,
	[charged traveller count] [int] NULL,
	[excess] [int] NULL,
	[climit] [varchar](5) NULL,
	[GeoZone] [nvarchar](max) NULL,
	[leadtime] [varchar](7) NULL,
	[duration] [varchar](7) NULL,
	[ageOldest] [varchar](6) NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
