USE [db-au-log]
GO
/****** Object:  Table [dbo].[Batch_Run_Status]    Script Date: 20/02/2025 10:24:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Batch_Run_Status](
	[Batch_ID] [int] IDENTITY(1,1) NOT NULL,
	[Batch_Date] [date] NOT NULL,
	[Batch_Start_Time] [datetime] NOT NULL,
	[Batch_Status] [varchar](10) NOT NULL,
	[Batch_End_Time] [datetime] NULL,
	[Subject_Area] [varchar](50) NOT NULL,
	[Batch_To_Date] [date] NULL,
 CONSTRAINT [pk_BatchID] PRIMARY KEY CLUSTERED 
(
	[Batch_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
