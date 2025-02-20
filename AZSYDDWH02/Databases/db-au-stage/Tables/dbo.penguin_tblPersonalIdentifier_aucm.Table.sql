USE [db-au-stage]
GO
/****** Object:  Table [dbo].[penguin_tblPersonalIdentifier_aucm]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[penguin_tblPersonalIdentifier_aucm](
	[ID] [int] NOT NULL,
	[Type] [nvarchar](100) NOT NULL,
	[Code] [varchar](50) NOT NULL,
	[CreateDateTime] [datetime] NOT NULL,
	[UpdateDateTime] [datetime] NOT NULL,
	[Status] [nvarchar](50) NOT NULL,
	[DomainId] [int] NOT NULL,
	[GroupCode] [nvarchar](max) NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
