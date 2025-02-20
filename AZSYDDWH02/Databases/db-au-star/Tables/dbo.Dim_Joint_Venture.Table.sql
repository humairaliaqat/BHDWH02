USE [db-au-star]
GO
/****** Object:  Table [dbo].[Dim_Joint_Venture]    Script Date: 20/02/2025 10:26:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Dim_Joint_Venture](
	[Joint_Venture_SK] [int] IDENTITY(0,1) NOT NULL,
	[Joint_Venture_Category_Code] [varchar](50) NOT NULL,
	[Joint_Venture_Category_Desc] [varchar](200) NULL,
	[Joint_Venture_Code] [varchar](50) NOT NULL,
	[Joint_Venture_Desc] [varchar](200) NULL,
	[Create_Date] [datetime] NOT NULL,
	[Update_Date] [datetime] NULL,
	[Insert_Batch_ID] [int] NOT NULL,
	[Update_Batch_ID] [int] NULL,
	[Distribution_Type_Code] [varchar](50) NOT NULL,
	[Distribution_Type_Desc] [varchar](200) NULL,
	[Super_Group_Code] [varchar](50) NOT NULL,
	[Super_Group_Desc] [varchar](200) NULL,
 CONSTRAINT [Dim_Joint_Venture_PK] PRIMARY KEY CLUSTERED 
(
	[Joint_Venture_SK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx]    Script Date: 20/02/2025 10:26:12 AM ******/
CREATE NONCLUSTERED INDEX [idx] ON [dbo].[Dim_Joint_Venture]
(
	[Joint_Venture_Code] ASC
)
INCLUDE([Joint_Venture_Desc],[Joint_Venture_Category_Desc],[Distribution_Type_Desc]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
