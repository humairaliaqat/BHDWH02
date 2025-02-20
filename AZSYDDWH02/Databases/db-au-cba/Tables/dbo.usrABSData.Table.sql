USE [db-au-cba]
GO
/****** Object:  Table [dbo].[usrABSData]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[usrABSData](
	[Month] [datetime] NULL,
	[FYear] [varchar](7) NULL,
	[CYear] [int] NULL,
	[DurationGroup] [nvarchar](50) NULL,
	[AgeGroup] [nvarchar](50) NULL,
	[Country] [nvarchar](200) NULL,
	[CountryGroup] [nvarchar](200) NULL,
	[Reason] [nvarchar](100) NULL,
	[TravellersCount] [int] NULL,
	[TravellersCountRLTM] [int] NULL
) ON [PRIMARY]
GO
