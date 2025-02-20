USE [db-au-star]
GO
/****** Object:  Table [dbo].[Dim_Board_Pack]    Script Date: 20/02/2025 10:26:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Dim_Board_Pack](
	[Parent_BP_Code] [nvarchar](255) NULL,
	[Child_BP_Code] [nvarchar](255) NULL,
	[Child_BP_Desc] [nvarchar](255) NULL,
	[Account_Code] [nvarchar](255) NULL,
	[Parent_Department_Code] [nvarchar](255) NULL,
	[BP_Operator] [nvarchar](255) NULL,
	[BP_Order] [nvarchar](255) NULL
) ON [PRIMARY]
GO
