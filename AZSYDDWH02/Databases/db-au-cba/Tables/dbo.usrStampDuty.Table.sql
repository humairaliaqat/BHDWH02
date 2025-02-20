USE [db-au-cba]
GO
/****** Object:  Table [dbo].[usrStampDuty]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[usrStampDuty](
	[ID] [int] NOT NULL,
	[Country] [varchar](3) NULL,
	[AreaType] [varchar](25) NULL,
	[State] [varchar](50) NULL,
	[StartDate] [date] NULL,
	[EndDate] [date] NULL,
	[Rate] [numeric](18, 5) NULL,
	[RateExSD] [numeric](18, 5) NULL
) ON [PRIMARY]
GO
