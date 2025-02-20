USE [db-au-star]
GO
/****** Object:  Table [dbo].[Dim_Sales_Force]    Script Date: 20/02/2025 10:26:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Dim_Sales_Force](
	[Sales_Force_SK] [int] IDENTITY(0,1) NOT NULL,
	[BDM_Code] [varchar](50) NOT NULL,
	[BDM_Name] [varchar](200) NULL,
	[Sales_State_Manager_ID] [varchar](50) NULL,
	[Sales_State_Manager_Name] [varchar](200) NULL,
	[Domain_ID] [int] NOT NULL,
	[Valid_From_Date] [datetime] NOT NULL,
	[Valid_To_Date] [datetime] NULL,
	[Is_Latest] [char](1) NOT NULL,
	[Source_System_Code] [varchar](20) NOT NULL,
	[Create_Date] [datetime] NOT NULL,
	[Update_Date] [datetime] NULL,
	[Insert_Batch_ID] [int] NOT NULL,
	[Update_Batch_ID] [int] NULL,
 CONSTRAINT [Dim_Sales_Force_PK] PRIMARY KEY CLUSTERED 
(
	[Sales_Force_SK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
