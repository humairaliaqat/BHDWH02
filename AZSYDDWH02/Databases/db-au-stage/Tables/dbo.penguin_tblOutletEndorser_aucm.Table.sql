USE [db-au-stage]
GO
/****** Object:  Table [dbo].[penguin_tblOutletEndorser_aucm]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[penguin_tblOutletEndorser_aucm](
	[OutletID] [int] NOT NULL,
	[EndorserID] [int] NULL,
	[EndorserList] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
