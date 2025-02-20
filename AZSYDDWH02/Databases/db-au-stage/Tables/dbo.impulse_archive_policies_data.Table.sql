USE [db-au-stage]
GO
/****** Object:  Table [dbo].[impulse_archive_policies_data]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[impulse_archive_policies_data](
	[sessiontoken] [varchar](max) NULL,
	[sessiondata] [bigint] NULL,
	[policydata] [varchar](max) NULL,
	[lastupdatetime] [varchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
