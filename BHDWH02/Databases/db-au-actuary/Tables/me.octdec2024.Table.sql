USE [db-au-actuary]
GO
/****** Object:  Table [me].[octdec2024]    Script Date: 18/02/2025 12:14:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [me].[octdec2024](
	[JV Code] [nvarchar](20) NULL,
	[Policy Vol] [int] NULL,
	[Issue YYMM] [int] NULL,
	[Premium] [float] NULL,
	[UW Premium] [float] NULL,
	[Segment] [nvarchar](50) NULL
) ON [PRIMARY]
GO
