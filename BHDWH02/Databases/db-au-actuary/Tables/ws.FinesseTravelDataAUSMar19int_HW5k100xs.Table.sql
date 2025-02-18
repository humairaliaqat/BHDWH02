USE [db-au-actuary]
GO
/****** Object:  Table [ws].[FinesseTravelDataAUSMar19int_HW5k100xs]    Script Date: 18/02/2025 12:14:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ws].[FinesseTravelDataAUSMar19int_HW5k100xs](
	[Sample No ] [varchar](50) NULL,
	[Destination] [varchar](50) NULL,
	[Plan Type] [varchar](50) NULL,
	[Number of Travellers] [varchar](50) NULL,
	[Travel Group] [varchar](50) NULL,
	[Number of Adults] [varchar](50) NULL,
	[Number of Children] [varchar](50) NULL,
	[Age of oldest adult] [varchar](50) NULL,
	[Age of second oldest adult] [varchar](50) NULL,
	[Age of oldest dependent] [varchar](50) NULL,
	[Age of second oldest dependent] [varchar](50) NULL,
	[Age of third oldest dependent] [varchar](50) NULL,
	[Travel Duration] [varchar](50) NULL,
	[Destination Region] [varchar](50) NULL,
	[Lead Time] [varchar](50) NULL,
	[CanxInt_STFYP] [varchar](50) NULL,
	[CanxInt_STICC] [varchar](50) NULL,
	[CanxInt_AMT_FFYP] [varchar](50) NULL,
	[CanxInt_AMT_FICC] [varchar](50) NULL,
	[CanxInt_AMT_SFYP] [varchar](50) NULL,
	[CanxInt_AMT_SICC] [varchar](50) NULL,
	[ExcessICC] [varchar](50) NULL,
	[ICC_B100] [varchar](50) NULL,
	[ICC_C100] [varchar](50) NULL,
	[ICC_100Tot] [varchar](50) NULL
) ON [PRIMARY]
GO
