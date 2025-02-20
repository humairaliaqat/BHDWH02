USE [db-au-star]
GO
/****** Object:  Table [dbo].[Dim_GL_Product_ind]    Script Date: 20/02/2025 10:26:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Dim_GL_Product_ind](
	[Product_SK] [int] IDENTITY(1,1) NOT NULL,
	[Product_Code] [varchar](50) NOT NULL,
	[Product_Desc] [varchar](200) NULL,
	[Product_Type_Code] [varchar](50) NOT NULL,
	[Product_Type_Desc] [varchar](200) NULL,
	[Product_Parent_Code] [varchar](50) NOT NULL,
	[Product_Parent_Desc] [varchar](200) NULL,
	[Create_Date] [datetime] NOT NULL,
	[Update_Date] [datetime] NULL,
	[Insert_Batch_ID] [int] NOT NULL,
	[Update_Batch_ID] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Index [Dim_GL_Product_PK_ind]    Script Date: 20/02/2025 10:26:11 AM ******/
CREATE CLUSTERED INDEX [Dim_GL_Product_PK_ind] ON [dbo].[Dim_GL_Product_ind]
(
	[Product_SK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX01_Dim_GL_Product_ind]    Script Date: 20/02/2025 10:26:12 AM ******/
CREATE NONCLUSTERED INDEX [IX01_Dim_GL_Product_ind] ON [dbo].[Dim_GL_Product_ind]
(
	[Product_Code] ASC
)
INCLUDE([Product_Type_Code],[Product_Parent_Code]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
