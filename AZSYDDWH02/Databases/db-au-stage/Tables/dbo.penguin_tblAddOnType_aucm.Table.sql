USE [db-au-stage]
GO
/****** Object:  Table [dbo].[penguin_tblAddOnType_aucm]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[penguin_tblAddOnType_aucm](
	[AddOnTypeId] [int] NOT NULL,
	[AddOnType] [nvarchar](50) NULL,
	[ValueList] [bit] NULL,
	[Text] [bit] NULL
) ON [PRIMARY]
GO
