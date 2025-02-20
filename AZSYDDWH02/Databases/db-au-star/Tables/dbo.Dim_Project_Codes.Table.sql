USE [db-au-star]
GO
/****** Object:  Table [dbo].[Dim_Project_Codes]    Script Date: 20/02/2025 10:26:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Dim_Project_Codes](
	[Project_Codes_SK] [int] IDENTITY(0,1) NOT NULL,
	[Project_Code] [varchar](50) NOT NULL,
	[Project_Desc] [varchar](200) NULL,
	[Project_Owner_Code] [varchar](50) NOT NULL,
	[Project_Owner_Desc] [varchar](200) NULL,
	[Parent_Project_Code] [varchar](50) NOT NULL,
	[Parent_Project_Code_Desc] [varchar](200) NULL,
	[Create_Date] [datetime] NOT NULL,
	[Update_Date] [datetime] NULL,
	[Insert_Batch_ID] [int] NOT NULL,
	[Update_Batch_ID] [int] NULL,
 CONSTRAINT [Dim_Project_Codes_PK] PRIMARY KEY CLUSTERED 
(
	[Project_Codes_SK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX01_Dim_Project_Codes]    Script Date: 20/02/2025 10:26:12 AM ******/
CREATE NONCLUSTERED INDEX [IX01_Dim_Project_Codes] ON [dbo].[Dim_Project_Codes]
(
	[Project_Code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
