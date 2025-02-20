USE [db-au-star]
GO
/****** Object:  Table [dbo].[Dim_Product]    Script Date: 20/02/2025 10:26:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Dim_Product](
	[Product_SK] [int] IDENTITY(0,1) NOT NULL,
	[Product_Code] [varchar](50) NOT NULL,
	[Product_Desc] [varchar](200) NULL,
	[Domain_ID] [int] NOT NULL,
	[Source_System_Code] [varchar](20) NOT NULL,
	[Create_Date] [datetime] NOT NULL,
	[Update_Date] [datetime] NULL,
	[Insert_Batch_ID] [int] NOT NULL,
	[Update_Batch_ID] [int] NULL,
 CONSTRAINT [Dim_Product_PK] PRIMARY KEY CLUSTERED 
(
	[Product_SK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
