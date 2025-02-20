USE [db-au-stage]
GO
/****** Object:  Table [dbo].[penguin_tblPolicyAdminCallComment_aucm]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[penguin_tblPolicyAdminCallComment_aucm](
	[CallCommentID] [int] NOT NULL,
	[PolicyID] [int] NOT NULL,
	[CommentDate] [datetime] NOT NULL,
	[Comment] [nvarchar](max) NULL,
	[ReasonID] [int] NOT NULL,
	[CRMUserID] [int] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
