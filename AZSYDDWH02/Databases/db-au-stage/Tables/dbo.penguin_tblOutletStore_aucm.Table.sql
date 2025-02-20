USE [db-au-stage]
GO
/****** Object:  Table [dbo].[penguin_tblOutletStore_aucm]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[penguin_tblOutletStore_aucm](
	[OutletStoreID] [int] NOT NULL,
	[Name] [nvarchar](250) NULL,
	[Code] [varchar](10) NOT NULL,
	[OutletID] [int] NOT NULL,
	[Status] [varchar](15) NOT NULL,
	[CreateDateTime] [datetime] NOT NULL,
	[UpdateDateTime] [datetime] NOT NULL,
	[StoreType] [int] NULL
) ON [PRIMARY]
GO
