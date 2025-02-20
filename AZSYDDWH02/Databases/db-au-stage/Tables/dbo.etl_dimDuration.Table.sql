USE [db-au-stage]
GO
/****** Object:  Table [dbo].[etl_dimDuration]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[etl_dimDuration](
	[Duration] [float] NULL,
	[DurationBand] [nvarchar](255) NULL,
	[ABSDurationBand] [varchar](22) NOT NULL,
	[MinimumBand] [float] NULL,
	[MaximumBand] [float] NULL,
	[LoadDate] [datetime] NULL,
	[updateDate] [datetime] NULL,
	[LoadID] [int] NULL,
	[updateID] [int] NULL,
	[HashKey] [varbinary](30) NULL
) ON [PRIMARY]
GO
