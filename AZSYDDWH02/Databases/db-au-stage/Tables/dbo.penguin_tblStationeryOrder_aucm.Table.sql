USE [db-au-stage]
GO
/****** Object:  Table [dbo].[penguin_tblStationeryOrder_aucm]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[penguin_tblStationeryOrder_aucm](
	[ID] [int] NOT NULL,
	[OrderDate] [datetime] NOT NULL,
	[ConsultantID] [int] NULL,
	[Email] [varchar](100) NULL,
	[Comments] [nvarchar](max) NULL,
	[OutletID] [int] NOT NULL,
	[StoreCode] [varchar](20) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
