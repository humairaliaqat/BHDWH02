USE [db-au-stage]
GO
/****** Object:  Table [dbo].[etl_factABSTravellerTemp]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[etl_factABSTravellerTemp](
	[TravelDate] [datetime] NULL,
	[DurationGroup] [nvarchar](50) NULL,
	[AgeGroup] [nvarchar](50) NULL,
	[Country] [nvarchar](200) NULL,
	[Reason] [nvarchar](100) NULL,
	[TravellersCount] [int] NULL
) ON [PRIMARY]
GO
