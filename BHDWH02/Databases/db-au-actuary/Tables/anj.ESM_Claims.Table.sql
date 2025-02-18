USE [db-au-actuary]
GO
/****** Object:  Table [anj].[ESM_Claims]    Script Date: 18/02/2025 12:14:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [anj].[ESM_Claims](
	[claim_no] [varchar](250) NULL,
	[Special_Measure_with_Leakage] [varchar](250) NULL,
	[Special_Measure_Anyway] [varchar](250) NULL,
	[Date] [date] NULL
) ON [PRIMARY]
GO
