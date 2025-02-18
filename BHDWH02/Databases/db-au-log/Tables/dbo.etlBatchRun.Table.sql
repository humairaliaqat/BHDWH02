USE [DB-AU-LOG]
GO
/****** Object:  Table [dbo].[etlBatchRun]    Script Date: 18/02/2025 12:59:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[etlBatchRun](
	[batchID] [int] IDENTITY(0,1) NOT NULL,
	[description] [nvarchar](255) NULL,
	[batchStartTimestamp] [datetime] NULL,
	[batchEndTimestamp] [datetime] NULL,
	[batchStatus] [nvarchar](50) NULL,
	[batchLayer] [nvarchar](50) NULL,
	[txnStartTimestamp] [datetime] NULL,
	[txnEndTimestamp] [datetime] NULL,
	[isInitialLoad] [bit] NULL,
	[srcTableType] [nvarchar](50) NULL,
	[isDWHLoaded] [bit] NULL,
	[country] [nvarchar](50) NULL
) ON [PRIMARY]
GO
