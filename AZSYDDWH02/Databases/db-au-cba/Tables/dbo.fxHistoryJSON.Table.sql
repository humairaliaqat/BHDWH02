USE [db-au-cba]
GO
/****** Object:  Table [dbo].[fxHistoryJSON]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[fxHistoryJSON](
	[BIRowID] [bigint] IDENTITY(1,1) NOT NULL,
	[LocalCode] [varchar](5) NULL,
	[FXStartDate] [date] NULL,
	[FXEndDate] [date] NULL,
	[FXJSON] [nvarchar](max) NULL,
	[FXSource] [varchar](50) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Index [cidx_fxHistory]    Script Date: 20/02/2025 10:13:01 AM ******/
CREATE UNIQUE CLUSTERED INDEX [cidx_fxHistory] ON [dbo].[fxHistoryJSON]
(
	[BIRowID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
