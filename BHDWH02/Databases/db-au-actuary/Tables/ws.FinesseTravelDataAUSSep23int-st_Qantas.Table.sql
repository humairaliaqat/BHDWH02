USE [db-au-actuary]
GO
/****** Object:  Table [ws].[FinesseTravelDataAUSSep23int-st_Qantas]    Script Date: 18/02/2025 12:14:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ws].[FinesseTravelDataAUSSep23int-st_Qantas](
	[Period] [varchar](50) NULL,
	[Sample Number] [varchar](50) NULL,
	[State] [varchar](50) NULL,
	[Destination] [varchar](50) NULL,
	[International_Domestic] [varchar](50) NULL,
	[TripType] [varchar](50) NULL,
	[Qantas IST (International Comprehensive) Premium] [varchar](50) NULL
) ON [PRIMARY]
GO
