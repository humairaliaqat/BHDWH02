USE [db-au-stage]
GO
/****** Object:  Table [dbo].[penguin_tblCRMAccessRole_aucm]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[penguin_tblCRMAccessRole_aucm](
	[ID] [int] NOT NULL,
	[DeptID] [int] NOT NULL,
	[AccessLvl] [int] NOT NULL,
	[RoleID] [int] NOT NULL
) ON [PRIMARY]
GO
