USE [db-au-cba]
GO
/****** Object:  Table [dbo].[usrCallMapping]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[usrCallMapping](
	[BIRowID] [bigint] IDENTITY(1,1) NOT NULL,
	[Answer Point] [nvarchar](30) NULL,
	[Call Classification] [varchar](250) NULL,
	[Call Type] [varchar](50) NULL,
	[Agent Group] [varchar](50) NULL,
	[Caller] [varchar](50) NULL,
	[Team Type] [varchar](50) NULL,
	[Start Date] [date] NULL,
	[End Date] [date] NULL
) ON [PRIMARY]
GO
