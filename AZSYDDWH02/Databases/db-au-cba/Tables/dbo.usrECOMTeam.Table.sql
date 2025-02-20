USE [db-au-cba]
GO
/****** Object:  Table [dbo].[usrECOMTeam]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[usrECOMTeam](
	[BIRowID] [bigint] NOT NULL,
	[Strategist] [varchar](250) NULL,
	[Country Code] [varchar](250) NULL,
	[Super Group Name] [varchar](250) NULL,
	[Group Name] [varchar](250) NULL,
	[Sub Group Name] [varchar](250) NULL
) ON [PRIMARY]
GO
