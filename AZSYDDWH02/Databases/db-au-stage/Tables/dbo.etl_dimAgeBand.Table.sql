USE [db-au-stage]
GO
/****** Object:  Table [dbo].[etl_dimAgeBand]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[etl_dimAgeBand](
	[Age] [float] NULL,
	[Code] [nvarchar](255) NULL,
	[AgeBand] [nvarchar](255) NULL,
	[ABSAgeBand] [varchar](7) NOT NULL,
	[ABSAgeCategory] [varchar](7) NOT NULL,
	[LoadDate] [datetime] NULL,
	[updateDate] [datetime] NULL,
	[LoadID] [int] NULL,
	[updateID] [int] NULL,
	[HashKey] [varbinary](30) NULL
) ON [PRIMARY]
GO
