USE [db-au-actuary]
GO
/****** Object:  Table [cng].[GLM_Trip_Cost_Table]    Script Date: 18/02/2025 12:14:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cng].[GLM_Trip_Cost_Table](
	[Domain_Country] [nvarchar](50) NOT NULL,
	[Cancellation_Group] [nvarchar](50) NOT NULL,
	[Plan_Type_Adj] [nvarchar](50) NOT NULL,
	[Trip_Cost_adj] [int] NOT NULL,
	[Value] [int] NOT NULL
) ON [PRIMARY]
GO
