USE [db-au-cba]
GO
/****** Object:  Table [dbo].[cbDateSummary]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cbDateSummary](
	[Date] [datetime] NOT NULL,
	[ClientName] [varchar](25) NULL,
	[Protocol] [varchar](10) NULL,
	[Country] [varchar](25) NULL,
	[DeletedCount] [int] NULL,
	[AllCount] [int] NULL,
	[AllAge] [int] NULL,
	[OpenCount] [int] NULL,
	[OpenAge] [int] NULL,
	[OpenedCount] [int] NULL,
	[ClosedCount] [int] NULL
) ON [PRIMARY]
GO
