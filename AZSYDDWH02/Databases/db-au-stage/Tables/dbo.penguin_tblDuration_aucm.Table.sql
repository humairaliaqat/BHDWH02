USE [db-au-stage]
GO
/****** Object:  Table [dbo].[penguin_tblDuration_aucm]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[penguin_tblDuration_aucm](
	[DurationID] [int] NOT NULL,
	[DurationSetID] [int] NOT NULL,
	[Length] [int] NOT NULL,
	[Period] [nchar](1) NOT NULL
) ON [PRIMARY]
GO
