USE [db-au-workspace]
GO
/****** Object:  Table [dbo].[e5TAT]    Script Date: 20/02/2025 10:27:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[e5TAT](
	[ClaimNo] [varchar](50) NULL,
	[Reference] [int] NULL,
	[WorkType] [varchar](50) NULL,
	[CreationDate] [datetime] NULL,
	[StatusChangeDate] [datetime] NULL,
	[AssignedUser] [varchar](255) NULL,
	[TAT] [int] NULL,
	[CurrentEstimate] [decimal](10, 2) NULL
) ON [PRIMARY]
GO
