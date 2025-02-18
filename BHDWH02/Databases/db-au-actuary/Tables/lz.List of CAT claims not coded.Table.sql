USE [db-au-actuary]
GO
/****** Object:  Table [lz].[List of CAT claims not coded]    Script Date: 18/02/2025 12:14:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [lz].[List of CAT claims not coded](
	[manual_assessment] [nvarchar](50) NULL,
	[Certainty] [nvarchar](50) NULL,
	[Reasoning] [nvarchar](50) NULL,
	[Person] [nvarchar](50) NULL,
	[CountryKey] [nvarchar](50) NULL,
	[CompanyKey] [nvarchar](50) NULL,
	[Column1] [nvarchar](50) NULL,
	[ClaimKey] [nvarchar](50) NULL,
	[ClaimNo] [nvarchar](50) NULL,
	[IssuedDate] [date] NULL,
	[EventDate] [date] NULL,
	[CreateDate] [date] NULL,
	[Coded] [nvarchar](50) NULL,
	[CATCode] [nvarchar](50) NULL,
	[EventDescription] [nvarchar](max) NULL,
	[CaseNote] [nvarchar](max) NULL,
	[EventLocation] [nvarchar](250) NULL,
	[EventCountryName] [nvarchar](50) NULL,
	[PerilCode] [nvarchar](50) NULL,
	[PerilDesc] [nvarchar](50) NULL,
	[FirstEstimateValue] [float] NULL,
	[ClaimValue] [float] NULL,
	[was_this_given_to_AS_and_CZ] [nvarchar](50) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
