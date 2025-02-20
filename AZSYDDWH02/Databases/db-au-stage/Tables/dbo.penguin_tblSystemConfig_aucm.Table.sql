USE [db-au-stage]
GO
/****** Object:  Table [dbo].[penguin_tblSystemConfig_aucm]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[penguin_tblSystemConfig_aucm](
	[SystemConfigID] [int] NOT NULL,
	[ConfigKey] [varchar](50) NOT NULL,
	[ConfigValue] [varchar](max) NOT NULL,
	[ConfigDesc] [varchar](500) NOT NULL,
	[Status] [varchar](15) NOT NULL,
	[CreateDateTime] [datetime] NOT NULL,
	[UpdateDateTime] [datetime] NOT NULL,
	[DomainId] [int] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
