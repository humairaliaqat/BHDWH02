USE [db-au-stage]
GO
/****** Object:  Table [dbo].[penguin_tblTravellerSet_aucm]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[penguin_tblTravellerSet_aucm](
	[TravellerSetID] [int] NOT NULL,
	[Name] [varchar](100) NOT NULL,
	[DomainID] [int] NOT NULL,
	[MinimumAdult] [smallint] NULL,
	[MaximumAdult] [smallint] NULL,
	[MinimumChild] [smallint] NULL,
	[MaximumChild] [smallint] NULL
) ON [PRIMARY]
GO
