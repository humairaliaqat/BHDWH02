USE [db-au-log]
GO
/****** Object:  Table [dbo].[Package_Run_Details]    Script Date: 20/02/2025 10:24:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Package_Run_Details](
	[Batch_ID] [int] NOT NULL,
	[Package_ID] [varchar](1024) NULL,
	[Package_Name] [varchar](50) NOT NULL,
	[Package_Start_Time] [datetime] NULL,
	[Src_Record_Count] [int] NULL,
	[Insert_Record_Count] [int] NULL,
	[Update_Record_Count] [int] NULL,
	[User_Name] [varchar](50) NULL,
	[Package_End_Time] [datetime] NULL,
	[Package_Status] [varchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
