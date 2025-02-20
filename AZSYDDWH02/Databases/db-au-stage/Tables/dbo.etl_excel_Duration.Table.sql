USE [db-au-stage]
GO
/****** Object:  Table [dbo].[etl_excel_Duration]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[etl_excel_Duration](
	[Duration] [float] NULL,
	[DurationBand] [nvarchar](255) NULL,
	[MinimumBand] [float] NULL,
	[MaximumBand] [float] NULL
) ON [PRIMARY]
GO
