USE [db-au-actuary]
GO
/****** Object:  Table [ws].[FinesseTravelDataAUSDec19TimeSeries_int]    Script Date: 18/02/2025 12:14:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ws].[FinesseTravelDataAUSDec19TimeSeries_int](
	[quarter] [varchar](5) NOT NULL,
	[Avg 1Cover mvt pc] [float] NULL,
	[Avg Allianz mvt pc] [float] NULL,
	[Avg Auspost mvt pc] [float] NULL,
	[Avg Medibank mvt pc] [float] NULL,
	[Avg Cover-More mvt pc] [float] NULL,
	[Avg TID mvt pc] [float] NULL,
	[Avg NRMA mvt pc] [float] NULL,
	[Avg Woolworths mvt pc] [float] NULL
) ON [PRIMARY]
GO
