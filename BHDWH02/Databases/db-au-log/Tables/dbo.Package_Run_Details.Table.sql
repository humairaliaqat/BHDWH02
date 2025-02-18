USE [DB-AU-LOG]
GO
/****** Object:  Table [dbo].[Package_Run_Details]    Script Date: 18/02/2025 12:59:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Package_Run_Details](
	[Batch_ID] [int] NOT NULL,
	[Package_ID] [varchar](50) NOT NULL,
	[Package_Name] [varchar](50) NOT NULL,
	[Package_Start_Time] [datetime] NULL,
	[Src_Record_Count] [int] NULL,
	[Insert_Record_Count] [int] NULL,
	[Update_Record_Count] [int] NULL,
	[User_Name] [varchar](50) NULL,
	[Package_End_Time] [datetime] NULL,
	[Package_Status] [varchar](50) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_main]    Script Date: 18/02/2025 12:59:40 PM ******/
CREATE CLUSTERED INDEX [idx_main] ON [dbo].[Package_Run_Details]
(
	[Batch_ID] ASC,
	[Package_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
