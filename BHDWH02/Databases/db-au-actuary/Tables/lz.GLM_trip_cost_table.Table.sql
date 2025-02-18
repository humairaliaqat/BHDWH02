USE [db-au-actuary]
GO
/****** Object:  Table [lz].[GLM_trip_cost_table]    Script Date: 18/02/2025 12:14:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [lz].[GLM_trip_cost_table](
	[Domain_Country] [nvarchar](50) NULL,
	[Cancellation_Group] [nvarchar](50) NULL,
	[Plan_Type_Adj] [nvarchar](50) NULL,
	[Trip_Cost_adj] [int] NULL,
	[Value] [int] NULL
) ON [PRIMARY]
GO
