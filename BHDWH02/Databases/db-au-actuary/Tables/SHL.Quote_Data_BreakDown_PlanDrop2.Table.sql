USE [db-au-actuary]
GO
/****** Object:  Table [SHL].[Quote_Data_BreakDown_PlanDrop2]    Script Date: 18/02/2025 12:14:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SHL].[Quote_Data_BreakDown_PlanDrop2](
	[Lead_Number] [int] NOT NULL,
	[GCLID] [nvarchar](1) NULL,
	[GA_Client_ID] [nvarchar](1) NULL,
	[Link_ID] [nvarchar](50) NOT NULL,
	[Session_ID] [int] NOT NULL,
	[Age] [float] NOT NULL,
	[Destination] [nvarchar](50) NOT NULL,
	[Region_List] [nvarchar](100) NOT NULL,
	[Quote_Date] [datetime2](7) NOT NULL,
	[Trip_Start] [datetime2](7) NOT NULL,
	[Trip_end] [datetime2](7) NOT NULL,
	[Promotional_Factor] [nvarchar](50) NULL,
	[Excess] [float] NOT NULL,
	[Plan_Type] [nvarchar](50) NOT NULL,
	[Trip_Type] [nvarchar](1) NULL,
	[Premium] [float] NOT NULL,
	[Agency_Code] [nvarchar](50) NOT NULL,
	[Agency_Name] [nvarchar](50) NOT NULL,
	[Brand] [nvarchar](50) NOT NULL,
	[Channel_Type] [nvarchar](50) NOT NULL,
	[Session_Token] [nvarchar](50) NOT NULL
) ON [PRIMARY]
GO
