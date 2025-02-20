USE [db-au-star]
GO
/****** Object:  Table [dbo].[Dim_Joint_Venture_ind]    Script Date: 20/02/2025 10:26:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Dim_Joint_Venture_ind](
	[Joint_Venture_SK] [int] IDENTITY(1,1) NOT NULL,
	[Joint_Venture_Category_Code] [varchar](50) NOT NULL,
	[Joint_Venture_Category_Desc] [varchar](200) NULL,
	[Joint_Venture_Code] [varchar](50) NOT NULL,
	[Joint_Venture_Desc] [varchar](200) NULL,
	[Distribution_Type_Code] [varchar](50) NOT NULL,
	[Distribution_Type_Desc] [varchar](200) NULL,
	[Super_Group_Code] [varchar](50) NOT NULL,
	[Super_Group_Desc] [varchar](200) NULL,
	[Create_Date] [datetime] NOT NULL,
	[Update_Date] [datetime] NULL,
	[Insert_Batch_ID] [int] NOT NULL,
	[Update_Batch_ID] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Index [Dim_Joint_Venture_PK_ind]    Script Date: 20/02/2025 10:26:11 AM ******/
CREATE CLUSTERED INDEX [Dim_Joint_Venture_PK_ind] ON [dbo].[Dim_Joint_Venture_ind]
(
	[Joint_Venture_SK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_ind]    Script Date: 20/02/2025 10:26:12 AM ******/
CREATE NONCLUSTERED INDEX [idx_ind] ON [dbo].[Dim_Joint_Venture_ind]
(
	[Joint_Venture_Code] ASC
)
INCLUDE([Joint_Venture_Desc],[Joint_Venture_Category_Desc],[Distribution_Type_Desc]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
