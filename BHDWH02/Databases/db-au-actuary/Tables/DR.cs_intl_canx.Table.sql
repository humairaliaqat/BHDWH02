USE [db-au-actuary]
GO
/****** Object:  Table [DR].[cs_intl_canx]    Script Date: 18/02/2025 12:14:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DR].[cs_intl_canx](
	[canx_count] [int] NULL,
	[canx_claimCost] [numeric](38, 6) NULL,
	[hasEMCbin] [bigint] NULL,
	[pcodebin] [bigint] NULL,
	[adultsbin] [bigint] NULL,
	[excessbin] [bigint] NULL,
	[climitbin] [bigint] NULL,
	[Zonebin] [bigint] NULL,
	[leadtimebin] [bigint] NULL,
	[durationbin] [bigint] NULL,
	[ageOldbin] [bigint] NULL
) ON [PRIMARY]
GO
