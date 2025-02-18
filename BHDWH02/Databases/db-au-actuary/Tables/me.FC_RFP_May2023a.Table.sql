USE [db-au-actuary]
GO
/****** Object:  Table [me].[FC_RFP_May2023a]    Script Date: 18/02/2025 12:14:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [me].[FC_RFP_May2023a](
	[Domain Country] [varchar](2) NULL,
	[Base Policy No] [varchar](50) NULL,
	[Issue Date] [date] NULL,
	[Trans Date] [date] NULL,
	[Product Code] [nvarchar](50) NULL,
	[Plan Type] [nvarchar](50) NULL,
	[Channel] [varchar](14) NOT NULL,
	[RFP Plan] [nvarchar](50) NULL,
	[RFP Brand] [nvarchar](50) NULL,
	[Alpha Code] [nvarchar](20) NULL,
	[Unadjusted Sell Price] [money] NULL,
	[Unadjusted GST on Sell Price] [money] NULL,
	[Unadjusted Stamp Duty on Sell Price] [money] NULL,
	[Unadjusted Agency Commission] [money] NULL,
	[Unadjusted GST on Agency Commission] [money] NULL,
	[Unadjusted Stamp Duty on Agency Commission] [money] NULL,
	[Unadjusted Admin Fee] [money] NULL,
	[Sell Price] [float] NULL,
	[GST on Sell Price] [float] NULL,
	[Stamp Duty on Sell Price] [float] NULL,
	[Premium] [float] NULL,
	[RFP Premium] [float] NULL,
	[Agency Commission] [money] NULL,
	[GST on Agency Commission] [money] NULL,
	[Stamp Duty on Agency Commission] [money] NULL,
	[Policy Count] [int] NULL,
	[Outlet Sub Group Name] [nvarchar](50) NULL,
	[Outlet Channel] [nvarchar](100) NULL,
	[JV Code] [nvarchar](20) NULL
) ON [PRIMARY]
GO
