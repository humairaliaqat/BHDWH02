USE [db-au-stage]
GO
/****** Object:  Table [dbo].[penguin_tblRegion_aucm]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[penguin_tblRegion_aucm](
	[RegionId] [int] NOT NULL,
	[DomainId] [int] NULL,
	[Region] [nvarchar](50) NULL,
	[TimeZoneId] [smallint] NULL
) ON [PRIMARY]
GO
