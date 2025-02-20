USE [db-au-stage]
GO
/****** Object:  Table [dbo].[penguin_tblAutoComments_aucm]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[penguin_tblAutoComments_aucm](
	[AutoCommentID] [int] NOT NULL,
	[OutletID] [int] NOT NULL,
	[AlphaCode] [nvarchar](50) NOT NULL,
	[CSRID] [int] NOT NULL,
	[AutoComments] [nvarchar](max) NOT NULL,
	[CommentDate] [datetime] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
