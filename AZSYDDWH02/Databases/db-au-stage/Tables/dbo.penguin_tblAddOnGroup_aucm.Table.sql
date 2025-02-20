USE [db-au-stage]
GO
/****** Object:  Table [dbo].[penguin_tblAddOnGroup_aucm]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[penguin_tblAddOnGroup_aucm](
	[AddOnGroupId] [int] NOT NULL,
	[GroupName] [nvarchar](50) NOT NULL,
	[Comments] [nvarchar](50) NULL,
	[Code] [varchar](10) NULL
) ON [PRIMARY]
GO
