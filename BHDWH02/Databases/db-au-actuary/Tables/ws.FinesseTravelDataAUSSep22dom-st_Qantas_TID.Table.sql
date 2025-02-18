USE [db-au-actuary]
GO
/****** Object:  Table [ws].[FinesseTravelDataAUSSep22dom-st_Qantas_TID]    Script Date: 18/02/2025 12:14:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ws].[FinesseTravelDataAUSSep22dom-st_Qantas_TID](
	[Period] [varchar](50) NULL,
	[Sample Number] [varchar](50) NULL,
	[Factor] [varchar](50) NULL,
	[State] [varchar](50) NULL,
	[Destination] [varchar](50) NULL,
	[International Domestic] [varchar](50) NULL,
	[Profile] [varchar](50) NULL,
	[Qantas Australian Comprehensive Premium] [varchar](50) NULL,
	[TID The Works Premium] [varchar](50) NULL
) ON [PRIMARY]
GO
