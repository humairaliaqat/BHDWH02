USE [DB-AU-LOG]
GO
/****** Object:  Table [dbo].[etlObjectRun]    Script Date: 18/02/2025 12:59:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[etlObjectRun](
	[objRunID] [int] IDENTITY(0,1) NOT NULL,
	[batchID] [int] NULL,
	[tableID] [int] NULL,
	[objStartTimestamp] [datetime] NULL,
	[objEndTimestamp] [datetime] NULL,
	[objRunStatus] [nvarchar](50) NULL,
	[srcRowCnt] [int] NULL,
	[tgtRowCnt] [int] NULL,
	[errMessage] [nvarchar](4000) NULL
) ON [PRIMARY]
GO
