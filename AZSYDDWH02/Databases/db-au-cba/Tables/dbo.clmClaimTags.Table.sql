USE [db-au-cba]
GO
/****** Object:  Table [dbo].[clmClaimTags]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[clmClaimTags](
	[BIRowID] [bigint] NOT NULL,
	[ClaimKey] [varchar](40) NULL,
	[Classification] [varchar](20) NULL,
	[ClassificationText] [varchar](max) NULL,
	[UpdateTime] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
