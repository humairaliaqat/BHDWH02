USE [DB-AU-LOG]
GO
/****** Object:  Table [dbo].[lnkServerToSourceTable]    Script Date: 18/02/2025 12:59:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[lnkServerToSourceTable](
	[lnkSSID] [int] IDENTITY(0,1) NOT NULL,
	[srcTableID] [int] NULL,
	[srcID] [int] NULL
) ON [PRIMARY]
GO
